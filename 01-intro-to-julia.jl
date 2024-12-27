### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ 1e47e383-b735-4c57-a300-2afe8491b49a
using PlutoUI; TableOfContents()

# ╔═╡ d1366a55-b4fc-4ddb-b5c2-5f3381c48b49
html"<button onclick='present()'>present</button>"

# ╔═╡ 09193424-25b9-45ce-840f-f24bbcc46c9d
md"""
## Introduction

### Historical Context

Twenty-six years ago at ADASS VI, Harrington and Barrett hosted a Birds-of-a-Feather session entitled "Interactive Data Analysis Environments". Based on their review of over a dozen interpreted programming languages such as Glish, GUILE, IDL, IRAF, Matlab, Perl, Python, and Tcl; they recommended that Python be considered the primary language for astronomical data analysis. The primary reasons were that the language was simple to learn, yet powerful; well supported by the programming community; and had FORTRAN-like arrays. However, for good performance, the multi-dimensional arrays needed to be written in a compiled language, namely C. So Numerical Python suffered from the "two language problem".

### Why Julia?

In about 2009, four faculty members at MIT, who were not satisfied with the state of scientific computing, decided to develop a high performance, scientific programming language. After ten years of development, they release Julia Version 1.0 on August 8, 2018. Their aims were to create an open-source interpreted language that was concise, extensible, and high performance.

### What Differentiates Julia From Other Languages?

* Julia is **composable**.
* Julia is **concise**.
* Julia is **high performance**.
* Julia is **productive**.
* Julia is **easy to maintain**.
* Julia is **free and open-source**.

### Why Have I migrated to Julia?

Although an early advocate and developer of Numerical Python, I knew its limitations, namely, the two language problem. Therefore, once a better scientific programming language came along, I was prepared to migrate to it. Julia is that language.
"""

# ╔═╡ b1ed2c4e-f5fa-4e5e-87d8-7af6f80a83ca

md"""## Getting Started"""




# ╔═╡ 7f3357bc-4103-4a35-af21-9c86f5a0ec2f
md"""
**===================================================================================**

### Starting Julia

Enter `julia` at the terminal prompt. Set the number of threads to `auto`. Threads will be discussed later in Parallel Computing.

    > julia --threads=auto
    
                   _
       _       _ _(_)_     |  Documentation: https://docs.julialang.org
      (_)     | (_) (_)    |
       _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
      | | | | | | |/ _` |  |
      | | |_| | | | (_| |  |  Version 1.10.0 (2023-12-25)
     _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
    |__/                   |

    julia>

!!! tip

    The command line option "-q" can be used to remove the start-up banner.
"""

# ╔═╡ 7475c896-d1b1-4429-9ba8-8e78de41e0b0
md"""
**===================================================================================**

### Stopping Julia

To exit Julia, enter `<Ctl-D>` or `exit()`

    julia> <Ctl-D>

!!! tip
    Don't do this now!

"""

# ╔═╡ 5df8264e-6e37-4674-abdf-2b05c530787f
md"""
**===================================================================================**

### The command line  or  REPL (Read-Eval-Print-Loop)"""

# ╔═╡ f646ca14-c01e-47ee-8e2b-052d9db0985b
md"""
Our first command:

    println("Hello World")
"""

# ╔═╡ 4a404280-2845-4deb-8eee-2dcdcb9aed27


# ╔═╡ 7813824a-cae9-4b97-ac90-e542fbd630d5
md"""
!!! note
    Unlike Jupyter and the REPL, Pluto prints the result above the line, not below.

Our first calculation

    a = 4
"""

# ╔═╡ 6ac51e87-87a2-4ccc-9f08-0028700b3cda


# ╔═╡ 27208179-35c3-43c1-9548-3620c8aa7680
md"    b = 2"

# ╔═╡ 40d8d18c-3713-4e77-812d-9d77a4e1ac50


# ╔═╡ aa3e9db7-49d1-40f8-b745-6c4faa2197e1
md"    a + b"

# ╔═╡ 8eb9630a-44b2-4ac8-b243-0c2ce5b16f50


# ╔═╡ 419a6dec-1db0-477f-911f-049223b5674f
md"""
**===================================================================================**

### Other REPL Modes

#### Help, '?'
For help mode,

    julia> ?
    help?> println
    search: println printstyled print sprint isprint

    println([io::IO], xs...)
    
    Print (using print) xs to io followed by a newline. If io is not supplied, prints to the default output stream stdout.
    
    See also printstyled to add colors etc
    
    Examples
    ≡≡≡≡≡≡≡≡≡≡
    
    julia> println("Hello, world")
    Hello, world
    
    julia> io = IOBuffer();
    
    julia> println(io, "Hello", ',', " world.")
    
    julia> String(take!(io))
    "Hello, world.\n"

Enter 'delete' or 'backspace' to exit help"""

# ╔═╡ 98340265-f51e-47a0-95d2-df179b87f54b


# ╔═╡ 8ee7f43d-bf75-4975-ac64-54c2d5a0174a
md"""
#### Shell, ';'

For shell mode,

    julia> ;
    shell> pwd
    /Users/myhomedir

Enter 'delete' or 'backspace' to exit shell
"""


# ╔═╡ 33082ba8-acba-4ef1-aac2-f4523a704522


# ╔═╡ d1e9c51c-efb9-4dcb-9d28-8c54a235fbb4
md"""
#### Package Manager, `]`

    julia> ]
    pkg> 

For package manager help,

    pkg> ? `return`

Returns a brief summary of package commands

To add a package,

    pkg> add <package>
    pkg> add <package1>, <package2>

When adding a package, the Julia on-line repository will be searched. The package and its dependencies will then be downloaded, compiled, and installed. This may take anywhere from a few seconds to a few minutes depending on the size of the package and its dependencies.

To use or load a package (after it has been added),

    julia> using <package>
    julia> using <package1>, <package2>

A feature of the 'using' command is that it will add the package, if it hasn't alaredy been added.
"""

# ╔═╡ b27578b2-f5f5-4e46-82e6-0007be187ba6
md"""
To check the manifest:

    pkg> status

or

    pkg> st
"""

# ╔═╡ 1a95f9e5-77a3-46d0-9d4d-b28fbb0abf26


# ╔═╡ 065265a5-c9ad-4a39-b14d-f4e2e49d3f7a
md"""
To update a package in the manifest:

    pkg> update <package>

or

    pkg> up <package>

To update all packages in the manifest,

    pkg> up

    up

To garbage collect packages not used for a significant time,

    pkg> gc
"""

# ╔═╡ 563f07ad-6aed-495e-85fb-bae4a1755ac2
md"""
-----------------------------------------------------------------------------------
The Measurements package enables variables to have both values and errors.
Let's add the Measurements package using the `using` statement:

```julia
using Measurements
```
"""

# ╔═╡ 40abc83f-b4bd-479f-8671-189cc712d792


# ╔═╡ 297cd86c-5e9d-4f70-b11a-cbae8fa96d1e
md"""
Let's do some more calculations.

    m1 = measurement(4.5, 0.1)

"""

# ╔═╡ 8f016c75-7768-4418-8c57-100db3073c85


# ╔═╡ 094b6f30-cbd6-46b1-8e0c-3fdb1ef18261
md"""Typing 'measurements' is rather awkward. There must be a better way. How about the following?

    m2 = 15 ± 0.3

where the plus-minus character is entered using LaTex syntax followed by tab, i.e., \pm<tab>.
"""


# ╔═╡ 7ba8dc19-e0ca-40de-a778-7583ca70978d


# ╔═╡ 668abc35-fdc3-430f-8c90-de3c2c2cd77b
md"""
One of the features of Julia is that it understands unicode. For example, expressions in a printed document that contain greek characters can be entered as greek characters in your code. Let's calculate the following expression.

    α = m1 + m2
"""

# ╔═╡ 0e42f7fd-955e-4679-8d90-0cb46c9a12dc


# ╔═╡ d2a2d0bc-e883-439f-8e34-166e2369caef
md"""
!!! note

    Notice that the error of the result α has been propogated correctly.

Let's add another package called Unitful, which enables attaching units to variables:

```julia
using Unitful
```
"""

# ╔═╡ 88ca2a73-6203-447c-afcc-9e370a82076b


# ╔═╡ c24f1ddd-5e31-4073-a627-86cedb1d44c2
md"""
Now let's create a new values m3 with units attached:, and then multiply them together to create a third variable β.

```julia
m3 = (32 ± 0.1)u"m/s"
```
"""

# ╔═╡ 63a4b27a-5361-4d95-8787-ae31ca7987fe


# ╔═╡ d65a2638-54c0-4eb5-a870-44d7ab35400c
md"""
Let's create another value `m4`:

```julia
m4 = (9.8 ± 0.3)u"s"
```
"""

# ╔═╡ 15674bb0-2fe1-40b1-a6c0-3a5a64a6a5c3


# ╔═╡ c07f9493-b867-485b-87f2-50348bb9eaa6
md"""
Let's calculate `β` by adding `m3` and `m4`:

```julia
β = m3 * m4
```
"""

# ╔═╡ 70f08712-002c-4adc-84b1-73a8655d8a44


# ╔═╡ 6cc63679-6352-4ffa-ae6a-3066431cfd10
md"""
Some care must be taken when using Greek characters to not override their predefined values. For example:

```julia
π
```
"""

# ╔═╡ d961b128-bd38-40dd-8942-da6b7c150c42
md"""
And

```julia
2π
```
"""

# ╔═╡ 75ab8e8b-3082-45b0-9442-9c21bd1b09fa


# ╔═╡ cf4a0e8f-9210-4f1e-84d4-ee7ff09aaf61
md"""
!!! note
	As in the case of `2π`, the multiplication operator is inferred from the context and is not necessary. There cannot be a space between the number and variable.

The variable β's value now has an associated error and unit.

Let's see if this works with one dimensional arrays or vectors.

    γ = [10 ± 0.1, 20 ± 0.2, 30 ± 0.3]u"m/s" .* [15 ± 0.01, 25 ± 0.02, 25 ± 0.03]u"s"

Note the dot '.' before the multiplication character '\*'.  This means element-wise multiplication. Whereas the multiplication character '\*' by itself means matrix multiplication. If you are coming from Python, this difference may take a little time.
"""

# ╔═╡ fdba7211-e480-4948-8435-76a7608e7e63


# ╔═╡ 3e8ee79c-c315-4c19-88ad-9b58caa86c40
md"""
Julia can also do symbolic manipulation. We will need the Symbolics package for this:

```julia
using Symbolics
```
"""

# ╔═╡ 2a73c720-e08e-4b18-90d2-f86f945806f9


# ╔═╡ 746e3dae-4bbb-410b-899f-ef95c8afb1b0
md"""
We will use rotation matrices as an example, where Rx, Ry, and Rz are rotations about the 'x', 'y', and 'z'-axes:

```julia
begin
	Rx(θ) = [1. 0. 0.; 0. cos(θ) sin(θ); 0. -sin(θ) cos(θ)]

	Ry(θ) = [cos(θ) 0. -sin(θ); 0. 1. 0.; sin(θ) 0. cos(θ)]

	Rz(θ) = [cos(θ) sin(θ) 0.; -sin(θ) cos(θ) 0.; 0. 0. 1.]
end
```
"""

# ╔═╡ d7169595-d401-4fab-8554-d25e3b367583


# ╔═╡ 80335b0c-de35-4133-a32d-c0ccb826a4b3
md"""
Now create symbolic variables for the three equatorial precession angles: 'z', 'θ', and 'ζ' defined by Lieske *et al.* (1977):

```julia
@variables z, θ, ζ
```
"""

# ╔═╡ 8f5f7d12-38eb-49c9-90c6-81d27eda13fe


# ╔═╡ 1b9553dd-149c-4e48-aacf-10d6ca4756c2
md"""
Let's see what the rotation matrix looks like for the three-angle formulation of the precession matrix:

```julia
Rz(-z)Ry(θ)Rz(-ζ)
```
"""

# ╔═╡ 856a6279-6354-48de-85ca-c5638be68c9e


# ╔═╡ b56255c6-9d3b-4e2f-a9a0-c6fe69990f3d
md"""
!!! note

    What have we learned about the Julia command line and features?

    * Julia has four command line modes: **REPL**, **help**, **shell**, and **package manager**. 

    * Julia understands **unicode**.

    * Julia packages are **composable**. It means that independent packages are compatible and work together without modification, as demonstrated by the Measurements and Unitful packages. 
"""

# ╔═╡ 5cd072cb-5d71-4a08-8e41-4eaaa7faaa5c
md"""
**===================================================================================**

## Language Basics

Because of Julia's multiple dispatch, types and functions are loosely bound. Thus, it is not a true object-oriented language, where functions are selected for execution using single dispatch. Multi-dispatch will be explained later when we dicsuss functions.
"""

# ╔═╡ f37bc13e-fa91-4166-983b-fd13a8493435
md"""
**===================================================================================**

### Comments

A comment string begins with a "#" and extends to the end of the line.

A comment block begins and ends with "###".
"""

# ╔═╡ 0d0c11c0-d39f-462c-9fb6-ab90ca98d230
md"""
**===================================================================================**

### Types

The optional type operator "::" is used to specify a type to expressions and variables, especially when writing functions. If no type is specified, Julia will infer the type based on context.

There are two primary reasons for type annotation:

1. As an assertion to confirm that the code is working properly, and
2. To provide extra type information to the compiler to improve performance.
"""

# ╔═╡ a02bbbbb-6b3f-47ef-a11f-1db9b802db6f
md"""
```julia
(1+2)::Float32
```

Let's see how this works. Try the above example.
"""

# ╔═╡ 2262c860-c06c-4293-8e6d-b616228cb301


# ╔═╡ d549483e-0746-4e47-9a27-34757a7cabf2
md"""
And this example:

```julia
(1+2)::Int
```
"""

# ╔═╡ 68e64f74-8a6b-403e-a404-52fb9cdea54b


# ╔═╡ 0887eca0-6760-4d9b-b44e-d1a14059aede
md"""Julia has various categories of types within a type-hierarchy. The following are some of the more common types.

!!! note
    Types should be capitalized.
"""

# ╔═╡ 0ad9aa76-f6c7-4368-8ae4-58daa548e065
md"""#### Abstract Types

"abstract type" declares a type that cannot be instantiated, and serves only as a node in the type graph, thereby describing sets of related concrete types.

Let's create an abstract type.

    abstract type Widget end
"""

# ╔═╡ 1bc3da9e-143c-489c-b8de-a29dc48f17cb


# ╔═╡ f00dd72a-8705-426b-9eb4-b91cf1ea95d4
md"""
And some Widget subtypes using the subtype operator "<:".

    abstract type Round <: Widget end
    abstract type Square <: Widget end
"""

# ╔═╡ d308df6b-14ec-49ec-8270-a3b9efd88517


# ╔═╡ 01805f02-f9f6-4e3e-8e93-a0628753130f


# ╔═╡ a90b9011-714e-41d1-b7a3-fb3eb9dc56da
md"""
The subtype and supertype of a type can be shown using the functions "subtype" and "supertype".

Show the supertype and subtypes of Widget:

```julia
supertype(Round)
```
"""

# ╔═╡ b8325403-9744-4a9d-ae64-be88671da89b


# ╔═╡ 6af7e056-85ae-422f-999d-41a7441a1593
md"""
```julia
subtypes(Widget)
```
"""

# ╔═╡ 4879dae5-442e-4dc6-90c9-366ff76912bb


# ╔═╡ 0ead7d75-553b-43e3-82da-656a06c61ec4
md"""
```julia
typeof(1)
```
"""

# ╔═╡ e2e57f49-f848-468a-a6f5-482b6e1ad4ba


# ╔═╡ 42ba3538-5570-4722-9985-6c0509847667
md"""
```julia
subtypes(AbstractFloat)
```
"""

# ╔═╡ faf01f78-029f-47eb-829a-1415f22374f7


# ╔═╡ 4c278c5a-3324-4245-8ddf-f5390167168f
md"""
!!! note
    The "Any" type is at the top of the hierarchy. It is the union of all types. In other words, it is the root node.
    
    When the type of an expression or variable cannot be inferred from the context, the type defaults to "Any".
"""

# ╔═╡ 3772a828-561d-4600-8e67-49a28cc6cf09
md"""#### Primitive Types

A primitive type is a concrete type whose data consists of plain old bits. Classic examples of primitive types are integers and floating-point values. Unlike most languages, Julia lets you declare your own primitive types, rather than providing only a fixed set of built-in ones.

Let's see what primitive types Integer and AbstractFloat contain.

    subtypes(Integer)
"""

# ╔═╡ aa4a7ec0-a270-482b-abeb-7168de767938


# ╔═╡ b8e3b72a-e501-4164-b06c-cbb3282d9d11
md"    subtypes(Signed)"

# ╔═╡ d9aa9f5e-31b6-49a3-bae8-a9b149e6ab91


# ╔═╡ 15b0159b-9c8c-4327-b73d-d7e19decde2a
md"    subtypes(AbstractFloat)"

# ╔═╡ 5d5b1283-043b-437a-afda-75801808acc9


# ╔═╡ 6a6b2a0a-6bb6-4a67-b4c1-46631503918d
md"""Theoretically, a primitive type can have any number of bits, e.g., 5 or 17. Practically, the number of bits is constrained to multiples of 8. This is a limitation of the LLVM compiler, not Julia. So the Bool type is 8 bits, not 1 bit.
"""

# ╔═╡ 877faa74-7490-44a3-9e97-b36b36050796
md"""#### Characters (' ') vs. Strings (" ")

Unlike Python, single and double quotes have different meanings. Single quotes create characters. Double quotes create strings. The reason for this is Unicode.

    'j'
"""

# ╔═╡ bba18435-d355-4fca-a6f5-10dacde17413


# ╔═╡ d9e911a8-13f9-41e5-ac36-4aee3ec24c59
md"""
    Char(167)

Or

    '\u00A7'
"""

# ╔═╡ 5f72777b-a174-453c-8b18-ebf1f4bebe0d


# ╔═╡ 734a4185-4001-410f-affc-71b33e339339


# ╔═╡ c349f7b8-bdf0-4b94-b412-06c5e7f3cbc5
md"""    "This is a string" """

# ╔═╡ d8be9383-fb60-4938-9376-f91d59f21559


# ╔═╡ 31dfb05b-ed87-48f9-a74c-0055e46de160
md"""
Triple quotes work the same as in Python.

    \"""
    This is line 1.
    This is line 2.
    \"""

Try it.
"""

# ╔═╡ d2ada743-b82d-47c8-9b1d-4bd56de76e62


# ╔═╡ ea15815e-0ae3-4f22-9dce-a17cb3a0560b
md"""#### Composite Types

Composite types are called records, structs, or objects in various languages. A composite type is a collection of named fields, an instance of which can be treated as a single value.

In mainstream object oriented languages, such as C++, Java, Python and Ruby, composite types also have named functions associated with them, and the combination is called an "object". In Julia, all types are objects, but the objects have no bound functions. This is necessary because Julia selects the function/method using multiple dispatch, meaning that all argument types of a function are used to select the method, not just the first argument type.

Composite types are defined using the "struct" keyword followed by a block of field names. They are immutable (for performance reasons), unless modified by the "mutable" keyword.

    struct Longday
        day::Int64
        frac::Float64
    end

An instance of Longday is created as follows.

    day1 = Longday(1, 0.5)

Let's create a Longday type and an instance of it.

"""

# ╔═╡ be09f5d0-daea-4f47-8dc8-33c875fca843


# ╔═╡ 10ec3b0d-1add-4f92-8f4c-b594ab3f0e68


# ╔═╡ 6ee4665d-c5b9-4881-ad65-15c6a8229f3f
md"""
The field can be access using "dot" notation as follows:

    day1.day
    day1.frac
"""

# ╔═╡ f5596a05-04de-4955-9575-4c035e0f1495


# ╔═╡ a1b4f7bb-8238-40d6-81cb-6d5e6c737134


# ╔═╡ 3b8e773f-df6e-4b59-9f5d-e14366d02754
md"""#### Type Union

A type union is an abstract type that includes all instances of any of its argument types. The empty union Union{} is the leaf node of all Julia types.

    Union{Int, Nothing}

The variable "nothing" is the singleton instance of the type "Nothing".

Try it.
"""

# ╔═╡ 91f35db2-6a17-42aa-8580-1dea220b8c11


# ╔═╡ a631464d-e08a-4a89-8c47-fd5a7b2dee16
md"""#### Symbol Type

A type used to represent identifiers in parsed Julia code, namely the Abstract Syntax Trees (ASTs). Also often used as a name or label to identify an entity (e.g., as a dictionary key). Symbols are created using the colon prefix operator ":".

Symbols can be confusing when you first meet them in Julia code.

    :symbol
    typeof(:symbol)
"""

# ╔═╡ 7a8faa02-34b1-4416-beab-2909fb56c767


# ╔═╡ 6e1a3b46-05f0-487d-933a-6ff0d9d43a2b


# ╔═╡ 05adfd23-c809-4706-9bf2-1a0a2445748b
md"""#### Using Types

The type hierarchy allows variables and functions to be constrained to a particular set of types. Let's try a simple example.

Enter the following expressions.

    arg1::Float32 = 12.3
"""

# ╔═╡ 67a4ff9f-c75f-444c-9091-e9b5c17ee773


# ╔═╡ 67ad1d30-498e-414a-83d5-12e020c92741
md"""    typeof(arg1) <: Integer"""

# ╔═╡ cfd93268-174f-4a7e-9f98-3d5787c9392c


# ╔═╡ 73be3ec3-2668-44a0-bed9-242796bf5f08
md"""    typeof(arg1) <: ABstractFloat"""

# ╔═╡ a96dd069-09aa-4add-baba-99ffae36bfe8


# ╔═╡ 8a3aa0d3-1ade-4961-975d-b39899731ffe
md"""
!!! note

    What new things have we learned about Julia?

    * Julia has a type hierarchy with the type "Any" at the top.

    * Julia defines characters and strings using single and double quotes, respectively.

    * Julia defines composite types using the "struct" keyword.

    * Julia allows a set of types to be defined using the "Union" type.
"""

# ╔═╡ 62edc512-89e6-4b29-b96e-f43b253654b9
md"""
**===================================================================================**

### Functions

In Julia, a function is an object that maps a tuple of argument values to a return value.

There are three syntaxes for defining a function. The first two are named functions and the third is an anonymous function. If the return value is the last statement, then the "return" keyword is optional.

Standard function definition:

    function myadd(x::Int, y::Int)
        x + y
    end

One-line function definition:

    myadd(x::Float64, y::Float64) = x + y

Anonymous function definition:

    x, y -> x + y

Anonymous functions are often used when a function argument expects a function, e.g., the filter method that expects a Boolean comparison function.

Let's define the above three functions.
"""

# ╔═╡ 771dee9c-1615-435a-884f-7d274172191c


# ╔═╡ c0c8fde0-1526-4e8a-896a-67c226b0badf


# ╔═╡ c3b1713c-1207-427f-bc2b-7ff973f5e35e
md"""Notice that the function "myadd" now has two methods; one for Ints and one for Float64s.

Try adding an Int and Float64 using the "myadd" function:

```julia
myadd(2, 3.1)
```
"""

# ╔═╡ c7b43469-232a-46a0-8bb6-c7a928e6d2f2


# ╔═╡ cc19d021-1f25-4469-8239-9924cc01f883
md"""The compiler returns a MethodError because their is no method that adds a Int and Float64. We can fix this by defining a generic "myadd" function:

```julia
myadd(x, y) = x + y
```
"""

# ╔═╡ e967114e-14ef-42e4-a1cd-dcfda5f19ca3


# ╔═╡ bf4b04d2-34eb-4f2d-8fb7-fccfce419cb5
md"""
Try adding `Int` and `Float64` using the "myadd" function again.
"""

# ╔═╡ 43b6afe5-8c9d-412a-ae68-c190b93c74e6


# ╔═╡ 02296dd4-ddca-4acb-929f-61ef5d9f755f
md"""
!!! note
    Now look at the result above of adding an Int and a Float64 using "myadd".

    In many cases, a function with generic arguments is sufficiently performant. But in those cases where extreme performance is needed, defining methods with specific argument types may be necessary.

!!! note
    One-line functions are usually inlined by the compiler. So, there is usually no performance penalty for using them. Multi-lined functions may also be inlined.
"""

# ╔═╡ 197727b0-f566-4953-94fd-9062f8d4e828
md"""#### Optional Arguments

Functions can often take sensible default values. Julia allows the default values to be defined in the function definition.

    optargs(y::Int, m::Int=1, d::Int=1) = "$y-$m-$d"

Define the above function and execute it with a variable number of arguments.

Note how many methods are created when the function is defined.
""" 

# ╔═╡ 5639ea0c-c911-4e17-892d-2baf3613c682


# ╔═╡ 73749087-81ee-4651-a012-6158336a0c27
md"""
Run this function example:

```julia
optargs(2, 2, 2)
```
"""

# ╔═╡ c463427e-1584-4eb7-aefe-0eb24a9c01ba


# ╔═╡ 086c5d4e-eb0f-4f75-8814-fb6792397221
md"""
Now run this example:
```julia

optargs(2, 3)
```
"""

# ╔═╡ 4f88a26d-e8d4-46b8-9d33-0483fa9b5f38


# ╔═╡ 3ddf7fd7-9ebd-4f63-a4ac-c6cea8973478
md"""#### Keyword Arguments

Some functions have a large number of arguments or a large number of behaviors. Remembering how to call such functions can be annoying. Keyword arguments can make these functions easier to use and extend by allowing arguments to be identified by name instead of only by position.

Keyword arguments are listed after the required and optional arguments. They are delimited by a semicolon in the argument list.

    kwfunc(arg1, arg2=1; kwd1="blue", kwd2="red")

!!! note
    Don't confuse keyword arguments and optional arguments. Optional arguments are positional arguments with default values. Keyword arguments are positionless arguments with default values.
"""

# ╔═╡ f997567b-b403-4e21-a87f-063b59dcc5a6
md"""#### Functors

Functors are anonymous functions that are defined only by their argument signature. They are synonymous with callable objects in Python.

```julia
begin
	struct Polynomial{R}
    	coeffs::Vector{R}
	end
    
    function (p::Polynomial)(x)
        v = p.coeffs[end]
        for i = (length(p.coeffs)-1):-1:1
           v = v*x + p.coeffs[i]
        end
        return v
    end
end
```

Define the Polynomial type and the functor by placing the struct and function in a begin-end block.
"""

# ╔═╡ 802d9fbf-8a1c-4bb3-aa2d-cd9bab659115


# ╔═╡ 679a571e-d866-4005-a047-028c426fb167
md"""
Create a polynomial

```julia
p = Polynomial([1,10,100])
```
"""

# ╔═╡ 1e8b04e8-ea02-41d1-94e1-42b02bbafdcc


# ╔═╡ 3ffc37d1-8fd2-4436-bb8d-4bd82291c174
md"""
Evaluate the polynomial

```julia
p(5)
```
"""

# ╔═╡ fad1263d-6a0a-435e-a6b5-2e2d394307be


# ╔═╡ 7a35a96c-be9e-4e6e-ba70-7fb9b84a609f
md"""
!!! note
    What have we learned about functions?

    * Julia uses the argument signature, called multiple dispatch, to select the executable function.
    * Julia has two syntaxes for defining functions: one is for many-line functions and the other for one-line functions.
    * Julia has named functions and anonymous functions.
    * Julia function signatures have arguments and keywords. Arguments are required and listed first, but can have optional default values. Whereas, keywords are listed last and are optional.
    * Julia has anonymous functions called "functors" that are defined by their argument signature. 

"""

# ╔═╡ 33105044-e651-40a5-b928-592032c68e42
md"""
**===================================================================================**

## Multi-dimensional Arrays

The array library is implemented almost completely in Julia itself, and derives its performance from the compiler. All arguments to functions are passed by sharing (i.e. by pointers). By convention, a function name ending with a "!" indicates that it will mutate or destroy the value of one or more of its arguments (compare, for example, "sort" and "sort!").

Two characteristics of Julia arrays are:

* Column-major indexing
* One-based indexing

Both column-major indexing and one-base indexing follow the matrix convention of vectors being column arrays and the first index being 1. This is the same as FORTRAN and Matlab, and, of course, unlike Python.

!!! tip
    Just remember that the first index varies fastest.
"""

# ╔═╡ b3c2831f-1de1-47f4-ba4a-1cc30c30d510
md"""
**===================================================================================**

### Array Construction and Initialization

There several ways to create and initialize a new array:


    Array{T}(undef, dims...)    # an unitialized dense array

    ones(T, dims...)            # an array of zeros

where `T` signifies the array type, and `dims...` is a list of array dimensions.

    [1, 2, 3]                   # an array literal

    [2*i + j for i=1:3, j=4:6]  # array comprehension

    (2*i + j for i=1:3, j=4:6)  # generator expression

!!! note

    A generator expression doesn't create an array, it produces a value on demand.

Let's create some arrays. Create:

    zeros(Int8, 2, 3)

"""

# ╔═╡ 579259ef-3b67-4497-a8a3-5e6bed5b2ce0


# ╔═╡ 84704840-b3f4-4b03-aa81-18a0b0239387
md"""
Create this array:

```julia
[2*i + j for i=1:3 for j=4:6]
```
"""

# ╔═╡ 897da563-60db-446d-88cc-b23eec8fd7e5


# ╔═╡ 76afc0a5-5da0-446d-afbd-1f202d84cf9a
md"""Create 

    zeros(Int8, (2,3))
"""

# ╔═╡ c92272d7-8729-468d-8bc5-f80f12a53856


# ╔═╡ e87c1b53-da8e-4747-92ea-b8299b9107b7
md"""

The array dimensons can be either a list or tuple.

Now create an array without the type argument.

    zeros((2, 3)

"""

# ╔═╡ 13e6db9b-8b75-4f30-b174-ce3623148169


# ╔═╡ cd46d32e-84e0-4d29-892f-b30db3fdcf8a
md"""The type defaults to Float64"""

# ╔═╡ ae306737-6a62-4265-af3c-91992e9adb30
md"""
Create an array using the slice operator and the execute it using `collect`:

```julia
collect(1:10)
```
"""

# ╔═╡ 133702ad-1d34-4974-a612-231564d7806a


# ╔═╡ 3fa93473-c331-4cbb-be3e-24ecad75454a
md"""
Or use an array comprehension:

```julia
[i for i=1:10]
```
"""

# ╔═╡ 3d1691fb-12ce-4e9f-9643-d691df69ba99


# ╔═╡ d41bcf68-f472-48d0-ad82-1883f1d8d8ae
md"""#### Indexing

Indexes may be a scalar integer, an array of integers, or any other supported index. This includes Colon (:) to select all indices within the entire dimension, ranges of the form `begin:end` or `begin:step:end` to select contiguous or strided subsections, and arrays of booleans to select elements at their true indices. Slices in Julia are inclusive, meaning the beginning and ending indices are included in the slice.

`begin` and `end` can be used to indicate the first and last index of a slice. So, `end-1` is the penultimate index.

!!! note
    Julia allows the beginning and ending indices to be any value. That is they can be positive, negative, or zero. For example, the indices can `-3:3`. This feature requires the OffsetArrays package.

One supported index that is commonly used is the "CartesianIndex". It is an index that represents a single multi-dimensional index.

```julia
begin
    A = reshape(1:32, 4, 4, 2)
    A[3, 2, 1]
    A[CartesianIndex(3, 2, 1)] == A[3, 2, 1] == 7
end
```

Try the above example.
"""

# ╔═╡ 8aa1bee5-c3f3-425c-8c33-5fed56866342


# ╔═╡ c76b138f-feb1-41af-9bb2-ad045a3675ac
md"""
An array of CartesionIndex is also supported. They help simplify manipulating arrays. For example, it enables accessing the diagonal elements from the first "page" of A from above:

```julia
page = A[:,:,1]
```

Try it.
"""

# ╔═╡ d98ad311-6bf5-4f39-8e92-167fb4eea9a5


# ╔═╡ b3011696-f43f-446b-8450-63d7bbb74b10
md"""
```julia
page[[CartesianIndex(1,1),
      CartesianIndex(2,2),
      CartesianIndex(3,3),
      CartesianIndex(4,4)]]
```
"""

# ╔═╡ c5e2c91c-3e4f-434e-9c35-d3e8933d28f4


# ╔═╡ cc9eae6f-4cef-4160-9d1d-08f53e0681f6
md"""
This is expressed more simply using dot broadcasting and combining it with a normal integer index (instead of extracting the first page from A as a separate step).

    A[CartesianIndex.(axes(A, 1), axes(A, 2)), 1]

Try this too.
"""

# ╔═╡ 2793ca45-024c-4289-8075-c48c02acb971


# ╔═╡ a15b5f47-1be5-42ae-91c0-b868382d7e9b
md"""
#### Iteration

The preferred way of iterating over an array is:

    for a in A
        # Do something with the element a
    end

    for i in eachindex(A)
        # Do something with i and/or A[i]
    end

The first example returns the value and the second returns the index. These methods work with both dense and sparse arrays.
"""

# ╔═╡ 173531b1-4347-4cd7-97dd-213b449087bb


# ╔═╡ 8a080dae-1a60-4384-ad4a-07cad30485bd
md"""
#### Vectors and Matrices

A vector and matrix are just aliases for one and two dimensional arrays. To perform matrix multiplication, use the matrix multiply operator `*`. 
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.54"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.2"
manifest_format = "2.0"
project_hash = "2715a914af8a023ee857a2c9015593fe036c0e1b"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"

    [deps.Pkg.extensions]
    REPLExt = "REPL"

    [deps.Pkg.weakdeps]
    REPL = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eba4810d5e6a01f612b948c9fa94f905b49087b0"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.60"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [deps.Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.Tricks]]
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╟─1e47e383-b735-4c57-a300-2afe8491b49a
# ╟─d1366a55-b4fc-4ddb-b5c2-5f3381c48b49
# ╟─09193424-25b9-45ce-840f-f24bbcc46c9d
# ╟─b1ed2c4e-f5fa-4e5e-87d8-7af6f80a83ca
# ╟─7f3357bc-4103-4a35-af21-9c86f5a0ec2f
# ╟─7475c896-d1b1-4429-9ba8-8e78de41e0b0
# ╟─5df8264e-6e37-4674-abdf-2b05c530787f
# ╟─f646ca14-c01e-47ee-8e2b-052d9db0985b
# ╠═4a404280-2845-4deb-8eee-2dcdcb9aed27
# ╟─7813824a-cae9-4b97-ac90-e542fbd630d5
# ╠═6ac51e87-87a2-4ccc-9f08-0028700b3cda
# ╟─27208179-35c3-43c1-9548-3620c8aa7680
# ╠═40d8d18c-3713-4e77-812d-9d77a4e1ac50
# ╟─aa3e9db7-49d1-40f8-b745-6c4faa2197e1
# ╠═8eb9630a-44b2-4ac8-b243-0c2ce5b16f50
# ╟─419a6dec-1db0-477f-911f-049223b5674f
# ╠═98340265-f51e-47a0-95d2-df179b87f54b
# ╟─8ee7f43d-bf75-4975-ac64-54c2d5a0174a
# ╠═33082ba8-acba-4ef1-aac2-f4523a704522
# ╟─d1e9c51c-efb9-4dcb-9d28-8c54a235fbb4
# ╟─b27578b2-f5f5-4e46-82e6-0007be187ba6
# ╠═1a95f9e5-77a3-46d0-9d4d-b28fbb0abf26
# ╟─065265a5-c9ad-4a39-b14d-f4e2e49d3f7a
# ╟─563f07ad-6aed-495e-85fb-bae4a1755ac2
# ╠═40abc83f-b4bd-479f-8671-189cc712d792
# ╟─297cd86c-5e9d-4f70-b11a-cbae8fa96d1e
# ╠═8f016c75-7768-4418-8c57-100db3073c85
# ╟─094b6f30-cbd6-46b1-8e0c-3fdb1ef18261
# ╠═7ba8dc19-e0ca-40de-a778-7583ca70978d
# ╟─668abc35-fdc3-430f-8c90-de3c2c2cd77b
# ╠═0e42f7fd-955e-4679-8d90-0cb46c9a12dc
# ╟─d2a2d0bc-e883-439f-8e34-166e2369caef
# ╠═88ca2a73-6203-447c-afcc-9e370a82076b
# ╟─c24f1ddd-5e31-4073-a627-86cedb1d44c2
# ╠═63a4b27a-5361-4d95-8787-ae31ca7987fe
# ╟─d65a2638-54c0-4eb5-a870-44d7ab35400c
# ╠═15674bb0-2fe1-40b1-a6c0-3a5a64a6a5c3
# ╟─c07f9493-b867-485b-87f2-50348bb9eaa6
# ╠═70f08712-002c-4adc-84b1-73a8655d8a44
# ╟─6cc63679-6352-4ffa-ae6a-3066431cfd10
# ╟─d961b128-bd38-40dd-8942-da6b7c150c42
# ╠═75ab8e8b-3082-45b0-9442-9c21bd1b09fa
# ╟─cf4a0e8f-9210-4f1e-84d4-ee7ff09aaf61
# ╠═fdba7211-e480-4948-8435-76a7608e7e63
# ╟─3e8ee79c-c315-4c19-88ad-9b58caa86c40
# ╠═2a73c720-e08e-4b18-90d2-f86f945806f9
# ╟─746e3dae-4bbb-410b-899f-ef95c8afb1b0
# ╠═d7169595-d401-4fab-8554-d25e3b367583
# ╟─80335b0c-de35-4133-a32d-c0ccb826a4b3
# ╠═8f5f7d12-38eb-49c9-90c6-81d27eda13fe
# ╟─1b9553dd-149c-4e48-aacf-10d6ca4756c2
# ╠═856a6279-6354-48de-85ca-c5638be68c9e
# ╟─b56255c6-9d3b-4e2f-a9a0-c6fe69990f3d
# ╟─5cd072cb-5d71-4a08-8e41-4eaaa7faaa5c
# ╟─f37bc13e-fa91-4166-983b-fd13a8493435
# ╟─0d0c11c0-d39f-462c-9fb6-ab90ca98d230
# ╟─a02bbbbb-6b3f-47ef-a11f-1db9b802db6f
# ╠═2262c860-c06c-4293-8e6d-b616228cb301
# ╟─d549483e-0746-4e47-9a27-34757a7cabf2
# ╠═68e64f74-8a6b-403e-a404-52fb9cdea54b
# ╟─0887eca0-6760-4d9b-b44e-d1a14059aede
# ╟─0ad9aa76-f6c7-4368-8ae4-58daa548e065
# ╠═1bc3da9e-143c-489c-b8de-a29dc48f17cb
# ╟─f00dd72a-8705-426b-9eb4-b91cf1ea95d4
# ╟─d308df6b-14ec-49ec-8270-a3b9efd88517
# ╠═01805f02-f9f6-4e3e-8e93-a0628753130f
# ╟─a90b9011-714e-41d1-b7a3-fb3eb9dc56da
# ╠═b8325403-9744-4a9d-ae64-be88671da89b
# ╟─6af7e056-85ae-422f-999d-41a7441a1593
# ╠═4879dae5-442e-4dc6-90c9-366ff76912bb
# ╟─0ead7d75-553b-43e3-82da-656a06c61ec4
# ╠═e2e57f49-f848-468a-a6f5-482b6e1ad4ba
# ╟─42ba3538-5570-4722-9985-6c0509847667
# ╠═faf01f78-029f-47eb-829a-1415f22374f7
# ╟─4c278c5a-3324-4245-8ddf-f5390167168f
# ╟─3772a828-561d-4600-8e67-49a28cc6cf09
# ╠═aa4a7ec0-a270-482b-abeb-7168de767938
# ╟─b8e3b72a-e501-4164-b06c-cbb3282d9d11
# ╠═d9aa9f5e-31b6-49a3-bae8-a9b149e6ab91
# ╟─15b0159b-9c8c-4327-b73d-d7e19decde2a
# ╠═5d5b1283-043b-437a-afda-75801808acc9
# ╟─6a6b2a0a-6bb6-4a67-b4c1-46631503918d
# ╟─877faa74-7490-44a3-9e97-b36b36050796
# ╠═bba18435-d355-4fca-a6f5-10dacde17413
# ╟─d9e911a8-13f9-41e5-ac36-4aee3ec24c59
# ╠═5f72777b-a174-453c-8b18-ebf1f4bebe0d
# ╠═734a4185-4001-410f-affc-71b33e339339
# ╟─c349f7b8-bdf0-4b94-b412-06c5e7f3cbc5
# ╠═d8be9383-fb60-4938-9376-f91d59f21559
# ╟─31dfb05b-ed87-48f9-a74c-0055e46de160
# ╠═d2ada743-b82d-47c8-9b1d-4bd56de76e62
# ╟─ea15815e-0ae3-4f22-9dce-a17cb3a0560b
# ╠═be09f5d0-daea-4f47-8dc8-33c875fca843
# ╠═10ec3b0d-1add-4f92-8f4c-b594ab3f0e68
# ╟─6ee4665d-c5b9-4881-ad65-15c6a8229f3f
# ╠═f5596a05-04de-4955-9575-4c035e0f1495
# ╠═a1b4f7bb-8238-40d6-81cb-6d5e6c737134
# ╟─3b8e773f-df6e-4b59-9f5d-e14366d02754
# ╠═91f35db2-6a17-42aa-8580-1dea220b8c11
# ╟─a631464d-e08a-4a89-8c47-fd5a7b2dee16
# ╠═7a8faa02-34b1-4416-beab-2909fb56c767
# ╠═6e1a3b46-05f0-487d-933a-6ff0d9d43a2b
# ╟─05adfd23-c809-4706-9bf2-1a0a2445748b
# ╠═67a4ff9f-c75f-444c-9091-e9b5c17ee773
# ╟─67ad1d30-498e-414a-83d5-12e020c92741
# ╠═cfd93268-174f-4a7e-9f98-3d5787c9392c
# ╟─73be3ec3-2668-44a0-bed9-242796bf5f08
# ╠═a96dd069-09aa-4add-baba-99ffae36bfe8
# ╟─8a3aa0d3-1ade-4961-975d-b39899731ffe
# ╟─62edc512-89e6-4b29-b96e-f43b253654b9
# ╠═771dee9c-1615-435a-884f-7d274172191c
# ╠═c0c8fde0-1526-4e8a-896a-67c226b0badf
# ╟─c3b1713c-1207-427f-bc2b-7ff973f5e35e
# ╠═c7b43469-232a-46a0-8bb6-c7a928e6d2f2
# ╟─cc19d021-1f25-4469-8239-9924cc01f883
# ╠═e967114e-14ef-42e4-a1cd-dcfda5f19ca3
# ╟─bf4b04d2-34eb-4f2d-8fb7-fccfce419cb5
# ╠═43b6afe5-8c9d-412a-ae68-c190b93c74e6
# ╟─02296dd4-ddca-4acb-929f-61ef5d9f755f
# ╟─197727b0-f566-4953-94fd-9062f8d4e828
# ╠═5639ea0c-c911-4e17-892d-2baf3613c682
# ╟─73749087-81ee-4651-a012-6158336a0c27
# ╠═c463427e-1584-4eb7-aefe-0eb24a9c01ba
# ╟─086c5d4e-eb0f-4f75-8814-fb6792397221
# ╠═4f88a26d-e8d4-46b8-9d33-0483fa9b5f38
# ╟─3ddf7fd7-9ebd-4f63-a4ac-c6cea8973478
# ╟─f997567b-b403-4e21-a87f-063b59dcc5a6
# ╠═802d9fbf-8a1c-4bb3-aa2d-cd9bab659115
# ╟─679a571e-d866-4005-a047-028c426fb167
# ╠═1e8b04e8-ea02-41d1-94e1-42b02bbafdcc
# ╟─3ffc37d1-8fd2-4436-bb8d-4bd82291c174
# ╠═fad1263d-6a0a-435e-a6b5-2e2d394307be
# ╟─7a35a96c-be9e-4e6e-ba70-7fb9b84a609f
# ╟─33105044-e651-40a5-b928-592032c68e42
# ╟─b3c2831f-1de1-47f4-ba4a-1cc30c30d510
# ╠═579259ef-3b67-4497-a8a3-5e6bed5b2ce0
# ╟─84704840-b3f4-4b03-aa81-18a0b0239387
# ╠═897da563-60db-446d-88cc-b23eec8fd7e5
# ╟─76afc0a5-5da0-446d-afbd-1f202d84cf9a
# ╠═c92272d7-8729-468d-8bc5-f80f12a53856
# ╟─e87c1b53-da8e-4747-92ea-b8299b9107b7
# ╠═13e6db9b-8b75-4f30-b174-ce3623148169
# ╟─cd46d32e-84e0-4d29-892f-b30db3fdcf8a
# ╟─ae306737-6a62-4265-af3c-91992e9adb30
# ╠═133702ad-1d34-4974-a612-231564d7806a
# ╟─3fa93473-c331-4cbb-be3e-24ecad75454a
# ╠═3d1691fb-12ce-4e9f-9643-d691df69ba99
# ╟─d41bcf68-f472-48d0-ad82-1883f1d8d8ae
# ╠═8aa1bee5-c3f3-425c-8c33-5fed56866342
# ╟─c76b138f-feb1-41af-9bb2-ad045a3675ac
# ╠═d98ad311-6bf5-4f39-8e92-167fb4eea9a5
# ╟─b3011696-f43f-446b-8450-63d7bbb74b10
# ╠═c5e2c91c-3e4f-434e-9c35-d3e8933d28f4
# ╟─cc9eae6f-4cef-4160-9d1d-08f53e0681f6
# ╠═2793ca45-024c-4289-8075-c48c02acb971
# ╟─a15b5f47-1be5-42ae-91c0-b868382d7e9b
# ╠═173531b1-4347-4cd7-97dd-213b449087bb
# ╟─8a080dae-1a60-4384-ad4a-07cad30485bd
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
