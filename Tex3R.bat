cd /d %~dp0
set PATH=
%cd%\miktex\texmfs\install\miktex\bin\x64;
%cd%\fonts;%cd%\Tex3R-CS;
%cd%\python;%cd%\Sumatra;%cd%\PortableGit\cmd;
%PATH%

SET OSFONTDIR=%cd%\TeX3R-CS\tex\fonts\TeX3R

SET REPO_PATH=%cd%\TeX3R-CS
SET VSCodium_PATH=%cd%\VSCodium

chcp 65001

if not exist "%REPO_PATH%" (
    echo Le dépôt n'existe pas, clonage en cours...
    git clone https://github.com/Tex3rivieres/TeX3R-CS "%REPO_PATH%"
) else (
    echo Mise à jour du dépôt Git...
    cd %REPO_PATH%
    git pull
    echo Mise à jour terminée.
)


start "" "%VSCodium_PATH%\VSCodium.exe"


