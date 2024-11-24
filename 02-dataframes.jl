### A Pluto.jl notebook ###
# v0.20.0

using Markdown
using InteractiveUtils

# ╔═╡ c25ec42a-81aa-11ef-3780-0f7138e64b77
import Pkg; Pkg.activate(Base.current_project())

# ╔═╡ 451ae1a0-1846-45dc-9517-6b78e7a81d4a
using DataFrames

# ╔═╡ c28cfbf4-d96f-4303-96e3-2d1a7debc1e8
using CSV

# ╔═╡ 177a8009-ea8b-46d4-bdfb-ef5e1e15ca0d
using Downloads

# ╔═╡ ecea514a-c138-4607-9172-1609ab347e81
using CairoMakie

# ╔═╡ 78a5f27a-8de7-4705-b58f-1f88b50cada5
import PlutoUI; PlutoUI.TableOfContents()

# ╔═╡ 3ebfbc37-294d-4659-b3b8-7e41a4469e84
md"""
## Basic structure
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
demo_df = DataFrame(
	A = 1:2:1000,
	B = repeat(1:10, inner=50),
	C = 1:500,
	age = rand(18:49, 500),
	admin = rand(Bool, 500),
)

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
## Indexing
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

# ╔═╡ 2091dff2-c5d0-4819-b8c9-bb4a3689cd04
demo_df[:, Not(:admin, :age)]

# ╔═╡ ef8cd520-e698-4bfb-a285-ddad7da93bbe


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

`!` returns a "view" of the underlying vector that's storing the column. So changing that changes the dataframe. Even when we're not changing the DataFrame, we may want to use `!` to select all the rows, because it's usually faster than making copies.

You can also remember Julia's mutation conventions to remember what `!` does. Recall that functions that mutate the data, like `push!` and `take!` end with exclamation marks, so any time you see a `!` used in assignment, you can infer that it's probably mutating the DataFrame somehow.
"""

# ╔═╡ e9c697bb-605e-4fa2-847a-b0757ed3f0ee
md"""
If you're not familiar with creating and interacting with DataFrames, it can take some getting used to. There are a few things to keep in mind, however:

- DataFrames are created columns at a time

  Building a DataFrame row-by-row is possible, but gets expensive and slow. Instead, its simpler to read in all of the data, say, from a file, and then transform it into a DataFrame. If you find yourself calling `push!()` on a DataFrame repeatedly, take a step back and think if it can be approached differently.


"""

# ╔═╡ 57d7fdba-97a1-4b26-94df-d2aaca2deb7a
md"""
Make look nicer
- DataFrames are created columns at a time
- Indexing into a column with view rather than slice is easier than for rows?
- Each column is a simple vector, not a specific series type object made for dataframes
"""

# ╔═╡ 6a0a94a1-c0a8-4bd8-b0fd-e15e49c58441
md"""
What if you don't feel like scrolling? TODO rewrite

```julia
names(demo_df)
```
"""

# ╔═╡ d079e4d6-e8e2-4793-b892-f706dddbd2d9
md"""
Comparison with pandas:
<https://dataframes.juliadata.org/stable/man/comparisons/>
"""

# ╔═╡ c65b63ad-9f94-4253-bfe1-d83e2769e630
md"""
## Reading data
"""

# ╔═╡ 599c9082-94ec-484e-82d4-2da504d7d7dd
md"""
TODO: find csv file or something with astronomical data
"""

# ╔═╡ fb7e4415-4554-4a85-b453-49b4619714d2
md"""
information about the database at https://astronexus.com/hyg
"""

# ╔═╡ 242b3f41-5b88-42d5-a20d-86f07d413f20
url = "https://www.astronexus.com/downloads/catalogs/hyglike_from_athyg_24.csv.gz"

# ╔═╡ abbfd16c-46d7-4d88-8b1c-a9abe44a7266
filename = Downloads.download(url)

# ╔═╡ aa184c54-a026-4349-b75c-f19f5323819e
hyg_df = CSV.read(filename, DataFrame)

# ╔═╡ 517de886-f681-4b69-9e67-afaaa0965bed
describe(hyg_df)

# ╔═╡ c0fad0e2-75f1-439e-b303-80c9157c9b74
md"""
## Indexing
"""

# ╔═╡ 8e7c3dfd-0f99-47ba-bbfa-321e749cc6bd


# ╔═╡ 9420c5e5-e3f3-43d3-9da4-e2c1fdadd26a
md"""
## Missing data
"""

# ╔═╡ 0183a9f1-733b-4bab-b5bb-1ff3209a6103
md"""
drop the base, lum, var_*** columns
"""

# ╔═╡ e950bf59-4c87-43c3-a963-b7889e798c74
select!(hyg_df, Not([:base, :lum, :var, :var_min, :var_max]))

# ╔═╡ 553ea807-d5e2-4167-b15d-8cd1441fdf94
describe(hyg_df)

# ╔═╡ 8b5809c4-cb79-4944-ba72-f5c7ff31d31a
md"""
## Modifying DataFrames
"""

# ╔═╡ 370ed029-2924-4012-bf10-b9b84887134f
md"""
rename some columns:

- con -> constellation
- proper -> proper name
- ci -> color
- mag -> apparentmag
"""

# ╔═╡ f5f6964f-fdaf-47cf-a4a7-81b5b1aac919
rename!(
	hyg_df,
	:con => :constellation,
	:proper => :proper_name,
	:ci => :color_index,
	:mag => :apparent_mag,
	:absmag => :absolute_mag,
	:rv => :radial_velocity,
)

# ╔═╡ b87fd0c4-9cea-407a-b9b9-b105476eea3a
md"""
make :con categorical? (I guess it already is?)
"""

# ╔═╡ 80d9c1bd-a9c1-45d6-95cc-d596084b28f6
hyg_df.constellation

# ╔═╡ 900f6e3a-706c-442e-ac2c-ceabc401727d
hyg_df.constellation |> levels

# ╔═╡ 3765d8d0-f256-4896-92bb-fa89823db786
md"""
## Plotting
"""

# ╔═╡ 6b926ec7-5804-47a4-a034-7c93cd74179a
md"""
make a color-magnitude diagram
"""

# ╔═╡ 734844f6-40d1-4908-b0c7-a8311f68306d
plot(hyg_df.color_index, hyg_df.absolute_mag)

# ╔═╡ 2b5f4d3c-6384-4852-885b-511b27a9be56
md"""
each color-index is different based on catalog, so separate them out and maybe group? then plot different color-magnitude diagrams

except they're not really different?
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
# ╠═2091dff2-c5d0-4819-b8c9-bb4a3689cd04
# ╠═ef8cd520-e698-4bfb-a285-ddad7da93bbe
# ╟─9590bcc0-ce77-4116-b220-ba86a77bb349
# ╠═581d3e22-c933-453e-a449-6464e9f0bce8
# ╟─acdc56f4-6853-4113-ba01-c6c05ac5ed14
# ╠═7ef2964c-be80-4bf1-be60-7db02aaf5fb5
# ╟─e09b849d-02f9-4ffd-80ee-b79b7fc2394f
# ╠═e9c697bb-605e-4fa2-847a-b0757ed3f0ee
# ╠═57d7fdba-97a1-4b26-94df-d2aaca2deb7a
# ╠═6a0a94a1-c0a8-4bd8-b0fd-e15e49c58441
# ╟─d079e4d6-e8e2-4793-b892-f706dddbd2d9
# ╟─c65b63ad-9f94-4253-bfe1-d83e2769e630
# ╠═c28cfbf4-d96f-4303-96e3-2d1a7debc1e8
# ╠═599c9082-94ec-484e-82d4-2da504d7d7dd
# ╠═177a8009-ea8b-46d4-bdfb-ef5e1e15ca0d
# ╠═fb7e4415-4554-4a85-b453-49b4619714d2
# ╠═242b3f41-5b88-42d5-a20d-86f07d413f20
# ╠═abbfd16c-46d7-4d88-8b1c-a9abe44a7266
# ╠═aa184c54-a026-4349-b75c-f19f5323819e
# ╠═517de886-f681-4b69-9e67-afaaa0965bed
# ╟─c0fad0e2-75f1-439e-b303-80c9157c9b74
# ╠═8e7c3dfd-0f99-47ba-bbfa-321e749cc6bd
# ╟─9420c5e5-e3f3-43d3-9da4-e2c1fdadd26a
# ╠═0183a9f1-733b-4bab-b5bb-1ff3209a6103
# ╠═e950bf59-4c87-43c3-a963-b7889e798c74
# ╠═553ea807-d5e2-4167-b15d-8cd1441fdf94
# ╟─8b5809c4-cb79-4944-ba72-f5c7ff31d31a
# ╠═370ed029-2924-4012-bf10-b9b84887134f
# ╠═f5f6964f-fdaf-47cf-a4a7-81b5b1aac919
# ╠═b87fd0c4-9cea-407a-b9b9-b105476eea3a
# ╠═80d9c1bd-a9c1-45d6-95cc-d596084b28f6
# ╠═900f6e3a-706c-442e-ac2c-ceabc401727d
# ╟─3765d8d0-f256-4896-92bb-fa89823db786
# ╠═6b926ec7-5804-47a4-a034-7c93cd74179a
# ╠═ecea514a-c138-4607-9172-1609ab347e81
# ╠═734844f6-40d1-4908-b0c7-a8311f68306d
# ╠═2b5f4d3c-6384-4852-885b-511b27a9be56
