# some useful staff about strings, ofc a is preferred

age = 40
name = 'xD'
data = 4.333333333

a = f'dupa {age} ree {name} lul: {data:.2f}'
print(a)
b = 'dupa {} ree {} lul: {:.2f}'.format(age, name, data)
print(b)
c = 'dupa %d ree %s lul: %.2f' % (age, name, data)
print(c)

try:
    i = int(input('dupa'))
except ValueError:
    print('xD')
