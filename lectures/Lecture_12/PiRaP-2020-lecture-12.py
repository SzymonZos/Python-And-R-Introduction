import numpy
import time
import math

########################################################
# Class
# - represents category of objects
# - can be instantiated (object creation)
class Rectangle:
    pass            # empty class


r = Rectangle()             # creating object (class instance)

# Data fields (attributes, properties, instance variables)
# - added after instantiation
r.width = 1.3               # adding attribute width
r.height = 2.5              # adding attribute height
print(r.width, r.height)    # ok - both attributes exist
print(r.w)                  # error - no such attribute
del r.width                 # delete width attribute

s = Rectangle()
type(r) == type(s)          # r and s are of same type (Rectangle) in spite of different attributes

# Aliasing
t = r                       # creates alias
t.height = 4                # modifies r

########################################################
# Methods
# - functions inside classes
# - may operate on instance variables
class Rectangle:
    def area(self):  # first argument - object for which a method is invoked
        return self.width * self.height


r = Rectangle()             # create instance
r.width = 1.3               # add variables
r.height = 2.5              #
print(r.area())             # invoke method
print(Rectangle.area(r))    # invoke method - alternative syntax

s = Rectangle()
print(s.area())             # error - no attributes width and height

########################################################
# Constructor (initialization method)
# - invoked automatically during instantiation
# - may have parameters
class Rectangle:

    #  constructor
    def __init__(self):
        self.width = 0
        self.height = 0

    def area(self):
        return self.width * self.height


s = Rectangle()     # automatic invocation of __init__ method
print(s.area())

# Python does not support function/method overloading
class Rectangle:

    def __init__(self):
        self.width = 0
        self.height = 0

    def __init__(self, width, height): # this redefines previous variant
        self.width = width
        self.height = height

s = Rectangle()         # error - no such variant
t = Rectangle(1 , 2)    # ok

# Default arguments instead of overloading
class Rectangle:
    def __init__(self, width = 0, height = 0):
        self.width = width
        self.height = height

    def area(self):
        return self.width * self.height

s = Rectangle()
t = Rectangle(2,3)
print(s.area(), t.area())

# Copy constructor
# - creates object on the basis of other instance of the same class
class Rectangle:
    def __init__(self, width = 0, height = 0, ref = None):
        if (ref == None):
            self.width = width
            self.height = height
        else:
            self.width = ref.width
            self.height = ref.height

    def area(self):
        return self.width * self.height


r = Rectangle()                     # non-argument variant
s = Rectangle(2,3)                  # two-argument variant
t = Rectangle(ref=s)                # make a deep copy
s.width = 10                        # alters s only
print(r.area(), s.area(), t.area())

# Alternative: clone method instead of copy constructor
import copy
class Rectangle:
    def __init__(self, width = 0, height = 0):
        self.width = width
        self.height = height

    def area(self):
        return self.width * self.height

    def clone(self):
        return copy.deepcopy(self) # use auxiliary library

r = Rectangle()                     # non-argument variant
s = Rectangle(2,3)                  # two-argument variant
t = s.clone()                       # make a deep copy
s.width = 10                        # alters s only
print(r.area(), s.area(), t.area())

########################################################
# Private members
# - Python does not provide private access qualifier
# - instead: automatic mangling of member names with double underscore prefix
# - prevents from accidental access to 'private' member
class Rectangle:

    def __init__(self, width = 0, height = 0):
        self.width = width
        self.height = height
        self.__privateData = 0x1234
        self.__privateMethod()

    def __privateMethod(self):
        print("private method")

r = Rectangle(4, 5)

print(r.__privateData)          # error - no such field
print(r._Rectangle__privateData)# ok - use mangled name
r.__privateData = 4             # warning - create new field

r.__privateMethod()             # error - method not found
r._Rectangle__privateMethod()   # ok - use mangled name


# Accessors
# - methods for getting and setting private attributes
class Foo:
    def __init__(self):
        self.__data = 1

    def getData(self): return self.__data
    def setData(self, v): self.__data = v

f = Foo()
f.setData(10)       # setter
print(f.getData())  # getter

########################################################
# Inheritance
# - modelling generalization-specialization relation
class Geometry: # base class

    def __init__(self, name):
        self.name = name

    def toString(self):
        return self.name

    def foo(self):
        print("foo from base class")

class Rectangle(Geometry):
    def __init__(self, width, height):
        Geometry.__init__(self, "Rectangle") # invoke constructor from base class
        self.width = width
        self.height = height

    def foo(self):
        # super(Rectangle, self).foo()        # alternative way of invoking base class member
        print("foo from inherited class")


r = Rectangle(5, 10)
print(r.toString())     # method inherited from the base class

r.foo()                     # inherited variant masks base variant
Geometry.foo(r)             # invoking base variant
super(type(r), r).foo()    # another way to invoke base variant

# Multiple inheritance
class Base1:
    def foo(self):
        print("Base1.foo")
    def boo(self):
        print("Base1.boo")

class Base2:
    def foo(self):
        print("Base2.foo")
    def boo(self):
        print("Base2.boo")

class Derived(Base1, Base2):
    def foo(self):
        super(Derived, self).foo()  # invoke method from the first on the inheritance list

    def boo(self):
        Base2.boo(self)  # explicitly indicate base class

d = Derived()
d.foo()
d.boo()
Base2.foo(d)


########################################################
# Class (static) fields
# - shared by all instances of a class
class Rectangle:
    counter = 0  # class field

    # constructor
    def __init__(self, width=0, height=0):
        self.width = width
        self.height = height
        Rectangle.counter = Rectangle.counter + 1

    # destructor
    def __del__(self):
        Rectangle.counter = Rectangle.counter - 1


s = Rectangle()
t = Rectangle(2, 3)
print(Rectangle.counter)
print(s.counter)

del s
print(Rectangle.counter)


########################################################
# Static methods
# - related to class, not particular instance
# - often used as factory methods
class Rectangle:
    # constructor
    def __init__(self, width=0, height=0):
        self.width = width
        self.height = height

    # factory method
    @staticmethod
    def from_string(s: str):
        sides = s.split(" ")  # split on space
        return Rectangle(float(sides[0]), float(sides[1]))


r = Rectangle.from_string("4 5")

# Problem: when inheriting, base class instance is created
class SpecialRectangle(Rectangle):
    pass

tt = SpecialRectangle(50, 60)             # constructor inherited - SpecialRectangle instantiation
sr = SpecialRectangle.from_string("1 2")  # Rectangle instantiation


########################################################
# Class methods
# - similar to static methods
# - require class type as the first argument (works nicely with inheritance)
class Rectangle:
    # constructor
    def __init__(self, width=0, height=0):
        self.width = width
        self.height = height

    # factory method
    @classmethod
    def from_string(classType, s: str):
        sides = s.split(" ")  # split on space
        return classType(int(sides[0]), int(sides[1]))

r = Rectangle.from_string("4 5")

class SpecialRectangle(Rectangle):
    pass

sr = SpecialRectangle.from_string("1 2") # ok - SpecialRectangle instantiation

########################################################
# Polymorphism
# - as Python is dynamically typed, it requires no inheritance
class Rectangle:
    def __init__(self, width, height):
        self.width = width
        self.height = height

    def area(self):
        return self.width * self.height


class Circle:
    def __init__(self, radius):
        self.radius = radius

    def area(self):
        return math.pi * self.radius * self.radius

figures = [Rectangle(3,4), Circle(5)]
for r in figures:
    print(r.area())


########################################################
# Example: creating iterable collection
class Node:
    def __init__(self, value, next = None):
        self.value = value
        self.next = next


class SortedList:
    def __init__(self):
    #    print("SortedList.__init__()")
        self.head = None

    def add(self, value):
        if (self.head == None or self.head.value > value):
            # add at the beginning
            self.head = Node(value, self.head)
        else:
            cur = self.head.next
            prev = self.head

            while (cur != None and cur.value < value):
                prev = cur
                cur = cur.next

            prev.next = Node(value, cur)

l = SortedList()
l.add(10)
l.add(15)
l.add(12)
l.add(5)

class IterableSortedList(SortedList):

    # iteration initialization - required
    def __iter__(self):
        self.current = self.head
        return self

    # iteration
    def __next__(self):
        if self.current != None:
            val = self.current.value
            self.current = self.current.next
            return val
        else:
            raise StopIteration()

l = IterableSortedList()
l.add(10)
l.add(15)
l.add(12)
l.add(5)

for e in l:
    print(e)