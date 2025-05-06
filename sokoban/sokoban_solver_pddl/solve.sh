#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "[Error] Usage: $0 <level.json>"
    exit 1
fi

DOMAIN_FILE="domain.pddl"
JSON_FILE=$1
PROBLEM_FILE="parsed_levels/${JSON_FILE%.json}.pddl"

echo "[Parser] Generating PDDL problem file from ${JSON_FILE}..."
python3 parser/level_parser.py "$JSON_FILE"

if [ ! -f "$PROBLEM_FILE" ]; then
    echo "[Error] Problem file ${PROBLEM_FILE} was not generated."
    exit 1
fi

echo "[Solver] Running solver with domain ${DOMAIN_FILE} and problem ${PROBLEM_FILE}..."
output=$(java -cp ./pddl4j-4.0.0.0.jar -server -Xms2048m -Xmx2048m fr.uga.pddl4j.planners.statespace.HSP "$DOMAIN_FILE" "$PROBLEM_FILE" -t 1 -m 1000 | python3 parser/parse_output.py)
echo "[Solver] Output: ${output}"
echo "[Viewer] Viewer launched go on https://localhost:8888 for visual solution"

{
    cd .. || exit 1
    java --add-opens java.base/java.lang=ALL-UNNAMED \
    -server -Xms2048m -Xmx2048m \
    -cp "$(mvn dependency:build-classpath -Dmdep_outputFile=/dev/stdout -q):target/test-classes/:target/classes" \
    schema.SokobanMain "$output" "$JSON_FILE" 
}