-- Paquete de usuarios para POS
CREATE OR REPLACE PACKAGE pos_usuarios_pkg AS

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

END pos_usuarios_pkg;
/

CREATE OR REPLACE PACKAGE BODY pos_usuarios_pkg AS

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

END pos_usuarios_pkg;
/
