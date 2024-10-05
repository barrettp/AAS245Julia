### A Pluto.jl notebook ###
# v0.19.36

using Markdown
using InteractiveUtils

# ╔═╡ e17b15bd-337d-4809-8b6c-2ed0f3701a9e
using PlutoUI; TableOfContents()

# ╔═╡ d8ff3dd3-e1ea-4f20-8937-8f8f995402fa
using BenchmarkTools # bring in @btime and @benchmark macros

# ╔═╡ d774d485-cfef-4373-9fed-77618ea928de
# Load LoopVectorization
using LoopVectorization

# ╔═╡ 463eab77-8c30-4071-bf84-a1aad685c21e
using FLoops

# ╔═╡ 72cd207c-7a63-4e29-a6d8-110bcf65ecdc
using CUDA

# ╔═╡ e6020e3a-77c7-11ed-2be9-e987cee1edf0
md"""
# Parallel Computing in Julia.

Julia is particularly able to exploit various types of parallelism to accelerate the performance of a program.
In this tutorial, we will overview how to enable parallelism in various Julia programs.
"""

# ╔═╡ fb75265d-b154-4913-8714-ee68959682b4
md"""
Julia has a strong parallel computing infrastructure that enable HPC using vectorization,
threading, distributed computing, and even GPU acceleration.

## Single Processor Parallelism (SIMD)

To get started, we will discuss low-level parallelism related to a single core called
*SIMD* or **Single Instruction Multiple Data**. SIMD is when the computer can apply a
single instruction to multiple data sets in a single instruction cycle. For instance,
suppose we have two vectors of number in Julia `a` and `b`. Then the following graph
compares how a serial instruction v.s. a vectorized instruction would be run on the computer.
"""

# ╔═╡ c23fcdf1-4fd8-4859-abb3-8e08b4476046
md"""
!!! note
	**CPU cycle**: Can be thought of the smallest unit of time on which a CPU behaves.
    In a single CPU cycle, the computer usually does a fetch-decode-execute step. Briefly,
    this means that you can think of the CPU doing a single simpler operation, like
    addition, multiplication, etc.
"""

# ╔═╡ 766c47e4-f8ff-4d5b-868a-d13b52a8a1c1
html"""
<img src="https://github.com/sefffal/AASJuliaWorkshop/blob/main/vectorization.jpeg?raw=true"/>
"""

# ╔═╡ b8e1a548-9c4d-40f1-baf3-c833151e7eba
md"""
While the serial computation loops through each element in the list and applies the
addition operation each CPU clock cycle, the vectorized version realizes that it can
group multiple datasets (array elements) together and perform the same operation.
This can lead to 2x, 4x, or greater speedups depending on the specific CPU architecture
(related to AVX, AVX2, AVX512).

So what does Julia do? Let's start with the simple example above:
"""

# ╔═╡ a1f9058a-9c7f-494e-9b73-f5acc4778604
md"""
!!! note
	Vectorization in this setting is usually different from vectorization in Python/R. In python vectorization refers to placing all your variables in some vector container, like a numpy array, so that the resulting operation is run using a C/Fortran library.
"""

# ╔═╡ 441099b3-4103-4cff-9deb-3c2153d657c6
md"""
```julia
function serial_add!(out, x, y)
	for i in eachindex(x, y)
		out[i] = x[i] + y[i]
	end
	return out
end
```
"""

# ╔═╡ 8c198d15-4367-44e8-9de0-43a468bfbac2


# ╔═╡ cadf8a67-1c1e-4850-9723-ef92196671dd
md"""
!!! note
	Note that we append the function with `!` this is a Julia convention which signals that we are mutating the arguments.
"""

# ╔═╡ 9fede501-3324-4076-a2ff-3b464063e5c9
md"""
First we will allocate some variables for this tutorial
"""

# ╔═╡ 7f5c5849-feef-4581-9356-8146cba48b9e
N = 2^10

# ╔═╡ 799e73d9-4857-466e-b645-8ee15566b03f
x = rand(N)

# ╔═╡ d490a507-4b9d-4077-9eaf-ae4ac3d149a1
y = rand(N)

# ╔═╡ 7be8c14e-e258-4deb-abdf-a042f873465a
out = zero(y)

# ╔═╡ cc00d185-1b7e-40f5-8036-da4132dc0700
md"""
Now let's benchmark our serial add to get a baseline for our performance.

```julia
@benchmark serial_add!($out, $x,  $y)
```
"""

# ╔═╡ 576491d9-0c0c-4740-b73a-165c61ce3fed


# ╔═╡ 34ad1196-a1d7-4118-b4da-426af6826c7d
md"""
Analyzing this on a Ryzen 7950x, it appears that the summation is 53.512 ns, or each
addition takes only 0.05ns! Inverting this number would naively suggest that the computer I am using has a 19 GHz processor!

SIMD is the reason for this performance. Namely Julia's was able to automatically apply its auto-vectorization routines to use SIMD to accelerate the program.

To confirm that Julia was able to vectorize the loop we can use the introspection tool
```julia
@code_llvm serial_all!(out, x, y)
```
"""

# ╔═╡ 7623b88a-ba60-450e-86fb-8890354f7a94


# ╔═╡ a872cf65-a11e-4371-9d4d-41ea92c55369
md"""
This outputs the LLVM IR and represents the final step of Julia's compilation pipeline
before it is converted into native machine code. While the output of `@code_llvm` is
complicated to check that the compiler effectively used SIMD we can look for something
similar to

```
   %wide.load30 = load <4 x double>, <4 x double>* %55, align 8
; └
; ┌ @ float.jl:383 within `+`
   %56 = fadd <4 x double> %wide.load, %wide.load27
```

This means that for each addition clock, we are simultaneously adding four elements of the array together. As a sanity check, this means that I have a 19/4 = 4.8 GHz processor which is roughly in line with the Ryzen 7950x reported speed.

### Vectorizing Julia Code with Packages

Proving that a program can SIMD however can be difficult, and sometimes the compiler
won't effectively auto-vectorize the code. Julia however provides a number of tools that
can help the user to more effectively use SIMD. The most low-level of these libraries
is [`SIMD.jl`](https://github.com/eschnett/SIMD.jl). However,  most users never need to use SIMD.jl directly (for an introduction
see <http://kristofferc.github.io/post/intrinsics/>. Instead most Julia users will use more-upstream packages, such as [`LoopVectorization.jl`](https://github.com/JuliaSIMD/LoopVectorization.jl).

To see `LoopVectorization` in action let's change our above example to the slightly more complicated function.

```julia
function serial_sinadd(out, x, y)
	for i in eachindex(out, x, y)
		out[i] = x[i] + sin(y[i])
	end
	return out
end
```
"""

# ╔═╡ 547df3f2-b2fe-4f22-a0ac-3ba6bdd3171c


# ╔═╡ 57bd871d-06fc-4050-9024-aaaf52297d0a
md"""
Again lets start with a baseline evaluation
```julia
@benchmark serial_sinadd($out, $x, $y)
```
"""

# ╔═╡ f51bd7cb-97fd-4d5e-bcac-a114f19abe7d


# ╔═╡ 566eb7e1-0e2f-4ea7-8770-a6b2c95c1eb4
md"""
Running this example will show that the code is a lot slower than our previous example! Part of this is because `sin` is expensive, however we can also check whether the code was vectorized using the `@code_llvm`.
```julia
@code_llvm serial_sinadd(out, x, y)
```
"""

# ╔═╡ e4e98981-1964-43a3-aa81-4fef27d7f864


# ╔═╡ 7f0ff927-71ea-4ab9-99aa-c4a6655b545c
md"""
Analyzing the output does show that Julia/LLVM was unable to automatically vectorize the expression. The reason for this is complicated and won't be discussed. However, we can fix this with
loop vectorization and its `@turbo` macro

"""

# ╔═╡ ccf102f3-9e85-4f70-b65e-6b4b056cf7e3
md"""
```julia
function serial_sinadd_turbo(out, x, y)
	@turbo for i in eachindex(out, x, y)
		out[i] = x[i] + sin(y[i])
	end
	return out
end
```
"""

# ╔═╡ fb6f9256-e874-418a-b226-83a9173b9ec2


# ╔═╡ 540326cd-5f2c-4b07-8dd6-1c65f63af7d6
md"""
```julia
@benchmark serial_sinadd_turbo($out, $x, $y)
```
"""

# ╔═╡ 1364924b-0cbd-443d-a319-9701708cbd15
md"""
And boom we get large speed increase (factor of 2 on a Ryzen 7950x) by simply adding the `@turbo` macro to our loop.
"""

# ╔═╡ 54d083d4-3bf8-4ed7-95b5-203e13cc3249
md"""
## Threading with Julia

Multi-threading is when a set of processors in Julia share the same Julia runtime and memory.
This means that multiple threads can all write and read from the exact same section of
memory in the computer and can execute code on the memory simultaneously.

To enable threading in julia you need to tell julia the number of threads you want to use.
For instance, start julia with 4 threads do
```bash
> julia -t 4
```
which will start Julia with 4 threads. You can also start Julia with threads on Linux/Mac by
using the environment label `JULIA_NUM_THREADS=4`. If you use `julia -t auto` then Julia will
start with the number of threads available on your machine. Note that `julia -t` required julia version 1.5 or later.

You can check the number of threads julia is using in the repl by typing
```julia
Threads.nthreads()
```
"""

# ╔═╡ c6228b0b-22b8-4e3d-95d2-350987544b85


# ╔═╡ b9e13054-7641-45f1-8cd6-c8565a9f5d1f
md"""
Each Julia thread is tagged with an id that can be found using
```julia
Threads.threadid()
```
which defaults to 1, the master thread.


!!! tip
	This is the number of `Julia` threads not the number of BLAS threads. To set those do
	```julia
	using LinearAlgebra
	BLAS.set_num_threads(8)
	```
	where 8 is the number of threads you want to use.
"""

# ╔═╡ 11f7af26-92d5-4430-bdde-5aad69859f2e


# ╔═╡ d1bae4b3-6455-458b-a00c-f7e8eda201c3
md"""
which defaults to `1` the master thread.
"""

# ╔═╡ 3214e9e9-bcae-43b4-8e07-e8106310cf83
md"""

### Simple threading with `Threads.@threads`

The simplest way to use multi-threading in Julia is to use the `Threads.@threads` macro
which automatically threads loops for you. For instance, we can thread our previous function using:
"""

# ╔═╡ e468d9fd-ead0-4ce4-92b1-cb96132f6921
md"""
```julia
function threaded_add!(out, x, y)
	Threads.@threads for i in eachindex(out, x, y)
		out[i] = x[i] + y[i]
	end
	return out
end
```
"""

# ╔═╡ f9841e19-68ad-411e-88c6-363996b7a95c


# ╔═╡ 478eaa1d-509a-4fba-8b65-cb45561f9157
md"""
And benchmarking:

```julia
@benchmark threaded_add!($out, $x, $y)
```
"""

# ╔═╡ 14b676f0-b3b3-41a0-8f08-80b4fae29ec3


# ╔═╡ c815af66-cb82-4dd0-a4b8-3c9cb4a8d9f2
md"""
This is actually slower than what we previously got without threading! This is because
threading has significant overhead! For simple computations, like adding two small vectors the overhead from threading dominates over any benefit you gain from using multiple threads.

In order to gain a benefit from threading our operation needs to:

1. Be expensive enough that the threading overhead is relatively minor
2. Be applied to a large enough vector to limit the threading overhead.

To see the benefit of threading we can then simply increase the number of operations
"""

# ╔═╡ 5852589e-388c-43bf-9ff5-da46af141680
xlarge = rand(2^20)

# ╔═╡ 69ada451-8806-4398-933a-e02efb28deea
ylarge = rand(2^20)

# ╔═╡ 8ebab57a-d4e5-4d50-8c5b-a95ed51487c9
outlarge = rand(2^20)

# ╔═╡ c06da2eb-ed9f-4986-854c-9b8d830e662b
md"""
Get the baseline again
```julia
@benchmark serial_add!($outlarge, $xlarge,  $ylarge)
```
"""

# ╔═╡ 54b2e366-f409-4603-a57a-b711202c4887


# ╔═╡ 07eddd9c-c53f-49e7-9d61-2f5d54711a1c
md"""
Now test the threading example
```julia
@benchmark threaded_add!($outlarge, $xlarge,  $ylarge)
```
"""

# ╔═╡ b5666e45-dcf6-4ea8-9e83-7609f2091f83


# ╔═╡ 45639208-ec9f-4aef-adb0-7a2c4467353a
md"""
Now, we are starting to see the benefits of threading for large enough vectors.
To determine whether threading is useful, a user should benchmark the code. Additionally, memory bandwidth limitations are often important and so multi-threaded code should also do as few allocations as possible.

### Low-Level Multi-Theading
"""

# ╔═╡ bd78505c-904c-4e65-9160-6b3ebf02c21e
md"""
There are additional considerations to keep in mind when multi-threading. An important one is that Julia's Base threading utilities are rather low-level and do not guarantee threading safety, e.g., to be free of **race-conditions**. To see this, let's consider a simple map and sum function.

```julia
function apply_sum(f, x)
	s = zero(eltype(x))
	for i in eachindex(x)
		@inbounds s += f(x[i])
	end
	return s
end
```
"""

# ╔═╡ 1ee1af8c-191c-4677-84fc-2cdeac39607c


# ╔═╡ 32068e63-5ad5-4d0d-bee6-205597db610b
md"""
Now apply this to our large vector
```julia
apply_sum(x->exp(-x), xlarge)
```
"""

# ╔═╡ d7ad4f01-2f7e-4dcc-8e32-88ebbf807a06


# ╔═╡ 5c5ce94e-1411-4b26-af48-2cd836b0857c
md"""
A naive threaded implementation of this would be to just prepend the for-loop with the @threads macro

```julia
function naive_threaded_apply_sum(f, x)
	s = zero(eltype(x))
	Threads.@threads for i in eachindex(x)
		@inbounds s += f(x[i])
	end
	return s
end
```
"""

# ╔═╡ df637f5c-d702-4e7d-81f5-cbefac75c13b


# ╔═╡ f4602617-c87b-4ce9-bbd0-7d3715b5c7e1
md"""
```julia
naive_threaded_apply_sum(x->exp(-x), xlarge)
```
"""

# ╔═╡ bd6bd1e9-66bf-421d-bb7b-4be4528a2701


# ╔═╡ 2a9f6170-b3d6-4fbb-ba48-2f82098b3849
md"""
We see that the naive threaded version gives the incorrect answer. This is because we have multiple threads writing to the same location in memory resulting in a race condition. If we run this block multiple times (**try this**) you will get different answers depending on the essentially random order that each thread writes to `s`.

To fix this issue there are two solutions. The first is to create a separate variable that holds the sum for each thread
"""

# ╔═╡ 0fbce4a6-0a0c-4251-be50-c13add4c4768
md"""
```julia
function threaded_sol1_apply_sum(f, x)
	partial = zeros(eltype(x), Threads.nthreads())
	# Do a partial reduction on each thread
	Threads.@threads for i in eachindex(x)
		id = Threads.threadid()
		@inbounds partial[id] += f(x[i])
	end
	# Now group everything together
	return sum(partial)
end
```
"""

# ╔═╡ 1f3b66c5-2845-4f3f-befd-e7e94243368c


# ╔═╡ 74ff761d-b1e4-4468-8f24-77fb84bda8ac
md"""
```julia
threaded_sol1_apply_sum(x->exp(-x), xlarge)
```
"""

# ╔═╡ 73097493-1abe-4c6e-9965-9dde6c97611e
md"""
Which now gives the correct answer.
"""

# ╔═╡ aad7b000-7f4b-4901-8513-078eae85ca67
md"""
The other solution is to use Atomics. Atomics are special types that do the tracking in `threaded_sol1_apply_sum` for you. The benefit of this approach is that functionally the program looks very similar
"""

# ╔═╡ 2969c283-4105-4c25-ae39-9e169c195f00
md"""
```julia
function threaded_atomic_apply_sum(f, x)
	s = Threads.Atomic{eltype(x)}(zero(eltype(x)))
	Threads.@threads for i in eachindex(x)
		Threads.atomic_add!(s, f(x[i]))
	end
	# Access the atomic element and return it
	return s[]
end
```
"""

# ╔═╡ c037381a-8b6e-4bfa-b39a-e8c6ed264f71


# ╔═╡ 21de2f77-b5ed-4b62-94e3-ca6e22a80e43
md"""
```julia
threaded_atomic_apply_sum(x->exp(-x), xlarge)
```
"""

# ╔═╡ cc4990eb-74f3-4b57-9b1d-0689fb2f6604


# ╔═╡ 79222f00-3d55-4914-9d9d-b3c7b1ed6c69
md"""
Both approaches gives the same answer, however let's benchmark both solutions:

```julia
@benchmark threaded_sol1_atomic_apply_sum($(x->exp(-x)), $xlarge)
```
"""

# ╔═╡ 6b496229-98bf-4312-9faf-f22aae633843


# ╔═╡ 4768f5c4-b37b-4667-9b42-d0352c8b5dde
md"""
```julia
@benchmark threaded_atomic_apply_sum($(x->exp(-x)), $xlarge)
```
"""

# ╔═╡ f82d29b5-4d18-4c66-9703-9445b205d1ff


# ╔═╡ dfa50bc7-2250-4326-b7a6-724a975c4928
md"""
The atomic solution is substantially slower than the manual solution. In fact, atomics should only be used if absolutely necessary. Otherwise the programmer should try to find a more manual solution.

### Using Higher-Level Threading Packages

In general multi-threading programming can be quite difficult and error prone. Luckily there are a number of packages in Julia that can make this much simpler. The [`JuliaFolds`](https://github.com/JuliaFolds) ecosystem has a large number of packages, for instance, the [`FLoops.jl`](https://github.com/JuliaFolds/FLoops.jl). FLoops.jl provides two macros that enable a simple for-loop to be used for a variety of different execution mechanisms. For instance, every previous version of apply_sum can be written as
"""

# ╔═╡ c8b7983f-295d-4ca4-9810-e0f130c5e92c
md"""
```julia
function floops_apply_sum(f, x; executor=ThreadedEx())
	s = zero(eltype(x))
	@floop for i in eachindex(x)
		@reduce s += f(x[i])
	end
	return s
end
```
"""

# ╔═╡ 7912e780-59cd-46d6-8a3a-a1eb47b6f9cf


# ╔═╡ a14e0cb2-42b5-41ea-a2f3-83a725baf38c
md"""
Pay special attention to the additional `executor` keyword argument. FLoops.jl provides a number of executors:
 - `SequentialEx` runs the for-loop serially (similar to `apply_sum`)
 - `ThreadedEx` runs the for-loop using threading, while avoiding data-races (similar to `threaded_sol1_apply_sum`)
 - `CUDAEx` runs the for-loop vectorized on the GPU using CUDA.jl. (this is experimental)
 - `DistributedEx` runs the for-loop using Julia's distributed computing infrastruture (see below).

We can then easily run both threaded and serial versions of the algorithm by just changing the `executor`
"""

# ╔═╡ 44ddfdd9-7898-4561-b46a-045bcc1ae467
md"""
```julia
floops_apply_sum(x->exp(-x), xlarge; executor=SerialEx())
```
"""

# ╔═╡ 256ca1f5-403f-4eb3-8422-19724fa95526


# ╔═╡ 872a2066-8c51-4597-89e8-5a902f40c2cc
md"""
```julia
floops_apply_sum(x->exp(-x), xlarge; executor=ThreadedEx())
```
"""

# ╔═╡ 23cf56d9-b53e-4be6-8dae-a6ebb8e0f6a4


# ╔═╡ df842625-04af-43d0-b802-3e4a9841c172
md"""
Benchmarking the `Floops` version

```julia
@benchmark floops_apply_sum($(x->exp(-x)), $xlarge; executor=ThreadedEx())
```
"""

# ╔═╡ 4f23d7c3-6d85-4d03-8d05-dd0719ebcbe3


# ╔═╡ 529f73c3-b8ba-4b4b-bab1-7aa84c2a3a29
md"""
is almost as fast as our hand-written example, but requires less understanding of race-conditions in threading.
"""

# ╔═╡ e7163af8-3534-44fc-8e8f-ef1c692c972e
md"""
## GPU Acceleration

### Introduction

GPUs are in some sense, opposite to CPUs. The typical CPU is characterized by a small
number of very fast processors. On the other hand, a GPU has thousands of very slow processors.
This dichotomy directly relates to the types of problems that are fast on a GPU compared to a CPU.

To get started with GPUs in Julia you need to load the correct package one of

1. [CUDA.jl](https://github.com/JuliaGPU/CUDA.jl): NVIDIA GPUs, and the most stable GPU package
2. [AMDGPU.jl](https://github.com/JuliaGPU/AMDGPU.jl): AMD GPUs, actively developed but not as mature as CUDA; only works on linux due to ROCm support
3. [oneAPI.jl](https://github.com/JuliaGPU/oneAPI.jl): Intel GPUs, currently under active development so it may have bugs; only works on linux currently.
4. [Metal.jl](https://github.com/JuliaGPU/Metal.jl): Mac GPUs. Work in progress. Expect bugs and it is open to pull-requests.

For this tutorial I will be using mostly be using the CUDA library. However, we will try to include code for other GPUs as well.


### Getting Started with GPU computing

CUDA.jl provides a complete suite of GPU tools in Julia from low-level kernel writing to
high-level array operations. Most of the time a user just needs to use the high-level array
interface which uses Julia's built-in broadcasting. For instance we can port our simple
addition example above to the GPU by first moving the data to the GPU and using Julia's CUDA.jl broadcast interface.
"""

# ╔═╡ 9d9d3fff-37d8-4773-816f-411fb79679f5
md"""
```julia
# For AMD
using AMDGPU
# For intel (linux only)
using oneAPI
# For M1 Mac
using Metal
```
"""

# ╔═╡ 799de936-6c6d-402f-93db-771e7ec1ef51
md"""
Now let's load our array onto the GPU

For CUDA:
```julia
begin
	xlarge_gpu   = cu(xlarge)
	ylarge_gpu   = cu(ylarge)
	outlarge_gpu = cu(outlarge)
end
```

For other GPU providers replace `cu` with 
```julia
# AMD
ROCArray(xlarge)
# Intel
oneArray(xlarge)
# M1 Mac
MtlArray(xlarge)
```
"""

# ╔═╡ 5215d6a5-5823-4d3b-9086-ebd975d4393b


# ╔═╡ 0116005e-c436-4dad-89bd-47260cfa706f
md"""
For CUDA.jl the `cu` function take an array and creates a `CuArray` which is a copy of the
array that lives in the GPU memory. For the other GPUs the story is very similar and just the array type changes. Below we will mention some potential performance
pitfalls that can occur due to this memory movement.

`cu` will tend to work on many Array types in Julia. However, if you have a
more complicated variable such as a `struct` then you will need to tell Julia how to move
the data to the GPU. To see how to do this see <https://cuda.juliagpu.org/stable/tutorials/custom_structs/>

Given these GPU array objects, our `serial_add!` function could be written as
"""

# ╔═╡ 0218d82e-35b4-4109-bbc8-b1d51c97ab6f
md"""
```julia
function bcast_add!(out, x, y)
	out .= x .+ y
	return out
end
```
"""

# ╔═╡ d7fdf09a-3c59-4dba-b089-ae6033b57809


# ╔═╡ 891a9803-7fd0-4a83-95ab-58b9bd44f8f2
md"""
!!! note
	Pay special attention to the `.=`. This ensures that not intermediate array is created on the GPU.
"""

# ╔═╡ 7ce8025e-16be-47e0-988d-85947cc4e359
md"""
Running this on the gpu is then as simple as
```julia
@benchmark bcast_add!($outlarge_gpu, $xlarge_gpu, $ylarge_gpu)
```

!!! note 
	This will work with any of the GPU packages mentioned above!
"""

# ╔═╡ 6b34f668-25d1-4c9b-8c1a-d08fcdc5dea0


# ╔═╡ 2020675b-859b-4939-9f8d-138995ce1d18
md"""
However, at this point you may notice something. Nowhere in our algorithm did we specify
that this kernel is actually running on the GPU. In fact we could use the exact same function
using our CPU verions of the arrays
"""

# ╔═╡ 147bbd17-abf6-465f-abd0-895cb742f896
md"""
```julia
@benchmark bcast_add!($outlarge, $xlarge, $ylarge)
```
"""

# ╔═╡ 1e88e7c1-f239-4da1-8af8-4f629ef86cb7


# ╔═╡ ccf924ae-fada-4635-af68-ab1fb612a5bc
md"""
This reflects more general advice in Julia. Programs should be written generically. Julia's
dot syntax `.` has been written to be highly generic, so functions should more generally be
written using it than with generic loops, unless speed due to SIMD as with LoopVectorization,
or multi-threading is required. This programming style has been codified in
the [`SciMLStyle coding guide`](https://github.com/SciML/SciMLStyle).
"""

# ╔═╡ 144bb14e-861a-4665-8b50-513b0f463546
md"""
Similarly our more complicated function `serial_sinadd!` could also be written as:
"""

# ╔═╡ 13085fcb-75db-41ec-b8ad-b509798037d7
md"""
```julia
outlarge_gpu .= xlarge_gpu .+ sin.(ylarge_gpu)
```
"""

# ╔═╡ 751950c0-ccae-4316-91cf-089ddaae95ad


# ╔═╡ 4c7383d8-c7ac-48c0-814d-abc7cfc7c447
md"""
### Writing Custom Kernels

While Julia's array base GPU programming is extremely powerful, sometimes we have to use
something more low-level. For instance, suppose our function accesses specific elements of
a GPU array (e.g., CuArray) that isn't handled through the usual linear algebra of broadcast interface.

In this case when we try to index into a `CuArray` we get a `Scalar Indexing` error
"""

# ╔═╡ 175e02af-6762-474f-a728-e77a2f6fa771
md"""
```julia
xlarge_gpu[1]
```
"""

# ╔═╡ d3e64cea-3b29-4d8b-8ee1-1353674c1d89


# ╔═╡ e4ca8a18-1bc9-4730-95ae-d2a1edc30114
md"""
Analyzing the error message tells us what is happening. When accessing a single element,
the CuArray will first copy the entire array to the CPU and then access the element.
This is incredibly slow! So how to we deal with this?

The first approach is to see if you can rewrite the function so that you can make use of
the GPU broadcasting interface. If this is impossible, you will need to write a custom kernel.

To do this, let's adapt our simple example to demonstrate the general approach to writing CUDA kernels
"""

# ╔═╡ bebb0e97-cfb3-46ac-80aa-2ada3159e4f5
md"""

For CUDA and AMD
```julia
function gpu_kernel_all!(out, x, y)
    index = (blockIdx().x - 1) * blockDim().x + threadIdx().x
    stride = gridDim().x * blockDim().x
	for i in index:stride:length(out)
		out[i] = x[i] + y[i]
	end
	return nothing
end
```

For Mac
```julia
function gpu_kernel_all!(out, x, y)
	i = thread_position_in_grid_1d()
	out[i] = x[i] + y[i]
	return nothing
end
```
"""

# ╔═╡ 759be8ef-7136-4330-abfe-0ffd212883d3


# ╔═╡ 6b40113f-5017-4530-9d76-fadeab58973c
md"""
This creates the kernel function. This looks almost identical to our `serial_add` function except for the `threadIDx` and `blockDim` calls. These arguments relate to how the GPU vectorizes the operation across all of its threads. For an introduction to these see the `CUDA.jl` [introduction](https://cuda.juliagpu.org/stable/tutorials/introduction/). Now to run the CUDA kernel we can compile our function to a native CUDA kernel using the `@cuda` macro.
"""

# ╔═╡ a5688604-240e-4d5d-8252-672fc789cd05
md"""
```julia
# Compile the CUDA kernel and run it
CUDA.@sync @cuda threads=256 gpu_kernel_all!(outlarge_gpu, xlarge_gpu, ylarge_gpu)
```
"""

# ╔═╡ e1964067-d3e7-4903-a17d-0606a6bc281e
md"""
For AMD we use the `@roc` macro
```julia
wait(@roc groupsize=256 gpu_kernel_all!(outlarge_gpu, xlarge_gpu, ylarge_gpu))
```

For M1 Mac we use the `@metal` macro
```julia
@metal threads=length(outlarge) gpu_kernel_all!(outlarge_gpu, xlarge_gpu, ylarge_gpu)
```
"""

# ╔═╡ d895744d-888d-45ff-a7e5-8865be535194


# ╔═╡ 8ff25eb9-a32f-410f-a430-d123c2f3c884
md"""
!!! note
	Due to the nature of GPU programming we need to specify the number of threads to run the kernel on. Here we use 256 as a default value. However, this is not optimal and the `CUDA.jl` documentation provides additional advice on how to optimize these parameters
"""

# ╔═╡ c6436555-0cb9-4738-af64-8d3fbd1c07c0
md"""
Finally, to get our result from the GPU we then just use the `Array` constructor
```julia
Array(outlarge_gpu)
```
"""

# ╔═╡ 3f4daf38-704e-41b0-94f1-d10043d8fb5b


# ╔═╡ 32d560e6-c5de-4740-81ba-dccc717d9677
md"""
And there you go, you just wrote your first native CUDA kernel within Julia! Unlike other programming languages, we can use native Julia code to write our own CUDA kernels and do not have to go to a lower-level language like C.
"""

# ╔═╡ 6be7f9a4-7c80-4c2b-8dfb-080609f716e8
md"""
### GPU caveats

#### Dynamic Control Flow
GPUs, in general, are more similar to SIMD than any other style of parallelism mentioned in
this tutorial. That is, GPUs follow the **Single Program Multiple Data** paradigm. What this
means is that GPUs will experience the fastest programming when the exact same program will
be run across all the processors on the system. In practice it means that a program with control flow such as

```julia
if a > 1
	# Do something
else
	# Do something else
```

will potentially be slow. The reason is that, in this case, the GPU will actually compute
both branches at run-time and then select the correct value. Therefore, GPU programs should
generally try to limit this kind of dynamic control flow. You may have noticed this when
using JAX. JAX tries to restrict the user to static computation graphs
(no dynamic control flow) as much as possible for this exact reason. GPUs are not good with
dynamical control flow.

#### GPU memory
Another important consideration is the time it takes to move memory on and off of the GPU.
To see how long this takes let's benchmark the cu function which move memory from the CPU to the GPU.
"""

# ╔═╡ 56a8891c-8993-43f9-bfff-81b520b10b88
md"""
```julia
@benchmark cu($xlarge)
```

!!! tip
	Replace `cu` with the correct GPU array call for your specific provider
"""

# ╔═╡ 3522798d-7e38-4db6-91b6-474e5d8d9119


# ╔═╡ 619ff9da-9562-4bd9-be89-69482091cdba
md"""
Similarly we can benchmark the time it takes to transform from the GPU to the CPU.

```julia
@benchmark Array($outlarge_gpu)
```
"""

# ╔═╡ d9a844e5-de7b-4266-85ea-01f27f2932c2


# ╔═╡ 8d6d2117-3513-470f-87e1-8f00dd340172
md"""
In both cases, we see that the just data transfer takes substantially longer than the computation
on the GPU! This is a general "feature" of GPU programming. Managing the data transfer
between the CPU and GPU is critical for performance. In general, when using the GPU you should aim
for as much of the computation to be performed on the GPU as possible. A good rule of thumb is
that if the computation on the CPU takes more than 1 ms, then moving it to the GPU will probably have some benefit.
"""

# ╔═╡ b2eb604f-9180-4e48-9ae5-04162583fb33
md"""

## Distributed Computing (Switch to the REPL here)

Distributed computing differs from all other parallelization strategies we have used.
Distributed computing is when multiple independent processes are used together for computation.
That is, unlike multi-threading, where each process lives in the Julia session, distributed
computing links multiple **separate** Julia sessions together.

As a result, each processor needs to communicate with the other processors
through message passing, i.e., sending data (usually through a network connection) from
one process to the other. The downside of this approach is that this communication
entails additional overhead compared to the other parallelization strategies we mentioned
previously. The upside is that you can link arbitrarily large numbers of processors and
processor memory together to parallelize the computation.

Julia has a number of different distributed computing facilities, but we will focus on Distributed.jl
the one supported in the standard library [`Distributed.jl`](https://tdocs.julialang.org/en/v1/manual/distributed-computing/).

### Distributed.jl (Manager-Worker parallelism)

Distributed's multiprocessing uses the **manager-worker** paradigm. This is where the programmer
controls the manager directly and then it assigns tasks to the rest of the workers.
To start multiprocessing with Julia, there are two options

1. `julia -p 3` will start julia with 3 workers (4 processes in total). This will also automatically bring the Distributed library into scope
2. Is to manually add Julia processors in the repl. To do this in a fresh Julia session,

we do

````julia
using Distributed
addprocs(3)
````

!!! note
    On HPC systems, you can also use [`ClusterManagers.jl`] (https://github.com/JuliaParallel/ClusterManagers.jl)
    to setup a distributed environment using different job queue systems, such as Slurm and SGE.

This add 3 worker processors to the Julia process. To check the id's of the workers we
can use the `workers` function

````julia
workers()
````

We see that there are three workers with id's 2, 3, 4. The manager worker is always given the first id `1` and corresponds to the current Julia session. To see this we can use the `myid()` function

````julia
myid()
````

To start a process on a separate worker process, we can use the `remotecall` function

````julia
f = remotecall(rand, 2, 4, 4)
````

The first argument is the function we wish to call on the worker, the second argument is the id of the worker, and the rest of the arguments are passed to the function.
One thing to notice is that `remotecall` doesn't return the actual result of the computation. Instead `remotecall` returns a `Future`. This is because we don't necessarily need to return the result of the computation to the manager processor, which would induce additional communication costs. However, to get the value of the computation you can use the `fetch` function

````julia
fetch(f)
````

`remotecall` is typically considered a low-level function. Typically a user will use the
`@spawnat` macro

````julia
f2 = @spawnat :any rand(4, 4)
````

This call does the same thing as the `remotecall` function above but the first argument is the worker id which we
set to any to let Julia itself decide which processor to run it on.

### Loading modules on a Distributed system
Since Julia uses a manager-worker workflow, we need to manually ensure that every process has access to all the required data. For instance, suppose we wanted to compute the mean of a vector. Typically, we would do

````julia
using Statistics
mean(rand(1000))
````

Now if we try to run this on processor 2 we get

````julia
fetch(@spawnat 2 mean(rand(1000)))
````

I.E., the function `mean` is not defined on worker 2. This is because
`using Statistics` only brought Statistics into the scope of the manager process. If we
want to load this package on worker 2 we then need to run

````julia
fetch(@spawnat 2 eval(:(using Statistics)))
````

Rerunning the above example gives the expected result

````julia
fetch(@spawnat 2 mean(rand(1000)))
````

Now calling this in every process could potentially be annoying. To simplify this Julia
provides the `@everywhere` macro

````julia
@everywhere using Statistics
````
which loads the module Statistics on every Julia worker and manager processor.

### Distributed computation
While remotecall and `spawnat` provide granular control of multi-processor parallelism often
we are interested in loop or map-reduce based parallelism. For instance, suppose we consider
our previous map or `apply_sum` function. We can easily turn this into a distributed program
using the `@distributed` macro

````julia
function distributed_apply_sum(f, x)
    @distributed (+) for i in eachindex(x)
        f(x[i])
    end
end
d = randn(1_000_000)
using BenchmarkTools
@benchmark distributed_apply_sum($(x->exp(-x)), $d)
````

!!! note
    We did not have to define

One important thing to note is that the distributed macro uses Julia's static scheduler. This means that the for loop is automatically split evenly among all workers. For the above calculation this make sense since `f` is a cheap variable. However, suppose that `f` is extremely expensive and its run time varies greatly depending on its argument. A trivial example of this would be

````julia
@everywhere function dynamic_f(x)
    if abs(x) < 1
        return x
    else
        sleep(5)
        return 2*x
    end
end
````

In this case, rather than equally splitting the run-time across all processes, it makes sense to assign work to processors as they finish their current task. This is known as a **dynamic scheduler** and is provided in julia by `pmap`

````julia
x = randn(10)
@time out = pmap(dynamic_f, x)
````

which is 2x faster than using the usual distributed function

````julia
@time out = distributed_apply_sum(dynamic_f, x)
````

However, for cheaper operations

````julia
@btime out = sum(pmap(exp, x))
@btime out = distributed_apply_sum(exp, d)
````

we find that `@distributed` is faster since it has less communication overhead. Therefore, the general recommendation is to use `@distributed` when reducing over cheap and consistent function, and to use `pmap` when the function is expensive.

## Conclusion

In this tutorial we have shown how Julia provides an extensive library of parallel computing facilities. From single-core SIMD, to multi-threading, GPU computing, and distributed computation. Each of these can be used independently or together.

In addition to the packages used in this tutorial, there are several other
potential parallel processing packages in the Julia ecosystem. Some of these are:

- [`Dagger.jl`](https://github.com/JuliaParallel/Dagger.jl): Similar to the python dask package that represents parallel computation using a directed acylic graph or DAG. This is built on Distributed and is useful for a more functional approach to parallel programming. It is more common in data science applications
- [`MPI.jl`](https://github.com/JuliaParallel/MPI.jl): The Julia bindings to the MPI standard. The standard parallel workhorse in HPC.
- [`Elemental.jl`](https://github.com/JuliaParallel/Elemental.jl) links to the C++ distributed linear algebra and optimization package.
- [`DistributedArrays.jl`](https://github.com/JuliaParallel/DistributedArrays.jl)

"""

# ╔═╡ Cell order:
# ╟─e17b15bd-337d-4809-8b6c-2ed0f3701a9e
# ╟─e6020e3a-77c7-11ed-2be9-e987cee1edf0
# ╟─fb75265d-b154-4913-8714-ee68959682b4
# ╟─c23fcdf1-4fd8-4859-abb3-8e08b4476046
# ╟─766c47e4-f8ff-4d5b-868a-d13b52a8a1c1
# ╟─b8e1a548-9c4d-40f1-baf3-c833151e7eba
# ╟─a1f9058a-9c7f-494e-9b73-f5acc4778604
# ╟─441099b3-4103-4cff-9deb-3c2153d657c6
# ╠═8c198d15-4367-44e8-9de0-43a468bfbac2
# ╟─cadf8a67-1c1e-4850-9723-ef92196671dd
# ╟─9fede501-3324-4076-a2ff-3b464063e5c9
# ╠═7f5c5849-feef-4581-9356-8146cba48b9e
# ╠═799e73d9-4857-466e-b645-8ee15566b03f
# ╠═d490a507-4b9d-4077-9eaf-ae4ac3d149a1
# ╠═7be8c14e-e258-4deb-abdf-a042f873465a
# ╠═d8ff3dd3-e1ea-4f20-8937-8f8f995402fa
# ╟─cc00d185-1b7e-40f5-8036-da4132dc0700
# ╠═576491d9-0c0c-4740-b73a-165c61ce3fed
# ╟─34ad1196-a1d7-4118-b4da-426af6826c7d
# ╠═7623b88a-ba60-450e-86fb-8890354f7a94
# ╟─a872cf65-a11e-4371-9d4d-41ea92c55369
# ╠═547df3f2-b2fe-4f22-a0ac-3ba6bdd3171c
# ╟─57bd871d-06fc-4050-9024-aaaf52297d0a
# ╠═f51bd7cb-97fd-4d5e-bcac-a114f19abe7d
# ╟─566eb7e1-0e2f-4ea7-8770-a6b2c95c1eb4
# ╠═e4e98981-1964-43a3-aa81-4fef27d7f864
# ╟─7f0ff927-71ea-4ab9-99aa-c4a6655b545c
# ╠═d774d485-cfef-4373-9fed-77618ea928de
# ╟─ccf102f3-9e85-4f70-b65e-6b4b056cf7e3
# ╠═fb6f9256-e874-418a-b226-83a9173b9ec2
# ╟─540326cd-5f2c-4b07-8dd6-1c65f63af7d6
# ╟─1364924b-0cbd-443d-a319-9701708cbd15
# ╟─54d083d4-3bf8-4ed7-95b5-203e13cc3249
# ╠═c6228b0b-22b8-4e3d-95d2-350987544b85
# ╟─b9e13054-7641-45f1-8cd6-c8565a9f5d1f
# ╠═11f7af26-92d5-4430-bdde-5aad69859f2e
# ╟─d1bae4b3-6455-458b-a00c-f7e8eda201c3
# ╟─3214e9e9-bcae-43b4-8e07-e8106310cf83
# ╟─e468d9fd-ead0-4ce4-92b1-cb96132f6921
# ╠═f9841e19-68ad-411e-88c6-363996b7a95c
# ╟─478eaa1d-509a-4fba-8b65-cb45561f9157
# ╠═14b676f0-b3b3-41a0-8f08-80b4fae29ec3
# ╟─c815af66-cb82-4dd0-a4b8-3c9cb4a8d9f2
# ╠═5852589e-388c-43bf-9ff5-da46af141680
# ╠═69ada451-8806-4398-933a-e02efb28deea
# ╠═8ebab57a-d4e5-4d50-8c5b-a95ed51487c9
# ╟─c06da2eb-ed9f-4986-854c-9b8d830e662b
# ╠═54b2e366-f409-4603-a57a-b711202c4887
# ╟─07eddd9c-c53f-49e7-9d61-2f5d54711a1c
# ╠═b5666e45-dcf6-4ea8-9e83-7609f2091f83
# ╟─45639208-ec9f-4aef-adb0-7a2c4467353a
# ╟─bd78505c-904c-4e65-9160-6b3ebf02c21e
# ╠═1ee1af8c-191c-4677-84fc-2cdeac39607c
# ╟─32068e63-5ad5-4d0d-bee6-205597db610b
# ╠═d7ad4f01-2f7e-4dcc-8e32-88ebbf807a06
# ╟─5c5ce94e-1411-4b26-af48-2cd836b0857c
# ╠═df637f5c-d702-4e7d-81f5-cbefac75c13b
# ╟─f4602617-c87b-4ce9-bbd0-7d3715b5c7e1
# ╠═bd6bd1e9-66bf-421d-bb7b-4be4528a2701
# ╟─2a9f6170-b3d6-4fbb-ba48-2f82098b3849
# ╟─0fbce4a6-0a0c-4251-be50-c13add4c4768
# ╠═1f3b66c5-2845-4f3f-befd-e7e94243368c
# ╟─74ff761d-b1e4-4468-8f24-77fb84bda8ac
# ╟─73097493-1abe-4c6e-9965-9dde6c97611e
# ╟─aad7b000-7f4b-4901-8513-078eae85ca67
# ╟─2969c283-4105-4c25-ae39-9e169c195f00
# ╠═c037381a-8b6e-4bfa-b39a-e8c6ed264f71
# ╟─21de2f77-b5ed-4b62-94e3-ca6e22a80e43
# ╠═cc4990eb-74f3-4b57-9b1d-0689fb2f6604
# ╟─79222f00-3d55-4914-9d9d-b3c7b1ed6c69
# ╠═6b496229-98bf-4312-9faf-f22aae633843
# ╟─4768f5c4-b37b-4667-9b42-d0352c8b5dde
# ╠═f82d29b5-4d18-4c66-9703-9445b205d1ff
# ╟─dfa50bc7-2250-4326-b7a6-724a975c4928
# ╠═463eab77-8c30-4071-bf84-a1aad685c21e
# ╟─c8b7983f-295d-4ca4-9810-e0f130c5e92c
# ╠═7912e780-59cd-46d6-8a3a-a1eb47b6f9cf
# ╟─a14e0cb2-42b5-41ea-a2f3-83a725baf38c
# ╟─44ddfdd9-7898-4561-b46a-045bcc1ae467
# ╠═256ca1f5-403f-4eb3-8422-19724fa95526
# ╟─872a2066-8c51-4597-89e8-5a902f40c2cc
# ╠═23cf56d9-b53e-4be6-8dae-a6ebb8e0f6a4
# ╟─df842625-04af-43d0-b802-3e4a9841c172
# ╠═4f23d7c3-6d85-4d03-8d05-dd0719ebcbe3
# ╟─529f73c3-b8ba-4b4b-bab1-7aa84c2a3a29
# ╟─e7163af8-3534-44fc-8e8f-ef1c692c972e
# ╟─9d9d3fff-37d8-4773-816f-411fb79679f5
# ╠═72cd207c-7a63-4e29-a6d8-110bcf65ecdc
# ╟─799de936-6c6d-402f-93db-771e7ec1ef51
# ╠═5215d6a5-5823-4d3b-9086-ebd975d4393b
# ╟─0116005e-c436-4dad-89bd-47260cfa706f
# ╟─0218d82e-35b4-4109-bbc8-b1d51c97ab6f
# ╠═d7fdf09a-3c59-4dba-b089-ae6033b57809
# ╟─891a9803-7fd0-4a83-95ab-58b9bd44f8f2
# ╟─7ce8025e-16be-47e0-988d-85947cc4e359
# ╠═6b34f668-25d1-4c9b-8c1a-d08fcdc5dea0
# ╟─2020675b-859b-4939-9f8d-138995ce1d18
# ╟─147bbd17-abf6-465f-abd0-895cb742f896
# ╠═1e88e7c1-f239-4da1-8af8-4f629ef86cb7
# ╟─ccf924ae-fada-4635-af68-ab1fb612a5bc
# ╟─144bb14e-861a-4665-8b50-513b0f463546
# ╟─13085fcb-75db-41ec-b8ad-b509798037d7
# ╠═751950c0-ccae-4316-91cf-089ddaae95ad
# ╟─4c7383d8-c7ac-48c0-814d-abc7cfc7c447
# ╟─175e02af-6762-474f-a728-e77a2f6fa771
# ╠═d3e64cea-3b29-4d8b-8ee1-1353674c1d89
# ╟─e4ca8a18-1bc9-4730-95ae-d2a1edc30114
# ╟─bebb0e97-cfb3-46ac-80aa-2ada3159e4f5
# ╠═759be8ef-7136-4330-abfe-0ffd212883d3
# ╟─6b40113f-5017-4530-9d76-fadeab58973c
# ╟─a5688604-240e-4d5d-8252-672fc789cd05
# ╟─e1964067-d3e7-4903-a17d-0606a6bc281e
# ╠═d895744d-888d-45ff-a7e5-8865be535194
# ╟─8ff25eb9-a32f-410f-a430-d123c2f3c884
# ╟─c6436555-0cb9-4738-af64-8d3fbd1c07c0
# ╠═3f4daf38-704e-41b0-94f1-d10043d8fb5b
# ╟─32d560e6-c5de-4740-81ba-dccc717d9677
# ╟─6be7f9a4-7c80-4c2b-8dfb-080609f716e8
# ╟─56a8891c-8993-43f9-bfff-81b520b10b88
# ╠═3522798d-7e38-4db6-91b6-474e5d8d9119
# ╟─619ff9da-9562-4bd9-be89-69482091cdba
# ╠═d9a844e5-de7b-4266-85ea-01f27f2932c2
# ╟─8d6d2117-3513-470f-87e1-8f00dd340172
# ╟─b2eb604f-9180-4e48-9ae5-04162583fb33
