import numpy as np
import time


# Task 1
def get_distance_matrix(array: np.array) -> np.array:
    n = array.shape[0]
    result = np.zeros((n, n))
    for x, y in np.ndindex(result.shape):
        result[x, y] = np.linalg.norm(array[x] - array[y])
    return result


# Task 2
def eliminate_distances(probability: float, array: np.array) -> np.array:
    result = array.copy()
    indices = np.random.uniform(0, 1, array.shape)
    result[probability >= indices] = np.inf
    return result


# Task 3
def calculate_floyd_warshall(array: np.array) -> np.array:
    n = array.shape[0]
    result = array.copy()
    for k in range(n):
        for i in range(n):
            for j in range(n):
                if array[i, j] > array[i, k] + array[k, j]:
                    result[i, j] = array[i, k] + array[k, j]
    return result


# Task 4
def apply_functions(probability: float, array: np.array) -> float:
    return float(np.sum(calculate_floyd_warshall(
        eliminate_distances(probability, get_distance_matrix(array)))))


# Task 5
def generate_system(solution: np.array) -> tuple:
    n = solution.shape[0]
    coefficients = np.random.uniform(0, 100, (n, n))
    np.fill_diagonal(coefficients, 0)
    non_diag = np.sum(abs(coefficients))
    np.fill_diagonal(coefficients, [non_diag + np.random.uniform(0, non_diag)
                                    for _ in range(n)])
    return coefficients, coefficients @ solution


# Task 6
def solve_system(coefficients: np.array, free_terms: np.array,
                 threshold=0.01, limit=1000) -> np.array:
    x = np.zeros((coefficients.shape[0], 1))
    diag = np.array([np.diag(coefficients)]).T
    for i in range(limit):
        prev_x = x.copy()
        x = (free_terms - ((coefficients - np.diagflat(diag)) @ x)) / diag
        if np.allclose(x, prev_x, threshold):
            break
    return x


# Task 7
def inversion(coefficients: np.array, free_terms: np.array) -> np.array:
    return np.linalg.inv(coefficients).dot(free_terms)


def execute_solution_method(method: callable, *args) -> None:
    t = time.perf_counter()
    method(*args)
    print("%s: %.5fs" % (method.__name__, time.perf_counter() - t))


def measure_execution_times() -> None:
    equations_number = [100, 200, 500, 1000, 2000, 5000]
    methods = [solve_system, np.linalg.solve, inversion]
    for number in equations_number:
        x = np.array([np.arange(number)]).T
        coefficients, free_terms = generate_system(x)
        print("Number of equations: %d" % number)
        for method in methods:
            execute_solution_method(method, coefficients, free_terms)
        print("\n")


def main():
    # Task 1
    matrix = np.array([[2, 1, 2], [3, 4, 5], [6, 7, 8], [9, 10, 2]])
    print(get_distance_matrix(matrix))

    # Task 2
    print(eliminate_distances(0.2, matrix.astype(float)))

    # Task 3
    distance_array = np.array([[10, 1, 10], [3, 4, 5], [6, 7, 8]])
    print(calculate_floyd_warshall(distance_array))

    # Task 4
    test_matrix = np.random.uniform(0, 100, (100, 3))
    print("Original: %f" % np.sum(test_matrix))
    msg = "Modified (probability = %.2f): %.2f"
    for probability in [0.5, 0.9, 0.99]:
        print(msg % (probability, apply_functions(probability, test_matrix)))
    # for probabilities 0.9 and 0.99 there are too many infs to reduce them

    # Task 5
    linear_system = generate_system(np.array([np.arange(3)]).T)
    print(linear_system)

    # Task 6
    print(solve_system(*linear_system))

    # Task 7
    print(np.linalg.solve(*linear_system))
    print(np.linalg.inv(linear_system[0]).dot(linear_system[1]))
    measure_execution_times()
    """
    Task 7 results:
        
    Number of equations: 100
    solve_system: 0.00055s
    solve: 0.00608s
    inversion: 0.00081s
    
    
    Number of equations: 200
    solve_system: 0.00210s
    solve: 0.00146s
    inversion: 0.00211s
    
    
    Number of equations: 500
    solve_system: 0.00903s
    solve: 0.00583s
    inversion: 0.01032s
    
    
    Number of equations: 1000
    solve_system: 0.02899s
    solve: 0.01925s
    inversion: 0.04739s
    
    
    Number of equations: 2000
    solve_system: 0.11639s
    solve: 0.09915s
    inversion: 0.29726s
    
    
    Number of equations: 5000
    solve_system: 0.44502s
    solve: 0.89216s
    inversion: 2.94675s
    """


if __name__ == "__main__":
    main()
