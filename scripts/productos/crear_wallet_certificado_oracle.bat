@echo off
setlocal

REM === CONFIGURACIÓN ===
set WALLET_PATH=C:\oracle\wallets\apiwallet
set CERT_FILE=C:\oracle\wallets\softpyme_cert.cer
set WALLET_PASSWORD=1234

echo ---------------------------------------------
echo Eliminando wallet anterior (si existe)...
rmdir /s /q "%WALLET_PATH%" >nul 2>&1

echo ---------------------------------------------
echo Creando nuevo wallet...
orapki wallet create -wallet "%WALLET_PATH%" -pwd %WALLET_PASSWORD%

echo ---------------------------------------------
echo Agregando certificado trusted: %CERT_FILE%
orapki wallet add -wallet "%WALLET_PATH%" -pwd %WALLET_PASSWORD% -trusted_cert -cert "%CERT_FILE%"

echo ---------------------------------------------
echo Habilitando auto-login...
orapki wallet create -wallet "%WALLET_PATH%" -pwd %WALLET_PASSWORD% -auto_login

echo ---------------------------------------------
echo Verificando contenido del wallet...
orapki wallet display -wallet "%WALLET_PATH%" -pwd %WALLET_PASSWORD%

echo ---------------------------------------------
echo Wallet creado y configurado exitosamente.
pause
