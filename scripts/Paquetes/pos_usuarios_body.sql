--------------------------------------------------------
-- Archivo creado  - sábado-agosto-16-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body POS_USUARIOS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "POSPROFESIONAL"."POS_USUARIOS_PKG" AS 
 
  FUNCTION validar_asignacion( 
    p_usuario_id IN pos_asignacion_cajas.cajeros_id%TYPE 
  ) RETURN BOOLEAN IS 
    v_count NUMBER; 
  BEGIN 
    SELECT COUNT(*) 
      INTO v_count 
      FROM pos_asignacion_cajas 
     WHERE cajeros_id = p_usuario_id; 
 
    RETURN (v_count > 0); 
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
      -- En teoría COUNT(*) nunca lanza NO_DATA_FOUND,  
      -- pero por robustez devolvemos FALSE si algo falla. 
      RETURN FALSE; 
  END validar_asignacion; 

  PROCEDURE eliminar_usuario(
    p_usuario_id IN pos_usuarios.id%TYPE
  )
  IS
    l_tiene_asignacion BOOLEAN;
  BEGIN
    -- Validar si el usuario tiene asignaciones activas
    l_tiene_asignacion := validar_asignacion(p_usuario_id);

    IF l_tiene_asignacion THEN
      -- Lanzar mensaje amigable si tiene asignaciones
      raise_application_error(
        -20001,
        'Este usuario no se puede eliminar porque tiene asignaciones activas de caja. Libere primero las cajas asociadas.'
      );
    ELSE
      -- Eliminar roles asociados al usuario
      DELETE FROM pos_roles_usuario
      WHERE usuarios_id = p_usuario_id;

      -- Eliminar al usuario
      DELETE FROM pos_usuarios
      WHERE id = p_usuario_id;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(
        -20002,
        'Ha ocurrido un error al intentar eliminar el usuario: ' || SQLERRM
      );
  END eliminar_usuario;

    FUNCTION validar_role(
      p_correo IN pos_usuarios.correo%TYPE,
      p_rol    IN pos_roles.rol%TYPE
    ) RETURN BOOLEAN IS
      v_count INTEGER;
        BEGIN
          SELECT COUNT(1)
            INTO v_count
            FROM pos_usuarios u
                 JOIN pos_roles_usuario ru ON u.id = ru.usuarios_id
                 JOIN pos_roles r ON ru.roles_rol = r.rol
           WHERE u.correo = p_correo
             AND r.rol = p_rol;

          RETURN v_count > 0;
        EXCEPTION
          WHEN OTHERS THEN
            RETURN FALSE;
        END validar_role;


END pos_usuarios_pkg;

/
