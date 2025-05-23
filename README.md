# PATIA

Avant de lancer quelconque fonctionalités, lancer le script `setup.sh` de la manière suivante
```bash
sudo sh setup.sh
```
Pour l'application web du sokoban, si le projet est executé depuis ssh. Initier la connection de la manière suivante : 
```bash
ssh -L 8888:localhost:8888 utilisateur@serveur
```

# TAQUIN

Implémentation du taquin, avec les algorithme de résolution A*, BFS et DFS avec graphique de leurs performances présentés dans `taquin/execution_time.ipynb`. Le générateur, le code du taquin et les graphiques de performances sont tout les trois dans le Notebook. 

## Représentation du taquin
On a choisit de représenter le taquin comme une liste d'entier de 0 à n² - 1. Le 0 étant la case vide.
Ainsi le taquin suivant\
1 2 3\
4 5 6\
7 8 0\
est représenté comme cela :
[1 2 3 4 5 6 7 8 0]

# PDDL - HANOI

L'execution du planificateur pour les tours d'hanoi se fait depuis le dossier `pddl` en lancant le script `pddl4j.sh`, en rentrant le domaine `hanoi/domain.pddl` et le problème `hanoi/4-disks.pddl` ou `hanoi/3-disks.pddl`

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

Ce script automatise le processus de génération de problème au format PDDL (fichiers pddl parsé retrouvable dans `sokoban/sokoban_solver_pddl/parsed_levels`) à partir d’un fichier `.json` (se trouvant dans `sokoban/config/`), puis résout ce problème en appelant un planificateur, affiche cette solution et lance l'application de visualisation pour cette solution.

## Utilisation

```bash
./solve.sh <fichier-level.json>
```

# SATPlanner
Nous avons tenté d'implémenter le planner comme vu dans le cours, nous ne sommes pas capables de fournir des plans pour des problemes entiers mais certaines parties isolées de notre solution fonctionnent.

## Ce que nous avons voulu faire :

- encodage de l’état initial en clauses unitaires à partir de problem.getInitialState().getPositiveFluents()

- génération des clauses de préconditions et d’effets non conditionnels via Condition et Effect

- construction des frame axiomes pour la persistance des fluents d’une étape à l’autre

- implémentation de la boucle incrémentale dans YetAnotherSATPlanner : instanciation du solver, ajout des clauses CNF, test SAT, extraction de modèle (cf. cours)

## Soupçons de causes de dysfonctionnement :

- pas certain de devoir encoder ou non les fluents négatifs initiaux

- clause de disjonction d’actions incorrecte (unit clauses pour chaque action au lieu d’une clause « au moins une action »)

- frame axiomes peut-être mal construites, laissant passer des transitions non souhaitées
