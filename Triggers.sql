--Este trigger nos permite que el usuario antes de dar cualquier calificacion al producto, verifiquemos si este ya compró el producto
create view CompraUsuario 
as select usuario.dni, producto.idprod, ventausuario.fecha 
from usuario, ventausuario,lineaventa,producto 
where (usuario.dni = ventausuario.dni) and 
(ventausuario.idventa = lineaventa.idventa) and 
(lineaventa.idprod = producto.idprod)  

CREATE FUNCTION validarCalificacionCompra() RETURNS TRIGGER AS $$
DECLARE 
produ int;
BEGIN
 
produ = 0;

produ = (select idprod from CompraUsuario where 
			 (new.dni = dni) and 
			 (new.idprod = idprod));

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

if (NEW.dni <> NULL) and (NEW.dni <> ' ') then
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
		IF(cantidad>NEW.cantidaddecadaprod) THEN
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

idProdEnFavoritos = (select idprod from favoritos 
					 where (new.idprod = favoritos.idprod) 
					 and (new.dni = favoritos.dni));
if (idProdEnFavoritos > 0) then
	return new;
else
	RAISE EXCEPTION 'El usuario ya tiene este producto en la seccion favoritos';

end if;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_Favoritos AFTER INSERT ON favoritos
FOR EACH ROW EXECUTE PROCEDURE ProductoFavoritoPorUsuario();


-------------------------------------------------------------------------------------------------------------------------------

--con este trigger al cargar la compraprod aumentamos el stocko del funko

CREATE FUNCTION aumentarElstock() RETURNS TRIGGER AS $$
DECLARE  
produ int;
BEGIN
 
produ = 0;

produ = (select idprod from producto where new.idprod = idprod);

if (produ>0) then
	update producto set stock = NEW.cantidad + producto.stock
  	where idprod = NEW.idprod;
	return new;
	
  else 
	RAISE EXCEPTION 'El producto no se encuentra cargado';
END IF;
END;
$$ LANGUAGE plpgsql;

create trigger triggerAumentarSTOCK BEFORE insert or update on compraprod
for each row execute procedure aumentarElstock();

-------------------------------------------------------------------------------------------------------------------------------

