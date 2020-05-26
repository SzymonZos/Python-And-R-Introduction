V = c('a', 'b', 'c')

for(el in V) {
  print(el)
}

for(i in 0:9) {
  print(i)
}

i = 10
while(i > 0) {
  print(i)
  i = i - 1
}

for(i in seq(100, 0, -20)) {
  print(i)
}

for(e in rev(V)) {
  print(e)
}

for(i in 0:99) {
  if(i == 21) {
    break
  }
  if(i %% 2) {
    next
  }
  print(i)
}