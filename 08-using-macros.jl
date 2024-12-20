### A Pluto.jl notebook ###
# v0.20.3

using Markdown
using InteractiveUtils

# ╔═╡ 1f443df9-619d-40c7-9e08-497ae1a08b5d
import Pkg; Pkg.activate(Base.current_project(), io=devnull)

# ╔═╡ 53265062-78c7-434a-8d96-089cdd758bf0
using PlutoUI; TableOfContents()

# ╔═╡ 61ba1a79-3f3f-4d4f-a43e-e3d8883787e8
md"""
## Using Macros
"""

# ╔═╡ 07c96535-102c-4581-bba7-50f37bd766f9
md"""
Unlike Matlab, Python, and R, Julia has macros. They are a very powerful programming construct. Macros change existing source code or generate entirely new code. In essence, they simplify programming by automating mundane coding tasks.

Preprocessor "macro" systems, like that of C/C++, work at the source code level by perform textual manipulation and substitution before any parsing or interpretation is done. Whereas, Julia macros work at the level of the abstract syntax tree after parsing, but before compilation is done.
"""

# ╔═╡ 2b1abe2e-fc7a-4d3a-9f65-b820eaff70ea
md"""
### The Abstract Syntax Tree

```julia
begin
str1 = "3 * 4 + 5"
ex1 = Meta.parse(str1)
println(typeof(ex1))
end
```

Try it.
"""

# ╔═╡ 9c45b534-cd6c-4b3d-9ff4-d035347c87e5


# ╔═╡ 6bc277f1-3ab6-4e12-92fc-65e6288af2c1
md"""
Note that the parsed expression is an `Expr` type.

```julia
dump(ex1)
```

Show or dump the abstract syntax tree (AST) of the expression.
"""

# ╔═╡ f09d458f-7846-46a5-a814-b51771bf91b7


# ╔═╡ 41a9007c-e9a1-4228-be45-55becfffa944
md"""
The `Expr` type has two fields, a `head` and an `args`. The `head` declares the item is a function `call` of type `Symbol` and the `args` is an `Array` of function arguments, namely the `+` operator of type `Symbol` and the two values to be added. The first value is another `Expr` type and the second is a 64-bit integer. The second nested `Expr` is also composed of a `Symbol` call. Its arguments are the multiplication `*` operation of type `Symbol` and two 64-bit integers. Note that the multiplication operation is nested in the addition operation, since multiplication has precedence over addition.

Note that the expression `ex1` can be written directly in AST syntax.

```julia
begin
ex2 = Expr(:call, :+, Expr(:call, :*, 3, 4), 5)
dump(ex2)
println(ex1 == ex2)
end
```

Try it.
"""

# ╔═╡ 06f3afb2-869a-4e2b-af58-4366b27d0a65


# ╔═╡ fb032b39-250b-486d-b0b7-0d21c8556562
md"""
!!! note
    If you prefer writing code as an AST, you can do so in Julia.

    However, you may not be popular with other coders.
"""

# ╔═╡ bc66ff75-77ce-4487-ab2e-72800331839b
md"""
### The `:` character

The `:` character has two syntatic purposes in Julia. It signifies a `Symbol` or a `Quote`.
"""

# ╔═╡ 3f2aef09-55c0-40c3-a50d-7081e66c60ed
md"""
#### Symbols

A `Symbol` is an interned string used as a building-block of an expression.

```julia
begin
sym = :foo
println(typeof(sym))
println(sym == Symbol("foo"))
end
```

Try it.
"""

# ╔═╡ bc5709bd-8c44-4d58-82cc-e14eef20cfe6


# ╔═╡ c1e446d9-63e9-4b9d-a0da-c1321c7f0a38
md"""
The `Symbol` constructor takes a variable number of arguments and concatenates them together to create a `Symbol` string.

```julia
Symbol("func", 10)
```

Try this.
"""

# ╔═╡ 8863cbcc-4ff6-4714-b7d8-c39373af384e


# ╔═╡ cf199e64-8fb6-4cd1-b2ea-8db5826c5be1
md"""
In the context of expressions, symbols are used to indicate access to variables. When an expression is evaluated, a symbol is replaced with the value bound to that symbol in the appropriate scope.
"""

# ╔═╡ 90538e89-e592-4536-99cb-7378ec320b8d
md"""
#### Quoting

The second purpose of the `:` character is to create expression objects without using the explicit `Expr` constructor. This is referred to as *quoting*.

```julia
begin
ex3 = :(3 * 4 + 5)
dump(ex3)
println(ex1 == ex2 == ex3)
end
```

Try this example.
"""

# ╔═╡ 611e0640-dc39-4846-89c9-172bc001e994


# ╔═╡ e7934544-0344-48d3-8046-c3796874e5b3
md"""
So, there are three ways to construct an expression allowing the programmer to use whichever one is most convenient.

There is a second syntatic form of quoting, called a `quote` block (i.e. `quote ... end`), that is commonly used for multiple expressions.

Try the following example.

```julia
begin
ex4 = quote
    x = 1
    y = 2
    x + y
end
println(typeof(ex4))
end
```
"""

# ╔═╡ c47eb25e-ff42-47a0-9949-11228e3c0535


# ╔═╡ 53ce9042-6f97-4a6e-bfaf-19aa7e313ba2
md"""
#### Interpolation

Julia allows *interpolation* of literals or expressions into quoted expressions by prefixing a variable with the `$` character. For example.

```julia
begin
a = 1;
ex5 = :($a + b)
dump(ex5)
end
```

Try it.
"""

# ╔═╡ 24368ee3-43e1-44c0-8293-75cc1e8f4f6c


# ╔═╡ 12b97064-d8da-49cc-92aa-f5155b5c1b52
md"""
Splatting is also possible.

```julia
begin
args = [:x, :y, :x];
dump(:(f(1, $(args...))))
end
```

And this too.
"""

# ╔═╡ 9de33d97-b08d-4a5a-b53a-862c0bfd2cb0


# ╔═╡ 2e45c794-62f0-4a1b-a346-da291e4c8469
md"""
#### Expression evaluation

Julia will evalution an expression in the global scope using `eval`.

```julia
println(eval(ex1))
```
"""

# ╔═╡ ade3dfbb-23bb-4ca6-8a33-3ec16dbed523


# ╔═╡ 3be5ecc9-58cf-457a-a5d4-c9ff6114ba01
md"""
### Macros
"""

# ╔═╡ c8c898a7-7ec5-4b3f-8875-5901e0ef12fc
md"""

#### Basics

Defining a macro is like defining a function. For example,

```julia
macro sayhello(name)
    return :( println("Hello", $name))
end
```
"""

# ╔═╡ f1ba0108-fbb7-4128-98f7-89c4f1e25790


# ╔═╡ 8bbe63e8-6a6e-4f96-8025-bbae25983a7e
md"""
Now invoke the `@sayhello` macro.

```julia
@sayhello("world")
```
"""

# ╔═╡ 6e6829b6-1d2a-46e8-bee2-dd4e116d4b3d


# ╔═╡ 2494a756-0b40-4b6e-b79f-deb616183384
md"""
Parentheses around the arguments are optional.

```julia
@sayhello "world"
```
"""

# ╔═╡ 3f9fcacd-05e6-4dd7-ba01-491750f3940d


# ╔═╡ f7fffc76-3607-4d90-ba75-d521366f7fb1
md"""
!!! note
    When using the parenthesized form, there should be no space between the macro name and the parentheses. Otherwise the argument list will be interpreted as a single argument containing a tuple.
"""

# ╔═╡ 9064ec91-4ddf-4f7b-890d-2e59265483a1
md"""
#### Usage

Macros can be used for many tasks such as performing operations on blocks of code, e.g. timing expressions (`@time`), threading `for` loops (`@threads`), and converting expressions to broadcast form (`@.`). Another use is to generate code. When a significant amount of repetitive boilerplate code is required, it is common to generate it programmatically to avoid redundancy.

Consider the following example.

```julia
struct MyNumber
    x::Float64
end
```
"""

# ╔═╡ bcce9741-7e63-4609-9529-0e9323b8eb21


# ╔═╡ a278e94d-1f4c-422c-9ac7-c950750a6ef9
md"""
We want to add a various methods to it. This can be done programmatically using a loop.

```julia
begin
println(length(methods(sin)))
for op = (:sin, :tan, :log, :exp)
    eval(quote
        Base.$op(a::MyNumber) = MyNumber($op(a.x))
    end)
end
println(length(methods(sin)))
end
```

Try this example.
"""

# ╔═╡ 386c7942-700d-4486-bede-853a6c2ef811


# ╔═╡ 1751fb54-938c-4222-a41a-17ce97f800bc
md"""
A slightly shorter version of the above code generator that use the `:` prefix is:

```julia
for op = (:sin, :cos, :tan, :log, :exp)
    eval(:(Base.$op(a::MyNumber) = MyNumber($op(a.x))))
end
```

An even shorter version of the code uses the `@eval` macro.

```julia
for op = (:sin, :cos, :tan, :log, :exp)
    @eval Base.$op(a::MyNumber) = MyNumber($op(a.x))
end
```

For longer blocks of generated code, the `@eval` macro can proceed a code `block`:

```julia
@eval begin
    # multiple lines
end
```
"""

# ╔═╡ d41b3124-0987-42d5-bd24-28a4c79cfe82
md"""
### Generated Functions

A special macro is `@generated`. It defines so-called *generated functions*. They have the capability to generate specialized code depending on the types of their arguments with more flexibility and/or less code than what can be done with multiple dispatch. Macros work with expressions at the AST level and cannot acces the input types. Whereas, generated functions are expanded at the time when the argument types are known, but before the function is compiled.

Here is an example.

```julia
@generated function foo(x)
    Core.println(x)
    return :(x * x)
end
```
"""

# ╔═╡ 1fbdea1e-ef3a-4ace-ae76-1ccda2273087


# ╔═╡ 1522314b-4982-439e-ab97-933869a5f307
md"""
```julia
begin
x = foo(2)
x
end
```

!!! note
    The result of the function call is the return type, not the return value.
"""

# ╔═╡ 63ed8db8-2104-4370-8a75-e9348c50cdf8


# ╔═╡ 3de9644d-b66a-45b8-945d-6e000319f2b9
md"""
```julia
begin
y = foo("bar")
y
end
```
"""

# ╔═╡ 28487c59-7df4-41b9-859a-79438b1d3b06


# ╔═╡ 78bb1e78-70ba-4f58-abb0-c0de3272eb50
md"""
Generated functions differ from regular functions in five ways. They:

1. are prefixed by `@generated`. This provides the AST with some additional information.
2. can only access the types of the arguments, not their values.
3. are nonexecuting. They return a quoted expression, not a value.
4. can only call previously defined functions. (Otherwise, `MethodErrors` may result.)
5. must not *mutate* or *observe* any non-constant global state. They can only read global constants, and cannot have side effects. In other words, they must be completely pure.
"""

# ╔═╡ Cell order:
# ╟─1f443df9-619d-40c7-9e08-497ae1a08b5d
# ╟─53265062-78c7-434a-8d96-089cdd758bf0
# ╟─61ba1a79-3f3f-4d4f-a43e-e3d8883787e8
# ╟─07c96535-102c-4581-bba7-50f37bd766f9
# ╟─2b1abe2e-fc7a-4d3a-9f65-b820eaff70ea
# ╠═9c45b534-cd6c-4b3d-9ff4-d035347c87e5
# ╟─6bc277f1-3ab6-4e12-92fc-65e6288af2c1
# ╠═f09d458f-7846-46a5-a814-b51771bf91b7
# ╟─41a9007c-e9a1-4228-be45-55becfffa944
# ╠═06f3afb2-869a-4e2b-af58-4366b27d0a65
# ╟─fb032b39-250b-486d-b0b7-0d21c8556562
# ╟─bc66ff75-77ce-4487-ab2e-72800331839b
# ╟─3f2aef09-55c0-40c3-a50d-7081e66c60ed
# ╠═bc5709bd-8c44-4d58-82cc-e14eef20cfe6
# ╟─c1e446d9-63e9-4b9d-a0da-c1321c7f0a38
# ╠═8863cbcc-4ff6-4714-b7d8-c39373af384e
# ╟─cf199e64-8fb6-4cd1-b2ea-8db5826c5be1
# ╟─90538e89-e592-4536-99cb-7378ec320b8d
# ╠═611e0640-dc39-4846-89c9-172bc001e994
# ╟─e7934544-0344-48d3-8046-c3796874e5b3
# ╠═c47eb25e-ff42-47a0-9949-11228e3c0535
# ╟─53ce9042-6f97-4a6e-bfaf-19aa7e313ba2
# ╠═24368ee3-43e1-44c0-8293-75cc1e8f4f6c
# ╟─12b97064-d8da-49cc-92aa-f5155b5c1b52
# ╠═9de33d97-b08d-4a5a-b53a-862c0bfd2cb0
# ╟─2e45c794-62f0-4a1b-a346-da291e4c8469
# ╠═ade3dfbb-23bb-4ca6-8a33-3ec16dbed523
# ╟─3be5ecc9-58cf-457a-a5d4-c9ff6114ba01
# ╟─c8c898a7-7ec5-4b3f-8875-5901e0ef12fc
# ╠═f1ba0108-fbb7-4128-98f7-89c4f1e25790
# ╟─8bbe63e8-6a6e-4f96-8025-bbae25983a7e
# ╠═6e6829b6-1d2a-46e8-bee2-dd4e116d4b3d
# ╟─2494a756-0b40-4b6e-b79f-deb616183384
# ╠═3f9fcacd-05e6-4dd7-ba01-491750f3940d
# ╟─f7fffc76-3607-4d90-ba75-d521366f7fb1
# ╟─9064ec91-4ddf-4f7b-890d-2e59265483a1
# ╠═bcce9741-7e63-4609-9529-0e9323b8eb21
# ╟─a278e94d-1f4c-422c-9ac7-c950750a6ef9
# ╠═386c7942-700d-4486-bede-853a6c2ef811
# ╟─1751fb54-938c-4222-a41a-17ce97f800bc
# ╟─d41b3124-0987-42d5-bd24-28a4c79cfe82
# ╠═1fbdea1e-ef3a-4ace-ae76-1ccda2273087
# ╟─1522314b-4982-439e-ab97-933869a5f307
# ╠═63ed8db8-2104-4370-8a75-e9348c50cdf8
# ╟─3de9644d-b66a-45b8-945d-6e000319f2b9
# ╠═28487c59-7df4-41b9-859a-79438b1d3b06
# ╟─78bb1e78-70ba-4f58-abb0-c0de3272eb50
