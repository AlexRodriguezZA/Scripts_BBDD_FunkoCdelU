CREATE FUNCTION confirmar_comprar_del_carrito(dni_user t_dni) RETURNS void AS $$

DECLARE

r record;
f record;
precio_total_lineacarrito t_precio;
cantidad_lineacarrito int;
idprod_lineacarrito int;
idventa_user int;
BEGIN

UPDATE carrito SET confirm = true WHERE dni = $1;

--hacemos un bucle en el sobre el carrito y con un condicional nos fijamos que el 
--confirm sea true, luego buscamos la linea carrito y creamos lineaventa y ventaa usuario
--luego una vez finalizada la compra /hacerlo con una funcion -> "FINALIZADA"/ con un trigger 
-- validar stock

FOR r IN select * from carrito
LOOP 

	IF (r.confirm = true) and (r.dni = $1) then
	--Creamos la venta usuario con los datos minimos
		INSERT INTO ventausuario (hora,fecha,dni) 
		VALUES (current_time(0),CURRENT_DATE,$1);
	
		--Ahora hacemos un bucle para poder pasar los datos de linea carrito 
		--a linea venta
			FOR f IN select * from lineacarrito
			LOOP
			precio_total_lineacarrito:= f.precio;
			cantidad_lineacarrito:= f.cantidaddecadaprod;
			idprod_lineacarrito:= f.idprod;
			--Encontramos el idventa con el dni_user
			idventa_user = (select idventa from usuario,ventausuario 
							where usuario.dni = $1 and ventausuario.dni = $1 and ventausuario.estadocompra is null);
			
			INSERT INTO lineaventa (cantproduc,totalprod,idprod,idventa) 
			VALUES (cantidad_lineacarrito,precio_total_lineacarrito,idprod_lineacarrito,idventa_user);
			END LOOP;
		
	END IF;	

END LOOP;



END;
$$ LANGUAGE plpgsql;



----------------------------------------------------------------------------------------------------
--El ojetivo de esta función es sacar la suma total de la lineaventa de usuario
--para luego utilizarla en la ventausuario -> "factura"
CREATE FUNCTION calcular_total_venta(dni t_dni) RETURNS t_precio AS $$
DECLARE
total t_precio;
BEGIN

	total = (select sum(lineaventa.totalprod)from lineaventa,ventausuario 
			 where ventausuario.dni = 42070594 and lineaventa.idventa = ventausuario.idventa);

return total;
END;
$$ LANGUAGE plpgsql;

----------------------------------------------------------------------------------------------------

--Con esta función logramos los siguientes objetivos
-- 1) Poner en finalizada la compra del usuario
-- 2) Poner en false la comfirmacion del carrito
-- 3) Eliminar las lineas del carrito del usuario 
--4) calcular el total de la venta y ponerla en ventausuario
CREATE FUNCTION confirmar_estado_de_venta(dni t_dni) RETURNS void AS $$
DECLARE
nro_carrito int;
idventa_ventausuario int;
BEGIN
--recogemos el idventa de ventausuario para luego poder actualizar y colocar el monto total
idventa_ventausuario = (select idventa from ventausuario 
		   where ventausuario.dni = $1 and ventausuario.total is null);

--Calculamos el total de la factura y lo colocamos en la ventausuario

UPDATE ventausuario set total = calcular_total_venta($1) 
where ventausuario.dni = $1 and ventausuario.idventa = idventa_ventausuario 
and ventausuario.total is null;


--Obtenes el idcarrito que está asociado al dni de usuario para luego eliminar
-- las lineas del carrito de usuario

nro_carrito = (select idcarrito from carrito where carrito.dni = $1);

--Actualizamos el estado de la compra a "finalizada"

UPDATE ventausuario SET estadocompra = 'finalizada' 
WHERE ventausuario.dni = $1 and ventausuario.estadocompra is null ;

-- Actualizamos la confirmacion del carrito a "false" para poder reutilizarlo
-- en la proxima compra del usuario
UPDATE carrito SET confirm = false where carrito.dni = $1;

--Eliminamos las lineas del carrito para luego poder cargalas nuevamente en una
-- nueva compra
delete from lineacarrito where lineacarrito.idcarrito = nro_carrito;





END;
$$ LANGUAGE plpgsql;


----------------------------------------------------------------------------------------

CREATE FUNCTION funcion_encontrar_dni_del_idcarrito(idcarrito int) RETURNS t_dni AS $$
DECLARE
dni_user t_dni;
BEGIN

dni_user = (select usuario.dni from carrito,usuario where carrito.idcarrito = $1 and usuario.dni = carrito.dni); 
return dni_user;
END;
$$ LANGUAGE plpgsql;


-----------------------------INSERTS DE PRUEBA------------------------------------
----------------------------------------------------------------------------------

INSERT INTO lineacarrito (precio,cantidaddecadaprod,idcarrito,idprod) 
			VALUES (6000,2,1,1);
INSERT INTO lineacarrito (precio,cantidaddecadaprod,idcarrito,idprod) 
			VALUES (6100,2,1,2);

INSERT INTO lineacarrito (precio,cantidaddecadaprod,idcarrito,idprod) 
			VALUES (4000,2,1,4);
INSERT INTO lineacarrito (precio,cantidaddecadaprod,idcarrito,idprod) 
			VALUES (6000,2,1,13);


SELECT confirmar_comprar_del_carrito(funcion_encontrar_dni_del_idcarrito(1));
SELECT confirmar_estado_de_venta(funcion_encontrar_dni_del_idcarrito(1));


----------------------------------------------------------------------------------------
INSERT INTO lineacarrito (precio,cantidaddecadaprod,idcarrito,idprod) 
			VALUES (6400,2,2,6);
INSERT INTO lineacarrito (precio,cantidaddecadaprod,idcarrito,idprod) 
			VALUES (6400,2,2,3);

INSERT INTO lineacarrito (precio,cantidaddecadaprod,idcarrito,idprod) 
			VALUES (5500,2,2,5);
INSERT INTO lineacarrito (precio,cantidaddecadaprod,idcarrito,idprod) 
			VALUES (5500,2,2,12);


SELECT confirmar_comprar_del_carrito(funcion_encontrar_dni_del_idcarrito(2));
SELECT confirmar_estado_de_venta(funcion_encontrar_dni_del_idcarrito(2));

----------------------------------------------------------------
INSERT INTO lineacarrito (precio,cantidaddecadaprod,idcarrito,idprod) 
			VALUES (6400,2,3,1);
INSERT INTO lineacarrito (precio,cantidaddecadaprod,idcarrito,idprod) 
			VALUES (6400,2,3,2);

INSERT INTO lineacarrito (precio,cantidaddecadaprod,idcarrito,idprod) 
			VALUES (5500,2,3,7);
INSERT INTO lineacarrito (precio,cantidaddecadaprod,idcarrito,idprod) 
			VALUES (5500,2,3,4);


SELECT confirmar_comprar_del_carrito(funcion_encontrar_dni_del_idcarrito(3));
SELECT confirmar_estado_de_venta(funcion_encontrar_dni_del_idcarrito(3));
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

--DESCONTAR EL SOTCK DE Los productos comprados

select * from ventausuario
select * from lineaventa
select * from lineacarrito
select * from carrito 

delete from lineaventa;
delete from ventausuario;
