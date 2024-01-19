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
echo *** Installation de VSCodium *** 
echo Telechargement de la derniere version de VSCodium
powershell -command "& {$apiUrl = 'https://api.github.com/repos/%Repo_VSCodium%/releases/latest'; $response = Invoke-RestMethod -Uri $apiUrl; $asset = $response.assets | Where-Object { $_.name -like '*VSCodium-win32-x64*.zip' } | Select-Object -First 1; if ($asset -eq $null) { Write-Error 'Asset correspondant non trouvé.'; exit; } $zipUrl = $asset.browser_download_url; Invoke-WebRequest -Uri $zipUrl -OutFile 'VSCodium.zip'; }"

cls
echo *** Installation de VSCodium *** 
echo Decompression de l'archive...
powershell -command "Expand-Archive -LiteralPath 'VSCodium.zip' -DestinationPath '%PATH_VSCodium%' -Force"

cls
echo *** Installation de VSCodium *** 
echo Creation du repertoire personnel data...
md %PATH_VSCodium%\data


cls
echo *** Installation de MiKTeX ***
echo Telechargement de l'utilitaire de configuration MiKTeX
powershell -command "& { Invoke-WebRequest -Uri %Link_Miktex% -OutFile 'miktexsetup.zip' }"

cls
echo *** Installation de MiKTeX ***
echo Extraction de l'utilitaire
powershell -command "& { Expand-Archive -Path 'miktexsetup.zip' -DestinationPath '.' } -Force"

cls
echo *** Installation de MiKTeX ***
echo Creation d'un depot local Miktex
miktexsetup_standalone --verbose --local-package-repository=%CD%\miktex-temp --package-set=basic download

cls
echo *** Installation de MiKTeX ***
echo Installation du moteur Miktex
miktexsetup_standalone --verbose --local-package-repository=%CD%\miktex-temp  --portable=%cd%\miktex --package-set=basic install

cls
echo *** Installation de MiKTeX - Ajout des paquets TeX3R-ClasseStyle***
echo Telechargement de la derniere version de TeX3R-ClasseStyle.zip...
powershell -command "& { $apiUrl = 'https://api.github.com/repos/%Repo_TeX3RClasseStyle%/releases/latest'; $response = Invoke-RestMethod -Uri $apiUrl; $zipUrl = $response.assets[0].browser_download_url; Invoke-WebRequest -Uri $zipUrl -OutFile 'TeX3R-ClasseStyle.zip'; }"

cls
echo *** Installation de MiKTeX - Ajout des paquets TeX3R-ClasseStyle***
echo Decompression de archive TeX3R-ClasseStyle...
powershell -command "Expand-Archive -LiteralPath 'TeX3R-ClasseStyle.zip' -DestinationPath '%PATH_ClasseStyle%' -Force"

cls
echo *** Installation de MiKTeX - Ajout des paquets TeX3R-ClasseStyle***
echo Copie des fichiers SlasseStyle vers repertoire Miktex
powershell -command "Copy-Item -Path '%PATH_ClasseStyle%\tex\lualatex*' -Destination '%PATH_Miktex%\texmfs\install\tex' -Recurse -Force"


cls
echo *** Installation de MiKTeX - Configuration MiKTeX ***
echo Mise a jour filename database
initexmf --update-fndb

cls
echo *** Installation de MiKTeX - Configuration MiKTeX ***
echo Mise a jour de la base de donnees...
miktex update-package-database

cls
echo *** Installation de MiKTeX - Configuration MiKTeX ***
echo Mise a jour des packages...
miktex packages update

cls
echo *** Installation de MiKTeX - Configuration MiKTeX ***
echo Compilation HelloWord.tex pour ajout dependances TeXR (decocher "Always show this dialog" et cliquer sur "Install")
pause
cd /d %PATH_ClasseStyle%\templates\HelloWord\ && lualatex HelloWord.tex
cd /d %~dp0


cls
echo *** Nettoyage des fichiers ***
del TeX3R-ClasseStyle.zip
del miktexsetup_standalone.exe
del miktexsetup.zip
del vscodium.zip
del "%PATH_ClasseStyle%\templates\HelloWord\HelloWord.log"
del "%PATH_ClasseStyle%\templates\HelloWord\HelloWord.aux"
rd /s /q "%CD%\miktex-temp"
rd /s /q "%PATH_ClasseStyle%\tex"
timeout /t 2 /nobreak >nul

cls
echo *** Installation des Extensions ***
echo Installation langage fr (ctrl+maj+P:configure display language pour activer)
call codium --install-extension MS-CEINTL.vscode-language-pack-fr

cls
echo *** Installation des Extensions ***
echo Installation correcteur orthographique
call codium --install-extension streetsidesoftware.code-spell-checker
call codium --install-extension streetsidesoftware.code-spell-checker-french

cls
echo *** Installation des Extensions ***
echo Installation TeX3R
call codium --install-extension Tex3R.tex3r



echo *** Creation des fichiers Batch ***
echo Fichier StartTex3R.bat
echo star.bat
> StartTex3R.bat echo cd /d %%~dp0
>> StartTex3R.bat echo ::
>> StartTex3R.bat echo :: Variables environnement systeme temporaires
>> StartTex3R.bat echo SET PATH=%%CD%%\miktex\texmfs\install\miktex\bin\x64;%%CD%%\Tex3R-ClasseStyle;%%cd%%\VSCodium\bin;%%PATH%%
>> StartTex3R.bat echo SET OSFONTDIR=%%cd%%\TeX3R-ClasseStyle\tex\fonts\TeX3R
>> StartTex3R.bat echo start "" "%%CD%%\Vscodium\VSCodium.exe"
timeout /t 2 /nobreak >nul

cls
echo *** Creation des fichiers Batch ***
echo updateClasseStyle.bat
echo updateClasseStyle.bat
> updateClasseStyle.bat echo @echo off
>> updateClasseStyle.bat echo echo ***  Update TeX3R-ClasseStyles ***
>> updateClasseStyle.bat echo cd /d %%~dp0
>> updateClasseStyle.bat echo SET "Repo_TeX3RClasseStyle=Tex3rivieres/TeX3R-ClasseStyle"
>> updateClasseStyle.bat echo SET "PATH_Miktex=%%cd%%\miktex"
>> updateClasseStyle.bat echo SET "PATH_ClasseStyle=%%cd%%\TeX3R-ClasseStyle"
>> updateClasseStyle.bat echo echo Telechargement de la derniere version de TeX3R-ClasseStyle.zip...
>> updateClasseStyle.bat echo powershell -command "& { $apiUrl = 'https://api.github.com/repos/%%Repo_TeX3RClasseStyle%%/releases/latest'; $response = Invoke-RestMethod -Uri $apiUrl; $zipUrl = $response.assets[0].browser_download_url; Invoke-WebRequest -Uri $zipUrl -OutFile 'TeX3R-ClasseStyle.zip'; }"
>> updateClasseStyle.bat echo cls
>> updateClasseStyle.bat echo echo ***  Update TeX3R-ClasseStyles ***
>> updateClasseStyle.bat echo echo Decompression archive
>> updateClasseStyle.bat echo powershell -command "Expand-Archive -LiteralPath 'TeX3R-ClasseStyle.zip' -DestinationPath '%%PATH_ClasseStyle%%' -Force"
>> updateClasseStyle.bat echo cls
>> updateClasseStyle.bat echo echo ***  Update TeX3R-ClasseStyles ***
>> updateClasseStyle.bat echo echo Copie des fichiers ClasseStyle vers repertoire Miktex
>> updateClasseStyle.bat echo powershell -command "Copy-Item -Path '%%PATH_ClasseStyle%%\tex\lualatex*' -Destination '%%PATH_Miktex%%\texmfs\install\tex' -Recurse -Force"
>> updateClasseStyle.bat echo echo ***  Update TeX3R-ClasseStyles ***
>> updateClasseStyle.bat echo echo Nettoyage
>> updateClasseStyle.bat echo del TeX3R-ClasseStyle.zip
>> updateClasseStyle.bat echo rd /s /q "%%PATH_ClasseStyle%%\tex"
>> updateClasseStyle.bat echo cls
>> updateClasseStyle.bat echo echo ***  Update TeX3R-ClasseStyles ***
>> updateClasseStyle.bat echo echo Update complet ...
>> updateClasseStyle.bat echo pause
@REM timeout /t 2 /nobreak >nul

cls
echo *************************************************************
echo * fin de l'installation, utiliser StartTex3R.bat pour demarrer.  *
echo *************************************************************
pause
