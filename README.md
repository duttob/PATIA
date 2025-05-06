# PATIA



# PDDL - HANOI

L'execution du planificateur pour les tours d'hanoi se fait depuis le dossier `pddl` en lancant le script `pddl4j.sh`, en rentrant le domaine `pddl/hanoi/domain.pddl` et le problème `pddl/hanoi/4-disks.pddl`

# PDDL - TAQUIN

Pour tester le planificateur sur le jeu du taquin on se place dans le dossier `pddl/taquin` puis on execute le script suivant:

`generate-solve.sh` – Script de résolution de taquin aléatoire de taille choisie avec PDDL
## Utilisation

```bash
./generate-solve.sh <taille-du-puzzle>
```

# Sokoban

Aller dans le répertoire sokoban/sokoban_solver_pddl puis executer le script suivant :

`solve.sh` – Script de résolution Sokoban avec PDDL

Ce script automatise le processus de génération de problème au format PDDL (fichiers pddl parsé retrouvable dans `sokoban/sokoban_solver_pddl/parsed_levels`) à partir d’un fichier `.json` (se trouvant dans `sokoban/config/`), puis résout ce problème en appelant un planificateur et affiche cette solution et lance l'application de visualisation pour cette solution.

## ▶️ Utilisation

```bash
./solve.sh <fichier-level.json>
