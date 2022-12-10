--Explotando restricciones y dominios

----------------------Probando restricciones de dominios--------------------------

---T_precio-----------------------------------------------------------------
INSERT INTO producto (stock,nombre,precio,descripcion,numerofunko,idcat) 
VALUES (150,'Dr saas',10000000000,'---',79,1);

---t_stock-------------------------------------------------------------------

INSERT INTO producto (stock,nombre,precio,descripcion,numerofunko,idcat) 
VALUES (10000,'Dr saas',1234,'---',79,1);

---t_calificacion-------------------------------------------------------------------

INSERT INTO calificacion (calificacion,dni,idprod) 
VALUES (9,funcion_encontrar_dni_del_idcarrito(12),4);

---t_comentario-------------------------------------------------------------------
INSERT INTO comentarios (hora,contenido,fecha,dni,idprod) 
VALUES (current_time(0),'saaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaassaaasasasasasasassaasasassaasassasasasaas',CURRENT_DATE,42070594,4);

---Restricciones de la tabla PRODUCTO----------------------------------------------------

--Nro funko -> UNIQUE y Not null

INSERT INTO producto (stock,nombre,precio,descripcion,numerofunko,idcat) 
VALUES (150,'Dr strange',2000,'---',79,1);


INSERT INTO producto (stock,nombre,precio,descripcion,idcat) 
VALUES (150,'Dr strange',2000,'---',1);

--Nombre del funko ->  Not null

INSERT INTO producto (stock,precio,descripcion,idcat) 
VALUES (150,2000,'---',1);

--Descripcion del funko ->  varchar(100)
INSERT INTO producto (stock,nombre,precio,descripcion,numerofunko,idcat) 
VALUES (150,'Dr strange',2000,'saaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaassaaasasasasasasassaasasassaasassasasasaas',79,1);

---Restricciones de la tabla CATEGORIA----------------------------------------------------

--NombreCat ->  varchar(30) UNIQUE NOT NULL
INSERT INTO categoria (nombrecat) VALUES ('FIFA');

INSERT INTO categoria (nombrecat) VALUES ('FIFAaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');

--Eliminar una categoria
 delete from categoria
  where nombrecat='FIFA';
  
---Restricciones de la tabla USUARIO----------------------------------------------------

--NOmbre not null
INSERT INTO usuario (dni,alturadireccion,direccion,email,esadmin,codigopostal)

VALUES (45450594,8009,'SAnjose','assfs@gmail.com',false,3174);

--Apellido not null
INSERT INTO usuario (dni,nombre,alturadireccion,direccion,email,esadmin,codigopostal)

VALUES (45450594,'Shayen',8009,'SAnjose','assfs@gmail.com',false,3174);

--DNI not null
INSERT INTO usuario (dni,nombre,apellido,alturadireccion,direccion,email,esadmin,codigopostal)

VALUES (45450594,'Shayen','Sirk',8009,'SAnjose','assfs@gmail.com',false,3174);

--Email not null
INSERT INTO usuario (dni,nombre,apellido,alturadireccion,direccion,email,esadmin,codigopostal)

VALUES (4594,'Shayen','Sirk',8009,'SAnjose','assfs@gmail.com',false,3174);

---Restricciones de la tabla CIUDAD----------------------------------------------------
--Primary key
INSERT INTO ciudad (codigopostal,ciudad) 
VALUES (3170,'Basavilbaso');


--NOmbre de la ciudad not null
INSERT INTO ciudad (codigopostal) 
VALUES (3170);


	