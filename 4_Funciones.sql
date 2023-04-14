---ventas del dia

--Parámentros: fecha de la cual se quiera saber las compras realizadas en el dia de hou

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
---Ventas realizada en una determinada fecha

--Parámentros: fecha de la cual se quiera saber las compras realizadas en ka misma




CREATE OR REPLACE FUNCTION Get_compras_fecha_dada (fecha date) 
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
--Parámentros: dni del usuario a buscar
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
--Parámentros: idcat que es el id de la categoría usuario
CREATE OR REPLACE FUNCTION Get_cantidad_productos_de_cada_categoria(idcat int) RETURNS int AS $$
DECLARE
cantidad int;
BEGIN
   cantidad = (select count(producto.idcat) from producto where producto.idcat = $1);
   
   return cantidad;
END; $$ 

LANGUAGE 'plpgsql';

-------------------------------------------------------------------------------------------------------

--Función que nos permite ver los productos en favoritos de un usuario dado

--Parámentros: dni del usuario
CREATE OR REPLACE FUNCTION Get_favoritos_usuario (dni t_dni) 
    RETURNS TABLE (
        usuario_nombre VARCHAR,
		usuario_apellido varchar,
		nombre_funko varchar,
		precio_funko t_precio,
		numero_funko int
) 
AS $$
BEGIN
    RETURN QUERY
    SELECT usuario.nombre,usuario.apellido,producto.nombre,producto.precio,producto.numerofunko
    FROM usuario,favoritos,producto
    WHERE usuario.dni = $1 and favoritos.dni = usuario.dni and favoritos.idprod = producto.idprod;
END; $$ 
LANGUAGE 'plpgsql';
-------------------------------------------------------------------------------------------------------


CREATE FUNCTION DeleteLineaCarrito(idcarrito_user int) RETURNS void AS $$
BEGIN

DELETE FROM lineacarrito where lineacarrito.idcarrito = idcarrito_user;

END;
$$ LANGUAGE plpgsql;






