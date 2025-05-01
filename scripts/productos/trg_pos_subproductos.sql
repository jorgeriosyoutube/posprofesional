create or replace TRIGGER trg_subproductos_gen_ean13
BEFORE INSERT ON pos_subproductos
FOR EACH ROW
DECLARE
  v_cod_productor VARCHAR2(4);
  v_proximo_ean   NUMBER;
BEGIN
  -- Obtener el código del productor desde los parámetros globales
  v_cod_productor := pos_parametros_globales_pkg.trae_parametro('COD_PRODUCTOR');

  -- Obtener el próximo valor de EAN desde los parámetros globales y convertirlo a número
  v_proximo_ean := TO_NUMBER(pos_parametros_globales_pkg.trae_parametro('PROXIMO_EAN'));

  -- Si el código de barras es nulo, generarlo
  IF :NEW.codigo_barras IS NULL THEN
    :NEW.codigo_barras := pos_subproductos_pkg.generar_codigo_ean13(
      p_cod_productor => v_cod_productor,
      p_producto_id   => v_proximo_ean
    );

    -- Incrementar el valor de PROXIMO_EAN en los parámetros globales
    pos_parametros_globales_pkg.actualiza_parametro(
      p_parametro => 'PROXIMO_EAN',
      p_valor     => ltrim(TO_CHAR(v_proximo_ean + 1))
    );
  END IF;
END;
/