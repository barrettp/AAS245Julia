### A Pluto.jl notebook ###
# v0.19.36

using Markdown
using InteractiveUtils

# ╔═╡ 5d8d2585-5c04-4f33-b547-8f44b3336f96
using PlutoUI; TableOfContents()

# ╔═╡ cab50215-8895-4789-997f-589f017b2b84
using PyCall

# ╔═╡ c3bc0c44-b2e9-4e6a-862f-8ab5092459ea
using LinearAlgebra

# ╔═╡ b83ba8db-b9b3-4921-8a93-cf0733cec7aa
using CUDA

# ╔═╡ a2680f00-7c9a-11ed-2dfe-d9cd445f2e57
md"""
# Optimization of Algorithms

Julia is a high-performance language. However, like any computer language, certain constructs are faster and use your computer's resources more efficiently. This tutorial will overview how you can use Julia and some of its unique features to enable blazing-fast performance.

However, to achieve good performance, there are a couple of things to keep in mind.

## Global Variables and Type Instabilities

First global variables in Julia are almost always a bad idea. First, from a coding standpoint, they are very hard to reason about since they could change at any moment. However, for Julia, they are also a performance bottleneck. Let's consider a simple function that updates a global array to demonstrate the issue of global arrays.

```julia
begin
	gl = rand(1000)

	function global_update()
		for i in eachindex(gl)
			gl[i] += 1
		end
	end
end
```
"""

# ╔═╡ b90d6694-b170-4646-b5a0-e477d4fe6f50
begin
	gl = rand(1000)

	function global_update()
		for i in eachindex(gl)
			gl[i] += 1
		end
	end
end

# ╔═╡ 5ed407ea-4bba-4eaf-b47a-9ae95b28abba
md"""
Now let's check the performance of this function. To do this, we will use the excellent benchmarking package [`BenchmarTools.jl`](https://github.com/JuliaCI/BenchmarkTools.jl) and the macro `@benchmark`, which runs the function multiple times and outputs a histogram of the time it took to execute the function

```julia
using BenchmarkTools

@benchmark global_update()

BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):   96.743 μs …   8.838 ms  ┊ GC (min … max): 0.00% … 97.79%
 Time  (median):     105.987 μs               ┊ GC (median):    0.00%
 Time  (mean ± σ):   123.252 μs ± 227.353 μs  ┊ GC (mean ± σ):  5.14% ±  2.76%

  ▄█▇█▇▅▄▃▄▅▃▂▃▅▆▅▅▄▃▃▂▂▂ ▁▁▁          ▁  ▁                     ▂
  ████████████████████████████▇██▇▇██▇███████▇▇█▇▇█▇▇▇▇▆▇▇▆▆▅▆▅ █
  96.7 μs       Histogram: log(frequency) by time        211 μs <

 Memory estimate: 77.77 KiB, allocs estimate: 3978.
```
** Note this was run on a Intel Core i7 i7-1185G7 processors so your benchmarks may differ **
"""

# ╔═╡ 76e3f9c8-4c39-4e7b-835b-2ba67435666a
md"""
**Try this benchmark below**
"""

# ╔═╡ f3d6edf3-f898-4772-80b7-f2aeb0f69216


# ╔═╡ 530368ec-ec33-4204-ac44-9dbabaca0dc4


# ╔═╡ 2310c578-95d8-4af0-a572-d7596750dfcc
md"""
Looking at the histogram, we see that the minimum time is 122 μs to update a vector! We can get an idea of why this is happening by looking at the total number of allocations we made while updating the vector. Since we are updating the array in place, there should be no allocations. 

To see what is happening here, Julia provides several code introspection tools.
Here we will use `@code_warntype`
```julia
@code_warntype global_update()
```
"""

# ╔═╡ 50b5500e-5ca8-4432-a5ac-01193a808232


# ╔═╡ 36a9656e-d09c-46b0-8dc4-b9a4de0ba3a8
md"""
which should give the following output


```julia
MethodInstance for Main.var"workspace#12".global_update()
  from global_update() in Main.var"workspace#12"
Arguments
  #self#::Core.Const(Main.var"workspace#12".global_update)
Locals
  @_2::Any
  i::Any
Body::Nothing
1 ─ %1  = Main.var"workspace#12".eachindex(Main.var"workspace#12".gl)::Any
│         (@_2 = Base.iterate(%1))
│   %3  = (@_2 === nothing)::Bool
│   %4  = Base.not_int(%3)::Bool
└──       goto #4 if not %4
2 ┄ %6  = @_2::Any
│         (i = Core.getfield(%6, 1))
│   %8  = Core.getfield(%6, 2)::Any
│   %9  = Base.getindex(Main.var"workspace#12".gl, i)::Any
│   %10 = (%9 + 1)::Any
│         Base.setindex!(Main.var"workspace#12".gl, %10, i)
│         (@_2 = Base.iterate(%1, %8))
│   %13 = (@_2 === nothing)::Bool
│   %14 = Base.not_int(%13)::Bool
└──       goto #4 if not %14
3 ─       goto #2
4 ┄       return nothing
```
"""

# ╔═╡ 8bc401d6-35f0-4722-8ac5-71ca34597b5f
md"""
`@code_warntype` tells us where the Julia compiler could not infer the variable type. If this happens, Julia cannot efficiently compile the function, and we end up with performance comparable to Python. The above example highlights the type instabilities in red and denotes accessing the global variable `gl`. These globals are a problem for Julia because their type could change anytime. As a result, Julia defaults to leaving the type to be the `Any` type.

Typically the standard way to fix this issue is to pass the offending variable as an argument to the function.

```julia
function better_update!(x)
	for i in eachindex(x)
		x[i] += 1
	end
end
```
"""

# ╔═╡ db9108c9-642f-4cb0-b1ba-08a76b505d2e


# ╔═╡ 29d231cf-131a-4907-aaf3-8ed4d8c1f181
md"""
Benchmarking this now

```julia
@benchmark better_update!(gl)
```
"""

# ╔═╡ d228e0f2-63f1-47aa-a0f2-ec4ede84fb3b


# ╔═╡ 934552be-59f8-4af4-86ad-711328035876
md"""
By passing the array as a function argument, Julia can infer the type and compile an efficient version of the function, achieving a 1000x speedup on my machine (Ryzen 7950x).

```julia
@code_warntype better_update!(gl)
```
"""

# ╔═╡ d5d35977-e8ef-4fd6-9573-5402616407d6


# ╔═╡ 1f3bfcc0-25f5-4c42-a989-0f3eb344eca8
md"""
we see that the red font is gone. This is a general thing to keep in mind when using Julia. Try not to use the global scope in performance-critical parts. Instead, place the computation inside a function.
"""

# ╔═╡ b89b329e-0dd1-4b0b-82a1-19d104dcf430
md"""
## Types

Julia is a typed but dynamic language. The use of types is part of the reason that Julia can produce fast code. If Julia can infer the types inside the body of a function, it will compile efficient machine code. However, if this is not the case, the function will become **type unstable**. We saw this above with our global example, but these type instabilities can also occur in other seemingly simple functions.

For example let's start with a simple sum
```julia
function my_sum(x)
	s = 0
	for xi in x
		s += xi
	end
	return
end
```

"""

# ╔═╡ 4f17c95e-8e0f-414d-ab62-413d7a848221


# ╔═╡ 946d91d1-7c37-4c35-b967-8b98856fb431
md"""
Analyzing this with `@code_warntype` shows a small type instability.

```julia
@code_warntype my_sum(gl)
```

!!! tip
	Remember to look for red-highlighted characters
"""

# ╔═╡ b050c5a4-3034-4a14-ae3a-b6eac433f275


# ╔═╡ 30e2be6c-f990-467a-85f9-a37f84f145ea
md"""
In this case, we see that Julia inserted a type instabilities since it could not determine the specific type of `s`. This is because when we initialized `s`, we used the value `0` which is an integer. Therefore, when we added xi to it, Julia determined that the type of `s` could either be an `Int` or `Float`. 

!!! note
	In Julia 1.8, the compiler is actually able to do something called [`union splitting`](https://julialang.org/blog/2018/08/union-splitting/), preventing this type instability from being a problem. However, it is still good practice to write more generic code.
"""

# ╔═╡ 32516afd-4d37-4739-bee5-8cebb2508276
md"""
To fix this we need to initialize `s` to be more generic. That can be done with the `zero` function in Julia.

```julia
function my_sum_better(x)
	s = zero(eltype(x))
	for xi in x
		s += xi
	end
	return s
end
```
"""

# ╔═╡ 55a4d63c-12d2-42de-867c-34879e4d39ec


# ╔═╡ 6bbdd13d-5d46-4bdc-b778-a18748a13552
md"""
Running `@code_warntype` we now get
```julia
@code_warntype my_sum_better(gl)
```
"""

# ╔═╡ e5a22bab-e5ea-4b43-b83e-3bd9bba2c014


# ╔═╡ 94b14c6c-952b-41c6-87e9-27785896d023
md"""
`zero` is a generic function that will create a `0` element that matches the type of the elements of the vector `x`.

One important thing to note is that while Julia uses types to optimize the code, using types in the function arguments does not impact performance at all. 

To see this let's look at an explicit version of `my_sum`
```julia
function my_sum_explicit(x::Vector{Float64})
	s = zero(eltype(x))
	for xi in x
		s += xi
	end
	return s
end
```
"""

# ╔═╡ e0584201-e9ee-49b1-ae55-e5c06efe8d5a


# ╔═╡ bba51c8a-43c0-4d61-985f-167de5a7329e
md"""
We can now benchmark both of our functions

```julia
@benchmark my_sum_better($gl)
```
"""

# ╔═╡ 6d941f25-f84e-4aad-ba2e-ee987155e8df


# ╔═╡ 6e6a2058-a728-4baf-b8dd-e0c59dc8c47b
md"""
```julia
@benchmark my_sum_explicit($gl)
```

"""

# ╔═╡ 9bbf0869-3d17-4f3f-9397-7bf97b31e6b1


# ╔═╡ 3b0c000d-3883-407b-900f-00db5e86c034
md"""
We can even make sure that both functions produce the same code using `@code_llvm` (`@code_native`), which outputs the LLVM IR (native machine code).
"""

# ╔═╡ 135bb62f-cda5-424e-969b-3a9e9389056d
md"""
```julia
@code_llvm my_sum_better(gl)
```
"""

# ╔═╡ 5508e9d9-0212-4e3b-9750-0e6ede4a5456


# ╔═╡ 9f6bbeae-5197-4fd7-8e4d-502020c0f974
md"""
```julia
@code_llvm my_sum_explicit(gl)
```
"""

# ╔═╡ 739cbd52-7c31-40f9-9e27-6e480ed79f83


# ╔═╡ f15013ed-b592-43f6-95ec-820480d804ef
md"""
Being overly specific with types in Julia is considered bad practice since it prevents composability with other libraries in Julia. For example, 

```julia
my_sum_explicit(Float32.(gl))
```
"""

# ╔═╡ 0a91e61c-9db9-4561-a9c6-ed678e8f3cca


# ╔═╡ 2861d873-6860-4d16-86af-3aebc57a9914
md"""
gives a method error because we told the compiler that the function could only accept `Float64`. In Julia, types are mostly used for `dispatch` i.e., selecting which function to use. However, there is one important instance where Julia requires that the types be specific. When defining a composite type or `struct`. 

For example
```julia
begin 
	struct MyType
		a::AbstractArray
	end
	Base.getindex(x, i) = x.a[i]
end
```
"""

# ╔═╡ 9b927077-d96f-482e-abcf-0b6ca7f0d674


# ╔═╡ 9358bba0-d1ca-47df-82a4-cf3102b88600
md"""
In this case, the `getindex` function is type unstable

```julia
@code_warntype MyType(rand(50))[1]
```

"""

# ╔═╡ 9a41649f-ba36-42d0-b85f-7c92b7c7aa7b


# ╔═╡ 7175833a-f7e3-4b83-9d5d-869b5ad2c78b
md"""
This is because Julia is not able to determine the type of `x.a` until runtime and so the compiler is unable to optimize the function.  This is because `AbstractArray` is an abstract type. 

!!! tip
	For maximum performance only use concrete types as `struct` fields/properties.

To fix this we can use *parametric types* 

```julia
begin
	struct MyType2{A<:AbstractArray}
		a::A
	end

	Base.getindex(a::MyType2, i) = a.a[i]
end
```
"""

# ╔═╡ 1840ebca-9856-438d-9daa-3912a43ca3a3


# ╔═╡ 8ff6ad52-b079-4b0c-8a84-56adc8796bbe
md"""
```julia
@code_warntype MyType2(rand(50))[1]
```

"""

# ╔═╡ e9e8ba32-1762-43eb-9b51-8d4bc81d35a9


# ╔═╡ 0898b019-488d-45b3-a8c2-cd72b4491049
md"""
and now because the exact layout `MyType2` is concrete, Julia is able to efficiently compile the code.
"""

# ╔═╡ a8c622c8-2eaf-4792-94fd-e18d622c3b23
md"""

### Additional Tools

In addition to `@code_warntype` Julia also has a number of other tools that can help diagnose type instabilities or performance problems:
  - [`Cthulhu.jl`](https://github.com/JuliaDebug/Cthulhu.jl): Recursively moves through a function and outputs the results of type inference.
  - [`JET.jl`](https://github.com/aviatesk/JET.jl): Employs Julia's type inference system to detect potential performance problems as well as bugs.
  - [`ProfileView.jl`](https://github.com/timholy/ProfileView.jl) Julia profiler and flame graph for evaluating function performance. 
"""

# ╔═╡ 20eff914-5853-4993-85a2-dfb6a8e2c14d
md"""
## Data Layout

Besides ensuring your function is type stable, there are a number of other performance issues to keep in mind with using Julia. 

When using higher-dimensional arrays like matrices, the programmer should remember that Julia uses a `column-major order`. This implies that indexing Julia arrays should be done so that the first index changes the fastest. For example

```julia
function row_major_matrix!(a::AbstractMatrix)
	for i in axes(a, 1)
		for j in axes(a, 2)
			a[i, j] = 2.0
		end
	end
	return a
end
```
!!! note
	We use the bang symbol !. This is stardard Julia convention and signals that the function is mutating.

"""

# ╔═╡ 4f4dde5e-21f3-4042-a91d-cd2c474a2279


# ╔═╡ da99dabc-f9e5-4f5e-8724-45ded36270dc
md"""
!!! tip
	Here we use an function to fill the matrix. This is just for clarity. The more Julian way to do this would be to use the `fill` or `fill!` functions.
"""

# ╔═╡ b3bb4563-e0f6-4edb-bae1-1a91f64b628f
md"""
Benchmarking this function gives
```julia
@benchmark row_major_matrix!($(zeros(1000, 1000)))
```

"""

# ╔═╡ 0d80a856-131d-4811-8d14-828c8c5e49dc


# ╔═╡ 1194df52-bd14-4d6b-9e99-d87c131156d6
md"""
This is very slow! This is because Julia uses column-major ordering. Computers typically store memory sequentially. That means that the most efficient way to access parts of a vector is to do it in order. For 1D arrays there is no ambiguity. However, for higher dimensional arrays a language must make a choice. Julia follows Matlab and Fortrans conventions and uses column-major ordering. This means that matrices are stored column-wise. In a for-loop this means that the inner index should change the fastest.

!!! note
	For a more complete introduction to computere memory and Julia see [https://book.sciml.ai/notes/02-Optimizing_Serial_Code/]()

```julia
function column_major_matrix!(a::AbstractMatrix)
	for i in axes(a, 1)
		for j in axes(a, 2)
			# The j index goes first
			a[j, i] = 2.0
		end
	end
	return a
end
```
"""

# ╔═╡ 5843b2ca-0e98-474d-8a92-7214b05399fd


# ╔═╡ 3270cc6e-3b2d-44b3-a75c-fa50cf15b77b
md"""
```julia
@benchmark column_major_matrix!($(zeros(1000, 1000)))
```
"""

# ╔═╡ 214b7f1b-f90d-4aa8-889f-2a522e80dcf5


# ╔═╡ 50e008a1-a9cc-488e-a1c0-bd21528414c6
md"""
To make iterating more automatic, Julia also provides a generic CartesianIndices tool that ensures that the loop is done in the correct order

```julia
function cartesian_matrix!(a::AbstractMatrix)
	for I in CartesianIndices(a)
		a[I] = 2.0
	end
	return a
end
```
"""

# ╔═╡ e6016b1b-1cb2-4e92-b657-a51a221aa3f2


# ╔═╡ 6ae76360-c446-4ee7-b452-0ac225e9e41b
md"""
```julia
@benchmark cartesian_matrix!($(zeros(1000, 1000)))
```
"""

# ╔═╡ 3534d380-d8ae-498a-84be-c14ba5454e65


# ╔═╡ a52e79b7-3fb0-4ad3-9bf5-f225beff01c3
md"""
## Broadcasting/Vectorization in Julia
"""

# ╔═╡ 16b55184-b515-47c8-bbb3-f899a920e9f8
md"""
One of Julia's greatest strengths over python is surprisingly its ability to vectorize algorithms and **fuse** multiple algorithms together. 

In python to get speed you typically need to use numpy to vectorize operations. For example, to compute the operation `x*y + c^3` you would do 
```python
python> x*y + c**3
```
However, this is not optimal since the algorithm works in two steps:
```python
python> a = x*y
python> b = c**3
python> out = a + b
```
What this means is that python/numpy is not able to fuse multiple operations together. This essentially loops through the data twice and can lead to substantial overhead. 

To demonstrate this, let's first write the `numpy` version of this simple function
"""

# ╔═╡ 4dd74c86-333b-4e7a-944b-619675e9f6ed
@pyimport numpy as np

# ╔═╡ e0a1b20d-366b-4048-80f1-94297697bd4a
x = rand(1_000_000)

# ╔═╡ 82edfb04-3de0-462b-ab4f-77cdad052bef
y = rand(1_000_000)

# ╔═╡ e8febda3-db2c-4f10-84bd-384c9ddd0ff7
c = rand(1_000_000)

# ╔═╡ f33eb06d-f45b-438c-86a9-26d8f94e7809
md"""
First let's use PyCall and numpy to do the computation
"""

# ╔═╡ 60e55645-ab59-4ea7-8009-9db7d0aea2e6
begin
	py"""
	def bench_np(x, y, c):
		return x*y + c**3 
	"""
	bench_np = py"bench_np"
end

# ╔═╡ 35f818c2-acee-4d20-9eb3-0c3ae37f3762
md"""
```julia-repl
@benchmark bench_np($x, $y, $c)
```
"""

# ╔═╡ a0c8660c-3ddb-4795-b3c9-a63cc64c8c00
@benchmark bench_np($x, $y, $c)

# ╔═╡ cb3bb128-49d3-4996-84e2-5154e13bbfbd
md"""
Now to get started with Julia we will use a simple for loop.

```julia
function serial_loop(x, y, c)
	out = similar(x)
	for i in eachindex(x, y, c)
		out[i] = x[i]*y[i] + c[i]^3
	end
	return out
end
```
"""

# ╔═╡ 924d11a7-5161-4b13-a1f6-a1a8530736da
function serial_loop(x, y, c)
	out = similar(x)
	for i in eachindex(x, y, c)
		out[i] = x[i]*y[i] + c[i]^3
	end
	return out
end

# ╔═╡ 40381501-952a-48a5-9a28-ee4bf1c65fd4
md"""
```julia
@benchmark serial_loop($x, $y, $c)
```
"""

# ╔═╡ 0be6a2d0-f470-436c-bbd7-8bab3635a34d
@benchmark serial_loop($x, $y, $c)

# ╔═╡ 7fad0fc0-1a6a-437a-a1c2-ce2c70d41acf
md"""
And right away, we have almost a factor of 4X speed increase in Julia compared to numpy.

However, we can make this loop faster! Julia automatically checks the bounds of an array every loop iteration. This makes Julia memory safe but adds overhead to the loop.

!!! warning 
	`@inbounds` used incorrectly can give wrong results or even cause Julia to  SEGFAULT

```julia
function serial_loop_inbounds(x, y, c)
	out = similar(x)
	@inbounds for i in eachindex(x, y, c)
		out[i] = x[i]*y[i] + c[i]^3
	end
	return out
end
```

!!! tip
	If you index with `eachindex` or `CartesianIndices` Julia can often automatically remove the bounds-check for you. The moral - always use Julia's iterator interfaces where possible. This example doesn't because `out` is not included in `eachindex`
"""

# ╔═╡ 54a92a14-405a-45d1-ad3a-5f42e4ce8789
function serial_loop_inbounds(x, y, c)
	out = similar(x)
	@inbounds for i in eachindex(x, y, c)
		out[i] = x[i]*y[i] + c[i]^3
	end
	return out
end

# ╔═╡ 946da67e-5aff-4de9-ba15-715a05264c4d
md"""
```julia
@benchmark serial_loop_inbounds($x, $y, $c)
```
"""

# ╔═╡ 4da9796c-5102-44e7-8af3-dadbdabcce73
@benchmark serial_loop_inbounds($x, $y, $c)

# ╔═╡ db4ceb7c-4ded-4048-88db-fd15b3231a5c
md"""
That is starting to look better. Now we can do one more thing. Looking at the results we see that we are still allocating in this loop. We can fix this by explicitly passing the output buffer. 
"""

# ╔═╡ 575d1656-0a0d-40ba-a190-74e36c354e8c
md"""
```julia
function serial_loop!(out, x, y, c)
	@inbounds for i in eachindex(x, y, c)
		out[i] = x[i]*y[i] + c[i]^3
	end
	return out
end
```
"""

# ╔═╡ fc2351f5-f808-499d-8251-d12c93a2be0e
function serial_loop!(out, x, y, c)
	@inbounds for i in eachindex(x, y, c)
		out[i] = x[i]*y[i] + c[i]^3
	end
	return out
end

# ╔═╡ 2bd7d41e-f2c9-47cd-8d5b-a2cfef84a830
out = similar(x)

# ╔═╡ 42be3a59-b6bb-49b2-a2ca-73adedc35588
md"""
```julia
@benchmark serial_loop!(out, x, y, c)
```
"""

# ╔═╡ f5ecdd06-addb-4913-996b-164e337853c2
@benchmark serial_loop!(out, x, y, c)

# ╔═╡ c14acc67-dbb2-4a86-a811-de857769a472
md"""
With just two changes, we have sped up our original function by almost a factor of 2. However, compared to NumPy, we have had to write a lot more code. 

Fortunately, writing these explicit loops, while fast, is not required to achieve good performance in Julia. Julia provides its own *vectorization* procedure using the 
`.` syntax. This is known as *broadcasting* and results in Julia being able to apply elementwise operations to a collection of objects.

To demonstrate this, we can rewrite our optimized `serial_loop` function just as

```julia
function bcast_loop(x, y, c)
	return x.*y .+ c.^3
	# or @. x*y + c^3
end
```
"""

# ╔═╡ f9a938d8-dce9-4ef0-967e-5b3d5384ca9b
function bcast_loop(x, y, c)
	return x.*y .+ c.^3
	# or @. x*y + c^3
end

# ╔═╡ 38bafb52-14f0-4a42-8e73-de1ada31c87e
md"""
```julia
@benchmark bcast_loop($x, $y, $c)
```
"""

# ╔═╡ 785a379a-e6aa-4919-9c94-99e277b57844
@benchmark bcast_loop($x, $y, $c)

# ╔═╡ 232cd259-5ff4-42d2-8ae1-cb6823114635
md"""
Unlike Python this syntax can even be used to prevent allocations!

```julia
function bcast_loop!(out, x, y, c)
	out .= x.*y .+ c.^3
	# or @. out = x*y + c^3
end
```
"""

# ╔═╡ 168aee22-6769-4077-a9da-a27689e6bb32
function bcast_loop!(out, x, y, c)
	out .= x.*y .+ c.^3
	# or @. out = x*y + c^3
end

# ╔═╡ 985cd6ec-bd2d-4dd9-bfbe-0bb066036150
md"""
```julia
@benchmark bcast_loop!($out, $x, $y, $c)
```
"""

# ╔═╡ 6acbaed4-6ff3-45be-9b28-595213206218
@benchmark bcast_loop!($out, $x, $y, $c)

# ╔═╡ 587d98d8-f805-4c4f-bf2f-1887d86adf05
md"""
Both of our broadcasting functions perform identically to our hand-tuned for loops. How is this possible? The main reason is that Julia's elementwise operations or broadcasting automatically **fuses**. This means that Julia's compiler eventually compiles the broadcast expression to a single loop, preventing intermediate arrays from ever needing to be formed. 
"""

# ╔═╡ ea2e2140-b826-4a05-a84c-6309241da0e7
md"""
Julia's broadcasting interface is also generic and a lot more powerful than the usual NumPy vectorization algorithm. For instance, suppose we wanted to perform an eigen decomposition on many matrices. In Julia, this is given in the `LinearAlgebra` module and the `eigen` function. To apply this to a vector of matrices, we then need to change `eigen` to `eigen.` .
"""

# ╔═╡ e8c1c746-ce30-4bd9-a10f-c68e3823faac
A = [rand(50,50) for _ in 1:50] 

# ╔═╡ e885bbe5-f7ec-4f6a-80fd-d6314179a3cd
md"""
```julia
eigen.(A)
```
"""

# ╔═╡ 90bd7f7b-3cc1-43ab-8f78-c1e8339a79bf
eigen.(A)

# ╔═╡ 608a3a98-924f-45ef-aeca-bc5899dd8c7b
md"""
Finally as a bonus we note that Julia's broadcasting interface also automatically works on the GPU.
"""

# ╔═╡ cc1e5b9f-c5b4-47c0-b886-369767f6ca4b
md"""
```julia
@benchmark bcast_loop!($(cu(out)), $(cu(x)), $(cu(y)), $(cu(c)))
```

!!! tip
	This will only work if you have CUDA installed and a NVIDIA GPU.
"""

# ╔═╡ 687b18c3-52ae-48fa-81d6-c41b48edd719


# ╔═╡ dcd6c1f3-ecb8-4a3f-ae4f-3c5b6f8494e7
md"""
!!! note
	`cu` is the function that moves the data on the CPU to the GPU. See the parallel computing tutorial for more information about GPU based parallelism in Julia.
"""

# ╔═╡ 20bcc70f-0c9f-40b6-956a-a286cea393f8
md"""
# Conclusion
This is just the start of various performance tips in Julia. There exist many other interesting packages/resources when optimizing Julia code. These resources include:
  - Julia's [`performance tips`](https://docs.julialang.org/en/v1/manual/performance-tips/) section is excellent reading for more information about the various optimization mentioned here and many more.
  - [`StaticArrays.jl`](https://github.com/JuliaArrays/StaticArrays.jl): Provides a fixed size array that enables aggressive SIMD and optimization for small vector operations.
  - [`StructArrays.jl`](https://github.com/JuliaArrays/StructArrays.jl): Provides an interface that acts like an array whose elements are a struct but actually stores each field/property of the struct as an independent array.
  - [`LoopVectorization.jl`](https://github.com/JuliaSIMD/LoopVectorization.jl) specifically the `@turbo` macro that can rewrite loops to make extra use of SIMD.
  - [`Tulio.jl`](https://github.com/mcabbott/Tullio.jl): A package that enables Einstein summation-style summations or tensor operations and automatically uses multi-threading and other array optimization.
"""

# ╔═╡ 97f7a295-5f33-483c-8a63-b74c8f79eef3

# ╔═╡ Cell order:
# ╟─5d8d2585-5c04-4f33-b547-8f44b3336f96
# ╟─a2680f00-7c9a-11ed-2dfe-d9cd445f2e57
# ╠═b90d6694-b170-4646-b5a0-e477d4fe6f50
# ╟─5ed407ea-4bba-4eaf-b47a-9ae95b28abba
# ╟─76e3f9c8-4c39-4e7b-835b-2ba67435666a
# ╠═f3d6edf3-f898-4772-80b7-f2aeb0f69216
# ╠═530368ec-ec33-4204-ac44-9dbabaca0dc4
# ╟─2310c578-95d8-4af0-a572-d7596750dfcc
# ╠═50b5500e-5ca8-4432-a5ac-01193a808232
# ╟─36a9656e-d09c-46b0-8dc4-b9a4de0ba3a8
# ╟─8bc401d6-35f0-4722-8ac5-71ca34597b5f
# ╠═db9108c9-642f-4cb0-b1ba-08a76b505d2e
# ╟─29d231cf-131a-4907-aaf3-8ed4d8c1f181
# ╠═d228e0f2-63f1-47aa-a0f2-ec4ede84fb3b
# ╟─934552be-59f8-4af4-86ad-711328035876
# ╠═d5d35977-e8ef-4fd6-9573-5402616407d6
# ╟─1f3bfcc0-25f5-4c42-a989-0f3eb344eca8
# ╟─b89b329e-0dd1-4b0b-82a1-19d104dcf430
# ╠═4f17c95e-8e0f-414d-ab62-413d7a848221
# ╟─946d91d1-7c37-4c35-b967-8b98856fb431
# ╠═b050c5a4-3034-4a14-ae3a-b6eac433f275
# ╟─30e2be6c-f990-467a-85f9-a37f84f145ea
# ╟─32516afd-4d37-4739-bee5-8cebb2508276
# ╠═55a4d63c-12d2-42de-867c-34879e4d39ec
# ╟─6bbdd13d-5d46-4bdc-b778-a18748a13552
# ╠═e5a22bab-e5ea-4b43-b83e-3bd9bba2c014
# ╟─94b14c6c-952b-41c6-87e9-27785896d023
# ╠═e0584201-e9ee-49b1-ae55-e5c06efe8d5a
# ╟─bba51c8a-43c0-4d61-985f-167de5a7329e
# ╠═6d941f25-f84e-4aad-ba2e-ee987155e8df
# ╟─6e6a2058-a728-4baf-b8dd-e0c59dc8c47b
# ╠═9bbf0869-3d17-4f3f-9397-7bf97b31e6b1
# ╟─3b0c000d-3883-407b-900f-00db5e86c034
# ╟─135bb62f-cda5-424e-969b-3a9e9389056d
# ╠═5508e9d9-0212-4e3b-9750-0e6ede4a5456
# ╟─9f6bbeae-5197-4fd7-8e4d-502020c0f974
# ╠═739cbd52-7c31-40f9-9e27-6e480ed79f83
# ╟─f15013ed-b592-43f6-95ec-820480d804ef
# ╠═0a91e61c-9db9-4561-a9c6-ed678e8f3cca
# ╟─2861d873-6860-4d16-86af-3aebc57a9914
# ╠═9b927077-d96f-482e-abcf-0b6ca7f0d674
# ╟─9358bba0-d1ca-47df-82a4-cf3102b88600
# ╠═9a41649f-ba36-42d0-b85f-7c92b7c7aa7b
# ╟─7175833a-f7e3-4b83-9d5d-869b5ad2c78b
# ╠═1840ebca-9856-438d-9daa-3912a43ca3a3
# ╟─8ff6ad52-b079-4b0c-8a84-56adc8796bbe
# ╠═e9e8ba32-1762-43eb-9b51-8d4bc81d35a9
# ╟─0898b019-488d-45b3-a8c2-cd72b4491049
# ╟─a8c622c8-2eaf-4792-94fd-e18d622c3b23
# ╟─20eff914-5853-4993-85a2-dfb6a8e2c14d
# ╠═4f4dde5e-21f3-4042-a91d-cd2c474a2279
# ╟─da99dabc-f9e5-4f5e-8724-45ded36270dc
# ╟─b3bb4563-e0f6-4edb-bae1-1a91f64b628f
# ╠═0d80a856-131d-4811-8d14-828c8c5e49dc
# ╟─1194df52-bd14-4d6b-9e99-d87c131156d6
# ╠═5843b2ca-0e98-474d-8a92-7214b05399fd
# ╟─3270cc6e-3b2d-44b3-a75c-fa50cf15b77b
# ╠═214b7f1b-f90d-4aa8-889f-2a522e80dcf5
# ╟─50e008a1-a9cc-488e-a1c0-bd21528414c6
# ╠═e6016b1b-1cb2-4e92-b657-a51a221aa3f2
# ╟─6ae76360-c446-4ee7-b452-0ac225e9e41b
# ╠═3534d380-d8ae-498a-84be-c14ba5454e65
# ╟─a52e79b7-3fb0-4ad3-9bf5-f225beff01c3
# ╟─16b55184-b515-47c8-bbb3-f899a920e9f8
# ╠═cab50215-8895-4789-997f-589f017b2b84
# ╠═4dd74c86-333b-4e7a-944b-619675e9f6ed
# ╠═e0a1b20d-366b-4048-80f1-94297697bd4a
# ╠═82edfb04-3de0-462b-ab4f-77cdad052bef
# ╠═e8febda3-db2c-4f10-84bd-384c9ddd0ff7
# ╟─f33eb06d-f45b-438c-86a9-26d8f94e7809
# ╠═60e55645-ab59-4ea7-8009-9db7d0aea2e6
# ╟─35f818c2-acee-4d20-9eb3-0c3ae37f3762
# ╠═a0c8660c-3ddb-4795-b3c9-a63cc64c8c00
# ╟─cb3bb128-49d3-4996-84e2-5154e13bbfbd
# ╠═924d11a7-5161-4b13-a1f6-a1a8530736da
# ╟─40381501-952a-48a5-9a28-ee4bf1c65fd4
# ╠═0be6a2d0-f470-436c-bbd7-8bab3635a34d
# ╟─7fad0fc0-1a6a-437a-a1c2-ce2c70d41acf
# ╠═54a92a14-405a-45d1-ad3a-5f42e4ce8789
# ╟─946da67e-5aff-4de9-ba15-715a05264c4d
# ╠═4da9796c-5102-44e7-8af3-dadbdabcce73
# ╟─db4ceb7c-4ded-4048-88db-fd15b3231a5c
# ╟─575d1656-0a0d-40ba-a190-74e36c354e8c
# ╠═fc2351f5-f808-499d-8251-d12c93a2be0e
# ╠═2bd7d41e-f2c9-47cd-8d5b-a2cfef84a830
# ╟─42be3a59-b6bb-49b2-a2ca-73adedc35588
# ╠═f5ecdd06-addb-4913-996b-164e337853c2
# ╟─c14acc67-dbb2-4a86-a811-de857769a472
# ╠═f9a938d8-dce9-4ef0-967e-5b3d5384ca9b
# ╟─38bafb52-14f0-4a42-8e73-de1ada31c87e
# ╠═785a379a-e6aa-4919-9c94-99e277b57844
# ╟─232cd259-5ff4-42d2-8ae1-cb6823114635
# ╠═168aee22-6769-4077-a9da-a27689e6bb32
# ╟─985cd6ec-bd2d-4dd9-bfbe-0bb066036150
# ╠═6acbaed4-6ff3-45be-9b28-595213206218
# ╟─587d98d8-f805-4c4f-bf2f-1887d86adf05
# ╟─ea2e2140-b826-4a05-a84c-6309241da0e7
# ╠═e8c1c746-ce30-4bd9-a10f-c68e3823faac
# ╠═c3bc0c44-b2e9-4e6a-862f-8ab5092459ea
# ╟─e885bbe5-f7ec-4f6a-80fd-d6314179a3cd
# ╠═90bd7f7b-3cc1-43ab-8f78-c1e8339a79bf
# ╟─608a3a98-924f-45ef-aeca-bc5899dd8c7b
# ╠═b83ba8db-b9b3-4921-8a93-cf0733cec7aa
# ╟─cc1e5b9f-c5b4-47c0-b886-369767f6ca4b
# ╠═687b18c3-52ae-48fa-81d6-c41b48edd719
# ╟─dcd6c1f3-ecb8-4a3f-ae4f-3c5b6f8494e7
# ╟─20bcc70f-0c9f-40b6-956a-a286cea393f8
# ╠═97f7a295-5f33-483c-8a63-b74c8f79eef3
