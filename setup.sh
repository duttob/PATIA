#!/bin/bash

cd sokoban
mvn install:install-file -DgroupId=fr.uga -DartifactId=pddl4j -Dversion=4.0.0 -Dpackaging=jar -Dfile=sokoban_solver_pddl/pddl4j-4.0.0.jar
mvn compile
cd ..