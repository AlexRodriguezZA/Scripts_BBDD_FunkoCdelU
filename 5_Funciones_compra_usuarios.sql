
--parametro: dni del usuario 
--El objetivo de la funcion es poner el estado del carrito en true para luego crear lineaventa y ventausuario  
begin;
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

--Hacemos un bucle sobre el carrito y con un condicional nos fijamos que el 
--confirm sea "true", luego buscamos la linea carrito y creamos lineaventa y venta usuario.
FOR r IN select * from carrito
LOOP 

	IF (r.confirm = true) and (r.dni = $1) then
	--Creamos la venta usuario con los datos mínimos
		INSERT INTO ventausuario (hora,fecha,dni) 
		VALUES (current_time(0),CURRENT_DATE,$1);
	
		--Ahora hacemos un bucle para poder pasar los datos de linea carrito 
		--a linea venta
			FOR f IN select * from lineacarrito
			LOOP
			precio_total_lineacarrito:= f.precio;
			cantidad_lineacarrito:= f.cantidaddecadaprod;
			idprod_lineacarrito:= f.idprod;
			--Encontramos el idventa con el dni ingresado
			idventa_user = (select idventa from usuario,ventausuario 
							where usuario.dni = $1 and ventausuario.dni = $1 and ventausuario.estadocompra is null);
			
			INSERT INTO lineaventa (cantproduc,totalprod,idprod,idventa) 
			VALUES (cantidad_lineacarrito,precio_total_lineacarrito,idprod_lineacarrito,idventa_user);
			END LOOP;
		
	END IF;	

END LOOP;


END;

$$ LANGUAGE plpgsql;
commit;


----------------------------------------------------------------------------------------------------
--parametro: dni usuario
--El ojetivo de esta función es sacar la suma total de la lineaventa de usuario
--para luego utilizarla en la ventausuario -> "factura"
CREATE FUNCTION calcular_total_venta(dni t_dni) RETURNS t_precio AS $$
DECLARE
total t_precio;
ultima_idventa int;
BEGIN

ultima_idventa = (select idventa from ventausuario order by idventa desc limit 1);
	total = (select sum(lineaventa.totalprod)from lineaventa,ventausuario 
			 where ventausuario.dni = $1 and lineaventa.idventa = ultima_idventa
			and lineaventa.idventa = ventausuario.idventa);

return total;
END;
$$ LANGUAGE plpgsql;

----------------------------------------------------------------------------------------------------

--Con esta función logramos los siguientes objetivos:
-- 1) Poner en "finalizada" la compra del usuario
-- 2) Poner en false la comfirmación del carrito

-- 3) Eliminar las lineas del carrito del usuario 
--4) calcular el total de la venta y ponerla en ventausuario

--parametro: dni del usuario
begin;
CREATE FUNCTION confirmar_estado_de_venta(dni t_dni,mercadopago_id varchar(110)) RETURNS void AS $$
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


--mercado pago
UPDATE ventausuario SET mercadopago_id = $2 
WHERE ventausuario.dni = $1 and ventausuario.mercadopago_id is null ;


-- Actualizamos la confirmacion del carrito a "false" para poder reutilizarlo
-- en la proxima compra del usuario
UPDATE carrito SET confirm = false where carrito.dni = $1;


--Eliminamos las lineas del carrito para luego poder cargalas nuevamente en una
-- nueva compra
delete from lineacarrito where lineacarrito.idcarrito = nro_carrito;




END;

$$ LANGUAGE plpgsql;
commit;
----------------------------------------------------------------------------------------

--Con esta función podemos encontrar el dni del usuario a travez del id de su carrito

--parametro: id del carrito
CREATE FUNCTION funcion_encontrar_dni_del_idcarrito(idcarrito int) RETURNS t_dni AS $$
DECLARE
dni_user t_dni;
BEGIN

dni_user = (select usuario.dni from carrito,usuario where carrito.idcarrito = $1 and usuario.dni = carrito.dni); 
return dni_user;
END;
$$ LANGUAGE plpgsql;




