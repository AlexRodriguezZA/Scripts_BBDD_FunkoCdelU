--EXPLOTANDO TRIGGERS


--Trigger de calificar funko, este mismo se va a dispara si el usuario no compro el funko y quiere calificar un producto

INSERT INTO calificacion (calificacion,dni,idprod) 
VALUES (5,funcion_encontrar_dni_del_idcarrito(9),10);

select * from ventausuario,lineaventa 
where ventausuario.dni = funcion_encontrar_dni_del_idcarrito(9) 
and lineaventa.idventa = ventausuario.idventa and idprod = 10;

-------------------------------------------------------------------------------------------

--Trigger de favoritos del usuario, este se va a activar cuando el usuario
--Ya tenga el mismo funko cargado en favoritos, para que este no tengo dos veces el mismo

INSERT INTO favoritos (dni,idprod)
VALUES (42070594,4);

select * from favoritos where dni = 42070594 and idprod = 4;


-------------------------------------------------------------------------------------------
--Trigger de cantidad de productos no exedidos, este trigger nos permite que no se pueda 
--cargar a la linea carrito una cantidad mas grande que la cantidad que hay en stock de producto.

INSERT INTO lineacarrito (precio,cantidaddecadaprod,idcarrito,idprod) 
			VALUES (6000,200,1,13);

select * from producto where idprod = 13;


-------------------------------------------------------------------------------------------

--Aumento del stock, cuando agregamos mas productos a travez de la tabla de compraprod
select nombre,stock from producto where idprod = 1;

INSERT INTO compraprod (cantidad,fecha,idprod)
VALUES (34,current_date,1);

select nombre,stock from producto where idprod = 1;
-------------------------------------------------------------------------------------------
--Descuento del stock, cuando finalizamos la compra lo que debemos hacer es descontar el stock 
--del producto


select nombre,stock from producto where idprod = 1;


INSERT INTO lineacarrito (precio,cantidaddecadaprod,idcarrito,idprod) 
			VALUES (6000,20,1,1);


SELECT confirmar_comprar_del_carrito(funcion_encontrar_dni_del_idcarrito(1));
SELECT confirmar_estado_de_venta(funcion_encontrar_dni_del_idcarrito(1));

select nombre,stock from producto where idprod = 1;

-------------------------------------------------------------------------------------------
--Con el trigger de actulizar automaticamente el stock podemos aumentar el promedio del 
--stock automaticamente en la tabla del producto

select nombre,stock,promediocalificacion,idprod from producto where idprod = 6;

---Primero tenemos que compralo antes de calificarlo
INSERT INTO lineacarrito (precio,cantidaddecadaprod,idcarrito,idprod) 
			VALUES (6000,1,1,6);


SELECT confirmar_comprar_del_carrito(funcion_encontrar_dni_del_idcarrito(1));
SELECT confirmar_estado_de_venta(funcion_encontrar_dni_del_idcarrito(1));

INSERT INTO calificacion (calificacion,dni,idprod) 
VALUES (3,funcion_encontrar_dni_del_idcarrito(1),6);

select nombre,stock,promediocalificacion,idprod from producto where idprod = 6;

