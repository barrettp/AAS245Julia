### A Pluto.jl notebook ###
# v0.20.1

using Markdown
using InteractiveUtils

# ╔═╡ f38cfc06-81aa-11ef-3139-af52386aa47a
import Pkg; Pkg.activate(Base.current_project())

# ╔═╡ e7981cc7-882f-4edb-a2a8-df6f1bf05a2a
using Unitful, UnitfulAstro

# ╔═╡ 3eb2c9e4-94fe-4c94-ab9b-d6e2aa788e32
using Measurements

# ╔═╡ dc38f2b1-635b-4331-8b21-2a22f06974a6
import PlutoUI; PlutoUI.TableOfContents()

# ╔═╡ 13f0294c-8f0a-4be4-b167-00b0beb1604a
md"""
## Creating "unitful" quantities
"""

# ╔═╡ fb6a64b8-1785-4e40-9555-05bac33e8c76
md"""
The Unitful.jl library allows you to add units to any variable, and to perform calculations with consistent dimensions
"""

# ╔═╡ 8f92a638-0d5c-4158-8ad4-f4a0013328e7
md"""
### `u"..."` macro
"""

# ╔═╡ c3954184-141e-421b-ba2f-96012ef1e868
md"""
### Unit objects
"""

# ╔═╡ aeb7f07a-0914-4675-b1ca-7bb891672025


# ╔═╡ 4ec88f8e-f98c-4cd2-a00c-3a6ef7dafc84
md"""
## Converting units
"""

# ╔═╡ 053e0ab1-3bf0-47b8-81cc-970badc00019


# ╔═╡ 48d69c4f-8d20-4388-a8b7-ba5c6888acf5
md"""
### Units as functions
"""

# ╔═╡ 73957fc7-ca46-4ab1-83e1-9776b8f7ff93
md"""
## Arithmetic
"""

# ╔═╡ 0dd49fe5-c380-4157-8eda-b8ad3711034c
1u"inch" + 1u"mi"

# ╔═╡ 2cb2e47a-1df8-471f-b8bb-2dbf1b885586
distance = 3u"m"

# ╔═╡ 516f94c9-a43a-4cf7-adb1-455ea7970c6d
duration = 9u"ms"

# ╔═╡ 6790961b-88e4-44b2-a47a-99c7b74d9367
distance / duration |> u"km/hr"

# ╔═╡ 57de6e0c-7b87-4f5b-b3b3-50d905d4b6d6
md"""
Maybe do a root-finding example here?
"""

# ╔═╡ 3be02ac2-63f4-4d98-92bc-194ce914c3f9
md"""
## Logarithms of units
"""

# ╔═╡ dfdffa39-a2a7-4093-a8d6-da98b5fd7988
md"""
### Logarithmic units
"""

# ╔═╡ 564185de-ab79-4e7e-8de6-4aa585ea57dd
md"""
## Differential equations integration
"""

# ╔═╡ 23b2db6d-dd15-4d74-b026-f6a18f3e1d11
md"""
TODO: Maybe do the dM_r/dr equation?

and plot it using both grams vs. cm and Msun vs. Rsun
"""

# ╔═╡ fa785498-f169-4066-9ef1-40e0ce4fbf9e
md"""
Lane--Emden for _n_ = 1 (neutron stars)
"""

# ╔═╡ e3171714-4b3f-489d-9f16-4b65b63dedce
md"""
```math
θ(ξ) = \frac{\sin(ξ)}{ξ}
```
"""

# ╔═╡ 50ee6b74-6594-4c63-8b1b-2897c1f1c70c
md"""
```math
α_1 ξ = r
```
"""

# ╔═╡ 1a3ee010-935b-4e13-b122-e1ad8a25532d
md"""
```math
α_1^2 = 2 K ρ_c^{\frac{1}{1} - 1} / 4π G
= 2 K / 4πG = K/2πG
```
"""

# ╔═╡ 2be72a6e-199c-4f7b-9f7e-486fac2e151b
md"""
```math
α_1 = \sqrt{\frac{K}{2πG}}
```
"""

# ╔═╡ 755e1363-6523-442f-b90a-5e27d54438ba
md"""
```math
r = \sqrt{\frac{K}{2πG}} \xi
```
"""

# ╔═╡ d8f774c8-3a7d-4486-8500-803105cddbcf
md"""
Know radius ``R_⋆ = `` and mass ``M_⋆ = ``
"""

# ╔═╡ f938f5d4-c5dc-420b-8379-8143e8a54b1b
md"""
``θ = 0`` when ``ξ = ξ_⋆ = π``, i.e., ``ρ = 0`` when ``r = R_⋆ = \sqrt{\dfrac{Kπ}{2G}}``. Figure out ``K`` from known radius
"""

# ╔═╡ 950d0ef5-4ae3-49b8-a508-fd7c26fa3645
md"""
```math
ρ(r) = ρ_c θ(ξ) = ρ_c \frac{\sin(r/α_1)}{r/α_1}
```
"""

# ╔═╡ 55535ccf-aa91-4a76-9443-e6a6dd9dfd99
md"""
```math
M_⋆ = \int_0^{R_⋆} 4π r^2 ρ(r) \, dr
= \int_0^π 4π α_1^2 ξ^2 ρ_c \frac{\sin(ξ)}{ξ} α_1 dξ
= 4π α_1^3 ρ_c \int_0^π ξ^2 \frac{\sin(ξ)}{ξ} \, dξ
= 4π α_1^3 ρ_c π
```
"""

# ╔═╡ 88faab5c-6a5e-41ed-917c-498ace40c35a
md"""
```math
M_⋆ = 4π^2 \frac{K}{2πG} \sqrt{\frac{K}{2πG}} ρ_c
= \frac{2Kπ}{G} \sqrt{\frac{K}{2πG}} ρ_c
= \frac{K}{G} \sqrt{\frac{2πK}{G}} ρ_c
```
"""

# ╔═╡ a9d4d25d-042d-4a1e-bc2a-a1029aa322c4
md"""
## Measurements?
"""

# ╔═╡ 780ec62f-e237-4ddc-a834-761e67bd718c
md"""
## Other extensions to Unitful
"""

# ╔═╡ 82814d6e-09bb-4a69-b532-0e9bbd355949
md"""
UnitfulUS and whatever else
"""

# ╔═╡ Cell order:
# ╠═f38cfc06-81aa-11ef-3139-af52386aa47a
# ╠═e7981cc7-882f-4edb-a2a8-df6f1bf05a2a
# ╟─dc38f2b1-635b-4331-8b21-2a22f06974a6
# ╟─13f0294c-8f0a-4be4-b167-00b0beb1604a
# ╠═fb6a64b8-1785-4e40-9555-05bac33e8c76
# ╠═8f92a638-0d5c-4158-8ad4-f4a0013328e7
# ╟─c3954184-141e-421b-ba2f-96012ef1e868
# ╠═aeb7f07a-0914-4675-b1ca-7bb891672025
# ╠═4ec88f8e-f98c-4cd2-a00c-3a6ef7dafc84
# ╠═053e0ab1-3bf0-47b8-81cc-970badc00019
# ╠═48d69c4f-8d20-4388-a8b7-ba5c6888acf5
# ╠═73957fc7-ca46-4ab1-83e1-9776b8f7ff93
# ╠═0dd49fe5-c380-4157-8eda-b8ad3711034c
# ╠═2cb2e47a-1df8-471f-b8bb-2dbf1b885586
# ╠═516f94c9-a43a-4cf7-adb1-455ea7970c6d
# ╠═6790961b-88e4-44b2-a47a-99c7b74d9367
# ╠═57de6e0c-7b87-4f5b-b3b3-50d905d4b6d6
# ╠═3be02ac2-63f4-4d98-92bc-194ce914c3f9
# ╠═dfdffa39-a2a7-4093-a8d6-da98b5fd7988
# ╠═564185de-ab79-4e7e-8de6-4aa585ea57dd
# ╠═23b2db6d-dd15-4d74-b026-f6a18f3e1d11
# ╠═fa785498-f169-4066-9ef1-40e0ce4fbf9e
# ╠═e3171714-4b3f-489d-9f16-4b65b63dedce
# ╠═50ee6b74-6594-4c63-8b1b-2897c1f1c70c
# ╠═1a3ee010-935b-4e13-b122-e1ad8a25532d
# ╠═2be72a6e-199c-4f7b-9f7e-486fac2e151b
# ╠═755e1363-6523-442f-b90a-5e27d54438ba
# ╠═d8f774c8-3a7d-4486-8500-803105cddbcf
# ╠═f938f5d4-c5dc-420b-8379-8143e8a54b1b
# ╠═950d0ef5-4ae3-49b8-a508-fd7c26fa3645
# ╠═55535ccf-aa91-4a76-9443-e6a6dd9dfd99
# ╠═88faab5c-6a5e-41ed-917c-498ace40c35a
# ╠═a9d4d25d-042d-4a1e-bc2a-a1029aa322c4
# ╠═3eb2c9e4-94fe-4c94-ab9b-d6e2aa788e32
# ╠═780ec62f-e237-4ddc-a834-761e67bd718c
# ╠═82814d6e-09bb-4a69-b532-0e9bbd355949
