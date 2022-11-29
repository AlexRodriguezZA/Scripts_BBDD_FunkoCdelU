--EXPLOTANDO TRIGGERS
--Trigger de calificar funko, este mismo se va a dispara si el usuario no compro el funko

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