--------------------------------------------------------
-- Archivo creado  - sábado-agosto-16-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package POS_USUARIOS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "POSPROFESIONAL"."POS_USUARIOS_PKG" AS 
 
  /* 
   * Función: validar_asignacion 
   * Parámetro: 
   *   p_usuario_id  IN  NUMBER  -- ID del usuario a validar 
   * Retorna: 
   *   BOOLEAN  -- TRUE si existe al menos una asignación de caja para ese usuario, FALSE en caso contrario 
   */ 
  FUNCTION validar_asignacion( 
    p_usuario_id IN pos_asignacion_cajas.cajeros_id%TYPE 
  ) RETURN BOOLEAN; 
   
  PROCEDURE eliminar_usuario(
    p_usuario_id IN pos_usuarios.id%TYPE
  );
    /**
   * Función: validar_role
   * Parámetros:
   *   p_correo IN VARCHAR2 -- Correo del usuario
   *   p_rol IN VARCHAR2    -- Nombre del rol
   * Retorna:
   *   BOOLEAN -- TRUE si el usuario tiene el rol, FALSE si no
   */
  FUNCTION validar_role(
    p_correo IN pos_usuarios.correo%TYPE,
    p_rol    IN pos_roles.rol%TYPE
  ) RETURN BOOLEAN;
END pos_usuarios_pkg;

/
