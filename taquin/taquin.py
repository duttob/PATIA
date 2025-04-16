from typing import List, Literal
from random import shuffle
import heapq

Algorithm = Literal['bfs', 'dfs', 'astar']
Move = Literal['up', 'down', 'left', 'right']

Solution = List[Move]
State = List[int]

UP = 'up'
DOWN = 'down'
LEFT = 'left'
RIGHT = 'right'

BFS = 'bfs'
DFS = 'dfs'
ASTAR = 'astar'

goal_state: State = []
initial_state: State = []


def index_to_coords(index: int, dimension: int) -> tuple[int, int]:
    """ Convertit un index i d'une liste de taille dimension**2 en coordonnées (x, y) dans un tableau 2D de taille dimension x dimension."""
    i = index // dimension
    j = index % dimension
    return i, j

def coords_to_index(i: int, j: int, dimension: int) -> int:
    return i * dimension + j

class NPuzzle:
    def __init__(self, dimension: int) -> None:
        self.dimension = dimension

    def __init__(self, initial_state: State) -> None:
        self.initial_state = initial_state
    
    def set_dimension(self, dimension: int) -> None:
        self.dimension = dimension

    def generate(self, dimension: int) -> State:
        """ Generate a random n-puzzle """
        self.dimension = dimension
        init_state : State = [i for i in range(dimension ** 2)]
        while True:
            shuffle(init_state)
            if self.is_solvable(init_state):
                break
        return init_state

    def create_goal(self) -> State:
        """ Create the goal state of the puzzle """
        return [i for i in range(1, self.dimension ** 2)] + [0]

    def solve_bfs(self, puzzle: State) -> Solution:
        """ Solve the puzzle using the BFS algorithm """
        if not self.is_solvable(puzzle):
            print("Non solvable !")
            return []

        visited = set()
        queue = [(puzzle, [])]
        while queue:
            current_state, path = queue.pop(0)
            if self.is_goal(current_state):
                return path

            for state, direction in zip(self.get_neighbors(current_state), [UP, DOWN, LEFT, RIGHT]):
                if state is None: continue
                if tuple(state) not in visited:
                    updated_path = path.copy()
                    updated_path.append(direction)
                    queue.append((state, updated_path))
                    visited.add(tuple(current_state))
        return []

    def solve_dfs(self, puzzle: State) -> Solution:
        """ Solve the puzzle using the DFS algorithm """
        if not self.is_solvable(puzzle):
            print("Non solvable !")
            return []

        stack = [(puzzle, [])]
        visited = set()
        while stack:
            current_state, path = stack.pop()
            if tuple(current_state) not in visited:
                visited.add(tuple(current_state))
                if self.is_goal(current_state):
                    return path

                for state, direction in zip(self.get_neighbors(current_state), [UP, DOWN, LEFT, RIGHT]):
                    if state is None: continue
                    if tuple(state) not in visited:
                        updated_path = path.copy()
                        updated_path.append(direction)
                        stack.append((state, updated_path))
        return []

    def solve_astar(self, puzzle: State) -> Solution:
        """ Solve the puzzle using the A* algorithm """
        if not self.is_solvable(puzzle):
            print("Non solvable !")
            return []

        priority_queue = []
        heapq.heappush(priority_queue, (0, puzzle, []))

        visited = set()
        while priority_queue:
            _, current_state, path = heapq.heappop(priority_queue)

            if self.is_goal(current_state):
                return path

            visited.add(tuple(current_state))
            for state, direction in zip(self.get_neighbors(current_state), [UP, DOWN, LEFT, RIGHT]):
                if state is None: continue
                if tuple(state) not in visited:
                    priority = self.heuristic(state) + len(path) + 1
                    heapq.heappush(priority_queue, (priority, state, path + [direction]))
        return []

    def heuristic(self, puzzle: State) -> int:
        total_distance = 0
        goal = self.create_goal()
        for i in range(self.dimension ** 2):
            x1, y1 = index_to_coords(goal.index(puzzle[i]), self.dimension)
            x2, y2 = index_to_coords(i, self.dimension)
            total_distance += abs(x1 - x2) + abs(y1 - y2)
        return total_distance

    def solve(self, puzzle: State, algorithm: Algorithm) -> Solution:
        """ Solve the puzzle using the algorithm """
        solution: list = []

        if algorithm == BFS:
            solution = self.solve_bfs(puzzle)
        elif algorithm == DFS:
            solution = self.solve_dfs(puzzle)
        elif algorithm == ASTAR:
            solution = self.solve_astar(puzzle)

        return solution

    def is_solvable(self, puzzle: State) -> bool:
        """ Check if the puzzle is solvable """
        puzzle_without_blank = [element for element in puzzle if element != 0]
        inversion_count = 0
        for i in range(len(puzzle_without_blank) - 1):
            for j in range(i + 1, len(puzzle_without_blank)):
                if puzzle_without_blank[i] > puzzle_without_blank[j]:
                    inversion_count += 1

        if self.dimension % 2 == 1:
            return inversion_count % 2 == 0
        else:
            blank_position = puzzle.index(0)

            blank_row = blank_position // self.dimension
            blank_row_from_bottom = self.dimension - blank_row
            return (inversion_count % 2 == 0) == (blank_row_from_bottom % 2 == 1)


    def is_goal(self, puzzle: State) -> bool:
        """Check if the puzzle is the goal state"""
        return self.create_goal() == puzzle

    def get_neighbors(self, puzzle: State) -> List[State]:
        """ Get the neighbors of the puzzle """
        state_list = []
        for direction in [UP, DOWN, LEFT, RIGHT]:
            new_state = self.move(puzzle, direction)
            state_list.append(new_state)
        return state_list

    def move(self, puzzle: State, direction) -> State | None:
        """ Move the blank tile in the puzzle """
        new_state = None

        current_state = puzzle.copy()
        blank_index = current_state.index(0)
        i, j = index_to_coords(blank_index, self.dimension)
        target_index = 0

        if direction == UP:
            if i - 1 < 0: return None
            target_index = coords_to_index(i - 1, j, self.dimension)
            pass
        elif direction == DOWN:
            if i + 1 >= self.dimension: return None
            target_index = coords_to_index(i + 1, j, self.dimension)
            pass
        elif direction == LEFT:
            if j - 1 < 0: return None
            target_index = coords_to_index(i, j - 1, self.dimension)
            pass
        elif direction == RIGHT:
            if j + 1 >= self.dimension: return None
            target_index = coords_to_index(i, j + 1, self.dimension)

        current_state[blank_index], current_state[target_index] = current_state[target_index], current_state[blank_index]
        new_state = current_state
        return new_state

    def save_puzzle(self, puzzle: State, filename: str) -> None:
        """ Save the puzzle to a file """
        with open(filename, 'w') as file:
            file.write(' '.join(map(str, puzzle)))

    def load_puzzle(self, filename: str) -> State:
        """ Load the puzzle from a file """
        with open(filename, 'r') as file:
            puzzle = list(map(int, file.read().split()))
        return puzzle