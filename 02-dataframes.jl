### A Pluto.jl notebook ###
# v0.20.3

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ c25ec42a-81aa-11ef-3780-0f7138e64b77
import Pkg; Pkg.activate(Base.current_project())

# ╔═╡ 451ae1a0-1846-45dc-9517-6b78e7a81d4a
using DataFrames

# ╔═╡ 177a8009-ea8b-46d4-bdfb-ef5e1e15ca0d
using Downloads

# ╔═╡ c28cfbf4-d96f-4303-96e3-2d1a7debc1e8
using CSV

# ╔═╡ ecea514a-c138-4607-9172-1609ab347e81
using CairoMakie

# ╔═╡ b61550b7-e0fa-462d-b724-9375e2f488e9
using PlutoUI

# ╔═╡ 78a5f27a-8de7-4705-b58f-1f88b50cada5
TableOfContents()

# ╔═╡ 3ebfbc37-294d-4659-b3b8-7e41a4469e84
md"""
## Basic structure of DataFrames
"""

# ╔═╡ 761da758-d32c-47d8-9dd7-330f46ecf784
md"""
DataFrames are similar to tables, they both hold rows of data where each column is a labeled field. The other popular library for dataframes is [pandas](https://pandas.pydata.org/), written for Python. [DataFrames.jl](https://dataframes.juliadata.org/stable/) provides a lot of the functionality that pandas does, but in a different way that feels like a breath of fresh air.
"""

# ╔═╡ f0d6895e-3928-4387-9627-29e195a0f050
md"""
Unlike pandas, DataFrames.jl does not create a special `Series` type. Each column of a DataFrame is a regular Julia vector, and you can even specify your own vector type to represent a column!
"""

# ╔═╡ 7f11873b-6367-4ab7-b5af-7221bac9d051
md"""
With all that said, let's create a DataFrame. One way to do it is by using a keyword constructor, where like Python, you specify each column you want as a name-value pair. Go ahead and create the following DataFrame, and feel free to add more columns! (Make sure that all the columns have the same length.)

```julia
demo_df = DataFrame(
	A = 1:2:1000,
	B = repeat(1:10, inner=50),
	C = 1:500,
	age = rand(18:49, 500),
	admin = rand(Bool, 500),
)
```
"""

# ╔═╡ 91573039-f052-4e15-a3b4-94f983b12d2a


# ╔═╡ 28f3291a-0715-4848-986b-5acf116721aa
md"""
To get a feel for how DataFrames arranges your data, go ahead and check the data type of one of the columns! (Don't worry, we'll talk about what's happening in the square brackets soon)

```julia
typeof(demo_df[!, :B])
# select a different column by changing the name after the colon
```
"""

# ╔═╡ 962f750e-5da3-4279-b391-71a3791aada6


# ╔═╡ 69640f84-120b-4f5f-be3e-93a0bf4c18b4
md"""
## Indexing into DataFrames
"""

# ╔═╡ dbfaef6a-a866-4d25-a4bf-9bff552d6b54
md"""
Although DataFrames are best described as tables, an analogy to matrices can be helpful when learning about indexing. In Julia you can index into any collection with square brackets `[]`, and DataFrames requires two arguments when indexing. The rows, and the columns. This is almost exactly how matrices are indexed, except here the columns can also have names.

```julia
demo_df[1, :] # select the first row, and all columns

demo_df[50:55, :] # select a range of rows

demo_df[1:2:end, [:ages, :admin]] # select the age and admin status from every other row

demo_df[:, [:A, :B]] # get all the A's and B's

demo_df[:, Not(:admin, :age)] # get everything except admin status and age
```
"""

# ╔═╡ ef8cd520-e698-4bfb-a285-ddad7da93bbe


# ╔═╡ 6a0a94a1-c0a8-4bd8-b0fd-e15e49c58441
md"""
Hmmm. We keep specifying the columns, but what if we read in a really big DataFrame and don't feel like scrolling? Well, we can just use the `names` function get all the columns.

```julia
names(demo_df)
```
"""

# ╔═╡ 92fb9204-ea5c-4a36-be2c-ebb24dceac90


# ╔═╡ 9590bcc0-ce77-4116-b220-ba86a77bb349
md"""
As you may have guessed, using `:` (colon) in place of an index just grabs every row or column of a DataFrame. However, there is another way to select rows, using the bang `!` character. Go ahead and try out these two examples. Can you notice a difference?

```julia
demo_df[:, :A]

demo_df[!, :A]
```
"""

# ╔═╡ 581d3e22-c933-453e-a449-6464e9f0bce8


# ╔═╡ acdc56f4-6853-4113-ba01-c6c05ac5ed14
md"""
Don't worry if you didn't! Let's try a different experiment to see if we can figure out when to use bangs `!`

```julia
demo_df[:, :A] .= 3.0

demo_df # check the DataFrame to see if anything's changed

demo_df[!, :A] .= 4.0

demo_df # check the DataFrame again to see if anything's changed
```
"""

# ╔═╡ 7ef2964c-be80-4bf1-be60-7db02aaf5fb5


# ╔═╡ e09b849d-02f9-4ffd-80ee-b79b7fc2394f
md"""
Aha! When we used the exclamation mark, the DataFrame itself changed! This tells us why we'd want to use `!` instead of a `:` to get the rows, because with a `:` we'd just be getting a copy!

Using `!` returns a "view" of the underlying vector that's storing the column. So changing that changes the dataframe. Even when we're not changing the DataFrame, we may want to use `!` to select all the rows, because it's usually faster than making copies.

You can also remember Julia's mutation conventions to remember what `!` does. Recall that functions that mutate the data, like `push!` and `take!` end with exclamation marks, so any time you see a `!` used in assignment, you can infer that it's using the DataFrame directly.
"""

# ╔═╡ e30cf743-8b32-4a39-bc2b-c2e8bc1c3d3a
md"""
That mostly covers what you need to know about indexing. There is one special thing about how DataFrames are stored in memory, however. Please take your time to read through this note:

!!! note "DataFrames are created columns at a time"

    Building a DataFrame row-by-row is possible, but gets expensive and slow. Instead, its simpler to read in all of the data, say, from a file, and then transform it into a DataFrame. If you find yourself calling `push!()` on a DataFrame repeatedly, take a step back and think if it can be approached differently.

"""

# ╔═╡ d079e4d6-e8e2-4793-b892-f706dddbd2d9
md"""
If you're a hardcore Python user, you may remember all the stuff we talked about regarding pandas. If you want to see how DataFrames.jl measures up with pandas, just click the link below and get a nice summary!

Comparison with pandas:
<https://dataframes.juliadata.org/stable/man/comparisons/>
"""

# ╔═╡ c65b63ad-9f94-4253-bfe1-d83e2769e630
md"""
## Reading external data into DataFrames
"""

# ╔═╡ 599c9082-94ec-484e-82d4-2da504d7d7dd
md"""
Hmmm... creating our own DataFrame was instructive and all, but it's not really all that interesting. To show the actual power behind DataFrames.jl, we'll need to find some external data sources that we can run analysis on.
"""

# ╔═╡ fb7e4415-4554-4a85-b453-49b4619714d2
md"""
For this workshop, we've chosen the [HYG database](https://astronexus.com/hyg), which catalogs distances, brightnesses, speeds, and spectra of various information. Since the full catalog is quite large, we're using a subset with ~100,000 stars. We'll use the Downloads module to make a local copy of the file to work on.
"""

# ╔═╡ 242b3f41-5b88-42d5-a20d-86f07d413f20
url = "https://astronexus.com/downloads/catalogs/hygdata_v41.csv.gz";

# ╔═╡ abbfd16c-46d7-4d88-8b1c-a9abe44a7266
filename = Downloads.download(url)

# ╔═╡ 0b362414-fa67-4f26-96c5-db02d5459b07
md"""
The database is published as a .csv file, so we'll use the CSV.jl package to read it. It'll take care of the .gz compression, and even store the data in a DataFrame!

```julia
using CSV

hyg_df = CSV.read(filename, DataFrame)
```
"""

# ╔═╡ aa184c54-a026-4349-b75c-f19f5323819e
hyg_df = CSV.read(filename, DataFrame)

# ╔═╡ c0441fbb-801e-4c1f-a384-f6f9d66d94b9
md"""
Next up, we can use the `describe()` function to get descriptive statistics of the DataFrame. This is a helpful summary to see, and right now, we're most interested in the `nmissing` and `eltype` columns, which tell us the number of missing entries, and what the data type of each column is.

```julia
describe(hyg_df)
```
"""

# ╔═╡ 517de886-f681-4b69-9e67-afaaa0965bed


# ╔═╡ 00e00f0b-31ff-4ebc-8010-9559b9a6295a
md"""
There are some entries that say `missing`, and some types that say `Missing` (or some `Union` of it), and that's Julia's specific way of saying that our external data source doesn't provide a value for that element. `missing` can easily be thought of like a `nothing` value, except `missing` specifically talks about missing data in a statistical sense. In that way, it's more like `NA` in R or `pandas.NA` in Python.
"""

# ╔═╡ ba4a3316-3a48-4e36-b252-5b578d7559f3
md"""
We can see that some of the columns have an awful lot of missing entries, but what if we forgot how many rows the dataset even had? It could be a rare case. Well, luckily, we can use the `nrow()` and `ncol()` functions to get the size of a DataFrame. Go ahead, try it out!

```julia
(nrow(hyg_df), ncol(hyg_df))
```
"""

# ╔═╡ 8e7c3dfd-0f99-47ba-bbfa-321e749cc6bd


# ╔═╡ 9420c5e5-e3f3-43d3-9da4-e2c1fdadd26a
md"""
## Dealing with missing data
"""

# ╔═╡ 2edb78ae-a4be-486e-9137-6731e4d31d02
md"""
So it seems that there are some columns with almost all missing data. There are a couple of ways to handle that, but right now, we can just drop the troublesome columns. Let's set the threshold to 80%, that is, we'll allow 80% of data to be missing in a column before we drop it. To do this programmatically, we'll need to create a function that checks the number of missing items in a column.
"""

# ╔═╡ 1f382a0d-d42d-49c7-9357-df93d0612ae8
md"""
Here, we're creating a function that gives us the number of missing elements in any array, which will go great for our purposes.

```julia
countmissing(v) = count(ismissing, v)
```
"""

# ╔═╡ 1f4e5ca8-1403-4f33-a807-3187f8f45a32


# ╔═╡ abb327d6-7168-4f24-be2e-1b15ac62f3a3
md"""
And the code to find the columns that match our criteria is
```julia
filter(
	colname -> (countmissing(hyg_df[!, colname]) / nrow(hyg_df) >= 8/10),
	names(hyg_df)
)
```

The code shown above takes a bit of time to understand, so let's go through it step by step.

`filter(...)` takes a function and an iterable (for iterable, think arrays), and then returns only those elements of the array where the function returns true.

The iterator is the second argument of `filter`, but we'll talk about it first. `names()` simply returns the name of each column. This is the array we're going to iterate through.

`colname -> ...` is the start of an anonymous function. Instead of using one of the pre-defined or builtin functions, we're writing a custom function that'll do what we want.

`countmissing(...) / nrow(hyg_df)` gets the percentage (or fraction, rather) of the column which is missing. We compare it to our threshold and pick out those that have more than 80% missing.

So all in all, this code takes each of our columns, gets the fraction of missing elements, and returns that column's name if more than 80% of the column is missing.
"""

# ╔═╡ 02176d6b-6fef-494e-b6b9-ac1351775bb9


# ╔═╡ aa75bb53-2988-4b59-bf0c-009d285c81c9
md"""
We get quite a few columns, so we can just drop all of them. Columns `hr`, `bf`, and `flam` are catalog numbers, however, so we keep those columns since not every star is in every catalog.
"""

# ╔═╡ 7bef4815-4cc6-41f3-b111-f57a20daf5ec
md"""
To drop columns, DataFrames doesn't have a `drop!` function, but a `select!()` (in-place version of `select()`) function, where we can use the `Not` function to select everything _but_ the columns we're dropping.

```julia
select!(hyg_df, Not(:base, :lum, :var, :var_min, :var_max))
```
"""

# ╔═╡ e950bf59-4c87-43c3-a963-b7889e798c74


# ╔═╡ 9b83a7d2-a4fb-47f0-a371-a063fad26fe6
md"""
That took care of a lot, but we still have a lot of missing entries to contend with. For example, what's the proper name of every star? It should be in the `proper` column, but not every star has one. We can use Julia's builtin `skipmissing()` to get the name of every star.

```julia
collect(skipmissing(hyg_df[!, :proper]))
```

We're using the `collect()` function to force the results back to an array, so we can see the results more easily.
"""

# ╔═╡ e84a8943-c41c-41c1-af45-c1bcd9e3a438


# ╔═╡ b599837f-7e47-412f-af2f-f5cb6cae9c0d
md"""
Well... that got rid of the missing entries, but there are sitll a lot of blanks. We should probably use make our own filter to get rid of them too. This is going to be super easy, because we can just use the builtin `!` (not) and `isempty` to get what we want!

```julia
skipmissing(hyg_df[!, :proper]) |> filter(!isempty)
```
"""

# ╔═╡ aa144035-af4b-43fb-920e-e83e7dd61486


# ╔═╡ c9f5b830-2a1c-4946-81da-65436a57d55d
md"""
DataFrames.jl goes more in-depth into how to work around missing data on <https://dataframes.juliadata.org/stable/man/missing/>. And since `missing` is built into Julia, it's also worth looking at the official Julia manual for it: <https://docs.julialang.org/en/v1/manual/missing/>.
"""

# ╔═╡ 8b5809c4-cb79-4944-ba72-f5c7ff31d31a
md"""
## Modifying DataFrames
"""

# ╔═╡ 78e7179e-6c66-4050-88fd-cd4da31cd5bf
md"""
In an effort to make using this DataFrame as effortless as possible (no pun intended... mostly), we can rename some columns so that it's easier to understand what the values refer to. We can look again at <https://astronexus.com/hyg> for the meaning of each column, then we can select which columns to rename.
"""

# ╔═╡ 370ed029-2924-4012-bf10-b9b84887134f
md"""
Okay, having looked through them, I propose that we change these names. Feel free to add your own as well!

```julia
rename!(
	hyg_df,
	:con    => :constellation,
	:proper => :proper_name,
	:ci     => :color_index,
	:mag    => :apparent_mag,
	:absmag => :absolute_mag,
	:rv     => :radial_velocity,
)
```
"""

# ╔═╡ f5f6964f-fdaf-47cf-a4a7-81b5b1aac919


# ╔═╡ b87fd0c4-9cea-407a-b9b9-b105476eea3a
md"""
Another thing we can do is to make the `constellation` field into a categorical vector. There are 88 IAU constellations, so we should have around 88 categories (excluding the sun). We can use the function `categorical` from a library CategoricalArrays.jl to make the column categorical, and make the data type more representative of the data being stored. To actually effect this change in our DataFrame, we use the `transform!` function:

```julia
using CategoricalArrays

transform!(
	hyg_df,
	:constellation =>			# take the constellation column
		categorical =>			# make a categorical vector out of it
		:constellation			# and store it back into the same column
)
```
"""

# ╔═╡ 80d9c1bd-a9c1-45d6-95cc-d596084b28f6


# ╔═╡ 1a7e5c9f-a304-4852-aae2-13ff5c11993c
md"""
We can also use the `levels()` function to see what categories are actually present in the column.

```julia
levels(hyg_df[!, :constellation])
```
"""

# ╔═╡ 9070aac6-82ca-4510-8ce9-cc2049cf2d60


# ╔═╡ 61f30aa0-5e34-45ad-8038-244504075c73
md"""
## Grouping DataFrames
"""

# ╔═╡ 88f15f53-43da-4739-a804-4b1932fe86c2
md"""
There's one other big feature of DataFrames.jl, which are `GroupedDataFrame`s. You can create a `GroupedDataFrame` by calling `groupby()` on an existing DataFrame and choosing a column to base the groups on. We're going to choose the `constellation` column, so stars that are in the same constellation will be grouped together.

```julia
hyg_groupeddf = groupby(hyg_df, :constellation)
```
"""

# ╔═╡ dab54fae-e13e-49af-a5b3-a16ff1f68495


# ╔═╡ a6d3b534-c2ce-4bd3-8ab7-39278cbff7ce
md"""
Ooh, that's a lot of groups. Note that you can select multiple groups as well, so whenever you're trying to get a specific group from a `GroupedDataFrame`, you'll have to put in a touple, one for each column you're grouping on. And if you're in a pinch, you can always use `groupcols()` to see which columns the groups are based on, and `keys()` to get the value that makes each group different.

```julia
groupcols(hyg_groupeddf)

keys(hyg_groupeddf)
```
"""

# ╔═╡ 569072d3-74b5-4907-a73e-8dd9e338c9b3


# ╔═╡ 044beffb-4a33-41b8-8c13-d55e1ccc97f2
md"""
And now, we can also use one of the constellation values directly to get all the stars in a specific constellation:

```julia
hyg_groupeddf[("Psc", )]
# OR
hyg_groupeddf[(; constellation = "Psc")] # use a named tuple
```
"""

# ╔═╡ cc7c98b6-268c-447c-9d13-1a06e38c37b8


# ╔═╡ 3765d8d0-f256-4896-92bb-fa89823db786
md"""
## Plotting
"""

# ╔═╡ 6b926ec7-5804-47a4-a034-7c93cd74179a
md"""
Finally! It's time for the exciting stuff. We get to plot all of the data we've been cleaning up using Makie.jl. Let's make a color-magnitude diagram.

```julia
using CairoMakie

plot(
	hyg_df.color_index, hyg_df.absolute_mag, # use dot notation to get columns
	axis = (;
		yreversed = true, # magnitude is upside-down
		xlabel = "B-V color", ylabel = "Magnitude",
	)
)
```
"""

# ╔═╡ ba098300-a096-49d9-9814-0765738decb9
md"""
That's not very informative. Maybe we can try plotting one constellation instead. Time to bring back the grouped data frame!

```julia
let df = hyg_groupeddf[(; constellation = "Ari")]
	plot(
		df.color_index, df.absolute_mag,
		axis = axis_properties,
	)
end
```
"""

# ╔═╡ 6e495c42-5b7a-4515-9e70-8c5ba28e2684


# ╔═╡ 16a55fcb-915a-40d6-a41d-b4b5dbf46f9b
axis_properties = (; yreversed = true, xlabel = "B-V color", ylabel = "Magnitude");

# ╔═╡ 123ab662-a4ab-4428-8115-3cfdb2a8ebe4
md"""
Much better. Now, we can pick and choose any constellation we want and make an H-R diagram out of it. As a bonus, we've made this little widget for you to select a constellation and get a specific HR diagram!
"""

# ╔═╡ bb4ba286-f90e-4b68-88b7-41b96730fa0f
@bind plotcon Select(levels(hyg_df[!, :constellation]))

# ╔═╡ 2b978aed-5e66-49e3-be67-f547db0d87e3
let constellation_df = hyg_groupeddf[(; constellation = plotcon)]
	scatter(
		constellation_df[!, :color_index], constellation_df[!, :absolute_mag],
		axis = (;
			axis_properties...,
			title = "Color-mangitude diagram of constellation $plotcon",
		)
	)
end

# ╔═╡ 2b5f4d3c-6384-4852-885b-511b27a9be56
md"""
And that concludes the workshop on DataFrames! Feel free to ask questions, and you can always look on the [DataFrames.jl website](https://dataframes.juliadata.org/stable) or [Julia Discourse](https://discourse.julialang.org/) for help!
"""

# ╔═╡ Cell order:
# ╠═c25ec42a-81aa-11ef-3780-0f7138e64b77
# ╟─78a5f27a-8de7-4705-b58f-1f88b50cada5
# ╟─3ebfbc37-294d-4659-b3b8-7e41a4469e84
# ╠═451ae1a0-1846-45dc-9517-6b78e7a81d4a
# ╟─761da758-d32c-47d8-9dd7-330f46ecf784
# ╟─f0d6895e-3928-4387-9627-29e195a0f050
# ╟─7f11873b-6367-4ab7-b5af-7221bac9d051
# ╠═91573039-f052-4e15-a3b4-94f983b12d2a
# ╟─28f3291a-0715-4848-986b-5acf116721aa
# ╠═962f750e-5da3-4279-b391-71a3791aada6
# ╟─69640f84-120b-4f5f-be3e-93a0bf4c18b4
# ╟─dbfaef6a-a866-4d25-a4bf-9bff552d6b54
# ╠═ef8cd520-e698-4bfb-a285-ddad7da93bbe
# ╟─6a0a94a1-c0a8-4bd8-b0fd-e15e49c58441
# ╠═92fb9204-ea5c-4a36-be2c-ebb24dceac90
# ╟─9590bcc0-ce77-4116-b220-ba86a77bb349
# ╠═581d3e22-c933-453e-a449-6464e9f0bce8
# ╟─acdc56f4-6853-4113-ba01-c6c05ac5ed14
# ╠═7ef2964c-be80-4bf1-be60-7db02aaf5fb5
# ╟─e09b849d-02f9-4ffd-80ee-b79b7fc2394f
# ╟─e30cf743-8b32-4a39-bc2b-c2e8bc1c3d3a
# ╟─d079e4d6-e8e2-4793-b892-f706dddbd2d9
# ╟─c65b63ad-9f94-4253-bfe1-d83e2769e630
# ╟─599c9082-94ec-484e-82d4-2da504d7d7dd
# ╟─fb7e4415-4554-4a85-b453-49b4619714d2
# ╠═177a8009-ea8b-46d4-bdfb-ef5e1e15ca0d
# ╠═242b3f41-5b88-42d5-a20d-86f07d413f20
# ╠═abbfd16c-46d7-4d88-8b1c-a9abe44a7266
# ╟─0b362414-fa67-4f26-96c5-db02d5459b07
# ╠═c28cfbf4-d96f-4303-96e3-2d1a7debc1e8
# ╠═aa184c54-a026-4349-b75c-f19f5323819e
# ╟─c0441fbb-801e-4c1f-a384-f6f9d66d94b9
# ╠═517de886-f681-4b69-9e67-afaaa0965bed
# ╟─00e00f0b-31ff-4ebc-8010-9559b9a6295a
# ╟─ba4a3316-3a48-4e36-b252-5b578d7559f3
# ╠═8e7c3dfd-0f99-47ba-bbfa-321e749cc6bd
# ╟─9420c5e5-e3f3-43d3-9da4-e2c1fdadd26a
# ╟─2edb78ae-a4be-486e-9137-6731e4d31d02
# ╟─1f382a0d-d42d-49c7-9357-df93d0612ae8
# ╠═1f4e5ca8-1403-4f33-a807-3187f8f45a32
# ╟─abb327d6-7168-4f24-be2e-1b15ac62f3a3
# ╠═02176d6b-6fef-494e-b6b9-ac1351775bb9
# ╟─aa75bb53-2988-4b59-bf0c-009d285c81c9
# ╟─7bef4815-4cc6-41f3-b111-f57a20daf5ec
# ╠═e950bf59-4c87-43c3-a963-b7889e798c74
# ╟─9b83a7d2-a4fb-47f0-a371-a063fad26fe6
# ╠═e84a8943-c41c-41c1-af45-c1bcd9e3a438
# ╟─b599837f-7e47-412f-af2f-f5cb6cae9c0d
# ╠═aa144035-af4b-43fb-920e-e83e7dd61486
# ╟─c9f5b830-2a1c-4946-81da-65436a57d55d
# ╟─8b5809c4-cb79-4944-ba72-f5c7ff31d31a
# ╟─78e7179e-6c66-4050-88fd-cd4da31cd5bf
# ╟─370ed029-2924-4012-bf10-b9b84887134f
# ╠═f5f6964f-fdaf-47cf-a4a7-81b5b1aac919
# ╟─b87fd0c4-9cea-407a-b9b9-b105476eea3a
# ╠═80d9c1bd-a9c1-45d6-95cc-d596084b28f6
# ╟─1a7e5c9f-a304-4852-aae2-13ff5c11993c
# ╠═9070aac6-82ca-4510-8ce9-cc2049cf2d60
# ╟─61f30aa0-5e34-45ad-8038-244504075c73
# ╟─88f15f53-43da-4739-a804-4b1932fe86c2
# ╠═dab54fae-e13e-49af-a5b3-a16ff1f68495
# ╟─a6d3b534-c2ce-4bd3-8ab7-39278cbff7ce
# ╠═569072d3-74b5-4907-a73e-8dd9e338c9b3
# ╟─044beffb-4a33-41b8-8c13-d55e1ccc97f2
# ╠═cc7c98b6-268c-447c-9d13-1a06e38c37b8
# ╟─3765d8d0-f256-4896-92bb-fa89823db786
# ╟─6b926ec7-5804-47a4-a034-7c93cd74179a
# ╠═ecea514a-c138-4607-9172-1609ab347e81
# ╟─ba098300-a096-49d9-9814-0765738decb9
# ╠═6e495c42-5b7a-4515-9e70-8c5ba28e2684
# ╠═16a55fcb-915a-40d6-a41d-b4b5dbf46f9b
# ╟─123ab662-a4ab-4428-8115-3cfdb2a8ebe4
# ╠═b61550b7-e0fa-462d-b724-9375e2f488e9
# ╠═bb4ba286-f90e-4b68-88b7-41b96730fa0f
# ╠═2b978aed-5e66-49e3-be67-f547db0d87e3
# ╟─2b5f4d3c-6384-4852-885b-511b27a9be56
