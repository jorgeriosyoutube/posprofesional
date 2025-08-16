--------------------------------------------------------
-- Archivo creado  - sábado-agosto-16-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function GENERAR_SALT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "POSPROFESIONAL"."GENERAR_SALT" RETURN VARCHAR2 IS 
  v_salt VARCHAR2(32); 
BEGIN 
  SELECT DBMS_RANDOM.STRING('x', 16) INTO v_salt FROM dual; 
  RETURN v_salt; 
END;

/
