@echo off
echo **************************************************
echo * Installation de l'environnement TeX3R          *
echo * Author: Frederic Leothaud - Vincent Crombez    *
echo * Copyright (C) [2023] TeX3R                     *
echo **************************************************
echo.
rem chcp 65001
cd /d %~dp0
timeout /t 5 /nobreak >nul
setlocal enabledelayedexpansion

::::::: Congiguration liens telechargement::::::

:: VSCODIUM ::
SET LINK_VSCODIUM=https://github.com/VSCodium/vscodium/releases/download/1.84.2.23319/VSCodium-win32-x64-1.84.2.23319.zip

:: ClasseStyle ::
SET LINK_ClasseStyle=https://github.com/Tex3rivieres/TeX3R-ClasseStyle/archive/refs/tags/3.0.1.zip

:: Extraire la partie après 'tags/'
set "temp=!LINK_ClasseStyle:*tags/=!"
set "version=!temp:.zip=!"

:: Extraire la version en retirant .zip
@REM for /f "delims=.zip" %%a in ("!temp!") do set "version=%%a"

:: Concaténer pour former le chemin final
SET "PATH_ClasseStyle=%CD%\TeX3R-ClasseStyle-!version!"


:: Miktex ::

SET LINK_Miktex='https://miktex.org/download/ctan/systems/win32/miktex/setup/windows-x64/miktexsetup-5.5.0+1763023-x64.zip'

::::::: FIN Congiguration liens telechargement::::::



:: Variables environnement systeme temporaires
SET PATH=%CD%\PortableGit\cmd;%CD%\miktex\texmfs\install\miktex\bin\x64;%PATH_ClasseStyle%;%CD%\7zip;%cd%\VSCodium\bin;%PATH%
SET OSFONTDIR=%cd%\TeX3R-ClasseStyle\tex\fonts\TeX3R

:: Configuration des variables PATH pour utiliser dans les commandes
SET VSCodium_PATH=%cd%\VSCodium
SET Miktex_PATH=%cd%\miktex
SET PortableGit_PATH=%cd%\PortableGit\cmd
SET zip_PATH=%cd%\7zip

:: Congiguration liens telechargement

cls
echo **********************************
echo * Installation de VSCodium       *
echo **********************************
timeout /t 2 /nobreak >nul

cls
echo Telechargement de VSCodium...
powershell -command "& { Invoke-WebRequest -Uri %LINK_VSCODIUM% -OutFile 'VSCodium.zip' }"

cls
echo extraction de VScodium.zip...
powershell -command "& { Expand-Archive -Path '.\VScodium.zip' -DestinationPath '.\VScodium' }"

echo Creation du repertoire personnel data...
md %Vscodium_PATH%\data


@REM cls
@REM echo **********************************
@REM echo * Installation de 7-Zip          *
@REM echo **********************************
@REM timeout /t 2 /nobreak >nul
@REM cls
@REM echo Telechargement de 7zip...
@REM powershell -command "& { Invoke-WebRequest -Uri 'https://www.7-zip.org/a/7z2301-x64.exe' -OutFile '7zip.exe' }"

@REM cls
@REM echo Installation 7zip (cliquer sur "oui")
@REM timeout /t 3 /nobreak >nul
@REM start /wait "" 7zip.exe /S /D="%zip_PATH%"

@REM cls
@REM echo **********************************
@REM echo * Installation de PortableGit    *
@REM echo **********************************
@REM timeout /t 2 /nobreak >nul

@REM cls
@REM echo Telechargement de PortableGit...
@REM powershell -command "& { Invoke-WebRequest -Uri 'https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/PortableGit-2.43.0-64-bit.7z.exe' -OutFile 'PortableGit.7z.exe' }"

@REM cls
@REM echo **********************************
@REM echo * Installation de PortableGit    *
@REM echo **********************************
@REM timeout /t 2 /nobreak >nul

@REM cls
@REM echo Decompression de PortableGit...
@REM 7z x PortableGit.7z.exe -o"%CD%\PortableGit" -y

cls
echo **********************************
echo * TeX3R-ClasseStyle              *
echo **********************************
timeout /t 2 /nobreak >nul
cls
echo Telechargement de TeX3R-ClasseStyle.zip...
powershell -command "& { Invoke-WebRequest -Uri %LINK_ClasseStyle% -OutFile 'TeX3R-ClasseStyle.zip' }"

cls
echo extraction de TeX3R-ClasseStyle.zip...
powershell -command "& { Expand-Archive -Path '.\TeX3R-ClasseStyle.zip' -DestinationPath '.' }"


cls
echo **********************************
echo * Installation de MiKTeX        *
echo **********************************
timeout /t 2 /nobreak >nul

cls
echo Telechargement de l'utilitaire de configuration MiKTeX
powershell -command "& { Invoke-WebRequest -Uri %LINK_Miktex% -OutFile 'miktexsetup.zip' }"

cls
echo Extraction de l'utilitaire
powershell -command "& { Expand-Archive -Path 'miktexsetup.zip' -DestinationPath '.' }"

cls
echo Creation d'un depot local Miktex
miktexsetup_standalone --verbose --local-package-repository=%CD%\miktex-temp --package-set=basic download

cls
echo Installation de miktex portable
miktexsetup_standalone --verbose --local-package-repository=%CD%\miktex-temp  --portable=%cd%\miktex --package-set=basic install

cls
echo **********************************
echo * Mise a jour des packages MiKTeX*
echo **********************************
timeout /t 2 /nobreak >nul

cls
echo Enregistrement de TeX3R-ClasseStyle dans MiKTeX...
initexmf --register-root="%PATH_ClasseStyle%"

cls
echo Mise a jour filename database
initexmf --update-fndb

cls
echo Mise a jour de la base de donnees des packages MiKTeX...
miktex update-package-database

cls
echo Mise a jour des packages MiKTeX...
miktex packages update


cls
echo **********************************
echo * Nettoyage des fichiers         *
echo **********************************
timeout /t 2 /nobreak >nul
del TeX3R-ClasseStyle.zip
del miktexsetup_standalone.exe
del miktexsetup.zip
del vscodium.zip
rd /s /q "%CD%\miktex-temp"


echo **********************************
echo * Creation de fichiers Batch     *
echo **********************************
timeout /t 2 /nobreak >nul

echo star.bat
> start.bat echo cd /d %%~dp0
>> start.bat echo ::
>> start.bat echo :: Variables environnement systeme temporaires
>> start.bat echo SET PATH=%%CD%%\PortableGit\cmd;%%CD%%\miktex\texmfs\install\miktex\bin\x64;%%CD%%\Tex3R-ClasseStyle;%%cd%%\VSCodium\bin;%%PATH%%
>> start.bat echo SET OSFONTDIR=%%cd%%\TeX3R-ClasseStyle\tex\fonts\TeX3R
>> start.bat echo start "" "%%CD%%\Vscodium\VSCodium.exe"
timeout /t 2 /nobreak >nul

cls
echo **********************************
echo * Installation des Extensions   *
echo **********************************
timeout /t 2 /nobreak >nul

cls
echo Installation langage fr (ctrl+maj+P:configure display language pour activer)
call codium --install-extension MS-CEINTL.vscode-language-pack-fr

cls
echo Installation TeX3R
call codium --install-extension Tex3R.tex3r

cls
echo *************************************************************
echo * fin de l'installation, utiliser start.bat pour demarrer.  *
echo *************************************************************
pause


