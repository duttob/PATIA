#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: generate-solve.sh <puzzle-size>"
  exit 1
fi

# Générer le puzzle
python3 taquin_generator.py "$1"

if [ ! -f "generated.pddl" ]; then
  echo "[Error] Generated PDDL file not created"
  exit 1
fi

echo "[Solver] Solving..."
java -cp ../pddl4j-4.0.0.jar -server -Xms2048m -Xmx2048m \
     fr.uga.pddl4j.planners.statespace.FF domain.pddl generated.pddl -t 1000