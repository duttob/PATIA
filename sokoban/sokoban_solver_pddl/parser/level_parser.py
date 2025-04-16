import json
import sys
import os

path = os.getcwd()

with open("../config/" + sys.argv[1], "r", encoding="utf-8") as f:
    data = json.load(f)  

level_tab = data['testIn'].split('\n')
l = max(len(line) for line in level_tab)
h = len(level_tab)

with open(path + "/parser/template.txt", "r", encoding="utf-8") as f:
    template = f.read()

coords_objects = [f"x{j}" for j in range(l)] + [f"y{i}" for i in range(h)]
coords_system = []
for i in range(h - 1):
    coords_system.append(f"(above y{i} y{i + 1})")
for j in range(l - 1):
    coords_system.append(f"(right-of x{j + 1} x{j})")

map_info = []
goal_info = []
for i in range(h):
    for j in range(len(level_tab[i])):
        if level_tab[i][j] == " ": # vide
            map_info.append(f"(empty x{j} y{i})")
        elif level_tab[i][j] == ".": # goal
            goal_info.append(f"(box-at x{j} y{i})")
            map_info.append(f"(empty x{j} y{i})")
        elif level_tab[i][j] == "@": # player
            map_info.append(f"(player-at p x{j} y{i})")
        elif level_tab[i][j] == "*":
            map_info.append(f"(box-at x{j} y{i})")
            goal_info.append(f"(box-at x{j} y{i})")
        elif level_tab[i][j] == "$":
            map_info.append(f"(box-at x{j} y{i})")
        elif level_tab[i][j] == "+":
            goal_info.append(f"(box-at x{j} y{i})")
            map_info.append(f"(player-at p x{j} y{i})")


file_content = template.format(
    coords_objects=" ".join(coords_objects),
    coords_system="\n\t".join(coords_system),
    map_info="\n\t".join(map_info),
    goal="(and\n" + "\n\t".join(goal_info) + "\n)"
)

with open(f"parsed_levels/{sys.argv[1].split('.')[0]}.pddl", "w", encoding="utf-8") as f:
    f.write(file_content)
