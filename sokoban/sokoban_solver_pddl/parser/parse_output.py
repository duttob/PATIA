import sys
import re

def parse_solver_output(output):
    pattern = re.compile(r'^\d+:\s*\((.+)\)\s*\[\d+\]$')
    
    actions = []
    
    for line in output.splitlines():
        match = pattern.match(line.strip())
        if match:
            action = match.group(1).strip()
            action_type = action.split()[0] 
            if action_type.startswith("move") or action_type.startswith("push"):
                if action_type == "move-right" or action_type == "push-right":
                    actions.append("R")
                elif action_type == "move-left" or action_type == "push-left":
                    actions.append("L")
                elif action_type == "move-up" or action_type == "push-up":
                    actions.append("U")
                elif action_type == "move-down" or action_type == "push-down":
                    actions.append("D") 
    
    return actions

def main():
    solver_output = sys.stdin.read()
    actions = parse_solver_output(solver_output)
    print("".join(actions))

if __name__ == "__main__":
    main()