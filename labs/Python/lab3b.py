import multiprocessing as mp
import numpy as np
import time
from functools import partial


class Timer:
    def __init__(self):
        self.__start = 0.0

    def __enter__(self):
        self.__start = time.time()
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        print(time.time() - self.__start)


# Task 5
def root(number: float, order: int) -> float:
    return number ** (1.0 / order)


def sequential(x: float, results: np.array, iterations: int) -> None:
    for i in range(iterations):
        results[i] = root(x, i + 1)


# Task 6
def multiprocess(x: float, results: np.array,
                 iterations: int, pool: mp.Pool) -> None:
    with pool:
        res = pool.starmap(root, ((x, i + 1) for i in range(iterations)))
    results[:] = res


# Task 7
def root_array(number: float, begin: int, size: int) -> np.array:
    results = np.empty(size)
    for i in range(size):
        results[i] = root(number, begin + i + 1)
    return results


def multiprocess_array(x: float, results: np.array,
                       iterations: int, pool: mp.Pool) -> None:
    no_workers = pool._processes
    size = iterations // no_workers
    with pool:
        res = pool.starmap(root_array,
                           ((x, i * size, size) for i in range(no_workers)))
    results[:] = np.concatenate(res)


# Task 8
def task(job_id: int, lock: mp.Lock) -> None:
    lock.acquire()
    try:
        print("Job id: %d" % job_id)
    finally:
        lock.release()


def main():
    # Task 5, 6, 7
    iterations = int(1e7)
    np.random.seed(237)
    x = np.random.uniform(1, 100)
    results = np.empty(iterations)
    pool = mp.Pool(mp.cpu_count())
    pool2 = mp.Pool(mp.cpu_count())
    algorithms = [partial(sequential, x, results, iterations),
                  partial(multiprocess, x, results, iterations, pool),
                  partial(multiprocess_array, x, results, iterations, pool2)]
    for algorithm in algorithms:
        print(algorithm.func.__name__)
        with Timer():
            algorithm()

    # Task 8
    lock = mp.Lock()
    workers = [mp.Process(target=task, args=(job, lock)) for job in range(10)]
    for worker in workers:
        worker.start()
    for worker in workers:
        worker.join()


if __name__ == "__main__":
    main()
