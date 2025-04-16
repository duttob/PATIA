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

if [ "$#" -ne 1 ]; then
    echo "${RED}[Error]${NC} Usage: $0 <level.json>"
    exit 1
fi

DOMAIN_FILE="domain.pddl"
JSON_FILE=$1
PROBLEM_FILE="parsed_levels/${JSON_FILE%.json}.pddl"

log "Parser" "${BLUE}" "Generating PDDL problem file from ${JSON_FILE}..."
python3 parser/level_parser.py "$JSON_FILE"

if [ ! -f "$PROBLEM_FILE" ]; then
    log "Error" "${RED}" "Problem file ${PROBLEM_FILE} was not generated."
    exit 1
fi

log "Solver" "${GREEN}" "Running solver with domain ${DOMAIN_FILE} and problem ${PROBLEM_FILE}..."
output=$(java -cp ./pddl4j-4.0.0.jar -server -Xms2048m -Xmx2048m fr.uga.pddl4j.planners.statespace.HSP "$DOMAIN_FILE" "$PROBLEM_FILE" -t 1000 | python3 parser/parse_output.py)
log "Solver" "${GREEN}" "Output: ${output}"

log "Done" "${GREEN}" "Solver execution completed."

log "View" "${BLUE}" "To view solution past the following commands"
echo "cd .. \njava --add-opens java.base/java.lang=ALL-UNNAMED       -server -Xms2048m -Xmx2048m       -cp \"\$(mvn dependency:build-classpath -Dmdep.outputFile=/dev/stdout -q):target/test-classes/:target/classes\"       sokoban.SokobanMain ${output} ${JSON_FILE} \ncd sokoban_solver_pddl"