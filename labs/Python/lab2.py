import numpy as np


# Task 1
def array_filter(array: np.array, t: int) -> list:
    return [(x, y) for x, y in np.ndindex(array.shape) if array[x, y] >= t]


# Task 2
def get_queen_moves(x: int, y: int) -> np.array:
    return np.array([[1 if ((i == x and j != y)
                            or (j == y and i != x)
                            or abs(x - i) == abs(y - j) > 0)
                      else 0 for i in range(8)] for j in range(8)])


# Task 3
def check_queen_puzzle(chessboard: np.array) -> bool:
    positions = array_filter(chessboard, 1)
    board = np.transpose(np.add.reduce(np.array([get_queen_moves(p[0], p[1])
                                                 for p in positions])))
    return np.add.reduce(np.array([board[pos] for pos in positions])) == 0


# Task 4
def generate_system(solution: np.array) -> tuple:
    n = solution.shape[0]
    coefficients = np.random.uniform(-1, 1, (n, n))
    np.fill_diagonal(coefficients, 0)
    non_diag = np.sum(abs(coefficients))
    np.fill_diagonal(coefficients, non_diag + np.random.uniform(0, non_diag))
    return coefficients, coefficients @ solution


# Task 5
def solve_system(coefficients: np.array, free_terms: np.array,
                 threshold=0.01, limit=25):
    x = np.zeros(coefficients.shape[0])
    diag = np.diag(coefficients)
    for i in range(limit):
        prev_x = x.copy()
        x = (free_terms - (coefficients - np.diagflat(diag)) @ x) / diag
        if np.all(abs(x - prev_x) < threshold):
            break
    return x


def main():
    # Task 1
    print(array_filter(np.array([[1, 2], [3, 4]]), 2))

    # Task 2
    print(get_queen_moves(2, 3))

    # Task 3
    chessboard = np.zeros((8, 8), dtype=int)
    chessboard[3, 2] = 1
    chessboard[6, 1] = 1
    print(check_queen_puzzle(chessboard))

    # Task 4
    linear_system = generate_system(np.array([[1], [2]]))
    print(linear_system)

    # Task 5
    print(solve_system(*linear_system))

    # Task 6
    print(np.linalg.solve(*linear_system))
    print(np.linalg.inv(linear_system[0]).dot(linear_system[1]))


if __name__ == "__main__":
    main()
