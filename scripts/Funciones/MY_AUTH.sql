--------------------------------------------------------
-- Archivo creado  - sábado-agosto-16-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package MY_AUTH
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "POSPROFESIONAL"."MY_AUTH" IS 
FUNCTION validar_login( p_usuario IN VARCHAR2,p_password IN VARCHAR2) RETURN BOOLEAN; 
end;

/
