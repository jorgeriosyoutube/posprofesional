--------------------------------------------------------
-- Archivo creado  - sábado-agosto-16-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body POS_SUBPRODUCTOS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "POSPROFESIONAL"."POS_SUBPRODUCTOS_PKG" AS

  ---------------------------------------------------------------------------
  -- Función: generar_codigo_ean13
  -- Genera un código EAN-13 válido basado en un código de productor y un ID
  ---------------------------------------------------------------------------
  FUNCTION generar_codigo_ean13(
    p_cod_productor IN VARCHAR2,
    p_producto_id   IN NUMBER
  ) RETURN VARCHAR2 IS
    v_base_codigo   VARCHAR2(12);
    v_total         NUMBER := 0;
    v_digito_final  NUMBER;
    v_resultado     VARCHAR2(13);
  BEGIN
    IF LENGTH(p_cod_productor) != 4 THEN
      RAISE_APPLICATION_ERROR(-20001, 'El código de productor debe tener exactamente 4 dígitos.');
    END IF;

    -- Armar el código base: '770' + productor (4) + producto_id (5, padded)
    v_base_codigo := '770' || p_cod_productor || LPAD(p_producto_id, 5, '0');
    v_base_codigo := SUBSTR(v_base_codigo, 1, 12); -- Asegurarse que no pase de 12 dígitos

    -- Calcular el dígito de control usando el algoritmo EAN-13
    FOR i IN 1 .. 12 LOOP
      v_total := v_total + 
        TO_NUMBER(SUBSTR(v_base_codigo, i, 1)) * CASE WHEN MOD(i, 2) = 0 THEN 3 ELSE 1 END;
    END LOOP;

    v_digito_final := MOD(10 - MOD(v_total, 10), 10);
    v_resultado := v_base_codigo || v_digito_final;

    RETURN v_resultado;
  END generar_codigo_ean13;


  ---------------------------------------------------------------------------
  -- Función: subproducto_tiene_ventas
  -- Retorna TRUE si el subproducto está presente en ventas
  ---------------------------------------------------------------------------
  FUNCTION subproducto_tiene_ventas(p_sub_producto_id IN NUMBER) RETURN BOOLEAN IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM pos_detalle_ventas
    WHERE precios_productos_id IN (
      SELECT id
      FROM pos_precios_productos
      WHERE subproductos_id = p_sub_producto_id
    );

    RETURN v_count > 0;
  END subproducto_tiene_ventas;


  ---------------------------------------------------------------------------
  -- Procedimiento: elimina_precios_subproducto
  -- Elimina todos los precios asociados a un subproducto
  ---------------------------------------------------------------------------
  PROCEDURE elimina_precios_subproducto(p_subproducto_id IN NUMBER) IS
  BEGIN
    DELETE FROM pos_precios_productos
    WHERE subproductos_id = p_subproducto_id;
  END elimina_precios_subproducto;

END pos_subproductos_pkg;

/
