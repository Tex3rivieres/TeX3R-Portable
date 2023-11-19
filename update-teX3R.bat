cd /d %~dp0
set PATH=%cd%\PortableGit\cmd;%cd%\Tex3R;%PATH%

SET REPO_PATH=%cd%\TeX3R
@echo off
chcp 65001

@echo on
echo Mise à jour du dépôt Git...




cd %REPO_PATH%
git pull
echo Mise à jour terminée.
pause
