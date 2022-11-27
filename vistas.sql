--Vistas

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