CREATE DOMAIN t_precio as FLOAT CHECK (VALUE >= 0 AND VALUE <= 9999999);
 CREATE DOMAIN t_calificacion as INT CHECK (VALUE >= 0 AND VALUE <= 5);
 CREATE DOMAIN t_comentario as varchar(100);
 CREATE DOMAIN t_stock as INT CHECK (VALUE >= 0 AND VALUE <= 9999);
 CREATE DOMAIN t_dni INTEGER; 


CREATE TABLE categoria (
   idCat SERIAL PRIMARY KEY,
   NombreCat varchar(30) unique NOT NULL
 );
 
------------------------------------------------------------------------------------- 
 
 CREATE TABLE producto(
 	idProd SERIAL PRIMARY KEY,
 	imagen varchar(100),
	stock t_stock,
	Nombre varchar (100) NOT NULL,
	precio t_precio NOT NULL,
	descripcion varchar(100),
	promediocalificacion real default 0,
	NumeroFunko int UNIQUE NOT NULL,
	
	idCat int       
        
 );
 
 
 alter table producto
 add constraint idCat
 foreign key (idCat) references categoria (idCat)
   ON DELETE cascade
   ON UPDATE cascade;
 


------------------------------------------------------------------------------------- 





CREATE TABLE ciudad (
	codigoPostal int PRIMARY KEY,
	ciudad varchar (30) not null
	
);


------------------------------------------------------------------------------------- 


 --- crear funcion que identifique el adminin
 
CREATE TABLE usuario (
	dni t_dni PRIMARY KEY,
	nombre varchar(20) NOT NULL,
	apellido varchar (20) NOT NULL,
	alturaDireccion int ,
	direccion varchar (20),
	email varchar(50) unique,
	esAdmin boolean,
	codigoPostal int
	
        
);


 alter table usuario
 add constraint codigoPostal
 foreign key (codigoPostal) references ciudad (codigoPostal)
   ON DELETE restrict
   ON UPDATE cascade;
 

------------------------------------------------------------------------------------- 

CREATE TABLE comentarios (
	IdComentario SERIAL PRIMARY KEY,
	hora time,
	contenido t_comentario,
	fecha date,
	dni t_dni,
	idProd int
	

);

 alter table comentarios
 add constraint dni
 foreign key (dni) references usuario (dni)
   ON DELETE cascade
   ON UPDATE cascade;
 
 alter table comentarios
 add constraint idProd
 foreign key (idProd) references producto (idProd)
   ON DELETE cascade
   ON UPDATE cascade;
 


------------------------------------------------------------------------------------- 


CREATE TABLE calificacion(
	IdCalif  SERIAL PRIMARY KEY,
	calificacion t_calificacion,
	dni t_dni,
	idProd int


);

 alter table calificacion
 add constraint dni
 foreign key (dni) references usuario (dni)
   ON DELETE cascade
   ON UPDATE cascade;
 
 alter table calificacion
 add constraint idProd
 foreign key (idProd) references producto (idProd)
   ON DELETE cascade
   ON UPDATE cascade;
 

------------------------------------------------------------------------------------- 


CREATE TABLE favoritos(
	IdFavoritos SERIAL PRIMARY KEY,
	dni t_dni,
	idProd int

);


 alter table favoritos
 add constraint dni
 foreign key (dni) references usuario (dni)
   ON DELETE cascade
   ON UPDATE cascade;
 
 alter table favoritos
 add constraint idProd
 foreign key (idProd) references producto (idProd)
   ON DELETE cascade
   ON UPDATE cascade;
 
------------------------------------------------------------------------------------- 


CREATE TABLE carrito(
	idCarrito SERIAL PRIMARY KEY,
	dni t_dni,
	confirm boolean default false

);

 alter table carrito
 add constraint dni
 foreign key (dni) references usuario (dni)
   ON DELETE cascade
   ON UPDATE cascade;



------------------------------------------------------------------------------------- 


CREATE TABLE lineaCarrito (
	IdLineaPedido SERIAL PRIMARY KEY,
	Precio t_precio,
	CantidadDeCadaProd int,
	idCarrito int,
	idProd int

);

 alter table lineaCarrito
 add constraint idCarrito
 foreign key (idCarrito) references carrito (idCarrito)
   ON DELETE cascade
   ON UPDATE cascade;

 alter table lineaCarrito
 add constraint idProd
 foreign key (idProd) references producto (idProd)
   ON DELETE cascade
   ON UPDATE cascade;



------------------------------------------------------------------------------------- 

CREATE TABLE VentaUsuario (
	idVenta SERIAL PRIMARY KEY,
	total t_precio,
	fecha date,
	hora time,
	dni t_dni,
	estadoCompra varchar(30)
	


);

 alter table VentaUsuario
 add constraint dni
 foreign key (dni) references usuario (dni)
   ON DELETE cascade
   ON UPDATE cascade;
 



------------------------------------------------------------------------------------- 




CREATE TABLE LineaVenta (
	idLinea SERIAL PRIMARY KEY,
	cantProduc int,
	totalProd t_precio,
	idProd int,
	idVenta int


);


alter table LineaVenta
 add constraint idProd
 foreign key (idProd) references producto (idProd)
   ON DELETE cascade
   ON UPDATE cascade;
 

alter table LineaVenta
 add constraint idVenta
 foreign key (idVenta) references VentaUsuario (idVenta)
   ON DELETE cascade
   ON UPDATE cascade;
 

------------------------------------------------------------------------------------- 



