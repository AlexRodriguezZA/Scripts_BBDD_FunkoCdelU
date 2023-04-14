--Este trigger nos permite que el usuario antes de dar cualquier calificacion al producto, verifiquemos si este ya compró el producto
create view CompraUsuario 
as select usuario.dni, producto.idprod, ventausuario.fecha 
from usuario, ventausuario,lineaventa,producto 
where (usuario.dni = ventausuario.dni) and 
(ventausuario.idventa = lineaventa.idventa) and 
(lineaventa.idprod = producto.idprod);

CREATE FUNCTION validarCalificacionCompra() RETURNS TRIGGER AS $$
DECLARE 
produ int;
BEGIN
 
--Si el usuario compro dicho producto recien ahi puede calificar el producto
-- de lo contrario no
produ = 0;

produ = (select idprod from (select idprod from CompraUsuario where 
			 (new.dni = dni) and 
			 (new.idprod = idprod)) as compra order by idprod desc limit 1);

if (produ>0) then
	return new;
  else 
	RAISE EXCEPTION 'El usuario No compro el producto';
END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_calificacion BEFORE INSERT OR UPDATE ON calificacion
FOR EACH ROW EXECUTE PROCEDURE validarCalificacionCompra();


-----------------------------------------------------------------------------------------------------------------------------

--Con este Trigger vamos a crear un carrito cuando el usuario creer su cuenta, de esta manera tiene una carrito asociado a su cuenta

CREATE FUNCTION CrearCarrito() RETURNS TRIGGER AS $$
BEGIN

if (NEW.dni is not null) then
	INSERT INTO carrito (dni) VALUES (NEW.dni);
else 
	RAISE EXCEPTION 'Ingrese el dni del usuario';
end if;
return NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_carrito AFTER INSERT ON usuario
FOR EACH ROW EXECUTE PROCEDURE CrearCarrito();

----------------------------------------------------------------------------------------------------------------------------

--Verificamos que en cada lineacarrito haya una cantida de producto no mayor al stock disponible
CREATE FUNCTION cantidadProductosNoExedidos() RETURNS TRIGGER AS $$
DECLARE  
cantidad int;
BEGIN
		cantidad:= (select producto.stock from producto where producto.idprod = NEW.idprod);
		IF(cantidad>=NEW.cantidaddecadaprod) THEN
			return new;
		ELSE
			RAISE EXCEPTION 'La cantidad de productos a comprar excede el stock';
		end if;

END;
$$ LANGUAGE plpgsql;

create trigger cantidadProductosLineaCarrito BEFORE insert or update on lineacarrito
for each row execute procedure cantidadProductosNoExedidos();

---------------------------------------------------------------------------------------------------------------------------

--Con este trigger lo que haces es actualizar el promedio de calificaciones que tienen cada producto 
CREATE OR REPLACE FUNCTION CalificacionActualizada() RETURNS TRIGGER AS $$
DECLARE
	calific integer;
	promedio real;
BEGIN
	promedio:= (select avg(calificacion) from calificacion where idprod=NEW.idprod);
	calific:= CAST ((select ROUND(promedio)) AS integer);
	update producto set promediocalificacion=calific where idprod=NEW.idprod;
	return new;
END;$$ LANGUAGE plpgsql;

create trigger ActualizarCalificacion after insert or update on calificacion
for each row execute procedure CalificacionActualizada();



-------------------------------------------------------------------------------------------------------------------------------


--En este caso lo que hacemos es que el  usuario solo pueda poner en favoritos 
-- un determinado producto UNA SOLA VEZ

CREATE FUNCTION ProductoFavoritoPorUsuario() RETURNS TRIGGER AS $$
DECLARE
idProdEnFavoritos int;
BEGIN
idProdEnFavoritos = 0;

idProdEnFavoritos = (select idprod from (select idprod from favoritos 
					 where (new.idprod = favoritos.idprod) 
					 and (new.dni = favoritos.dni)) as fav order by idprod desc limit 1);
if (idProdEnFavoritos = 0)  or (idProdEnFavoritos is null) then
	return new;
else
	RAISE EXCEPTION 'El usuario ya tiene este producto en la seccion favoritos';

end if;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_Favoritos BEFORE INSERT ON favoritos
FOR EACH ROW EXECUTE PROCEDURE ProductoFavoritoPorUsuario();


-------------------------------------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------------------------------------

--con este trigger al vender un determinado funko descontamos el stock del mismo
CREATE FUNCTION DescontarElstock() RETURNS TRIGGER AS $$

DECLARE
r record;
id_ultima_venta int;

BEGIN
id_ultima_venta = (select idventa from ventausuario ORDER BY idventa DESC LIMIT 1);
if (new.estadocompra = 'finalizada') then
		FOR r IN select * from lineaventa,ventausuario where lineaventa.idventa = ventausuario.idventa and ventausuario.idventa = id_ultima_venta
			LOOP
				update producto set stock = stock - r.cantproduc  where idprod = r.idprod;
			END LOOP;
	
	
end if;
Return new;
END;

$$ LANGUAGE plpgsql;

create trigger triggerDescontarSTOCK After update on ventausuario
for each row execute procedure DescontarElstock();

-----------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION actualizar_stock()
RETURNS TRIGGER AS $$
DECLARE
    cantidad_vendida INTEGER;
BEGIN
    -- Obtenemos la cantidad vendida de la línea de venta que se acaba de insertar
    cantidad_vendida := NEW.cantidad;

    -- Verificamos que haya suficiente stock disponible
    IF cantidad_vendida > (SELECT stock FROM productos WHERE id = NEW.id_producto) THEN
        RAISE EXCEPTION 'No hay suficiente stock disponible';
    END IF;

    -- Actualizamos el stock del producto
    UPDATE productos SET stock = stock - cantidad_vendida WHERE id = NEW.id_producto;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER actualizar_stock
AFTER INSERT ON linea_venta
FOR EACH ROW
EXECUTE FUNCTION actualizar_stock();

-----------------------------------------------------------------------------------------------------------------------------------
--Cuando el stock de funko quede en cero se elimina del los carritos del usuario

CREATE OR REPLACE FUNCTION eliminar_producto() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.stock = 0 THEN
        DELETE FROM lineacarrito WHERE lineacarrito.idprod = NEW.idprod;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER actualizar_stock AFTER UPDATE ON producto
FOR EACH ROW EXECUTE FUNCTION eliminar_producto();
