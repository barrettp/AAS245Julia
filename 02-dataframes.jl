### A Pluto.jl notebook ###
# v0.20.0

using Markdown
using InteractiveUtils

# ╔═╡ c25ec42a-81aa-11ef-3780-0f7138e64b77
import Pkg; Pkg.activate(Base.current_project())

# ╔═╡ b7fa824f-72de-4763-ae60-1735bf3205cb
using CSV, DataFrames

# ╔═╡ 177a8009-ea8b-46d4-bdfb-ef5e1e15ca0d
using Downloads

# ╔═╡ ecea514a-c138-4607-9172-1609ab347e81
using CairoMakie

# ╔═╡ 78a5f27a-8de7-4705-b58f-1f88b50cada5
import PlutoUI; PlutoUI.TableOfContents()

# ╔═╡ 91573039-f052-4e15-a3b4-94f983b12d2a
demo_df = DataFrame(A=1:2:1000, B=repeat(1:10, inner=50), C=1:500)

# ╔═╡ 962f750e-5da3-4279-b391-71a3791aada6
demo_df[!,:B] |> typeof

# ╔═╡ 3ebfbc37-294d-4659-b3b8-7e41a4469e84
md"""
## Basic structure
"""

# ╔═╡ 57d7fdba-97a1-4b26-94df-d2aaca2deb7a
md"""
Make look nicer
- DataFrames are created columns at a time
- Indexing into a column with view rather than slice is easier than for rows?
- Each column is a simple vector, not a specific series type object made for dataframes
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
# ╠═b7fa824f-72de-4763-ae60-1735bf3205cb
# ╟─78a5f27a-8de7-4705-b58f-1f88b50cada5
# ╠═91573039-f052-4e15-a3b4-94f983b12d2a
# ╠═962f750e-5da3-4279-b391-71a3791aada6
# ╟─3ebfbc37-294d-4659-b3b8-7e41a4469e84
# ╠═57d7fdba-97a1-4b26-94df-d2aaca2deb7a
# ╠═d079e4d6-e8e2-4793-b892-f706dddbd2d9
# ╟─c65b63ad-9f94-4253-bfe1-d83e2769e630
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
