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
begin
	import PyCall
	ENV["JULIA_PYTHONCALL_EXE"] = "@PyCall"
	import PythonCall
end

# ╔═╡ 8b19061b-f877-4971-b33d-88465e26c350
import SpectralFitting, XSPECModels

# ╔═╡ 6a0125e7-9eb6-41ae-ad69-f09647d531a5
import Statistics

# ╔═╡ 68a19a89-c1b6-45d7-9c07-e43df3400339
import UUIDs

# ╔═╡ a14b8108-aa33-488b-94ac-6291ec2c2760
import Unitful, UnitfulAstro

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AstroImages = "fe3fc30c-9b16-11e9-1c73-17dabf39f4ad"
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
CairoMakie = "13f3f980-e62b-5c42-98c6-ff1f3baf88f0"
CategoricalArrays = "324d7699-5711-5eae-9e2f-1d82baa6b597"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Distributed = "8ba89e20-285c-5b6f-9357-94700520ee1b"
FLoops = "cc61a311-1640-44b5-9fba-1b764f453329"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
LoopVectorization = "bdcacae8-1622-11e9-2a5c-532679323890"
Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
PhysicalConstants = "5ad8b20f-a522-5ce9-bfc9-ddf1d5bda6ab"
Pkg = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyCall = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
PythonCall = "6099a3de-0909-46bc-b1f4-468b9a2dfc0d"
SpectralFitting = "f2c56810-742e-4b72-8bf4-27af3bb81a12"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
UUIDs = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"
UnitfulAstro = "6112ee07-acf9-5e0f-b108-d242c714bf9f"
XSPECModels = "e051c099-9e89-4e1f-aad2-39a4611ecf4d"

[compat]
AstroImages = "~0.5.0"
BenchmarkTools = "~1.5.0"
CSV = "~0.10.15"
CairoMakie = "~0.12.18"
CategoricalArrays = "~0.10.8"
DataFrames = "~1.7.0"
FLoops = "~0.2.2"
LoopVectorization = "~0.12.171"
Measurements = "~2.11.0"
PhysicalConstants = "~0.2.3"
Plots = "~1.40.9"
PlutoUI = "0.7"
PyCall = "~1.96.4"
PythonCall = "~0.9.23"
SpectralFitting = "~0.6.2"
Statistics = "~1.11.1"
Unitful = "~1.21.1"
UnitfulAstro = "~1.2.1"
XSPECModels = "~0.1.1"
"""

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
# ╟─00000000-0000-0000-0000-000000000001
