import numpy as np
import time
import math


# auxiliary function for cleaning the workspace
def clear_all():
    gl = globals().copy()
    for var in gl:
        if var[0] == '_': continue
        if 'func' in str(globals()[var]): continue
        if 'module' in str(globals()[var]): continue

        del globals()[var]


# Type: ndarray
# - represents array of any dimensionality
# - 0-based indexing
# - all elements have to be of same type
#   (they are stored directly in the array, not through pointers)

# Initialization from data
clear_all()
A = np.array([[1, 2], [3, 4]])  # 2D array of size 2x2 (integer)
B = np.array([[1, 2], [3, 4.5]])  # 2D array of size 2x2 (float)
C = np.array([1, 2])  # 1D vector of size 2 (integer)
D = np.array([[1, 2]])  # 2D row vector 1x2 (integer)
E = np.array([[1], [2]])  # 2D column vector 2x1 (integer)
F = np.array([[[1, 2], [3, 4]], [[5, 6], [7, 8]]])  # 3D array 2x2x2 (integer)

# Type ndarray can store non-numeric types
clear_all()
strings = np.array(['abc', 'pqr', 'xyzuvw'])  # 1D vector of strings
mixed1 = np.array([3, True, 'xyz'])  # type conversion: 1D vector of strings
mixed2 = np.array([3, True, False])  # type conversion: 1D vector of integers
lists = np.array([[1, 2], [3]])  # 1D array of lists

# Type: matrix
# - inherits from ndarray type
# - only 2D arrays
# - DEPRECATED

# Special initialization
clear_all()
A = np.empty((4, 2))  # uninitialized 4x2 array (float)
B = np.zeros((2, 3))  # 2x3 zeros array (float)
C = np.ones((3, 2, 1))  # 3x2x1 ones array (float)
D = np.identity(3)  # 3x3 identity array (float)

# Random arrays
m = 5
n = 3
U1 = np.random.rand(m, n)  # m-by-n array, uniform distribution [0,1)
U2 = np.random.uniform(100, 200,
                       (m, n))  # m-by-n array, uniform distribution [100,200)

R1 = np.random.randn(m, n)  # m-by-n array, normal distribution N(0,1)
R2 = np.random.normal(10, 2,
                      (m, n))  # m-by-n array, normal distribution N(10,2)

# Accessing elements
# - ndarray type is mutable,
# - whenever possible, operations produce views of existing data,
# - copying must be often explicitly specified,
# - potential performance boost.
clear_all()
A = np.array([[1, 2], [3, 4], [5, 6]])  # 2D array of size 3x2 (integer)
a = A[0, 0]  # get an element
A[0, 1] = 8  # set an element
A[:, 0] = 5  # set a column
A[1, :] = 10, 20  # set a row
A[2, :] = [30, 40]  # set a row

B = A  # create a view
B[0, 0] = 0  # modifies A
C = A.copy()  # create a copy
C[0, 0] = 111  # does not modify A

rowA_1D = A[1, :]  # get row view by an index (1D vector)
rowA_1D[0] = -100  # modifies A and B

rowA_2D = A[1:2, :]  # get row view by slice operator (2D vector)
rowA_2D[0, 1] = -200  # modifies A, B, and rowA_1D

subA = A[1:, :]  # get submatrix view
subA[1, 1] = 1  # modifies A and its views

E = A[0, :].copy()  # row copy (1D)
F = A[0:1, :].copy()  # row copy (2D)
E[0] = 1234  # does not modify A
F[0, 0] = 4321  # does not modify A

# Q: When the assignment operator produces a copy instead of a view?
# A: When it is unable to determine the stride.
clear_all()
V = np.asarray(range(1, 10))  # initialize using generator
V1 = V[0:9:2]  # get view
V1[0] = 100  # modifies V
V2 = V[9:None:-2]  # get view (using None includes 0'th index)
V2[0] = 100  # modifies V
V3 = V[[1, 5, 3]]  # get copy (unable to determine the stride)
V3[0] = 200  # does not modify V
V4 = V[[0, 4, 8]]  # get copy (unable to determine the stride)
V4[0] = 200  # does not modify V

Q = np.asarray(range(0, 100)).reshape(10, 10)
subQ = Q[10:None:-3, 0:10:2]  # get view (known strides for rows and columns)
subQ[1, 2] = 10000  # modifies Q
rowQ = Q[[1], :]  # get row copy (unable to determine stride)
rowQ[0, 1] = -300  # does not modify Q

# Reshaping
# - whenever possible reshape function returns a view on the array
clear_all()
V = np.array([[1, 2]])  # 2D row vector 1x2 (integer)
V2 = np.reshape(V, (2, 1))  # 1x2->2x1 conversion - view creation
V2[0, 0] = 100  # modifies V

V3 = np.reshape(V, 2)  # 2D->1D conversion - view creation
V3[1] = 200  # modifies V

A = np.array([[1, 2], [3, 4]])  # 2D matrix 2x2
B = np.reshape(A, (-1, 1))  # 2x2->4x1 conversion, 4 set automatically
B[0] = 100  # modifies A
C = np.reshape(A, 4)  # 2x2-> x4 vector conversion
D = np.reshape(A, 5)  # 2x2-> x5 vector conversion - exception

A = np.asarray(range(0, 9)).reshape(3, 3)
flatA = np.reshape(A, -1)  # 3x3->9x vector conversion - view creation
flatA[0] = 100;  # modifies A

At = np.transpose(A)  # creates a transposition as view
At[0, 0] = -100  # modifies A
flatAt = np.reshape(At, -1)  # 3x3->9x vector conversion as copy
flatAt[0] = 100  # does not modify At and A

# views - access times
n_reps = 10
m = 10000
A = np.random.uniform(0, 1, (m, m))
B = A.copy()
C = A.copy()
D = A.copy()

# vertical sums as row vectors
vsumA = np.zeros((1, m))
vsumB = np.zeros((1, m))
vsumC = np.zeros((1, m))

t = time.perf_counter()
for r in range(n_reps):
    for i in range(m):
        vsumA = vsumA + A[i, :]  # access directly
print("w/o view:", (time.perf_counter() - t) / n_reps)

t = time.perf_counter()
for r in range(n_reps):
    for i in range(m):
        row = B[i, :]  # create view
        vsumB = vsumB + row
print("w/ view:", (time.perf_counter() - t) / n_reps)

t = time.perf_counter()
for r in range(n_reps):
    for i in range(m):
        row = C[[i], :]  # create copy
        vsumC = vsumC + row
print("Row copy:", (time.perf_counter() - t) / n_reps)

t = time.perf_counter()
for r in range(n_reps):
    vsumD = np.sum(D, axis=0)  # sum the columns (1D vector as a result)
print("Library call:", (time.perf_counter() - t) / n_reps)

# verify correctness
(vsumA == vsumB).all()
(vsumA == vsumC).all()

# operations
clear_all()
A = np.array([[1, 2], [3, 4]])  # 2x2 integer array
B = A + A  # sum elements
C = -2.5 * A  # multiply matrix by scalar
D = np.array([[10, -10], [-10, 10]])
E = A * D  # multiply corresponding elements (not a matrix multiplication!)
F = np.dot(A, D)  # matrix multiplication
FF = A @ D  # matrix multiplication - new operator in python 3.5

F = np.array([[1, -1]])  # row vector (2D)
G = A * F  # multiply columns per F elements
print(G)  # [[1, -2],[3, -4]]
Q = A * np.array([1, -1])  # the same, but with 1D vector
H = A * F.transpose()  # multiply rows per F elements
print(H)  # [[1, 2],[-3, -4]]

clear_all()
A = np.random.rand(2, 10)
B = np.random.rand(10, 2)
C = np.dot(A, B)  # 2x10 by 10x2 matrix multiplication
V = np.array([[1], [2]])
U = np.dot(B, V)  # 10x2 by 2x1 matrix-vector multiplication

# solving linear system AX = B
clear_all()
A = np.random.rand(10, 10)
X = np.random.rand(10, 1)
B = np.dot(A, X)
A_inv = np.linalg.inv(A)  # matrix inverse
Xsolved = np.dot(A_inv, B)  # solve the system
print(X == Xsolved)  # array comparison (logical array as a result)
print(abs(X - Xsolved))  # determine reminders
print(np.isclose(X, Xsolved))  # comparison with tolerance

# Math functions
clear_all()
n = 1000000
X = np.random.rand(n)
sinX = np.sin(X)

# more complicated functions
f_scalar = lambda x: math.log(math.sin(x) * math.sqrt(x / 2) + 1)
f_vector = lambda x: np.log(np.sin(x) * np.sqrt(x / 2) + 1)

Y1 = np.empty(n)

# for-based variant
n_reps = 1
t = time.perf_counter()
for r in range(n_reps):
    for i in range(n):
        Y1[i] = f_scalar(X[i])
print("For-based:", (time.perf_counter() - t) / n_reps)

# vectorized variant
n_reps = 10
t = time.perf_counter()
for r in range(n_reps):
    Y2 = f_vector(X)
print("Vectorized:", (time.perf_counter() - t) / n_reps)

# Concatenations, diagonals
clear_all()
A = np.array([[1, 2]])
B = np.array([[3, 4]])
C = np.array([[9, 8, 7, 6]])
AB = np.hstack((A, B))  # horizontal concatenation
ABC = np.vstack((AB, C))  # vertical concatenation

D = np.array([[1, 2], [3, 4]])  # 2x2 matrix
E = np.diag(D)  # reduce dimensionality: matrix 2D -> vector 1D
F = np.diag(E)  # extend dimensionality: vector 1D -> matrix 2D

G = np.diag(ABC)  # reduction: get diagonal of square submatrix

H = [[1, 4]]  # 2D row vector
I = np.diag(H)  # reduction: get diagonal of square submatrix

np.fill_diagonal(A, [-1, -2])  # set diagonal

# logical indexing
A = np.array([[1, 2, 3], [3, 4, 3], [3, 2, 5]])

B = A[A[:, 1] == 2, :]  # select rows containing 2 as a second element
C = A[A[:, 1] == 2]  # second dimension can be ommited
D = A[:, A[1, :] == 3]  # select columns containing 3 as a second element

# Access test
# Generate rotation matrix for given vector
clear_all()

m = 10000
V = np.array(range(0, m))
A = np.empty((m, m), dtype=np.int)
B = np.empty((m, m), dtype=np.int)
C = np.empty((m, m), dtype=np.int)
D = np.empty((m, m), dtype=np.int)
Q = np.empty((m, m), dtype=np.int)

# For-based solutions
t = time.perf_counter()
for i in range(m):
    for j in range(m):
        Q[i, j] = V[(i + j) % m]
print("Naive:", (time.perf_counter() - t))

# Access consecutive rows
n_reps = 10
t = time.perf_counter()
for r in range(n_reps):
    for i in range(m):
        A[i, 0:m - i] = V[i:]
        A[i, m - i:] = V[:i]
print("Row-wise:", (time.perf_counter() - t) / n_reps)

# Access consecutive columns
t = time.perf_counter()
for r in range(n_reps):
    for i in range(m):
        B[0:m - i, i] = V[i:]
        B[m - i:, i] = V[:i]
print("Column-wise:", (time.perf_counter() - t) / n_reps)

# Access rows and transpose the result
t = time.perf_counter()
for r in range(n_reps):
    for i in range(m):
        C[i, 0:m - i] = V[i:]
        C[i, m - i:] = V[:i]
    C = C.transpose()  # this makes a copy
print("Row-wise + transposition:", (time.perf_counter() - t) / n_reps)

# validation
A_eq_B = (A == B)
A_eq_C = (A == C)
A_eq_Q = (A == Q)
print(A_eq_B.all())
print(A_eq_C.all())
print(A_eq_Q.all())

N = 10000
A = np.random.rand(N, N)
B = np.random.rand(N, N)

t = time.perf_counter()
C = np.dot(A, B)
print("Matrix multiplication", (time.perf_counter() - t))
