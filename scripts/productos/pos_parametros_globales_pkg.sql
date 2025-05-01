create or replace PACKAGE pos_parametros_globales_pkg AS
  FUNCTION trae_parametro(p_parametro IN VARCHAR2) RETURN VARCHAR2;

  PROCEDURE inserta_parametro(
    p_parametro   IN VARCHAR2,
    p_descripcion IN VARCHAR2,
    p_valor       IN VARCHAR2
  );

  PROCEDURE actualiza_parametro(
    p_parametro IN VARCHAR2,
    p_valor     IN VARCHAR2
  );

  PROCEDURE listar_parametros;

END pos_parametros_globales_pkg;
/

create or replace PACKAGE BODY pos_parametros_globales_pkg AS

  FUNCTION trae_parametro(p_parametro IN VARCHAR2) RETURN VARCHAR2 IS
    v_valor pos_parametros_globales.valor%TYPE;
  BEGIN
    SELECT valor
    INTO v_valor
    FROM pos_parametros_globales
    WHERE parametro = p_parametro;

    RETURN v_valor;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
    WHEN OTHERS THEN
      RETURN NULL;
  END trae_parametro;

  PROCEDURE inserta_parametro(
    p_parametro   IN VARCHAR2,
    p_descripcion IN VARCHAR2,
    p_valor       IN VARCHAR2
  ) IS
  BEGIN
    INSERT INTO pos_parametros_globales (parametro, descripcion, valor)
    VALUES (p_parametro, p_descripcion, p_valor);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error al insertar: ' || SQLERRM);
  END inserta_parametro;

  PROCEDURE actualiza_parametro(
    p_parametro IN VARCHAR2,
    p_valor     IN VARCHAR2
  ) IS
  BEGIN
    UPDATE pos_parametros_globales
    SET valor = p_valor
    WHERE parametro = p_parametro;

    IF SQL%ROWCOUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Parámetro no encontrado.');
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error al actualizar: ' || SQLERRM);
  END actualiza_parametro;

  PROCEDURE listar_parametros IS
  BEGIN
    FOR r IN (
      SELECT parametro, descripcion, valor
      FROM pos_parametros_globales
      ORDER BY parametro
    ) LOOP
      DBMS_OUTPUT.PUT_LINE('Parámetro: ' || r.parametro || ', Valor: ' || r.valor || ', Descripción: ' || r.descripcion);
    END LOOP;
  END listar_parametros;

END pos_parametros_globales_pkg;
/