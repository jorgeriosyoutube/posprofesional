/* Este fragmentpo debe ser cargado desde sqldeveloper como una clase de java

import java.security.MessageDigest;

public class SHA256Hasher {

    public static String hash(String input) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashBytes = md.digest(input.getBytes("UTF-8"));
        
        StringBuilder hexString = new StringBuilder();
        for (byte b : hashBytes) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        return hexString.toString();
    }
}
*/
create or replace FUNCTION hash_sha256(p_input VARCHAR2) RETURN VARCHAR2 AS
  LANGUAGE JAVA
  NAME 'SHA256Hasher.hash(java.lang.String) return java.lang.String';
/

create or replace FUNCTION generar_salt RETURN VARCHAR2 IS
  v_salt VARCHAR2(32);
BEGIN
  SELECT DBMS_RANDOM.STRING('x', 16) INTO v_salt FROM dual;
  RETURN v_salt;
END;
/

create or replace TRIGGER trg_hash_password_con_salt
BEFORE INSERT ON POS_USUARIOS
FOR EACH ROW
DECLARE
  v_salt VARCHAR2(32);
BEGIN
  -- Generar un SALT si no se proporciona
  IF :NEW.SALT IS NULL THEN
    SELECT DBMS_RANDOM.STRING('x', 16) INTO v_salt FROM dual;
    :NEW.SALT := v_salt;
  ELSE
    v_salt := :NEW.SALT;
  END IF;

  -- Generar el hash solo si viene contraseña
  IF :NEW.CLAVE IS NOT NULL THEN
    :NEW.CLAVE := hash_sha256(:NEW.CLAVE || v_salt);
  END IF;
END;
/