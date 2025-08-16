--------------------------------------------------------
-- Archivo creado  - sábado-agosto-16-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function HASH_SHA256
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "POSPROFESIONAL"."HASH_SHA256" (p_input VARCHAR2) RETURN VARCHAR2 AS 
  LANGUAGE JAVA 
  NAME 'SHA256Hasher.hash(java.lang.String) return java.lang.String';

/
