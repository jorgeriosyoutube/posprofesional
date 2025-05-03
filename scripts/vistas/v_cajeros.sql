--liquibase formatted sql
--changeset admin:crear_vista_cajeros

create or replace view v_cajeros as
select a.id as usuario_id,
       a.nombre as nombre_usuario,
       b.id role_id,
       b.roles_rol,
       a.activo 
 from POS_USUARIOS a,pos_roles_usuario b 
where a.id=b.usuarios_id
and   upper(b.roles_rol)=upper(pos_parametros_globales_pkg.trae_parametro('ROL_CAJERO')) 
--changeset admin:actualizar_vista_cajeros
create or replace view v_cajeros as
select a.id as usuario_id,
       a.nombre as nombre_usuario,
       a.CORREO,
       b.id role_id,
       b.roles_rol,
       a.activo 
 from POS_USUARIOS a,pos_roles_usuario b 
where a.id=b.usuarios_id
and   upper(b.roles_rol)=upper(pos_parametros_globales_pkg.trae_parametro('ROL_CAJERO')) 