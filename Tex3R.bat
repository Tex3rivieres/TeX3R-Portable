echo off
cd /d %~dp0
set PATH=%cd%\PortableGit\cmd;%cd%\miktex\texmfs\install\miktex\bin\x64;%cd%\Tex3R-ClasseStyle;%cd%\python;%cd%\Sumatra;%PATH%
SET OSFONTDIR=%cd%\TeX3R-ClasseStyle\tex\fonts\TeX3R
SET REPO_PATH=%cd%\TeX3R-ClasseStyle
SET VSCodium_PATH=%cd%\VSCodium

chcp 65001

if not exist "%REPO_PATH%" (
    echo Clonage du dépôt TeX3R-ClasseStyle en cours...
    git clone https://github.com/Tex3rivieres/TeX3R-ClasseStyle.git "%REPO_PATH%"
) else (
    echo Mise à jour du dépôt TeX3R-ClasseStyle...
    cd %REPO_PATH%
    git config --global --add safe.directory "%REPO_PATH%"
    git pull
    echo Mise à jour terminée.
)

pause

start "" "%cd%\vscodium\VSCodium.exe"
