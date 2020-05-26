# Task 1
def find_position(string: str, key: str) -> list:
    return [position for position, char in enumerate(string) if char == key]


def find_positions(string: str, *keys) -> dict:
    positions = {}
    for key in keys:
        position = find_position(string, key)
        if position:
            positions[key] = position
    return positions


# Task 2
def positions_to_tuple_list(positions: dict) -> list:
    tuple_list = []
    for char in positions:
        for position in positions[char]:
            tuple_list.append((position, char))
    return sorted(tuple_list)


def positions_to_tuple_list_comprehension(positions: dict) -> list:
    return sorted([(pos, key) for key in positions for pos in positions[key]])


# Task 3
def dict_sorted_generator(input_dict: dict):
    return ((key, value) for key, value in sorted(input_dict.items()))


# Task 4
def draw_histo(input_dict: dict) -> None:
    new_dict = {key: len(value) for key, value in input_dict.items()}
    for key, value in dict_sorted_generator(new_dict):
        print(key, "*" * value)


# Task 5
def convert_to_unique(input_list: list) -> list:
    return [*set(input_list)]


# Task 6
def jaccard_index(set_1: set, set_2: set) -> float:
    return len(set_1 & set_2) / len(set_1 | set_2)


# Task 7
def evaluate_sets(set_1: set, set_2: set) -> tuple:
    return (set_1, set_2) if len(set_1) >= len(set_2) else (set_2, set_1)


def remove_from_bigger_set(bigger: set, smaller: set) -> None:
    bigger.remove((bigger - smaller).pop())


def optimize_jaccard_index(set_1: set, set_2: set, limit=0.9) -> float:
    index = jaccard_index(set_1, set_2)
    while set_1 and set_2 and index < limit:
        try:
            remove_from_bigger_set(*evaluate_sets(set_1, set_2))
        except KeyError:
            break
        index = jaccard_index(set_1, set_2)
    return index


def main():
    # Task 1
    positions = find_positions("test" * 2 + "xD", "a", "e", "s", "x")
    print(positions)

    # Task 2
    print(positions_to_tuple_list(positions))
    print(positions_to_tuple_list_comprehension(positions))

    # Task 3
    dict_gen = dict_sorted_generator({5: 1, 1: 5})
    for a, b in dict_sorted_generator({5: 1, 1: 5}):
        print(f"k={a}, v={b}")
    for a, b in dict_gen:
        print(f"k={a}, v={b}")
    for a, b in dict_gen:
        print(f"k={a}, v={b}")

    # Task 4
    draw_histo(positions)

    # Task 5
    print(convert_to_unique([1, 2, 1, 2, 6, 7, 6, 9, 9, 9, 10]))

    # Task 6
    s1 = {0, 10, 20}
    s2 = {20, 5, 10}
    print(jaccard_index(s1, s2))

    # Task 7
    set_1 = {0, 5, 4}
    set_2 = {5, 2, 4}
    optimize_jaccard_index(set_1, set_2, 0.55)
    print(set_1, set_2, jaccard_index(set_1, set_2))

    set_1 = {0, 5, 4}
    set_2 = {5, 2, 4}
    optimize_jaccard_index(set_1, set_2)
    print(set_1, set_2, jaccard_index(set_1, set_2))


if __name__ == "__main__":
    main()
