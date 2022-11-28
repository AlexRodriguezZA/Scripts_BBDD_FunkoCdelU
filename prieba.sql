select * from ventausuario

select idventa from ventausuario order by idventa desc limit 1
select sum(lineaventa.totalprod) from lineaventa,ventausuario 
			 where ventausuario.dni = 44234567 and ventausuario.idventa = 60 and ventausuario.idventa = lineaventa.idventa;
			 
delete from lineaventa
delete from ventausuario

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
------
INSERT INTO lineacarrito (precio,cantidaddecadaprod,idcarrito,idprod) 
			VALUES (8000,5,10,1);
INSERT INTO lineacarrito (precio,cantidaddecadaprod,idcarrito,idprod) 
			VALUES (2000,4,10,2);

INSERT INTO lineacarrito (precio,cantidaddecadaprod,idcarrito,idprod) 
			VALUES (4500,2,10,4);
INSERT INTO lineacarrito (precio,cantidaddecadaprod,idcarrito,idprod) 
			VALUES (6000,2,10,13);


SELECT confirmar_comprar_del_carrito(funcion_encontrar_dni_del_idcarrito(10));
SELECT confirmar_estado_de_venta(funcion_encontrar_dni_del_idcarrito(10));

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

select * from producto;
delete from calificacion;
select * from calificacion
INSERT INTO calificacion (calificacion,dni,idprod) 
			VALUES (3,funcion_encontrar_dni_del_idcarrito(3),1);

select * from favoritos
INSERT INTO favoritos (dni,idprod) 
			VALUES (42070594,1);

INSERT INTO favoritos (dni,idprod) 
			VALUES (42070594,14);
delete from favoritos where idfavoritos =45

