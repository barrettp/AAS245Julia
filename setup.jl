### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ 43409ef6-72e4-4286-97f1-120a0ef96540
import Pkg

# ╔═╡ eed615b4-c184-4384-b0dc-f8ee3447ce62
using AstroImages

# ╔═╡ 6d510e03-6247-4f4b-842c-429af6575267
using BenchmarkTools

# ╔═╡ f32f1252-26c6-4598-96f9-77bc3de6a829
using CairoMakie

# ╔═╡ 45c9756e-07af-4e79-826e-326915e2aa94
using CategoricalArrays

# ╔═╡ 92ddf0f0-f174-4c96-90d7-7ea7905502e9
using DataFrames

# ╔═╡ 8a73b23d-8bae-4775-8150-8cd900e170ee
using Distributed

# ╔═╡ f430e418-e35d-43cd-95f5-50cabe95752e
using FLoops

# ╔═╡ f343b464-de53-4b1f-a289-4ff2cdfbc0dc
using LinearAlgebra

# ╔═╡ 6380be9b-9e37-4c47-8c7f-1b3a7dcb05cd
using LoopVectorization

# ╔═╡ 94f82621-7ea7-4944-912f-eba72cdcb8df
using Measurements

# ╔═╡ b5b3c885-6df5-4681-86ce-cd3bb4ea57fc
using PhysicalConstants

# ╔═╡ e0b3d4a3-b5d0-4ede-b893-23aab7fc31ed
using Plots

# ╔═╡ fad45a22-672b-48f6-adfc-205bc24d7f77
using Pluto

# ╔═╡ e87f4f0b-1f67-40b8-abba-a5618448e48f
using PlutoUI

# ╔═╡ 4d7f6651-d60e-4ffb-be36-2c656942bc68
using PyCall

# ╔═╡ 30aa2734-ec04-463b-8611-d586102ea48d
using PythonCall

# ╔═╡ 8b19061b-f877-4971-b33d-88465e26c350
using SpectralFitting

# ╔═╡ 6a0125e7-9eb6-41ae-ad69-f09647d531a5
using Statistics

# ╔═╡ 68a19a89-c1b6-45d7-9c07-e43df3400339
using UUIDs

# ╔═╡ a14b8108-aa33-488b-94ac-6291ec2c2760
using Unitful, UnitfulAstro

# ╔═╡ 238893ad-19e7-437d-803f-10511a763433
using XSPECModels

# ╔═╡ 1d172390-c561-11ef-127e-b3b5a71867b4
md"""
The intent of this notebook is only to set up all the packages in the environment.
"""

# ╔═╡ f0176dfe-b7b3-41d6-93b4-5334d7b74619
Pkg.Registry.add(url="https://github.com/astro-group-bristol/AstroRegistry")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Pkg = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.2"
manifest_format = "2.0"
project_hash = "1f8f362efbc96b36e3e02e3f6877c9789d681061"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

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

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"

    [deps.Pkg.extensions]
    REPLExt = "REPL"

    [deps.Pkg.weakdeps]
    REPL = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

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
# ╟─1d172390-c561-11ef-127e-b3b5a71867b4
# ╠═43409ef6-72e4-4286-97f1-120a0ef96540
# ╠═f0176dfe-b7b3-41d6-93b4-5334d7b74619
# ╠═eed615b4-c184-4384-b0dc-f8ee3447ce62
# ╠═6d510e03-6247-4f4b-842c-429af6575267
# ╠═f32f1252-26c6-4598-96f9-77bc3de6a829
# ╠═45c9756e-07af-4e79-826e-326915e2aa94
# ╠═92ddf0f0-f174-4c96-90d7-7ea7905502e9
# ╠═8a73b23d-8bae-4775-8150-8cd900e170ee
# ╠═f430e418-e35d-43cd-95f5-50cabe95752e
# ╠═f343b464-de53-4b1f-a289-4ff2cdfbc0dc
# ╠═6380be9b-9e37-4c47-8c7f-1b3a7dcb05cd
# ╠═94f82621-7ea7-4944-912f-eba72cdcb8df
# ╠═b5b3c885-6df5-4681-86ce-cd3bb4ea57fc
# ╠═e0b3d4a3-b5d0-4ede-b893-23aab7fc31ed
# ╠═fad45a22-672b-48f6-adfc-205bc24d7f77
# ╠═e87f4f0b-1f67-40b8-abba-a5618448e48f
# ╠═4d7f6651-d60e-4ffb-be36-2c656942bc68
# ╠═30aa2734-ec04-463b-8611-d586102ea48d
# ╠═8b19061b-f877-4971-b33d-88465e26c350
# ╠═6a0125e7-9eb6-41ae-ad69-f09647d531a5
# ╠═68a19a89-c1b6-45d7-9c07-e43df3400339
# ╠═a14b8108-aa33-488b-94ac-6291ec2c2760
# ╠═238893ad-19e7-437d-803f-10511a763433
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
