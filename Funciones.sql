--Funciones
--Funcion que nos permite ver la cantidad de productos de una categoría dada.
CREATE OR REPLACE FUNCTION cantidadDeProddeCadaCat(cat int) RETURNS TABLE (idcat int, cantidad int) AS
$BODY$ 
DECLARE
BEGIN
	return query(SELECT producto.idcat, count(producto.idcat) FROM producto
	group by producto.idcat having producto.idcat = $1);
end
$BODY$
LANGUAGE 'plpgsql';


-------------------------------------------------------------------------------------------------------

--Funcion que nos permite ver que usuarios compraron mas entre dos fechas determinadas

CREATE OR REPLACE FUNCTION UsuarioConMayorCantidadDeCompra(date, date) RETURNS TABLE (usuario varchar(50), cantidad_compras int) AS
$BODY$
DECLARE
BEGIN
	return query (SELECT usuario.nombre,usuario.dni, count(ventausuario.dni) AS mayor_comprador FROM ventausuario,usuario  
				  WHERE ventausuario.fecha BETWEEN $1 and $2 
				  and ventausuario.dni = usuario.dni
			 GROUP BY ventausuario.dni ORDER BY mayor_comprador DESC);
end
$BODY$
LANGUAGE 'plpgsql';

-------------------------------------------------------------------------------------------------------


--Funcion que nos permite ver que usuarios compraron en una fecha dada

CREATE OR REPLACE FUNCTION compraendeterminadafecha(date) RETURNS TABLE (usuario varchar(50),venta_fecha date, total t_precio) AS
$BODY$

DECLARE
BEGIN
	return query (SELECT usuario.nombre, ventausuario.fecha,ventausuario.total FROM ventausuario,usuario  
				  WHERE ventausuario.fecha = $1 
				  and ventausuario.dni = usuario.dni);
end

-------------------------------------------------------------------------------------------------------

--Funcion que nos permite ver las compras de un usuario dado
CREATE OR REPLACE FUNCTION compradeunusuario(dni t_dni) RETURNS TABLE (usuario varchar(50),venta_fecha date, total t_precio) AS
$BODY$

DECLARE
BEGIN
	return query (SELECT usuario.nombre,usuario.apellido, ventausuario.fecha,ventausuario.total FROM ventausuario,usuario  
				  WHERE ventausuario.dni = $1 
				  and ventausuario.dni = usuario.dni);
end

$BODY$
LANGUAGE 'plpgsql';