### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ 1d172390-c561-11ef-127e-b3b5a71867b4
md"""
The intent of this notebook is only to set up all the packages in the environment.
"""

# ╔═╡ 43409ef6-72e4-4286-97f1-120a0ef96540
begin
	import Pkg
	Pkg.Registry.add(url="https://github.com/astro-group-bristol/AstroRegistry")
end

# ╔═╡ eed615b4-c184-4384-b0dc-f8ee3447ce62
import AstroImages

# ╔═╡ 6d510e03-6247-4f4b-842c-429af6575267
import BenchmarkTools

# ╔═╡ f32f1252-26c6-4598-96f9-77bc3de6a829
import CairoMakie

# ╔═╡ 45c9756e-07af-4e79-826e-326915e2aa94
import CategoricalArrays

# ╔═╡ 92ddf0f0-f174-4c96-90d7-7ea7905502e9
import CSV, DataFrames

# ╔═╡ 8a73b23d-8bae-4775-8150-8cd900e170ee
import Distributed, FLoops, LoopVectorization

# ╔═╡ f343b464-de53-4b1f-a289-4ff2cdfbc0dc
import LinearAlgebra

# ╔═╡ 94f82621-7ea7-4944-912f-eba72cdcb8df
import Measurements, PhysicalConstants

# ╔═╡ e0b3d4a3-b5d0-4ede-b893-23aab7fc31ed
import Plots

# ╔═╡ e87f4f0b-1f67-40b8-abba-a5618448e48f
import PlutoUI

# ╔═╡ 4d7f6651-d60e-4ffb-be36-2c656942bc68
import PyCall, PythonCall

# ╔═╡ 8b19061b-f877-4971-b33d-88465e26c350
import SpectralFitting, XSPECModels

# ╔═╡ 6a0125e7-9eb6-41ae-ad69-f09647d531a5
import Statistics

# ╔═╡ 68a19a89-c1b6-45d7-9c07-e43df3400339
import UUIDs

# ╔═╡ a14b8108-aa33-488b-94ac-6291ec2c2760
import Unitful, UnitfulAstro

# ╔═╡ Cell order:
# ╟─1d172390-c561-11ef-127e-b3b5a71867b4
# ╠═43409ef6-72e4-4286-97f1-120a0ef96540
# ╠═eed615b4-c184-4384-b0dc-f8ee3447ce62
# ╠═6d510e03-6247-4f4b-842c-429af6575267
# ╠═f32f1252-26c6-4598-96f9-77bc3de6a829
# ╠═45c9756e-07af-4e79-826e-326915e2aa94
# ╠═92ddf0f0-f174-4c96-90d7-7ea7905502e9
# ╠═8a73b23d-8bae-4775-8150-8cd900e170ee
# ╠═f343b464-de53-4b1f-a289-4ff2cdfbc0dc
# ╠═94f82621-7ea7-4944-912f-eba72cdcb8df
# ╠═e0b3d4a3-b5d0-4ede-b893-23aab7fc31ed
# ╠═e87f4f0b-1f67-40b8-abba-a5618448e48f
# ╠═4d7f6651-d60e-4ffb-be36-2c656942bc68
# ╠═8b19061b-f877-4971-b33d-88465e26c350
# ╠═6a0125e7-9eb6-41ae-ad69-f09647d531a5
# ╠═68a19a89-c1b6-45d7-9c07-e43df3400339
# ╠═a14b8108-aa33-488b-94ac-6291ec2c2760
