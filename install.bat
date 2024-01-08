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

::::::: Congiguration liens/Repos telechargement::::::

:: VSCODIUM ::
SET "Repo_VSCodium=VSCodium/vscodium"

:: ClasseStyle ::
SET "Repo_TeX3RClasseStyle=Tex3rivieres/TeX3R-ClasseStyle"

:: Miktex ::

SET "Link_Miktex=https://miktex.org/download/win/miktexsetup-x64.zip"

::::::: FIN Congiguration liens telechargement::::::

:: Configuration des variables PATH pour utiliser dans les commandes
SET "PATH_VSCodium=%cd%\VSCodium"
SET "PATH_Miktex=%cd%\miktex"
SET "PATH_ClasseStyle=%cd%\TeX3R-ClasseStyle"
:: Variables environnement systeme temporaires
SET "PATH=%CD%\miktex\texmfs\install\miktex\bin\x64;%PATH_ClasseStyle%;%cd%\VSCodium\bin;%PATH%"
SET "OSFONTDIR=%cd%\TeX3R-ClasseStyle\tex\fonts\TeX3R"



cls
echo **********************************
echo * Installation de VSCodium       *
echo **********************************
timeout /t 2 /nobreak >nul

cls
echo Telechargement de la derniere version de VSCodium

powershell -command "& {$apiUrl = 'https://api.github.com/repos/%Repo_VSCodium%/releases/latest'; $response = Invoke-RestMethod -Uri $apiUrl; $asset = $response.assets | Where-Object { $_.name -like '*VSCodium-win32-x64*.zip' } | Select-Object -First 1; if ($asset -eq $null) { Write-Error 'Asset correspondant non trouvé.'; exit; } $zipUrl = $asset.browser_download_url; Invoke-WebRequest -Uri $zipUrl -OutFile 'VSCodium.zip'; }"

echo Décompression de l'archive...
powershell -command "Expand-Archive -LiteralPath 'VSCodium.zip' -DestinationPath '%PATH_VSCodium%'"


echo Creation du repertoire personnel data...
md %PATH_VSCodium%\data



cls
echo **********************************
echo * TeX3R-ClasseStyle              *
echo **********************************
timeout /t 2 /nobreak >nul
cls
echo Telechargement de la derniere version de TeX3R-ClasseStyle.zip...
powershell -command "& { $apiUrl = 'https://api.github.com/repos/%Repo_TeX3RClasseStyle%/releases/latest'; $response = Invoke-RestMethod -Uri $apiUrl; $zipUrl = $response.assets[0].browser_download_url; Invoke-WebRequest -Uri $zipUrl -OutFile 'TeX3R-ClasseStyle.zip'; }"

echo Décompression de l'archive...
powershell -command "Expand-Archive -LiteralPath 'TeX3R-ClasseStyle.zip' -DestinationPath '%PATH_ClasseStyle%'"

cls
echo **********************************
echo * Installation de MiKTeX        *
echo **********************************
timeout /t 2 /nobreak >nul

cls
echo Telechargement de l'utilitaire de configuration MiKTeX
powershell -command "& { Invoke-WebRequest -Uri %Link_Miktex% -OutFile 'miktexsetup.zip' }"

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
echo *      Configuration MiKTeX      *
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
>> start.bat echo SET PATH=%%CD%%\miktex\texmfs\install\miktex\bin\x64;%%CD%%\Tex3R-ClasseStyle;%%cd%%\VSCodium\bin;%%PATH%%
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


