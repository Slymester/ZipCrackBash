# ZIPCrackBash

`ZIPCrackBash` est un script en Bash conçu pour effectuer une attaque par force brute sur des fichiers ZIP protégés par mot de passe. Il génère des permutations à partir d'un fichier d'entrée et tente chaque mot de passe jusqu'à trouver le bon.

## Fonctionnalités

- **Génération de permutations** : Crée toutes les combinaisons possibles à partir des colonnes d'un fichier d'entrée.
- **Gestion des fichiers temporaires** : Les permutations sont stockées dans un fichier temporaire pour un traitement optimisé.
- **Support pour plusieurs lignes d'entrée** : Peut lire des informations utilisateur à partir d'un fichier texte (prénoms, noms, dates, etc.).
- **Mode verbeux** : Affiche les mots de passe testés.
- **Sauvegarde des résultats** : Possibilité de sauvegarder les tentatives dans un fichier externe.
- **Validation des entrées** : Gère les lignes vides et limite le nombre de colonnes analysées.

## Prérequis

- Système d'exploitation : Linux ou tout autre système compatible avec Bash.
- Outils nécessaires :
  - `unzip` : utilisé pour tester les mots de passe.

## Installation

Clonez ce dépôt GitHub sur votre machine locale :

```bash
git clone https://github.com/Slymester/ZIPCrackBash.git
cd ZIPCrackBash
écriture


Rendez le script exécutable :
chmod +x ZIPCrackBash.sh

Utilisation
Syntaxe
./ZIPCrackBash.sh [-v] [-s save_file.txt] [users.txt] [archive.zip]
Options

    -v : Mode verbeux, affiche les mots de passe testés.
    -s save_file.txt : Enregistre les mots de passe testés et les statistiques dans un fichier texte.
    users.txt : (Optionnel) Fichier contenant les informations utilisateur.
    archive.zip : (Optionnel) Fichier ZIP à déverrouiller.

Exemple d'exécution

    Avec tous les arguments :
    ./ZIPCrackBash.sh -v -s attempts.log users.txt archive.zip

Exécution interactive :

Si vous n'indiquez pas les fichiers en ligne de commande, le script vous les demandera :

./ZIPCrackBash.sh
What is the name of the file containing user information? users.txt
What is the name of the ZIP file to crack? archive.zip
Exemple de fichier d'entrée (users.txt)

Chaque ligne représente un utilisateur avec des informations séparées par des espaces :

John Smith 1984
Alice Brown 2020
Mark Lee

Le script générera toutes les permutations possibles des mots sur chaque ligne, par exemple :

    John
    Smith
    1984
    John Smith
    Smith John 1984
    etc.

Résultats

    Si le mot de passe est trouvé : il sera affiché dans la console et sauvegardé dans le fichier spécifié (si l'option -s est utilisée).

    Si aucun mot de passe ne correspond, le script affichera :

    Password not found. Process completed.

Nettoyage

Le script crée un fichier temporaire pour stocker les permutations. Celui-ci est automatiquement supprimé à la fin de l'exécution.
Limitations

    Le nombre de colonnes est limité par défaut à 5 pour éviter une surcharge de permutations.
    Le fichier users.txt doit être bien formaté ; les caractères non alphanumériques sont supprimés automatiquement.

Contribuer

    Forkez le projet.
    Créez une branche pour vos modifications (git checkout -b feature/my-feature).
    Commitez vos modifications (git commit -m 'Add my feature').
    Poussez sur la branche (git push origin feature/my-feature).
    Ouvrez une Pull Request.