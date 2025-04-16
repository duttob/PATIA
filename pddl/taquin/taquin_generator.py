import sys 
from random import shuffle
from typing import List, Literal

State = List[int]

def is_solvable(puzzle: State, dimension) -> bool:
        """ Check if the puzzle is solvable """
        puzzle_without_blank = [element for element in puzzle if element != 0]
        inversion_count = 0
        for i in range(len(puzzle_without_blank) - 1):
            for j in range(i + 1, len(puzzle_without_blank)):
                if puzzle_without_blank[i] > puzzle_without_blank[j]:
                    inversion_count += 1

        if dimension % 2 == 1:
            return inversion_count % 2 == 0
        else:
            blank_position = puzzle.index(0)

            blank_row = blank_position // dimension
            blank_row_from_bottom = dimension - blank_row
            return (inversion_count % 2 == 0) == (blank_row_from_bottom % 2 == 1)

def generate(dimension: int) -> State:
    """ Generate a random n-puzzle """
    dimension = dimension
    init_state : State = [i for i in range(dimension ** 2)]
    while True:
        shuffle(init_state)
        if is_solvable(init_state, dimension):
            break
    return init_state

def create_problem_pddl(state: State, dimension: int, filename="generated.pddl"):
    with open(filename, "w") as f:
        f.write(f"(define (problem taquin-problem)\n")
        f.write(f"  (:domain taquin)\n")
        f.write(f"  (:objects\n")
        for i in range(dimension):
            f.write("    " + " ".join([f"x{i}" for i in range(dimension)]) + " - coords\n")
            break
        for j in range(dimension):
            f.write("    " + " ".join([f"y{j}" for j in range(dimension)]) + " - coords\n")
            break
        f.write("    " + " ".join([f"t{i}" for i in range(1, dimension ** 2)]) + " - tile-obj\n")
        f.write("  )\n")

        f.write("  (:init\n")

        for i in range(dimension):
            for j in range(dimension - 1):
                f.write(f"    (right-of x{j + 1} x{j})\n")
                f.write(f"    (above y{j + 1} y{j})\n")

        for idx, tile in enumerate(state):
            x = idx % dimension
            y = idx // dimension
            if tile == 0:
                f.write(f"    (empty x{x} y{y})\n")
            else:
                f.write(f"    (placed-at t{tile} x{x} y{y})\n")

        f.write("  )\n")

        f.write("  (:goal (and\n")
        for tile in range(1, dimension ** 2):
            goal_x = (tile - 1) % dimension
            goal_y = (tile - 1) // dimension
            f.write(f"    (placed-at t{tile} x{goal_x} y{goal_y})\n")
        f.write(f"    (empty x{dimension - 1} y{dimension - 1})\n")
        f.write("  ))\n")
        f.write(")\n")

if __name__ == "__main__":
    dimension = int(sys.argv[1])
    puzzle = generate(dimension)
    print("Puzzle generated :", puzzle)
    create_problem_pddl(puzzle, dimension)
    print("PDDL generated : generated.pddl")