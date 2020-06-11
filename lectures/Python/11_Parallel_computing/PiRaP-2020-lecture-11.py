import numpy
import time
import math

import multiprocessing as mp
import joblib

# own function definitions
import tasks

def clear_all():
    gl = globals().copy()
    for var in gl:
        if var[0] == '_': continue
        if 'func' in str(globals()[var]): continue
        if 'module' in str(globals()[var]): continue

        del globals()[var]


# Main guard - put main script code in here
# (avoids multiprocessing problems when executing functions from same module in parallel)
if __name__ == "__main__":
    clear_all()
    ###############################################################################
    # Problem:
    # Evaluate logistic map for selected values of r from [1, 2] interval after
    # assumed number of iterations
    #
    # y(n) = r * y(n-1) * (1 - y(n-1))
    #
    # Evaluations for different r are independent - embarrassingly parallel problem
    print("Problem: Logistic map")

    # Case 1
    # - small number of large tasks (all of same size)
    # - few memory accesses
    print("Case 1: small number of large tasks")
    N = 100                 # number of r values to be evaluated
    numIters = 1000000      # number of iterations

    A = numpy.empty(N)
    t = time.perf_counter()
    for i in range(N):
        r = 1 + (i + 1) / N
        A[i] = tasks.logisticMap(r, numIters)
    dt_serial = (time.perf_counter() - t)
    print("Serial:", dt_serial)

    # do the same in parallel with multiprocessing Pool
    print("Number of Cores: ",  mp.cpu_count())
    numWorkers = 4 # use 4 threads anyway

    t = time.perf_counter()
    with mp.Pool(processes = numWorkers) as pool: # pool only visible in the context below
       # starmap method
       # arguments: task to be invoked, itereble object with task parameters
       # return value: list
       B = pool.starmap(tasks.logisticMap, ((1 + (i + 1) / N, numIters) for i in range(N)) )
    dt = (time.perf_counter() - t)
    print("Pool:", dt, ", speedup:", dt_serial/dt, ", correct: ", (A == B).all())

    # alternative solution: joblib library
    t = time.perf_counter()
    C = joblib.Parallel(n_jobs = numWorkers)(joblib.delayed(tasks.logisticMap)((1 + (i + 1) / N), numIters) for i in range(N))
    dt = (time.perf_counter() - t)
    print("Joblib:", dt, ", speedup:", dt_serial/dt, ", correct: ", (A == C).all())

    ##############################################################################
    # Case 2
    # - different amount of job for each task

    print("Case 2: uneven tasks")
    N = 100                 # number of r values to be evaluated
    numIters = 1000000      # number of iterations
    numWorkers = 4

    A = numpy.empty(N)
    t = time.perf_counter()
    for i in range(N):
        r = 1 + (i + 1) / N
        n = (numIters // N) * i * 2
        A[i] = tasks.logisticMap(r, n)
    dt_serial = (time.perf_counter() - t)
    print("Serial:", dt_serial)

    # parallel - pool
    t = time.perf_counter()
    with mp.Pool(processes = numWorkers) as pool: # pool only visible in the context below
       B = pool.starmap(tasks.logisticMap, ((1 + (i + 1) / N, (numIters // N) * i * 2) for i in range(N)) )
    dt = (time.perf_counter() - t)
    print ("Pool:", dt, ", speedup:", dt_serial/dt, ", correct: ", (A == B).all())

    # parallel - joblib
    t = time.perf_counter()
    C = joblib.Parallel(n_jobs = numWorkers)(joblib.delayed(tasks.logisticMap)((1 + (i + 1) / N), (numIters // N) * i * 2) for i in range(N))
    dt =  (time.perf_counter() - t)
    print ("Joblib:", dt, ", speedup:", dt_serial/dt, "correct: ", (C == A).all())

    ##############################################################################
    # Case 3
    # - large number of small tasks (all of same size)
    # - more memory accesses
    print("Case 3: large number of small tasks")
    N = 10000000
    numIters = 10
    numWorkers = 4

    # serial
    A = numpy.empty(N)
    t = time.perf_counter()
    for i in range(N):
        r = 1 + (i + 1) / N
        A[i] = tasks.logisticMap(r, numIters)
    dt_serial = (time.perf_counter() - t)
    print("Serial:", dt_serial)

    # pool
    t = time.perf_counter()
    with mp.Pool(processes = numWorkers) as pool:
       B = pool.starmap(tasks.logisticMap, ((1 + (i + 1) / N, numIters) for i in range(N)) )
    dt = (time.perf_counter() - t)
    print("Pool:", dt, ", speedup:", dt_serial/dt, "correct: ", (A == B).all())

    # joblib
    t = time.perf_counter()
    C = joblib.Parallel(n_jobs = numWorkers)(joblib.delayed(tasks.logisticMap)((1 + (i + 1) / N), numIters) for i in range(N))
    dt =  (time.perf_counter() - t)
    print("Joblib:", dt, ", speedup:", dt_serial/dt, "correct: ", (A == C).all())

    # pool - output arrays
    t = time.perf_counter()
    blockSize = N // numWorkers # note the reminder!
    with mp.Pool(processes = numWorkers) as pool:
       res = pool.starmap(tasks.logisticMap_outArray, ((N, numIters, i * blockSize, blockSize ) for i in range(numWorkers)) )
    D = numpy.concatenate(res)
    dt = (time.perf_counter() - t)
    print("Pool, array-wise:", dt, ", speedup:", dt_serial/dt, "correct: ", (A == D).all())

    # joblib - output arrays
    t = time.perf_counter()
    blockSize = N // numWorkers
    res = joblib.Parallel(n_jobs = numWorkers)(joblib.delayed(tasks.logisticMap_outArray)(N, numIters, i * blockSize, blockSize ) for i in range(numWorkers))
    E = numpy.concatenate(res)
    dt = (time.perf_counter() - t)
    print("Joblib, array-wise:", dt, ", speedup:", dt_serial/dt, "correct: ", (A == E).all())

    ##############################################################################
    # Problem: apply complex function on a large array
    # - in place transformation (modify original array)
    # - workers share memory but do not interact
    print("\nProblem: complex function")
    clear_all()

    n = 10 ** 8      # 100 million elements
    origA = numpy.random.uniform(0, 1, n)
    fun = lambda x: numpy.arctan(numpy.power(numpy.sin(x) + 1.0, 0.75))  # complex function to make task arithmetic-bound

    # Serial
    A = origA.copy()
    t = time.perf_counter()
    A = fun(A)
    dt_serial = time.perf_counter() - t
    print("Serial:", dt_serial)

    # Parallel
    bufA = mp.Array("d", n)                         # allocate shared buffers (it contains optional lock)
    sharedA = numpy.frombuffer(bufA.get_obj())      # create 1D numpy matrices as views
    sharedA[:] = origA                              # initialize vector (alters underlying buffer)

    test = numpy.frombuffer(bufA.get_obj())         # get another view to see if it works

    # create list of workers
    t = time.perf_counter()
    numWorkers = 4
    sliceSize = n // numWorkers
    workers = [mp.Process(target=tasks.transformComplex, args = (bufA, sid * sliceSize, sliceSize) ) for sid in range(numWorkers)]

    for w in workers:
        w.start()
    for w in workers:
        w.join()

    dt = (time.perf_counter() - t)
    print("Parallel:", dt, ", speedup: ", dt_serial/dt, "correct: ", (A == sharedA).all())

    ##############################################################################
    # Problem: calculating histogram
    # - workers share memory and do interact
    print("\nProblem: histogram")
    sampleSize = 100
    n = 10 ** 7
    A = numpy.random.binomial(sampleSize, 0.5, n)

    histo = numpy.zeros(sampleSize, dtype="i")

    t = time.perf_counter()
    for i in range(n):
        ai = A[i]
        histo[ai] = histo[ai] + 1
    dt_serial = time.perf_counter() - t
    print ("Serial:", dt_serial)


    # Parallel
    bufA = mp.Array("i", n)                       # allocate shared buffers with optional lock
    sharedA = numpy.frombuffer(bufA.get_obj(), dtype="i")    # create 1D numpy matrices as views
    sharedA[:] = A

    bufHisto = mp.Array("i", sampleSize)                       # allocate shared buffers with optional lock
    sharedHisto = numpy.frombuffer(bufHisto.get_obj(), dtype="i")    # create 1D numpy matrices as views
    sharedHisto[:] = 0                                # initialize vector (alters underlying buffer)

    numWorkers = 4
    sliceSize = n // numWorkers

    # variant 1
    t = time.perf_counter()
    workers = [mp.Process(target=tasks.histo, args = (bufA, bufHisto, sid, sliceSize) ) for sid in range(numWorkers)]
    for w in workers: w.start()
    for w in workers: w.join()
    dt = (time.perf_counter() - t)
    print ("Parallel:", dt, ", speedup: ", dt_serial/dt, "correct: ", (histo == sharedHisto).all())

    # variant 2
    sharedHisto[:] = 0
    t = time.perf_counter()
    workers = [mp.Process(target=tasks.histoLock, args = (bufA, bufHisto, sid, sliceSize) ) for sid in range(numWorkers)]
    for w in workers: w.start()
    for w in workers: w.join()
    dt = (time.perf_counter() - t)
    print ("Parallel:", dt, ", speedup: ", dt_serial/dt, "correct: ", (histo == sharedHisto).all())

    # variant 3
    sharedHisto[:] = 0
    t = time.perf_counter()
    workers = [mp.Process(target=tasks.histoLockFast, args = (bufA, bufHisto, sid, sliceSize) ) for sid in range(numWorkers)]
    for w in workers: w.start()
    for w in workers: w.join()
    dt = (time.perf_counter() - t)
    print ("Parallel:", dt, ", speedup: ", dt_serial/dt, "correct: ", (histo == sharedHisto).all())