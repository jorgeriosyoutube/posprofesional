--liquibase formatted sql
--changeset admin:crear_vista_supervisores
create or replace view v_supervisores as
select a.id as usuario_id,
       a.nombre as nombre_usuario,
       a.CORREO,
       b.id role_id,
       b.roles_rol,
       a.activo 
 from POS_USUARIOS a,pos_roles_usuario b 
where a.id=b.usuarios_id
and   upper(b.roles_rol)=upper(pos_parametros_globales_pkg.trae_parametro('ROL_SUPERVISOR')) 