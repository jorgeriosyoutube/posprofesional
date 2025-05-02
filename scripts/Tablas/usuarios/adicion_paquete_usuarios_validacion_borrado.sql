CREATE OR REPLACE PACKAGE pos_usuarios_pkg AS

  /*
   * Función: validar_asignacion
   * Retorna TRUE si el usuario tiene asignaciones de caja activas.
   */
  FUNCTION validar_asignacion(
    p_usuario_id IN pos_asignacion_cajas.cajeros_id%TYPE
  ) RETURN BOOLEAN;

  /*
   * Procedimiento: eliminar_usuario
   * Si el usuario tiene asignaciones activas, lanza un error amigable.
   * Si no tiene, elimina sus roles y luego su registro.
   */
  PROCEDURE eliminar_usuario(
    p_usuario_id IN pos_usuarios.id%TYPE
  );

END pos_usuarios_pkg;
/
CREATE OR REPLACE PACKAGE BODY pos_usuarios_pkg AS

  FUNCTION validar_asignacion(
    p_usuario_id IN pos_asignacion_cajas.cajeros_id%TYPE
  ) RETURN BOOLEAN
  IS
    l_exists NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_exists
    FROM pos_asignacion_cajas
    WHERE cajeros_id = p_usuario_id;

    RETURN l_exists > 0;
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

END pos_usuarios_pkg;
/
