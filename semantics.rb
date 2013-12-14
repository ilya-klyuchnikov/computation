class Number < Struct.new(:value)
  def to_s
    value.to_s
  end

  def inspect
    "«#{self}»"
  end
end

class Add < Struct.new(:left, :right)
  def to_s
    "(#{left} + #{right})"
  end

  def inspect
    "«#{self}»"
  end
end

class Multiply < Struct.new(:left, :right)
  def to_s
    "(#{left} * #{right})"
  end

  def inspect
    "«#{self}»"
  end
end

Add.new(
    Multiply.new(Number.new(1), Number.new(2)),
    Multiply.new(Number.new(3), Number.new(4))
)

# reduction
class Number
  def reducible?
    false
  end
end

class Add
  def reducible?
    true
  end
end

class Multiply
  def reducible?
    true
  end
end

# this is why ruby is good for writing books -
# we can add methods/functions step by step -
# so code in book is working!

=begin
# not OOP
def reducible?(expression)
  case expression
    # the same as Number === expression
    when Number
      false
    when Add, Multiply
      true
  end
end
=end

class Number
  def reduce
    self
  end
end

class Add
  def reduce
    if left.reducible?
      Add.new(left.reduce, right)
    elsif right.reducible?
      Add.new(left, right.reduce)
    else
      Number.new(left.value + right.value)
    end
  end
end

class Multiply
  def reduce
    if left.reducible?
      Multiply.new(left.reduce, right)
    elsif right.reducible?
      Multiply.new(left, right.reduce)
    else
      Number.new(left.value * right.value)
    end
  end
end

class Machine < Struct.new(:expression)
  def step
    self.expression = expression.reduce
  end

  def run
    while expression.reducible?
      puts expression
      step
    end
    puts expression
  end
end

Machine.new( Add.new(
                 Multiply.new(Number.new(1), Number.new(2)),
                 Multiply.new(Number.new(3), Number.new(4)) )
).run

class Boolean < Struct.new(:value)
  def to_s
    value.to_s
  end
  def inspect
    "«#{self}»"
  end
  def reducible?
    false
  end
end

class LessThan < Struct.new(:left, :right)
  def to_s
    "#{left} < #{right}"
  end

  def inspect
    "«#{self}»"
  end

  def reducible?
    true
  end

  def reduce
    if left.reducible?
      LessThan.new(left.reduce, right)
    elsif right.reducible?
      LessThan.new(left, right.reduce)
    else
      Boolean.new(left.value < right.value)
    end
  end
end

Machine.new(
    LessThan.new(Number.new(5), Add.new(Number.new(2), Number.new(2)))
).run

class Variable < Struct.new(:name)
  def to_s
    name.to_s
  end

  def inspect
    "«#{self}»"
  end

  def reducible?
    true
  end
end

# using environments

# old reduce method is replaced - arguments are not part of
# method signature
class Variable
  def reduce(environment)
    environment[name]
  end
end

class Number
  def reduce(environment)
    self
  end
end

class Add
  def reduce(environment)
    if left.reducible?
      Add.new(left.reduce(environment), right)
    elsif right.reducible?
      Add.new(left, right.reduce(environment))
    else
      Number.new(left.value + right.value)
    end
  end
end

class Multiply
  def reduce(environment)
    if left.reducible?
      Multiply.new(left.reduce(environment), right)
    elsif right.reducible?
      Multiply.new(left, right.reduce(environment))
    else
      Number.new(left.value * right.value)
    end
  end
end

class LessThan
  def reduce(environment)
    if left.reducible?
      LessThan.new(left.reduce(environment), right)
    elsif right.reducible?
      LessThan.new(left, right.reduce(environment))
    else
      Boolean.new(left.value < right.value)
    end
  end
end

# forget about the old Machine class
Object.send(:remove_const, :Machine)

class Machine < Struct.new(:expression, :environment)
  def step
    self.expression = expression.reduce(environment)
  end

  def run
    while expression.reducible?
      puts expression
      step
    end

    puts expression
  end
end

Machine.new(
    Add.new(Variable.new(:x), Variable.new(:y)), { x: Number.new(3), y: Number.new(4) }
).run

# statements

class DoNothing
  def to_s
    'do-nothing'
  end

  def inspect
    "<#{self}>"
  end

  def ==(other_statement)
    other_statement.instance_of?(DoNothing)
  end

  def reducible?
    false
  end
end

class Assign < Struct.new(:name, :expression)
  def to_s
    "#{name} = #{expression}"
  end

  def inspect
    "<#{self}>"
  end

  def reducible?
    true
  end

  # returns reduced statement and environment
  def reduce(environment)
    if expression.reducible?
      [Assign.new(name, expression.reduce(environment)), environment]
    else
      [DoNothing.new, environment.merge({name => expression})]
    end
  end
end

statement = Assign.new(:x, Add.new(Variable.new(:x), Number.new(1)))

environment = { x: Number.new(2) }

statement.reducible?

statement, environment = statement.reduce(environment)

statement, environment = statement.reduce(environment)

statement, environment = statement.reduce(environment)

statement.reducible?

# forget an old machine

Object.send(:remove_const, :Machine)

class Machine < Struct.new(:statement, :environment)
  def step
    self.statement, self.environment = statement.reduce(environment)
  end

  def run
    while statement.reducible?
      puts "#{statement}, #{environment}"
      step
    end

    puts "#{statement}, #{environment}"
  end
end

Machine.new(
    Assign.new(:x, Add.new(Variable.new(:x), Number.new(1))), { x: Number.new(2) }
).run

# more expressions - If

class If < Struct.new(:condition, :consequence, :alternative)
  def to_s
    "if (#{condition}) { #{consequence} } else { #{alternative} }"
  end

  def inspect
    "«#{self}»"
  end

  def reducible?
    true
  end

  def reduce(environment)
    if condition.reducible?
      [If.new(condition.reduce(environment), consequence, alternative), environment]
    else
      case condition
        when Boolean.new(true)
          [consequence, environment]
        when Boolean.new(false)
          [alternative, environment]
      end
    end
  end
end

Machine.new(
    If.new(
        Variable.new(:x),
        Assign.new(:y, Number.new(1)),
        Assign.new(:y, Number.new(2))
    ),
    { x: Boolean.new(true) }
).run

# without else
Machine.new(
    If.new(Variable.new(:x), Assign.new(:y, Number.new(1)), DoNothing.new),
    { x: Boolean.new(false) }
).run

class Sequence < Struct.new(:first, :second)
  def to_s
    "#{first}; #{second}"
  end

  def inspect
    "«#{self}»"
  end

  def reducible?
    true
  end

  def reduce(environment)
    case first
      when DoNothing.new
        [second, environment]
      else
        reduced_first, reduced_environment = first.reduce(environment)
        [Sequence.new(reduced_first, second), reduced_environment] end
  end
end

Machine.new(
    Sequence.new(
        Assign.new(:x, Add.new(Number.new(1), Number.new(1))),
        Assign.new(:y, Add.new(Variable.new(:x), Number.new(3))) ),
    {}
).run

# while-expression is surprisingly simple

class While < Struct.new(:condition, :body)
  def to_s
    "while (#{condition}) { #{body} }"
  end

  def inspect
    "«#{self}»"
  end

  def reducible?
    true
  end

  def reduce(environment)
    [If.new(condition, Sequence.new(body, self), DoNothing.new), environment]
  end
end

Machine.new(
    While.new(
        LessThan.new(Variable.new(:x), Number.new(5)),
        Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3))) ),
    { x: Number.new(1) }
).run

# BIG-STEP SEMANTICS NOW
# small-step semantics = iteration
# big-step semantics = recursion

class Number
  def evaluate(env)
    self
  end
end

class Boolean
  def evaluate(env)
    self
  end
end

class Variable
  def evaluate(env)
    env[name]
  end
end

class Add
  def evaluate(env)
    Number.new(left.evaluate(env).value + right.evaluate(env).value)
  end
end

class Multiply
  def evaluate(env)
    Number.new(left.evaluate(env).value * right.evaluate(env).value)
  end
end

class LessThan
  def evaluate(env)
    Boolean.new(left.evaluate(env).value < right.evaluate(env).value)
  end
end

LessThan.new(
    Add.new(Variable.new(:x), Number.new(2)),
    Variable.new(:y)
).evaluate(
    { x: Number.new(2), y: Number.new(5) }
)

# evaluation of statement just returns a new environment
class Assign
  def evaluate(env)
    env.merge({ name => expression.evaluate(env) })
  end
end

class DoNothing
  def evaluate(env)
    env
  end
end

class If
  def evaluate(env)
    case condition.evaluate(env)
      when Boolean.new(true)
        consequence.evaluate(env)
      when Boolean.new(false)
        alternative.evaluate(env)
    end
  end
end

class Sequence
  def evaluate(env)
    second.evaluate(first.evaluate(env))
  end
end

statement = Sequence.new(
    Assign.new(:x, Add.new(Number.new(1), Number.new(1))),
    Assign.new(:y, Add.new(Variable.new(:x), Number.new(3)))
)

statement.evaluate({})

class While
  def evaluate(env)
    case condition.evaluate(env)
      when Boolean.new(true)
        evaluate(body.evaluate(env))
      when Boolean.new(false)
        env
    end
  end
end

statement = While.new(
    LessThan.new(Variable.new(:x), Number.new(5)),
    Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3)))
)

statement.evaluate({ x: Number.new(1) })

# DENOTATIONAL SEMANTICS
# = translation to Ruby
# here we use %{ ... } - multi-line string with interpolation
# see http://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Literals

class Number
  def to_ruby
    %{-> e { #{value.inspect} }}
  end
end

class Boolean
  def to_ruby
    %{-> e { #{value.inspect} }}
  end
end

proc = eval(Number.new(5).to_ruby)

proc.call({})

class Variable
  def to_ruby
    %{-> e { e[#{name.inspect}] }}
  end
end

expression = Variable.new(:x)

expression.to_ruby

proc = eval(expression.to_ruby)

proc.call({x: 7})

class Add
  def to_ruby
    %{-> e { (#{left.to_ruby}).call(e) + (#{right.to_ruby}).call(e) }}
  end
end

class Multiply
  def to_ruby
    %{-> e { (#{left.to_ruby}).call(e) * (#{right.to_ruby}).call(e) }}
  end
end

class LessThan
  def to_ruby
    %{-> e { (#{left.to_ruby}).call(e) < (#{right.to_ruby}).call(e) }}
  end
end

Add.new(Variable.new(:x), Number.new(1)).to_ruby

LessThan.new(Add.new(Variable.new(:x), Number.new(1)), Number.new(3)).to_ruby

environment = { x: 3 }

proc = eval(Add.new(Variable.new(:x), Number.new(1)).to_ruby)

proc.call(environment)

proc = eval(
    LessThan.new(Add.new(Variable.new(:x), Number.new(1)), Number.new(3)).to_ruby
)

proc.call(environment)

# semantics of statements

class Assign
  def to_ruby
    %{-> e { e.merge({ #{name.inspect} => (#{expression.to_ruby}).call(e) }) }}
  end
end

statement = Assign.new(:y, Add.new(Variable.new(:x), Number.new(1)))

statement.to_ruby

proc = eval(statement.to_ruby)

proc.call({ x: 3 })

class DoNothing
  def to_ruby
    %{-> e { e }}
  end
end

class If
  def to_ruby
    %{-> e { if (#{condition.to_ruby}).call(e)
        then (#{consequence.to_ruby}).call(e)
        else (#{alternative.to_ruby}).call(e)" + " end
      }
    }
  end
end

class If
  def to_ruby
    %{
    -> e {
      if (#{condition.to_ruby}).call(e)
      then (#{consequence.to_ruby}).call(e)
      else (#{alternative.to_ruby}).call(e)" + " end
      }
    }
  end
end

class Sequence
  def to_ruby
    %{-> e { (#{second.to_ruby}).call((#{first.to_ruby}).call(e)) }}
  end
end

class While
  def to_ruby
    %{-> e {
        while (#{condition.to_ruby}).call(e);
          e = (#{body.to_ruby}).call(e);
        end
        e }
    }
  end
end

statement =
    While.new(
        LessThan.new(Variable.new(:x), Number.new(5)),
        Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3)))
    )

statement.to_ruby

proc = eval(statement.to_ruby)

proc.call({ x: 1 })
