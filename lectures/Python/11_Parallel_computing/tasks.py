import numpy

# calculate n'th value of logistic map with given parameter R
def logisticMap(r, n):
    y = 0.5
    for i in range(2, n):
       y = r * y * (1 - y)
    return y

# array-wise logistic map
def logisticMap_outArray(N, numIters, begin, blockSize):
    Y = numpy.empty(blockSize)
    for i in range(blockSize):
        r = 1 + ((i + begin) + 1) / N
        Y[i] = logisticMap(r, numIters)
    return Y

# transformation of function
def transformComplex(bufA, offset, blockSize):
    A = numpy.frombuffer(bufA.get_obj())
    fun = lambda x: numpy.arctan(numpy.power(numpy.sin(x) + 1.0, 0.75))
    A[offset: offset+blockSize] = fun(A[offset: offset+blockSize]) # no need to use lock


# histogram of array block
def histo(bufA, bufHisto, blockId, blockSize):
    A = numpy.frombuffer(bufA.get_obj(),  dtype="i", offset=blockId * blockSize * 4, count=blockSize)
    histo = numpy.frombuffer(bufHisto.get_obj(),  dtype="i")
    for i in range(blockSize):
        ai = A[i]
        histo[ai] = histo[ai] + 1

# histogram of array block with locking
def histoLock(bufA, bufHisto, blockId, blockSize):
    A = numpy.frombuffer(bufA.get_obj(),  dtype="i", offset=blockId * blockSize * 4, count=blockSize)
    histo = numpy.frombuffer(bufHisto.get_obj(),  dtype="i")
    for i in range(blockSize):
        ai = A[i]
        bufHisto.get_lock().acquire()
        histo[ai] = histo[ai] + 1
        bufHisto.get_lock().release()

# histogram of array block with local copy
def histoLockFast(bufA, bufHisto, blockId, blockSize):
    A = numpy.frombuffer(bufA.get_obj(), dtype="i", offset=blockId * blockSize * 4, count=blockSize)
    sharedHisto = numpy.frombuffer(bufHisto.get_obj(), dtype="i")
    histo = numpy.zeros(len(sharedHisto), dtype="i")
    for i in range(blockSize):
        ai = A[i]
        histo[ai] = histo[ai] + 1

    bufHisto.get_lock().acquire()
    sharedHisto += histo
    bufHisto.get_lock().release()