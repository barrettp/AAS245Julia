### A Pluto.jl notebook ###
# v0.20.0

using Markdown
using InteractiveUtils

# ╔═╡ c25ec42a-81aa-11ef-3780-0f7138e64b77
import Pkg; Pkg.activate(Base.current_project())

# ╔═╡ b7fa824f-72de-4763-ae60-1735bf3205cb
using CSV, DataFrames

# ╔═╡ 78a5f27a-8de7-4705-b58f-1f88b50cada5
import PlutoUI; PlutoUI.TableOfContents()

# ╔═╡ 91573039-f052-4e15-a3b4-94f983b12d2a
df = DataFrame(A=1:2:1000, B=repeat(1:10, inner=50), C=1:500)

# ╔═╡ 962f750e-5da3-4279-b391-71a3791aada6
df[!,:B] |> typeof

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

# ╔═╡ 6e27dc4c-3f5f-4de3-93c7-bc3cebfbee29


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


# ╔═╡ 8b5809c4-cb79-4944-ba72-f5c7ff31d31a
md"""
## Modifying DataFrames
"""

# ╔═╡ 370ed029-2924-4012-bf10-b9b84887134f


# ╔═╡ 3765d8d0-f256-4896-92bb-fa89823db786
md"""
## Plotting
"""

# ╔═╡ 6b926ec7-5804-47a4-a034-7c93cd74179a


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
# ╠═6e27dc4c-3f5f-4de3-93c7-bc3cebfbee29
# ╟─c0fad0e2-75f1-439e-b303-80c9157c9b74
# ╠═8e7c3dfd-0f99-47ba-bbfa-321e749cc6bd
# ╟─9420c5e5-e3f3-43d3-9da4-e2c1fdadd26a
# ╠═0183a9f1-733b-4bab-b5bb-1ff3209a6103
# ╟─8b5809c4-cb79-4944-ba72-f5c7ff31d31a
# ╠═370ed029-2924-4012-bf10-b9b84887134f
# ╟─3765d8d0-f256-4896-92bb-fa89823db786
# ╠═6b926ec7-5804-47a4-a034-7c93cd74179a
