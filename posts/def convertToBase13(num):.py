""" Given a number nn, write a formula that returns n!n!.

In case you forgot the factorial formula,

 n!=n∗(n−1)∗(n−2)∗.....2∗1n!=n∗(n−1)∗(n−2)∗.....2∗1.

For example, 5!=5∗4∗3∗2∗1=1205!=5∗4∗3∗2∗1=120 so we'd return 120.

Assume is nn is a non-negative integer. """

def factorial(x):
  out = 1
  while x > 1:
    out *= x
    x -= 1

    # 1*5 = 5 # x = 4
    # 5*4 = 20 # x = 3
    # 20*3 =  60 # x = 2
    # 60*2 = 120 # x = 1

  return out

def count_trailing_zeros(x):
  
  x_s = str(x)[::-1] # reverse
  count = 0
  for digit in x_s:
    if digit == "0":
      count += 1
    else:
      break
  return count

def factorial_trailing_zeroes(x):
  return count_trailing_zeros(factorial(x))

print(factorial_trailing_zeroes(30))