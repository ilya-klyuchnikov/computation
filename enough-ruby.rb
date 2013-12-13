# "just enough ruby" interactive cheat sheet
# irb --noprompt enough.rb

# utilities for formatting/pagination

def BYE!
  gets.chomp
  exit()
end

def NEXT?
  a = gets.chomp
  if a == 'n'
    exit()
  end
  puts a
end

def SECTION(name)
  system 'clear'
  return name
end

class String
  def / x
    return self + ' / ' + x
  end
end

##########################

SECTION 'BASIC DATA'

(true && false) || true

(3 + 3) * (14 / 2)

'hello' + ' world'

'hello world'.slice(6)

:my_symbol

:my_symbol == :my_symbol

:my_symbol == :another_symbol

# returns nil to indicate no result
# slice(n) - returns n-th char
'hello world'.slice(11)

NEXT?

##########################

SECTION 'DATA STRUCTURES' / 'ARRAY'

numbers = ['zero', 'one', 'two']

names = ['bob', 'mary']

numbers[0]

numbers[1]

# functional append (returns array)
numbers + names

numbers

# "imperative append"
numbers.push('three', 'four')

numbers

# functional drop
numbers.drop(2)

numbers

NEXT?

##########################

SECTION 'DATA STRUCTURES' / 'RANGE'

ages = 18..30

ages.entries

ages.include?(25)

ages.entries.include?(25)

ages.include?(33)

NEXT?

##########################

SECTION 'DATA STRUCTURES' / 'HASH'

fruit = { 'a' => 'apple', 'b' => 'banana', 'c' => 'coconut' }

fruit['b']

fruit['d'] = 'date'

fruit

# syntax for symbolic keys
dimensions = { width: 1000, height: 2250, depth: 250 }

dimensions[:depth]

NEXT?

##########################

SECTION 'PROCS'

multiply = -> x, y { x * y }

multiply.call(6, 9)

multiply[3, 4]

NEXT?

##########################

SECTION 'CONTROL FLOW'

if 2 < 3
  'less'
else
  'more'
end

quantify =
    -> number {
      case number
        when 1
          'one'
        when 2
          'a couple'
        else
          'many'
      end
    }

quantify.call(2)

quantify.call(10)

x = 1

while x < 1000
  x=x*2
end

x

NEXT?

##########################

SECTION 'OBJECTS and METHODS'

o = Object.new

# we can add methods to object!
def o.add(x, y)
  x+y
end

o.add(2, 3)

# self
def o.add_twice(x, y)
  self.add(x, y) + add(x, y)
end

o.add_twice(2, 3)

def multiply(a, b)
  a*b
end

multiply(2, 3)

# top-level methods are private methods of Object - see exception
xxx(2, 3)

NEXT?

##########################

SECTION 'CLASSES and MODULES' / '1'

class Calculator
  def divide(x, y)
    x/y
  end
end

c = Calculator.new

c.class

c.divide(10, 2)

# exception
divide(10, 2)

NEXT?

SECTION 'CLASSES and MODULES' / '2'

# inheritance
class MultiplyingCalculator < Calculator
  def multiply(x, y)
    x*y
  end
end

mc = MultiplyingCalculator.new

mc.class

mc.class.superclass

mc.multiply(10, 2)

mc.divide(10, 2)

NEXT?

SECTION 'CLASSES and MODULES' / '3'

# calling superclass method of the same name
class BinaryMultiplyingCalculator < MultiplyingCalculator
  def multiply(x, y)
    result = super(x, y)
    result.to_s(2)
  end
end

bmc = BinaryMultiplyingCalculator.new

bmc.multiply(10, 2)

# modules = traits
module Addition
  def add(x, y)
    x+y
  end
end

# mixing modules
class AddingCalculator
  include Addition
end

ac = AddingCalculator.new

ac.add(10, 2)

NEXT?

##########################

SECTION 'MISC' / 'Assignment, interpolation'

# parallel assignment

width, height, depth = [1000, 2250, 250]

height

# string interpolation
"hello #{'dlrow'.reverse}"

o = Object.new

# interpolation uses `to_s` method
def o.to_s
  'a new object'
end

"here is #{o}"

# IRB uses `inspect` method
def o.inspect
  '[my object]'
end

o

NEXT?

##########################

SECTION 'MISC' / 'Printing'

# printing strings

x = 128

while x < 1000
  puts "x is #{x}"
  x=x*2
end

NEXT?

##########################

SECTION 'MISC' / 'Variadic args'

# variadic methods `*words` is an array
def join_with_commas(*words)
  words.join(', ')
end

join_with_commas('one', 'two', 'three')

def join_with_commas(before, *words, after)
  before + words.join(', ') + after
end

join_with_commas('Testing: ', 'one', 'two', 'three', '.')

# like Scala ``: *``
join_with_commas(*['Testing: ', 'one', 'two', 'three', '.'])

# * in parallel assignments
before, *words, after = ['Testing: ', 'one', 'two', 'three', '.']

words

NEXT?

##########################

SECTION 'MISC' / 'Blocks'

# blocks are called via yield
def do_three_times
  yield
  yield
  yield
end

do_three_times { puts 'hello' }

# blocks can take arguments
def do_three_times
  yield('first')
  yield('second')
  yield('third')
end

# yield returns the result of executing the block
def number_names
  [yield('one'), yield('two'), yield('three')].join(', ')
end

number_names { |name| name.upcase.reverse }

NEXT?

##########################

SECTION 'MISC' / 'Enumerable - 1'

(1..10).count { |number| number.even? }

(1..10).select { |number| number.even? }

(1..10).any? { |number| number < 8 }

(1..10).all? { |number| number < 8 }

(1..5).each do |number|
  if number.even?
    puts "#{number} is even"
  else
    puts "#{number} is odd"
  end
end

(1..10).map { |number| number * 3 }

# &:message = { |object| object.message }
(1..10).select(&:even?)

['one', 'two', 'three'].map(&:upcase)

NEXT?

##########################

SECTION 'MISC' / 'Enumerable - 2'

# #flat_map
['one', 'two', 'three'].map(&:chars)

['one', 'two', 'three'].flat_map(&:chars)

# inject = fold
(1..10).inject(0) { |result, number| result + number }

(1..10).inject(1) { |result, number| result * number }

['one', 'two', 'three'].inject('Words:') { |result, word| "#{result} #{word}" }

NEXT?

##########################

SECTION 'MISC' / 'Struct'

# Struct = almost cases classes
class Point < Struct.new(:x, :y)

  def +(other_point)
    Point.new(x + other_point.x, y + other_point.y)
  end

  def inspect
    "#<Point (#{x}, #{y})>"
  end

end

a = Point.new(2, 3)

b = Point.new(10, 20)

a + b

# responding to x, x =
a.x
a.x = 35
a + b

# ==
Point.new(4, 5) == Point.new(4, 5)
Point.new(4, 5) == Point.new(6, 7)

NEXT?

##########################

SECTION 'MISC' / 'Monkey Patching'

# extending "existing" classes
class Point
  def -(other_point)
    Point.new(x - other_point.x, y - other_point.y)
  end
end

Point.new(10, 15) - Point.new(1, 1)

# everything is extensible, including built-in classes
class String
  def shout
    upcase + '!!!'
  end
end

'hello world'.shout

NEXT?

##########################

SECTION 'MISC' / 'CONSTANT'

# var, which name starts with capital is CONSTANT
NUMBERS = [4, 8, 15, 16, 23, 42]

class Greetings
  ENGLISH = 'hello'
  FRENCH = 'bonjour'
  GERMAN = 'guten Tag'
end

NUMBERS.last

Greetings::FRENCH

# NOTE : classes and modules are constants!

NEXT?

##########################

SECTION 'MISC' / 'REMOVING CONSTANTS'

NUMBERS.last

# remove_const is a private method, so sending a message
Object.send(:remove_const, :NUMBERS)

NUMBERS.last

Greetings::GERMAN

Object.send(:remove_const, :Greetings)

Greetings::GERMAN

BYE!
