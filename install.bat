@echo off
setlocal enabledelayedexpansion

rem chcp 65001
cd /d %~dp0

:: Variables environnement systeme temporaires
SET PATH=%CD%\PortableGit\cmd;%CD%\miktex\texmfs\install\miktex\bin\x64;%CD%\Tex3R-ClasseStyle;%CD%\7zip;%cd%\VSCodium\bin;%PATH%
SET OSFONTDIR=%cd%\TeX3R-ClasseStyle\tex\fonts\TeX3R

:: Configuration des variables PATH pour utiliser dans les commandes
SET TeX3R-ClasseStyle_PATH=%cd%\TeX3R-ClasseStyle
SET VSCodium_PATH=%cd%\VSCodium
SET Miktex_PATH=%cd%\miktex
SET PortableGit_PATH=%cd%\PortableGit\cmd
SET zip_PATH=%cd%\7zip

cls
echo *********** VScodium ***********
echo Telechargement de VSCodium...
powershell -command "& { Invoke-WebRequest -Uri 'https://github.com/VSCodium/vscodium/releases/download/1.84.2.23319/VSCodium-win32-x64-1.84.2.23319.zip' -OutFile 'VSCodium.zip' }"

cls
echo extraction de VScodium.zip...
powershell -command "& { Expand-Archive -Path '.\VScodium.zip' -DestinationPath '.\VScodium' }"

echo Creation du repertoire personnel data...
md %Vscodium_PATH%\data


cls
echo *********** 7zip ***********

echo Telechargement de 7zip...
powershell -command "& { Invoke-WebRequest -Uri 'https://www.7-zip.org/a/7z2301-x64.exe' -OutFile '7zip.exe' }"

cls
echo Installation 7zip (cliquer sur "oui")
start /wait "" 7zip.exe /S /D="%zip_PATH%"

cls
echo *********** PortableGit ***********
:: Telechargement de PortableGit
echo Telechargement de PortableGit...
powershell -command "& { Invoke-WebRequest -Uri 'https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/PortableGit-2.43.0-64-bit.7z.exe' -OutFile 'PortableGit.7z.exe' }"

cls
:: Decompression de PortableGit.7z.exe
echo Decompression de PortableGit...
7z x PortableGit.7z.exe -o"%CD%\PortableGit" -y

cls
echo *********** TeX3R-ClasseStyle ***********
echo Clonage du depot TeX3R-ClasseStyle en cours...
git clone https://github.com/Tex3rivieres/TeX3R-ClasseStyle.git "%TeX3R-ClasseStyle_PATH%"


cls
echo *********** Miktex ***********
:: Telechargement de l'utilitaire de configuration MiKTeX
echo Telechargement de l'utilitaire de configuration MiKTeX
powershell -command "& { Invoke-WebRequest -Uri 'https://miktex.org/download/ctan/systems/win32/miktex/setup/windows-x64/miktexsetup-5.5.0+1763023-x64.zip' -OutFile 'miktexsetup.zip' }"

cls
:: Extraction de l'utilitaire
echo Extraction de l'utilitaire
powershell -command "& { Expand-Archive -Path 'miktexsetup.zip' -DestinationPath '.' }"

cls
:: Creation d'un depot local Miktex
echo Creation d'un depot local Miktex
miktexsetup_standalone --verbose --local-package-repository=%CD%\miktex-temp --package-set=basic download

cls
:: Installation de miktex portable
echo Installation de miktex portable (peut durer quelques minutes, patientez...)
miktexsetup_standalone --verbose --local-package-repository=%CD%\miktex-temp  --portable=%cd%\miktex --package-set=basic install

cls
echo *********** Mise a jour des packages ***********
echo Enregistrement de TeX3R-ClasseStyle dans MiKTeX...
initexmf --register-root="%TeX3R-ClasseStyle_PATH%"

echo Mise a jour filename database
initexmf --update-fndb

echo Mise a jour de la base de donnees des packages MiKTeX...
miktex packages update
miktex update-package-database



:: NETTOYAGE 
echo *********** NETTOYAGE ***********
del PortableGit.7z.exe
del 7zip.exe
del miktexsetup_standalone.exe
del miktexsetup.zip
del vscodium.zip
rd /s /q "%CD%\miktex-temp"
rd /s /q "%CD%\7zip"

echo *********** CREATION start.bat et update.bat ***********
@echo off

:: Creer le fichier start.bat
> start.bat echo cd /d %%~dp0
>> start.bat echo ::
>> start.bat echo :: Variables environnement systeme temporaires
>> start.bat echo SET PATH=%%CD%%\PortableGit\cmd;%%CD%%\miktex\texmfs\install\miktex\bin\x64;%%CD%%\Tex3R-ClasseStyle;%%cd%%\VSCodium\bin;%%PATH%%
>> start.bat echo SET OSFONTDIR=%%cd%%\TeX3R-ClasseStyle\tex\fonts\TeX3R
>> start.bat echo start "" "%%CD%%\Vscodium\VSCodium.exe"


:: Creer le fichier update.bat
> update.bat echo cd /d %%~dp0
>> update.bat echo ::
>> update.bat echo :: Variables environnement systeme temporaires
>> update.bat echo SET PATH=%%CD%%\PortableGit\cmd;%%CD%%\miktex\texmfs\install\miktex\bin\x64;%%CD%%\Tex3R-ClasseStyle;%%cd%%\VSCodium\bin;%%PATH%%
>> update.bat echo SET TeX3R-ClasseStyle_PATH=%%cd%%\TeX3R-ClasseStyle
>> update.bat echo SET VSCodium_PATH=%%cd%%\VSCodium
>> update.bat echo SET Miktex_PATH=%%cd%%\miktex
>> update.bat echo SET PortableGit_PATH=%%cd%%\PortableGit\cmd
>> update.bat echo cd "%%TeX3R-ClasseStyle_PATH%%"
>> update.bat echo git pull
>> update.bat echo echo mise a jour terminee
>> update.bat echo pause

cls
echo *********  Installation Extensions VScodium (langue fr et TeX3R) *****************

:: Telechargement de l'extension
echo Installation langage fr et TeX3R
codium --install-extension MS-CEINTL.vscode-language-pack-fr
echo Installation TeX3R
codium --install-extension Tex3R.tex3r
echo installation terminee.


echo installation terminee
pause


