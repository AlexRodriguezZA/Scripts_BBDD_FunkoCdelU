CREATE USER Useradmin PASSWORD 'admin123456789';
CREATE USER Userclient PASSWORD 'client123456789';
--------------------------------------------------------------------------


grant select, update, delete, insert ON TABLE categoria TO UserAdmin;
grant select, update, delete, insert ON TABLE producto TO UserAdmin;

grant select ON TABLE ventausuario TO UserAdmin;
grant select,insert,delete,update ON TABLE compraprod TO UserAdmin;

grant select ON TABLE usuario TO UserAdmin;
grant select ON TABLE ciudad TO UserAdmin;

----------------------------------------------------------------------------

grant update,select ON TABLE usuario TO Userclient;
grant select ON TABLE ventausuario TO Userclient;

grant insert,update,select,delete ON TABLE lineacarrito TO Userclient;
grant select ON TABLE carrito TO Userclient;
grant insert,update,delete ON TABLE comentarios TO Userclient;
grant insert,update,delete ON TABLE calificacion TO Userclient;
grant insert,delete,select ON TABLE favoritos TO Userclient;
 