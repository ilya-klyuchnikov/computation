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
Object.multiply(2, 3)

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

BYE!
