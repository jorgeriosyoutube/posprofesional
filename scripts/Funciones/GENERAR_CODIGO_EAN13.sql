--------------------------------------------------------
-- Archivo creado  - sábado-agosto-16-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function GENERAR_CODIGO_EAN13
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "POSPROFESIONAL"."GENERAR_CODIGO_EAN13" (
    p_cod_productor IN VARCHAR2,  -- Ej: '1234'
    p_producto_id   IN NUMBER     -- Ej: 56
) RETURN VARCHAR2 IS
    v_base_codigo  VARCHAR2(12);
    v_total        NUMBER := 0;
    v_digito_final NUMBER;
    v_resultado    VARCHAR2(13);
BEGIN
    -- Asegurar que el código de productor tenga 4 dígitos
    IF LENGTH(p_cod_productor) != 4 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El código de productor debe tener 4 dígitos.');
    END IF;

    -- Construimos los primeros 12 dígitos del código
    -- Ejemplo: '770' (país) + '1234' (productor) + '00056' (producto)
    v_base_codigo := '770' || p_cod_productor || LPAD(p_producto_id, 5, '0');
    v_base_codigo := SUBSTR(v_base_codigo, 1, 12);

    -- Calcular el dígito verificador EAN13
    FOR i IN 1 .. 12 LOOP
        IF MOD(i, 2) = 0 THEN
            v_total := v_total + TO_NUMBER(SUBSTR(v_base_codigo, i, 1)) * 3;
        ELSE
            v_total := v_total + TO_NUMBER(SUBSTR(v_base_codigo, i, 1));
        END IF;
    END LOOP;

    v_digito_final := MOD(10 - MOD(v_total, 10), 10);
    v_resultado := v_base_codigo || v_digito_final;

    RETURN v_resultado;
END;

/
