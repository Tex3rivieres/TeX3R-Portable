# TeX3R-Portable installation automatique (Windows)
* Créer un répertoire à la racine du support USB. Par exemple: **"./TeX3R-Portable"**
* Copier install.bat à l'intérieur et exécuter

# TeX3R-Portable installation manuelle

## Repertoire du programme
* Créer un répertoire à la racine du support USB. Par exemple: **"./TeX3R-Portable"**

## Git pour installation et mise à jour
 
* Telecharger la version "Git Portable" adaptée à votre sytème d'exploitation :[git-scm.com/downloads](https://git-scm.com/downloads)
   * Décompresser l'archive dans **"./TeX3R-Portable/PortableGit"**

## VSCodium : Editeur de texte

* Télécharger l'archive de VSCodium adaptée à votre sytème d'exploitation :  [github.com/VSCodium/vscodium/releases](https://github.com/VSCodium/vscodium/releases)
   * Décompresser l'archive dans **"./TeX3R-Portable/VSCodium"**
   * Créer le repertoire **"./TeX3R-Portable/VSCodium/data"**

## MiKTeX : Interpréteur Latex
* Telecharger [MiKTeX](https://MiKTeX.org/download)
   * Renommer **"basic-MiKTeX-*.exe"** en **"MiKTeX-portable.exe"**
   * Executer et indiquer **"./TeX3R-Portable/MiKTeX"** comme repertoire d'installation
* Copier **TeX3R.bat** dans **"./TeX3R-Portable"**
* Executer **"./TeXR3R-Portable/TeX3R.bat"** puis quitter VSCodium.
* Exécuter **"./Tex3R_Portable/MiKTeX/MiKTeX-portable.cmd"**
   * Ouvrir la console à partir de la barre des tâches :

 ![](assets/images/console-miktek.png)
  
   * Mettre à jour MiKTeX : 

 <img src="./assets/images/update-MiKTeX.png" width="400"/>
  
   * Ajouter **"./TeX3R-Portable/TeX3R-CS"** au "Path" MiKTeX
 
  ![](assets/images/path-MiKTeX.png)

   * Rafraîchir la base de données des noms de fichiers
 
  ![](assets/images/name_database-MiKTeX.png)

## Utilisation du programme
* Utiliser **"./TeXR3R-Portable/TeX3R.bat"** pour exécuter et maintenir à jour TeX3R
* Installer l'extension TeX3R (1 seule fois)
**Attention**, la première compilation d'un document ```.tex``` est un peu longue car MiKTeX telecharge et installe les packages qui ne sont pas déjà dans sa base.

## Enjoy ;) 

## Pour les impateints
ArchiveSFX prête à l'emploi
