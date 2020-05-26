# auxiliary function for cleaning the workspace
def clear_all():
    gl = globals().copy()
    for var in gl:
        if var[0] == '_': continue
        if 'func' in str(globals()[var]): continue
        if 'module' in str(globals()[var]): continue

        del globals()[var]

# --------------------------------------------------------------------
# Basics
# --------------------------------------------------------------------
# Importing modules

# load modules
import math 	# system module
#import mylib 	# own module
y = math.sin(math.pi)
#z = mylib.myfun()

# import single element
from math import pi
y = math.sin(pi)

# import everything
from math import *
y = sin(pi)

# alias
import math as m
y = m.sin(m.pi)

# --------------------------------------------------------------------
# Functions

# no return value
def display(x):
    print(x)

# return value
def sqr(x):
   return x * x

# function that does nothing
def doNothing():
    pass

# conditional return
def geoMean(x,y):
    if x < 0 or y < 0: return None
    else: return math.sqrt(x * y)

b = display('abc') #  b is None
p = sqr(2) # p is 4
q = geoMean(2, 8) # q is 4
r = geoMean(-2, 8) # r is None

# default and named arguments
def fun(x, y=10, s='abc'):
    print(x,y,s)

fun(0) 		            # fun(0, 10, 'abc')
fun(1, 3.14, 'xyz')
fun(2, s='PS') 	        # named argument - fun(2, 10, 'PS')
fun(y=4, x=1)	        # named arguments - fun(1, 4, 'abc')
fun(5, x=1)             # error: x passed twice

def fun2(x=1, y): # error: non-default follows default
    pass

# --------------------------------------------------------------------
# Iterations

# Iterate over collection
V = ['a', 'b', 'c'] # list comprehension - creates a list from values
for e in V:
    print(e)

# Iterate over range (right excluded)
for i in range(0,10): #  [0, 1, ... 9]
    print(i)

# while loop
i = 10
while i > 0:
    print(i)
    i -= 1

# 100, 95, ...,5
for i in range(100, 0, -5): print(i)

# reversed collection
for e in reversed(V): print(e)

# break, continue, loop-else
for n in range(2, 10):
    for x in range(2, n):
        if n % x == 0:
            print(f'{n} = {x} * {n//x}')
            break
    else: # concerns for loop - executed when loop exited normally (not by break)
        print ('{} is a prime number'.format(n))

# --------------------------------------------------------------------
# String type
#
# - Immutable - you cannot alter the string, you can only create
#               a new one on the basis of the existing one.
# - Assignment operator makes a copy.
# - Indexing using slices: [begin:end:step].
# - 0-based, end is an element after the slice.
clear_all()

# Accessing elements
s = 'Dog'
c = s[1]                # 'o' - get single character
s0 = s[0:len(s)]        # 'Dog' - copy entire string
s1 = s[1:]              # 'og' - copy all beside the first char
s2 = s[:len(s)-1]       # 'Do' - copy all beside the last char
s3 = s[:-1]             # 'Do' -         -||-
s4 = s[::2]             # 'Dg' - copy every second character

s[1] = 'a'              # error: immutable
s = s[0] + 'a' + s[2]   # 'Dag'
t = s * 2               # 'DagDag'

# Capitalization
s = 'Piotr'
s = s.lower()       # 'piotr'
flag = s.islower()  # True
s = s.capitalize()  # 'Piotr'

# Finding substrings
s = 'Ala ma kota'
print(s.find('a'))      # 2 - index of the first match
print(s.find('ko'))     # 7 - index of the first match
print(s.find('a', 3))   # 5 - index of the first match starting from 3
print(s.rfind('a'))     # 10 - index of the last match
print(s.find('q'))      # -1 - no match
f1 = 'la' in s          # True
f2 = 'abc' in s         # False

# Checking characters
s = '1234'
print(s.isalnum())
print(s.isnumeric())
print(s.isalpha())
print('abc'.isalpha())

# Multi-line strings
a = 'first line\nsecond line' # escape characters

# Triple quoute string
b = '''first line
second line'''

# Splitting
s = '192.168.0.0'
ip = s.split('.')       # create list of strings
lines = a.splitlines()

# --------------------------------------------------------------------
# List type
#
# - Mutable - you can alter elements of the container.
# - Assignment operator makes an alias.
# - Can store elements of any type.
# - Indexing using slices: [begin:end:step].
# - 0-based, end is an element after the slice.
clear_all()

# Accessing elements
t = [1, 3.14, True, [2, 'xyz']]         # list comprehension
print(t)
x = t[1]                                # x = 3.14
t[2] = False                            # ok – mutable type
t[3][1] = 'abc'                         # ok
1 in t                                  # True
2 in t                                  # False – it is in sublist

# Aliasing
p = [1, 2, 3]
q = p                       # q points to p (aliasing)
q[1] = 10                   # modify p as well
print(p, '-', q)            # 1 10 3 - 1 10 3
r = p[:]                    # explicit copy
r[0:2] = ['a', 'b']
print(p, '-', r)             # 1 100 3 - a b 3

# Adding elements
t = list()                  # empty list (alternative syntax)
t += ['a', 'b', 'c']        # modify - extend with sublist
t.extend(['e', 'f'])        # modify - extend with sublist
t.append('d')               # modify - add an element (character)
t.append(['g'])             # modify - add an element (sublist)
t = t + ['k', 'i']          # create new and store in t
u = t * 2                   # create new

# Removing elements
x = t.pop(1)    # remove 'b' and assign result to x
del t[1]        # remove'c'
del t[4:6]      # remove 'g' i 'h'
t.append('a')
t.remove('a')   # remove first 'a'

# Sorting elements
t.sort()


# --------------------------------------------------------------------
# Iterators
#
# - objects for iteration over collections
# - allow creating iterable collections

I = iter([1, 2, 3])  # list iterator
print(I.__next__())  # 1
print(I.__next__())  # 2
print(I.__next__())  # 3
print(I.__next__())  # exception

# loop using iterator
I = iter([1, 2, 3])  # list iterator
for i in I:
    print(i)


# --------------------------------------------------------------------
# Generators
#
# - allow generation of values,
# - lazy evaluation (values generated when needed),
# - are iterable objects,

# define generator object that creates characters from given range
def genChars(c1, c2):
    for c in range(ord(c1), ord(c2)+1):
        yield chr(c) # preserve a state

gen = genChars('a','z')

# in a loop
for x in gen:
    print(x)

# does nothing - generator can be iterated through only once
for x in gen:
    print(x)

# range function also creates a generator
# (from Python 3, in Python 2 xrange should be used)
clear_all()
N = 10000000
G = range(0,N)
print(sum(G)) # passing iterable object to the function

# unpacking generator to list
L = [*G]
M = [G]   # a list with generator as an element

# sum of squares of even numbers from the list
V = [0,12,4,6,242,7,9]
s = 0
for x in V:
   if x % 2 == 0:
     s = s + x*x
print(s)

# list
L = [x*x for x in V if x % 2 == 0]
print(sum(L))
print(L[2])

# generator – w/o list
gen = (x*x for x in V if x % 2 == 0)
print(sum(gen))
print(gen[2]) # error - cannot use subscriptfor generators


# performance comparison - list vs generator
import time
N = 100000000

t = time.perf_counter()
L = [x/N for x in range(0,N)]
print(sum(L))
print("List:", time.perf_counter() - t)

t = time.perf_counter()
G = (x/N for x in range(0,N))
print(sum(G))
print("Generator:", time.perf_counter() - t)


# --------------------------------------------------------------------
# Tuple type
#
# - Similar to list, but immutable.
clear_all()


t1 = 1, 2, 3		   # declaration
t2 = ('a', 'c', 'd')   # parentheses () are optional
t3 = 'q', 		       # one-element tuple
t4 = t2[1:3] 		    # ('c', 'd')
t5 = t4, 'e' 		    # (('c', 'd'), 'e')
t6 = t4 + t3 		    # ('c', 'd', 'q')
t7 = t4 + ('a',) 	    # ('c', 'd', 'a')
t7[1] = 4; 		        # error – immutable

t1,t2 = t2,t1 		# value swap

# iteration over collection: index + value
X = ['a', 'b', 'c']
for i, x in enumerate(X):
    print(f'X[{i}]={x}')

# iteration over several collections (adjust to the shortest)
Y = [0.4, 11, -10]
Z = [True, False, False, True]
for x, y, z in zip(X, Y, Z):
    print(x, y, z)

# returning multiple values from a function
def getFirstLast(L):
    return L[0], L[-1]

L = [1, 2, 3, 4, 5, 6, 7, 8]
f, l = getFirstLast(L)
f_l = getFirstLast(L)
print(f_l)  # (1,8)

# function with variable number of parameters
def add(*args):
    s = 0
    for e in args:
        s += e
    return s

print(add(1, 2, 3, 4, 5))  # sum the parameters
t = (9, 8, 7)
L = [*t]                     # „unpacking" a tuple to list

# sorting using multiple criteria
names = ['Stan', 'Peter' , 'Alice']
salaries = [3000, 2000, 2000]
zipped = [*zip(salaries, names)] # zip is an iterable object - it has to be unpacked to list
zipped.sort() # sort list
print(zipped) # [(2000, 'Alice'), (2000, 'Peter'), (3000, 'Stan')]

#
#
#   Powerpoint time...
#
#

# --------------------------------------------------------------------
# Set type
#
# - Stores keys (immutable),
# - implemented as hashtable (keys are not sorted)
clear_all()

S = set()
S.add(1)
S.add('pqr')
S.add([33])      # error, lists are mutable - cannot be stored in set
S.add((35,))     # ok, tuples are immutable
S.add(1)         # already exist

S.remove('pqr') # ok, exists
S.remove(55)    # error, doesn't exist

start = 1800
end = 2200

A = {x for x in range(start,end) if x % 4 == 0}   # divisible by 4 (set comprehension)
B = {x for x in range(start,end) if x % 100 == 0} # divisible by 100
C = {x for x in range(start,end) if x % 400 == 0} # divisible by 400

leapYears = A.difference(B).union(C)

print(leapYears) # hashtable elements are not sorted

L = [*leapYears] # unpack set to list and sort
L.sort()
print(L)


# --------------------------------------------------------------------
# List vs Set performance
#

# Read all words from the file
clear_all()
f = open('for-whom-the-bell-tolls.txt', 'r', encoding='utf8') # open text UTF-8 file
text = f.read()         # read everything
words = text.split()   # split on white characters
words = words * 6       # ~1M words
import time
# Determine unique words
t1 = time.perf_counter()
L = []
for word in words:
    if (word not in L):
        L.append(word)
print("Unique (list):", time.perf_counter() - t1)


t1 = time.perf_counter()
S = set()
for word in words:
    if (word not in S):
         S.add(word)
print("Unique (set):", time.perf_counter() - t1)

# sort elements
U1 = L[:]
U1.sort()
U2 = [*S]
U2.sort()

# compare
U1 == U2


# --------------------------------------------------------------------
# Dictionary type
#
# - Stores key-value pairs,
# - key: immutable type,
# - value: any type,
# - implemented as hashtable (keys are not sorted)
#
clear_all()

d = dict()
d[123] = 'abc'
d['xyz'] = 3.14
d[False] = True
d[3.14] = [1, 2]


# dictionary comprehensions
c = {}
d = {'a': 3, 654: True, 'b': 123}
e = {x: x*x for x in range(1,100)} # with generator

vals = d.values()   # [3, 123, True]
ks = d.keys()       # ['a', 'b', 654]

x = d[4]            # exception
y = d.get(4,'q')   # 'q’ as a default value

