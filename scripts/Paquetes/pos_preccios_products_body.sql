--------------------------------------------------------
-- Archivo creado  - sábado-agosto-16-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body POS_PRECIOS_PRODUCTOS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "POSPROFESIONAL"."POS_PRECIOS_PRODUCTOS_PKG" AS

  PROCEDURE insertar_precio(
    p_subproducto_id IN NUMBER,
    p_desde          IN DATE,
    p_hasta          IN DATE,
    p_precio         IN NUMBER
  ) IS
    v_conflictos NUMBER := 0;
    v_usuario    VARCHAR2(255);
    v_fin_rango  DATE;
  BEGIN
    -- Usuario actual (APEX si existe, de lo contrario USER de DB)
    v_usuario := NVL(APEX_APPLICATION.G_USER, USER);

    -- Validaciones básicas del rango
    IF p_hasta IS NOT NULL AND p_hasta < p_desde THEN
      RAISE_APPLICATION_ERROR(-20000, 'La fecha HASTA no puede ser menor que DESDE.');
    END IF;

    v_fin_rango := NVL(p_hasta, DATE '9999-12-31');

    -- Verificar solape con rangos existentes (permitiendo bordes adyacentes)
    SELECT COUNT(*)
      INTO v_conflictos
      FROM pos_precios_productos t
     WHERE t.subproductos_id = p_subproducto_id
       AND NVL(t.hasta, DATE '9999-12-31') >= p_desde
       AND v_fin_rango >= t.desde;

    IF v_conflictos > 0 THEN
      RAISE_APPLICATION_ERROR(-20001, 'El rango de fechas se superpone con un registro existente.');
    END IF;

    -- Insertar
    INSERT INTO pos_precios_productos(
      subproductos_id,
      desde,
      hasta,
      precio,
      moneda,
      fecha_creacion,
      creado_por,
      fecha_actualizacion,
      actualizado_por
    ) VALUES (
      p_subproducto_id,
      p_desde,
      p_hasta,
      p_precio,
      pos_parametros_globales_pkg.trae_parametro('MONEDA'),
      SYSDATE,
      v_usuario,
      SYSDATE,
      v_usuario
    );

    -- Sin COMMIT aquí
  END insertar_precio;


  FUNCTION validar_rango(
    p_subproducto_id IN NUMBER,
    p_desde          IN DATE,
    p_hasta          IN DATE
  ) RETURN BOOLEAN IS
    v_conflictos NUMBER := 0;
    v_fin_rango  DATE := NVL(p_hasta, DATE '9999-12-31');
  BEGIN
    SELECT COUNT(*)
      INTO v_conflictos
      FROM pos_precios_productos t
     WHERE t.subproductos_id = p_subproducto_id
       AND NVL(t.hasta, DATE '9999-12-31') >= p_desde
       AND v_fin_rango >= t.desde;

    RETURN (v_conflictos > 0);
  END validar_rango;


  FUNCTION get_precio_actual(
    p_subproducto_id IN NUMBER
  ) RETURN NUMBER IS
    v_precio pos_precios_productos.precio%TYPE;
  BEGIN
    -- Evitar TRUNC para aprovechar índices y ordenar para prevenir TOO_MANY_ROWS
    SELECT t.precio
      INTO v_precio
      FROM pos_precios_productos t
     WHERE t.subproductos_id = p_subproducto_id
       AND t.desde <= SYSDATE
       AND (t.hasta IS NULL OR t.hasta >= SYSDATE)
     ORDER BY t.desde DESC
     FETCH FIRST 1 ROW ONLY;

    RETURN v_precio;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
  END get_precio_actual;

END pos_precios_productos_pkg;

/
