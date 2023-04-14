--Vistas
create view Usuario_que_mas_compras_hizo as
select usuario.nombre,usuario.apellido,usuario.dni,tabla1.cant_compras from 
(SELECT ventausuario.dni, COUNT(ventausuario.dni) cant_compras FROM ventausuario GROUP BY ventausuario.dni 
		ORDER BY cant_compras DESC LIMIT 1) as tabla1, usuario where usuario.dni = tabla1.dni;

create view FavoritosDelUsuario 
as select usuario.nombre,usuario.apellido, producto.nombre as nombreProducto
from usuario, favoritos,producto 
where (usuario.dni = favoritos.dni) and (favoritos.idprod = producto.idprod);

create view HistorialVentas 
as select usuario.nombre,usuario.apellido, ventausuario.total, ventausuario.fecha
from usuario, ventausuario 
where usuario.dni = ventausuario.dni;


create view valoracionesProductos as
	select * from producto order by promediocalificacion desc;
	
	
create view ProductosSinStock as
	select * from producto where producto.stock = 0;
	
	
	
create view ProductosStockbajo as
	select * from producto where producto.stock < 10;
	
	

CREATE VIEW Top3usuarioConMasCompras as
select nombre,apellido,email,usuario.dni,total as totalventas from usuario,
(select dni, count(dni) as total from ventausuario group by dni ) as tabla2 where
usuario.dni = tabla2.dni order by tabla2.total DESC limit 4; 

CREATE VIEW top3_funkos_mas_vendidos as
SELECT producto.imagen,
    producto.nombre,
    producto.idprod,
    producto.numerofunko,
    tabla2.total
   FROM producto,
    ( SELECT lineaventa.idprod,
            sum(lineaventa.cantproduc) AS total
           FROM lineaventa
          GROUP BY lineaventa.idprod) tabla2
  WHERE producto.idprod = tabla2.idprod
  ORDER BY tabla2.total DESC
 LIMIT 3;
