---Compras del dia
CREATE OR REPLACE FUNCTION Get_compras_del_dia (fecha date) 
    RETURNS TABLE (
        usuario_nombre VARCHAR,
		usuario_apellido varchar,
		total_venta t_precio,
		fecha_venta date,
		hora_venta time
) 
AS $$
BEGIN
    RETURN QUERY
    SELECT usuario.nombre,usuario.apellido,ventausuario.total,ventausuario.fecha,ventausuario.hora
    FROM ventausuario,usuario
    WHERE ventausuario.fecha = $1 and ventausuario.dni = usuario.dni;
END; $$ 

LANGUAGE 'plpgsql';
-------------------------------------------------------------------------------------------------------

--Funcion que nos permite ver las compras de un usuario dado

CREATE OR REPLACE FUNCTION Get_compra_usuario (dni t_dni) 
    RETURNS TABLE (
        usuario_nombre VARCHAR,
		usuario_apellido varchar,
		total_venta t_precio,
		fecha_venta date,
		hora_venta time
) 
AS $$
BEGIN
    RETURN QUERY
    SELECT usuario.nombre,usuario.apellido,ventausuario.total,ventausuario.fecha,ventausuario.hora
    FROM ventausuario,usuario
    WHERE ventausuario.dni = $1 and ventausuario.dni = usuario.dni;
END; $$ 

LANGUAGE 'plpgsql';

-------------------------------------------------------------------------------------

---Con esta función obtenemos cuantos productos tenemos por la categoria seleccionada
CREATE OR REPLACE FUNCTION Get_cantidad_productos_de_cada_categoria(idcat int) RETURNS int AS $$
DECLARE
cantidad int;
BEGIN
   cantidad = (select count(producto.idcat) from producto where producto.idcat = $1);
   
   return cantidad;
END; $$ 

LANGUAGE 'plpgsql';

