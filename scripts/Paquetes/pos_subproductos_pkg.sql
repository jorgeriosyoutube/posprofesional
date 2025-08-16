--------------------------------------------------------
-- Archivo creado  - sábado-agosto-16-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package POS_SUBPRODUCTOS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "POSPROFESIONAL"."POS_SUBPRODUCTOS_PKG" AS 
  FUNCTION generar_codigo_ean13( 
    p_cod_productor IN VARCHAR2, 
    p_producto_id   IN NUMBER 
  ) RETURN VARCHAR2; 
 function subproducto_tiene_ventas(p_sub_producto_id IN Number) return boolean;
 procedure elimina_precios_subproducto(p_subproducto_id IN Number);
END pos_subproductos_pkg;

/
