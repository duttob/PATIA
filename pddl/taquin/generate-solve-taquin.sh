#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' 

log() {
    local tag=$1
    local color=$2
    local message=$3
    echo "${color}[${tag}]${NC} ${message}"
}

python3 taquin_generator.py $1
log Solver $BLUE start solving ...

java -cp ../pddl4j-4.0.0.jar -server -Xms2048m -Xmx2048m fr.uga.pddl4j.planners.statespace.FF domain.pddl generated.pddl -t 1000

