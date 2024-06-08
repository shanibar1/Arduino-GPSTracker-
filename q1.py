import heapq
import pandas as pd
from collections import deque, defaultdict
from itertools import permutations

def build_graph(adjacency_df): # build a graph of neighbors between the cities
    graph = defaultdict(list)
    for _, row in adjacency_df.iterrows():
        county1 = row.iloc[0]
        county2 = row.iloc[1]
        graph[county1].append(county2)
        graph[county2].append(county1)
    return graph

def get_state_from_county(county): #Find the state from the county name
    return county.split(", ")[-1]

def get_step_cost(graph, current_node, neighbor): #Calculate the cost/penalty of moving between two neighboring districts.
    state = get_state_from_county(current_node)
    same_state_neighbors = sum(1 for n in graph[neighbor] if get_state_from_county(n) == state)
    return same_state_neighbors

def bfs_distance(graph, start, goal):#Calculate the distance between two cities using the BFS algorithm
    distances = {node: float('inf') for node in graph}
    distances[start] = 0
    queue = deque([start])

    while queue:#Calculate the distance between two cities using the BFS algorithm
        current_node = queue.popleft()
        current_distance = distances[current_node]

        if current_node == goal:
            return current_distance

        for neighbor in graph[current_node]:
            if distances[neighbor] == float('inf'):
                distances[neighbor] = current_distance + 1
                queue.append(neighbor)

    return distances[goal]

def a_star_search(graph, start, goal, detail_output=False): #Find the best route between two cities using the A* algorithm
    open_set = []
    heapq.heappush(open_set, (0, start))

    g_score = {node: float('inf') for node in graph}
    g_score[start] = 0

    came_from = {node: None for node in graph}

    first_iteration = True
    total_neighbors = 0

    heuristic_values = []

    while open_set:
        current_f_score, current_node = heapq.heappop(open_set)

        if current_node == goal:
            path = []
            while current_node is not None:
                path.append(current_node)
                current_node = came_from[current_node]
            path.reverse()
            return path, total_neighbors, heuristic_values

        for neighbor in graph[current_node]:
            step_cost = get_step_cost(graph, current_node, neighbor)
            tentative_g_score = g_score[current_node] + step_cost
            if tentative_g_score < g_score[neighbor]:
                came_from[neighbor] = current_node
                g_score[neighbor] = tentative_g_score
                f_score = tentative_g_score + bfs_distance(graph, neighbor, goal)
                heapq.heappush(open_set, (f_score, neighbor))

                if first_iteration:
                    total_neighbors += step_cost
                    heuristic_values.append(f_score)

        if first_iteration:
            first_iteration = False

    return None, total_neighbors, heuristic_values #return the route found, the total number of neighbors on the same route, and a heuristic estimate.

def has_intra_state_neighbors(graph, county): #check if the county has neighbors from the same state
    state = get_state_from_county(county)
    for neighbor in graph[county]:
        if get_state_from_county(neighbor) == state:
            return True
    return False

def has_any_neighbors(graph, county):#check if the district has neighbors from the same district
    return len(graph[county]) > 0

def format_output(starting_locations, goal_locations, paths, heuristics, all_heuristics, graph):
    start_color_locs = [f"{loc.split(', ', 1)[1]} ({loc.split(', ', 1)[0][0]})" for loc in starting_locations]
    max_length = max(len(path) for path in paths if path != "No path found")

    # Print the starting locations
    print("{ " + " ; ".join(start_color_locs) + " }")

    for i in range(1, max_length):
        line = []
        for path, start_loc in zip(paths, starting_locations):
            if path == "No path found":
                line.append("No path found")
            else:
                color = start_loc.split(", ")[0][0]
                if i < len(path):
                    node = path[i]
                else:
                    node = path[-1]
                line.append(f"{node} ({color})")
        print("{ " + " ; ".join(line) + " }")

        # Print heuristic after the second path line
        if i == 1:
            heuristic_str = []
            for path in paths:
                if path != "No path found" and len(path) > 1:
                    start_node = path[0]
                    second_node = path[1]
                    step_cost = get_step_cost(graph, start_node, second_node)
                    heuristic_str.append(str(step_cost))
                else:
                    heuristic_str.append("0")
            print("Heuristic: { " + " ; ".join(heuristic_str) + " }")


def count_colors(locations):#Testing in terms of the amount of colors that matches at the beginning and at the end
    color_count = defaultdict(int)
    for loc in locations:
        color = loc.split(", ")[0]
        color_count[color] += 1
    return color_count

from itertools import permutations

def find_path(starting_locations, goal_locations, search_method=1, detail_output=False):
    if search_method != 1:
        raise ValueError("Currently, only A* search (search_method=1) is implemented")

    # Count colors in starting and goal locations
    start_color_count = count_colors(starting_locations)
    goal_color_count = count_colors(goal_locations)

    # Check if color counts match
    if start_color_count != goal_color_count:
        print("No path found due to mismatch in color counts")
        return ["No path found"] * len(starting_locations)

    adjacency_df = pd.read_csv(r'C:\Users\Shani\Documents\שנה ג\סמסטר ב\מערכות נבונות\PycharmProjects\adjacency.csv')
    graph = build_graph(adjacency_df)

    results = []
    paths = []
    heuristics = []
    all_heuristics = []

    for permuted_goals in permutations(goal_locations):
        temp_results = []
        temp_paths = []
        temp_heuristics = []
        temp_all_heuristics = []

        for start_info, goal_info in zip(starting_locations, permuted_goals):
            start_color, start = start_info.split(", ", 1)
            goal_color, goal = goal_info.split(", ", 1)

            if start_color != goal_color:
                temp_results.append("No path found")
                temp_paths.append("No path found")
                temp_heuristics.append(0)
                temp_all_heuristics.append([])
                continue

            # Check for intra-state neighbors or any neighbors for start and goal
            if not has_intra_state_neighbors(graph, start) and not has_any_neighbors(graph, start):
                temp_results.append("No path found")
                temp_paths.append("No path found")
                temp_heuristics.append(0)
                temp_all_heuristics.append([])
                continue

            if not has_intra_state_neighbors(graph, goal) and not has_any_neighbors(graph, goal):
                temp_results.append("No path found")
                temp_paths.append("No path found")
                temp_heuristics.append(0)
                temp_all_heuristics.append([])
                continue

            path, total_neighbors, heuristic_values = a_star_search(graph, start, goal, detail_output)
            if path is None:
                temp_results.append("No path found")
                temp_paths.append("No path found")
                temp_heuristics.append(0)
                temp_all_heuristics.append([])
            else:
                temp_results.append(goal_info)  # הוספת יעד הסיום לפלט
                temp_paths.append(path)
                temp_heuristics.append(heuristic_values[1] if len(heuristic_values) > 1 else 0)
                temp_all_heuristics.append(heuristic_values)

        if all(result != "No path found" for result in temp_results):
            results = temp_results
            paths = temp_paths
            heuristics = temp_heuristics
            all_heuristics = temp_all_heuristics
            break

    format_output(starting_locations, results, paths, heuristics, all_heuristics, graph)

    return results


# example
starting_locations = ["Blue, Adams County, WI", "Blue, Rensselaer County, NY"]
goal_locations = ["Blue, Rensselaer County, NY", "Blue, Cannon County, TN"]
paths = find_path(starting_locations, goal_locations, search_method=1, detail_output=False)
