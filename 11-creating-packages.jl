### A Pluto.jl notebook ###
# v0.20.3

using Markdown
using InteractiveUtils

# ╔═╡ 1f443df9-619d-40c7-9e08-497ae1a08b5d
import Pkg; Pkg.activate(Base.current_project(), io=devnull)

# ╔═╡ cfebe185-8871-4fe5-ac55-20c7803a0457
using PlutoUI; TableOfContents()

# ╔═╡ 2b2adba9-fc0d-4f59-95a5-8d14d1c067f4
md"""
In this section, we will discuss Julia modules, environments, and packages. This may be confusing at first, since in Python all three are combined into a single concept.
"""

# ╔═╡ 35e08843-8dde-495c-ab4f-bbb43ed75395
md"""
# Julia Modules

A module in Julia is a way to group a set of variables, types, and functions into a namespace. We've already used lots of modules in this workshop.

A module is created using a `module` block like this one:

```julia
module MyModA
	y = 1
	f(x) = 2x^2
end
```

Try making a small module with a couple of variables and functions in the next Pluto cell:
"""

# ╔═╡ 49bac5a6-51ee-4150-bb4f-3934bd8e4fb2


# ╔═╡ 56a7b4fe-970b-480a-bfaa-f703a17ade8c
md"""
The contents of modules can be accessed using a `.` (dot):
```julia
MyModA.f(2)
```

Try running the function you defined inside your module:
"""

# ╔═╡ 45695b6c-4f80-4eb7-8292-daf946ae494a


# ╔═╡ 3c3f1920-1c73-4744-a88c-9510e6bf4299
md"""
Any function, variable, or type defined in a module is distinct from those defined outside it.
For example, these two refer to completely different functions called `f`:
```julia
f(x) = 9x^3
module MyModA
	f(x) = 2x
end

f(2) != MyModA.f(x)
```

This is separate from the concept of *methods*.  Here` f` and `MyModA.f` are two different functions that have different meanings. Two methods of the same function are different *implementations* of the same meaning.
"""

# ╔═╡ 853c7f60-8445-4e5b-aa52-7560203b3a08
md"""
That said, it's common to extend a function from one module from another to add a new method. Let's see how that might work.


Imagine Alice creates a module called Geometry that defines a Point2D type.
It also contains a function `distance_from_origin`.
It has one method that accepts a single `Point2D` argument.
"""

# ╔═╡ 6303b5b5-63c8-4389-a0ae-2883c97840f7
module Geometry

	struct Point2D
		x::Float64
		y::Float64
	end

	"""
	Compute the distance between a point and the origin.
	"""
	function distance_from_origin end

	function distance_from_origin(point::Point2D)
		return sqrt(point.x^2 + point.y^2)
	end

end

# ╔═╡ 075f999a-d2c6-4ef3-a776-ac1c81f1f1a0
module BobsGeometryExtras
	using ..Geometry # .. only needed in Pluto since these are both submodules of Main

	struct Point3D
		x::Float64
		y::Float64
		z::Float64
	end

	function Geometry.distance_from_origin(point::Point3D)
		return sqrt(point.x^2 + point.y^2 + point.x^2)
	end

end

# ╔═╡ bd33ebc5-f4cc-4cf5-b8ba-3d4bf280749e
md"""

Try creating a `Point2D` and using the distance function:
"""

# ╔═╡ 0177630e-be79-4a84-bc7f-2c44bf260052


# ╔═╡ 1fd083b6-3a6d-4b96-8bbb-c4a2a108bff8


# ╔═╡ 96db8904-78e2-4caa-8e65-d01501df9b15
md"""

Now imagine that Bob wants to use Alice's package, and extend it to work with three dimensional points. Bob defines a new `Point3D` type and extends the `Geometry.distance_from_origin` function with a new method:
"""

# ╔═╡ c184cecc-cdad-4df1-a8b8-12e9cfdde48e
md"""
!!! note
	The syntax `Module.function` should be used when adding a method to a function from another module.
"""

# ╔═╡ c7ccc1ff-9784-4cb1-a2cf-89a21d2c4ec3
md"""
Try using the `distance_from_origin` function with a `Point3D`:
"""

# ╔═╡ 307b6e57-28a2-4b0f-a512-76985925bc17


# ╔═╡ ef7c4547-552c-4487-91d8-4152cd60beb2


# ╔═╡ 47213373-9623-4edd-bfa8-9db62ff2eaba
md"""
Finally, let's take a look at how we can add methods to Julia's built in functions.
Add the following to the `BobsGeometryExtras` module from earlier:

```julia
using LinearAlgebra

function Base.abs(point::Point3D)
	return Point3D(abs(point.x), abs(point.y), abs(point.z))
end

function Base.:(+)(a::Point3D, b::Point3D)
	return Point3D(a.x + b.x, a.y + b.y, a.z + b.z)
end

# Define Point3D multiplication as the cross product
function Base.:(*)(a::Point3D, b::Point3D)
	return Point3D(
		a.z*b.z - a.z*b.y,
		a.z*b.x - a.x*b.z,
		a.x*b.y - a.y*b.x
	)
end
```

Once you've done that, try the following examples:
```julia
p1 = BobsGeometryExtras.Point3D(1,1,1)
p2 = BobsGeometryExtras.Point3D(1,-1,1)
p3 = p1 + p2

p4 = p1 * p2
```
"""

# ╔═╡ 736dce7f-cc86-4dd8-ab5a-e05410689f7f


# ╔═╡ 93d3f0fc-030e-4600-8773-a68631dd5207
md"""
Since we've defined the `+` function on the Point2D type, lots of new behaviour emerges naturally.

1. Try creating a vector of points, and passing it to the `sum` function
2. Create two matrices of points, take the matrix multiplication of them with `*`
"""

# ╔═╡ dafceedf-5825-44a6-87f6-bb48e443ccb2


# ╔═╡ b4209638-ad3a-48ef-8323-883aaaf10a50


# ╔═╡ 4edef180-aa31-4e27-be61-e9d3a1d7b4a1


# ╔═╡ 8d877a0b-4a47-410f-818c-4a2e24ba4727


# ╔═╡ aac4a5ac-6492-4af5-898b-0e7e9eec2be0


# ╔═╡ 454ff2f3-fbe0-4125-a435-ef44b175c35d
md"""
!!! danger "Type Piracy"
	**Type Piracy** is when you extend a function without at least one argument type that your module "owns". For example, it would be type piracy for Bob to extend Alice's distance_from_origin function with a method that takes two integers.

	Though not enforced at the language level, type piracy must be avoided to prevent spooky action at a distance, where loading one module changes the behaviour of unrelated functionality in a separate module.
"""

# ╔═╡ d507c992-7b68-4af0-98c4-dacca3609273
md"""
Adding methods to existing functions is the main way that Julia packages are built, and a key component of Julia's uniquely pervasive composability.

A great talk on this topic is [The Unreasonable Effectiveness of Multiple Dispatch](https://www.youtube.com/watch?v=kc9HwsxE1OY) by Stefan Karpinski.

"""

# ╔═╡ 077135e0-8322-11ed-32aa-0724ce8da92c
md"""
# Julia Environments and Packages


Putting your code into a package is especially important in Julia, since it unlocks a few useful features:

* Re-using code
* Saving your compiled code for faster loading
* Live-reloading of code changes with Revise.jl
* Sharing your code with others

Notice that I put sharing your code at the bottom of the list. Placing your code in a package is a useful thing to do even if you're not sure you want to share your code with other people.

!!! note
	A commercial but free service for finding Julia packages is  [juliahub.com](https://juliahub.com/ui/Packages), operated by Julia Computing.

Before we talk about building a packge, let's discuss "environments".
"""

# ╔═╡ 9739ac67-b5ff-4488-9c7d-bbc4b3c36d3a
md"""
## Environments

An "environment" is a list of packages and possibly version numbers.
An environment consists of just two files:
* `Project.toml`
* `Manifest.toml`

`Project.toml` tracks what packages need to be installed to use that environment. It might look something like this:
```toml
[deps]
FITSIO = "525bcba6-941b-5504-bd06-fd0dc1a4d2eb"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
```

Or
```toml
[deps]
FITSIO = "525bcba6-941b-5504-bd06-fd0dc1a4d2eb"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[compat]
FITSIO = "0.17.0"
```

The keys on the left are the names of the packages, and the gobbledegook on the right is a unique machine readable identifier. This makes sure that even if people pick the same names for their packages, Julia won't get them confused.

!!! note
	If you're planning on writing some scripts for a project, it's a very good idea to create an environment.

You don't have to make Project.toml yourself. Just open the julia REPL, navigate to the folder you're working out of, and type `] activate .` to activate the current folder as an environment.
Then, you can install packages as usual (`] add FITSIO`, for example) and Julia will modify `Project.toml`.

If you share your `Project.toml` with someone, they can activate it and run `instantiate` to install all of the packages inside. It will pick versions that match the general constraints listed under `[compat]`

---

`Manifest.toml` is a bit more niche. It stores all the exact versions of every package you use. If you want someone (possibly yourself at a later date) to be able to exactly reproduce an environment down to every detail, send them the `Manifest.toml` as well. This is a great way of ensuring reproducible science.
"""

# ╔═╡ 63d8bf16-f065-48dc-9e17-a92937414cd9
md"""
## Pluto (aside)
Pluto notebooks are stored in `.jl` files just like regular scripts. If you open one up in a text editor of your choice, you will see contents like the following:

```julia
### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# e28bad2f-f4ea-4c30-9f08-746ca2f609d8
using AstroImages

# 98d2310d-a17b-4b0d-877d-9f77020848d3
using Plots

# 1877c9ea-77e9-11ed-11b3-4d295a402999
md"this is a markdown cell"


# 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = \"""
[deps]
AstroImages = "fe3fc30c-9b16-11e9-1c73-17dabf39f4ad"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"

[compat]
AstroImages = "~0.4.0"
Plots = "~1.37.2"
\"""

# 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = \"""
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0-DEV"
manifest_format = "2.0"
project_hash = "59562c7a7aee2e03c8392b93c96735eb9485add4"


# Cell order:
# ╠═20b9ba30-2685-4535-9244-693f8e653a9a
# ╠═67371af8-bd8d-4fef-b46a-6f57624e052d
# ╠═1877c9ea-77e9-11ed-11b3-4d295a402999
```

That is, a Pluto notebook is just a regular Julia script with some special formatting.
Two variables are defined `PLUTO_PROJECT_TOML_CONTENTS` and `PLUTO_MANIFEST_TOML_CONTENTS` that bundle in the Project.toml and Manifest.toml.

Basically, Pluto creates an environment for each notebook. If you open the notebook on another computer, Pluto will load the exact same versions of all packages.
"""

# ╔═╡ 1413a21a-d653-489d-80e6-9348b114fcff
md"""
## Packages

To make a Julia package, we create a simple file and folder structure. In other languages, a package might be called a "library".

To make a package called `MyPackage`, we'll create the following files:
```
MyPackage/
├─ src/
│  ├─ MyPackage.jl
├─ Project.toml
├─ Manifest.toml  <this will be generated automatically by Julia>
```

Inside Project.toml we'll give the package a name and unique identifier. You can generate the identifier by running:
```julia
using UUIDs
uuid4()
```

Try it now:
"""

# ╔═╡ 9d08cba7-90e1-4fe0-842b-757d3df36a32


# ╔═╡ a413ec8f-0787-4d77-a04c-acffdf305b7a


# ╔═╡ 9238dcf9-3722-45a1-ad4b-af2a39d24626
md"""
`Project.toml` should look like
```toml
name = "MyPackage"
uuid = "<insert unique id here>"
```


Inside `MyPackage.jl` we'll create an empty module
```julia
module MyPackage
	# code goes here!
end
```

That's it! You can now load your package by typing `] activate MyPackage` and then `using MyPackage`.

If you want your package accessible to other code, activate your other environment and, from inside, run `] develop /home/path-to/MyPackage`. This will add it to that environment's Project.toml.
"""

# ╔═╡ e120cf73-9eb2-4618-aa7f-215c6d9ccbbf
md"""
------
"""

# ╔═╡ 42ca97fc-57dc-4f24-9919-8d6a823ae151
md"""
Notice how we had to put `module MyPackage` at the top of MyPackage.jl? Unlike in Python, modules != files. You can create multiple, nested modules inside the same file (you should rarely want to do this):
```julia
module MyPackage

	module PartA
	end

	module PartB
	end
end
```

Or split a module across multiple files (you should often do this):
```julia
module MyPackge

	include("type-definitions.jl")
	include("function-definitions.jl")

end
```

`include` almost-literally copies and pastes in code from another file. It's the main way to split a package up into different unique units. Nested modules, like the first example, are almost never used in Julia.

!!! note
	You can also use `include("file.jl")` to directly run a script from inside Julia.
"""

# ╔═╡ 44b4a9f9-7740-4ea5-bb03-3fca9a48f220
md"""
### Workflows for Developing Packages

The best way to work on a package is with Revise.jl. Revise is a simple package, just run `using Revise` at the start of your session, and Julia will automatically notice and recompile any code that changes in your package.
This way you can edit your package as you go, adding functions, fixing bugs, etc, and whenever you run anything in the REPL, you'll see the latest changes.

"""


# ╔═╡ 7dbb9c09-5b7a-4a5a-b6b1-8946b0cf962e
md"""
### Sharing Packages

The easiest way to share a Julia package is to put it on GitHub.

* Create a repository with same name as your package (include the `.jl`) and push your folder to it.
* Other people can install your package by running `] add https://github.com/yourname/MyPackage.jl.git`

Once you're happy with your package, you can "register" it with the Julia General Registry so that people can install it by just typing `] add MyPackage`.

There are lots more things you can add to your package over time.
"""

# ╔═╡ ea74763f-ece3-4a4c-ae76-39d1ac5ca2dd
md"""
### Tests
You can add tests in a file called `tests/runtests.jl`. Then, you can run `] test MyPackage` to get a test report.

If your package is registered, the Julia developers will run your package tests against new versions of Julia to make sure everything works as expected.

You can even hook up these tests to GitHub so that they run everytime you change the code. This is a great way to make sure everything stays working the way it should!
"""

# ╔═╡ cf62edf6-59e7-4880-9c51-897c29c1233c
md"""
### Documentation
You can add documentation to your package in the `docs` folder.
Read about how here: [documenter.juliadocs.org](https://documenter.juliadocs.org/stable/). You can set GitHub up to automatically convert your docs into a hosted webpage.
"""

# ╔═╡ 575703f0-efec-4092-b067-8eaf5600bd69
md"""
## Excercises

In these excercises, we will create our own package. This can be just a simple "hello world" function, but I would suggest you try creating a very basic package that you would use in your research.

### Part 1
* Come up with a name for your package.
* Create a folder structure with the right names.
* Using a text editor of your choiceCreate Project.toml with the package name and a unique identifier

### Part 2
* Fill out your package with a function or two. Try to come up with a function that would be useful to other people working in your sub-field.
* If you need to use a function defined in another Julia package, use `] add OtherPackage` to install and add it to `Project.toml` automatically.

### Part 3
* Share it with the group!

"""

# ╔═╡ 7b6689b3-75d3-4245-87ef-b46d93249414
md"""
## Bonus content: Defining functions with a for loop.
A neat trick that is widely used when writing modules is to use a for loop to write functions for you.

One common situtation where this is useful is when writing a package is that you define a type that combines an existing type like an array with some additional fields and behaviour. For example, `AstroImage` combines an a matrix with a header structure to track metadata.

In these situations, one typically wants the new type to behave just like the object it wraps (the matrix in this example) in several ways, but not in others.

Let's see how this may look.
"""

# ╔═╡ c16ec715-7adc-4fde-9021-8b44746ae6ff
struct MetaArray{TArray,TMetadata}
	array::TArray
	meta::TMetadata
end

# ╔═╡ 0a174016-3511-477b-ae12-d7978c20f45f
arr = MetaArray(randn(4,4), (a=1,b=2,c="text"))

# ╔═╡ feb49ac1-989c-4652-8e71-6d1f0d88199e
arr.meta.c

# ╔═╡ 147e7d41-5a58-4831-b449-66084a9210bb
for f in [
	:(Base.getindex),
	:(Base.setindex!),
	:(Base.adjoint),
	:(Base.transpose),
	:(Base.view),
]
	@eval ($f)(arr::MetaArray, args...) = MetaArray($f(arr.array, args...), arr.meta)
end

# ╔═╡ 8df360a9-df72-4da8-82a4-7f09b347c7cb
md"""
This is an example of *metaprogramming*: a program that writes a program.

We loop over the variable names Base.getindex, Base.setindex!, etc.
Inside the loop body, we create a quoted expression where some function \$f is defined against a MetaArray.
Then, we evaluate that expression, replacing \$f with the function in question.

"""

# ╔═╡ f7cb6ead-8799-47f9-a553-d570581e4b56
# Now we can use [] to get elements
arr[1,2]

# ╔═╡ fdece0ec-966a-4d33-82dc-3f6fe095075c
# We can transpose it
arr'

# ╔═╡ 365f7190-0737-46ba-accb-8d237e75a460
# We can create views into it

# ╔═╡ 6477fbb2-f266-44ee-b0b9-5464a53d88cf
v = view(arr, 1:2, 1:2)

# ╔═╡ Cell order:
# ╟─1f443df9-619d-40c7-9e08-497ae1a08b5d
# ╟─cfebe185-8871-4fe5-ac55-20c7803a0457
# ╟─2b2adba9-fc0d-4f59-95a5-8d14d1c067f4
# ╟─35e08843-8dde-495c-ab4f-bbb43ed75395
# ╠═49bac5a6-51ee-4150-bb4f-3934bd8e4fb2
# ╟─56a7b4fe-970b-480a-bfaa-f703a17ade8c
# ╠═45695b6c-4f80-4eb7-8292-daf946ae494a
# ╟─3c3f1920-1c73-4744-a88c-9510e6bf4299
# ╟─853c7f60-8445-4e5b-aa52-7560203b3a08
# ╠═6303b5b5-63c8-4389-a0ae-2883c97840f7
# ╟─bd33ebc5-f4cc-4cf5-b8ba-3d4bf280749e
# ╠═0177630e-be79-4a84-bc7f-2c44bf260052
# ╠═1fd083b6-3a6d-4b96-8bbb-c4a2a108bff8
# ╟─96db8904-78e2-4caa-8e65-d01501df9b15
# ╠═075f999a-d2c6-4ef3-a776-ac1c81f1f1a0
# ╟─c184cecc-cdad-4df1-a8b8-12e9cfdde48e
# ╟─c7ccc1ff-9784-4cb1-a2cf-89a21d2c4ec3
# ╠═307b6e57-28a2-4b0f-a512-76985925bc17
# ╠═ef7c4547-552c-4487-91d8-4152cd60beb2
# ╟─47213373-9623-4edd-bfa8-9db62ff2eaba
# ╠═736dce7f-cc86-4dd8-ab5a-e05410689f7f
# ╟─93d3f0fc-030e-4600-8773-a68631dd5207
# ╠═dafceedf-5825-44a6-87f6-bb48e443ccb2
# ╠═b4209638-ad3a-48ef-8323-883aaaf10a50
# ╠═4edef180-aa31-4e27-be61-e9d3a1d7b4a1
# ╠═8d877a0b-4a47-410f-818c-4a2e24ba4727
# ╠═aac4a5ac-6492-4af5-898b-0e7e9eec2be0
# ╟─454ff2f3-fbe0-4125-a435-ef44b175c35d
# ╟─d507c992-7b68-4af0-98c4-dacca3609273
# ╟─077135e0-8322-11ed-32aa-0724ce8da92c
# ╟─9739ac67-b5ff-4488-9c7d-bbc4b3c36d3a
# ╟─63d8bf16-f065-48dc-9e17-a92937414cd9
# ╟─1413a21a-d653-489d-80e6-9348b114fcff
# ╠═9d08cba7-90e1-4fe0-842b-757d3df36a32
# ╠═a413ec8f-0787-4d77-a04c-acffdf305b7a
# ╟─9238dcf9-3722-45a1-ad4b-af2a39d24626
# ╟─e120cf73-9eb2-4618-aa7f-215c6d9ccbbf
# ╟─42ca97fc-57dc-4f24-9919-8d6a823ae151
# ╟─44b4a9f9-7740-4ea5-bb03-3fca9a48f220
# ╟─7dbb9c09-5b7a-4a5a-b6b1-8946b0cf962e
# ╟─ea74763f-ece3-4a4c-ae76-39d1ac5ca2dd
# ╟─cf62edf6-59e7-4880-9c51-897c29c1233c
# ╟─575703f0-efec-4092-b067-8eaf5600bd69
# ╟─7b6689b3-75d3-4245-87ef-b46d93249414
# ╠═c16ec715-7adc-4fde-9021-8b44746ae6ff
# ╠═0a174016-3511-477b-ae12-d7978c20f45f
# ╠═feb49ac1-989c-4652-8e71-6d1f0d88199e
# ╠═147e7d41-5a58-4831-b449-66084a9210bb
# ╟─8df360a9-df72-4da8-82a4-7f09b347c7cb
# ╠═f7cb6ead-8799-47f9-a553-d570581e4b56
# ╠═fdece0ec-966a-4d33-82dc-3f6fe095075c
# ╠═365f7190-0737-46ba-accb-8d237e75a460
# ╠═6477fbb2-f266-44ee-b0b9-5464a53d88cf
