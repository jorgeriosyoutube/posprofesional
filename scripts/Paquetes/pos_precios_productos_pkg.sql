--------------------------------------------------------
-- Archivo creado  - sábado-agosto-16-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package POS_PRECIOS_PRODUCTOS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "POSPROFESIONAL"."POS_PRECIOS_PRODUCTOS_PKG" AS 
-- updated 16/08/2025
  PROCEDURE insertar_precio( 
    p_subproducto_id IN NUMBER, 
    p_desde          IN DATE, 
    p_hasta          IN DATE, 
    p_precio         IN NUMBER 
  ); 

  FUNCTION validar_rango( 
    p_subproducto_id IN NUMBER, 
    p_desde          IN DATE, 
    p_hasta          IN DATE 
  ) RETURN BOOLEAN; 

  FUNCTION get_precio_actual(
    p_subproducto_id IN NUMBER
  ) RETURN NUMBER;
END pos_precios_productos_pkg;

/
