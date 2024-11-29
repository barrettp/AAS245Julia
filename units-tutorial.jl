### A Pluto.jl notebook ###
# v0.20.3

using Markdown
using InteractiveUtils

# ╔═╡ f38cfc06-81aa-11ef-3139-af52386aa47a
import Pkg; Pkg.activate(Base.current_project())

# ╔═╡ e7981cc7-882f-4edb-a2a8-df6f1bf05a2a
using Unitful, UnitfulAstro

# ╔═╡ 4b4c3352-ebe8-400e-9e4a-c30a68242d1c
using PhysicalConstants: CODATA2018

# ╔═╡ debbc427-afcb-4819-8ef3-c8359a278340
using PhysicalConstants.CODATA2018: h, c_0, k_B

# ╔═╡ 309af238-b4f8-49cb-9be4-a3f14ef2be25
using CairoMakie

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

# ╔═╡ b96e76bf-16d6-4b38-b893-dbd31e49551f
md"""
The most straightforward way of creating units is through the `@u_str` macro, or, by putting a `u` in front of a string literal

```julia
u"km"     # kilometre
u"m/s"    # m/s
u"J*s"    # joule*second
```
"""

# ╔═╡ 719d7037-baac-4855-a57d-6eac29401ea2


# ╔═╡ e8dd3759-9c1b-409b-9157-a9ea2cf4b9b9
md"""
Even though they look like strings, they're a shorthand way of expressing units, so anything inside the quotes must be a valid Julia expression.
"""

# ╔═╡ c3954184-141e-421b-ba2f-96012ef1e868
md"""
### Unit objects
"""

# ╔═╡ aeb7f07a-0914-4675-b1ca-7bb891672025
md"""
Another way of using units is to import them directly from Unitful, and then we can place them next to number literals to multiply them.

```julia
using Unitful: m, s, minute
using UnitfulAstro: AU
```
"""

# ╔═╡ 8bcc51de-39e5-43d3-96d1-2f8e52b2e668


# ╔═╡ a90701d6-0396-40f2-b16b-87d07547ca7d
md"""
For example, we can check by multiplying the speed of light _c_ = 2.998×10⁸m/s with the duration for light from the sun to arrive to earth (≈ 8 mins) that it's approximately 1 AU.

```julia
isapprox(2.998e8m/s * 8.31minute, 1AU, rtol=1e-3)
```
"""

# ╔═╡ 27f28dff-d17b-476e-b05c-25d83795997b


# ╔═╡ 4ec88f8e-f98c-4cd2-a00c-3a6ef7dafc84
md"""
## Converting units
"""

# ╔═╡ 053e0ab1-3bf0-47b8-81cc-970badc00019
md"""
To convert between units, we can use the `uconvert` function. Note that it'll throw an error if two units don't have the same dimensions.

We can demonstrate this by getting Planck's constant in eV⋅s.

```julia
using PhysicalConstants: CODATA2018    # use the 2018 values by CODATA

CODATA2018.h    # check to make sure Planck's constant is what you expect

uconvert(u"eV*s", CODATA2018.h)
```
"""

# ╔═╡ 48d69c4f-8d20-4388-a8b7-ba5c6888acf5
md"""
### Units as functions
"""

# ╔═╡ dad07605-2a2c-4137-af14-01b83d17b13f
md"""
Alternatively, we can also "call" the units to convert them. This might not seem too useful, but we can use Julia's `|>` syntax to "pipe" a quantity into becoming a different unit.

For example, we can calculate how far a light year is in miles"
```julia
CODATA2018.c_0 * 1u"yr" |> u"mi"
```
"""

# ╔═╡ 213bd052-a49f-42e0-a604-f0b31c5d28ce


# ╔═╡ 73957fc7-ca46-4ab1-83e1-9776b8f7ff93
md"""
## Arithmetic
"""

# ╔═╡ 390b6958-31c0-4178-98d3-e329ea7d046a
md"""
Arithmetic on unitful quantities work like you'd expect. You can add and subtract quantities of same dimension, and multiply and divide quantities of any dimension to create new quantities.

```julia
1u"inch" + 1u"mi" # this should give an exact answer
```
```julia
distance = 3u"m"
```
```julia
duration = 9u"ms"
```
```julia
distance / duration |> u"km/hr"     # calculate speed, then convert to km/h
```
"""

# ╔═╡ 516f94c9-a43a-4cf7-adb1-455ea7970c6d


# ╔═╡ 6790961b-88e4-44b2-a47a-99c7b74d9367


# ╔═╡ 5490f990-ec78-433f-a580-2b58842b15d4


# ╔═╡ 3b63b03c-00da-4178-8b9a-59b4ff8db31d


# ╔═╡ a0ef6b7a-3289-4730-ad2b-1efb07a57a8e
md"""
Unitful quantities are a benefit of writing generic functions: the units can carry through. Further down in the notebook we've created a function for [spectral radiance of a blackbody (Planck's law)](https://en.wikipedia.org/wiki/Planck%27s_law), and we can find the maximum flux by searching over a range of wavelengths.

```julia
wavelength_range = 1.0u"nm":25u"nm":1u"m"

argmax(B, wavelength_range)
```
"""

# ╔═╡ 5a37ca8f-f7ce-4b01-b364-7a2caedfae7d


# ╔═╡ 3be02ac2-63f4-4d98-92bc-194ce914c3f9
md"""
## Logarithms of units
"""

# ╔═╡ dfdffa39-a2a7-4093-a8d6-da98b5fd7988
md"""
### Logarithmic units
"""

# ╔═╡ cd2c5d48-5105-4443-9f1e-b81c8a56b0a3
md"""
While special functions such as sine, cosine, exponentials, and logarithms only work on dimensionless quantities, it can be useful to define a unit in a logarithmic scale. Unitful.jl supports logarithmic scales with units such as dB, and UnitfulAstro.jl extends it with the magnitude system in the UBVRI bands:

```julia
1u"B_mag"
```

```julia
3*u"V_mag"/100
```

```julia
3u"B_mag" - 4u"V_mag" # B-V color
```
"""

# ╔═╡ 48baf5ad-a733-4950-9efd-991e7eeddad0


# ╔═╡ 59d96cd1-d2f5-4e5c-ba87-b42571f9f0c2


# ╔═╡ e5f03292-4294-4cc2-9085-034f9eb12b18


# ╔═╡ 564185de-ab79-4e7e-8de6-4aa585ea57dd
md"""
## Example: Planck's law
"""

# ╔═╡ 79dd9f59-2caa-4c7d-9bd6-890cab454515
md"""
We can also see the units come through in plots by plotting Planck's law for different temperatures. We have the code for Planck's law written below, you can try and create a plot that suits your needs!
"""

# ╔═╡ 666abdfb-a2ff-48b6-a533-c869d33d800d
B(λ, T = 3000u"K") = 2*h*c_0^2 / λ^5 * 1 / (exp(h*c_0/λ / (k_B * T)) - 1)

# ╔═╡ aeeb94a9-68f9-405d-a0e5-c7d727859586
md"""
As a start, we can try the following plot:
```julia
temperatures = (200:750:7000)u"K"
```

```julia
let f = Figure()
	ax = Axis(
		f[1,1],
		title = "Planck's law",
		xlabel = "Temperature", ylabel = "Radiance",
		xminorgridvisible = true, yminorgridvisible = true,
	)

	wavelengths = (75:25:2500)u"nm"
	for T in temperatures
		# get the radiance, and convert to W/m^3
		radiance = B.(wavelengths, T) .|> u"W/m^3"
		lines!(ax, wavelengths, radiance, label = string(T))
	end

	axislegend(ax)

	f
end
```
"""

# ╔═╡ 072107dc-cb23-47d6-8cc4-944ac394b46b


# ╔═╡ 172a863a-bee2-4915-8ce3-133ba925e158


# ╔═╡ 687b8ab2-27f4-4fbd-86ff-4ac8778df573
md"""
!!! warning "Makie & units"

    Due to a bug in Makie's rendering system, the units might not show up just as you expect, and only the first unit would be shown in the tick marks.
"""

# ╔═╡ a9d4d25d-042d-4a1e-bc2a-a1029aa322c4
md"""
## Measurements
"""

# ╔═╡ 7660e99c-b520-41d8-bd44-e77b1ffb6fa6
md"""
Julia also has a library Measurements.jl, for representing physical uncertainties with measurements. Combined with Unitful.jl, you can work on quantities exactly how they appear in the real world, and all the uncertainties and units will be propagated for you!

```julia
k = 2.5 ± 0.03 # raw measurement with uncertainty, no units
```

```julia
x = (9.1 ± 0.01)u"m"    # distancce measurement
t = (1.1 ± 0.2)u"s"     # time measurement
v = x / t               # calculated speed
```
"""

# ╔═╡ 1aefe863-1eb7-400e-83a8-7c89939e3dc6


# ╔═╡ 3d21a3ba-da61-434f-bcbf-122ccd4a546b


# ╔═╡ 780ec62f-e237-4ddc-a834-761e67bd718c
md"""
## Other extensions to Unitful
"""

# ╔═╡ 82814d6e-09bb-4a69-b532-0e9bbd355949
md"""
[Unitful.jl](https://github.com/PainterQubits/Unitful.jl) works well enough with other packages that JuliaAstro develops the package UnitfulAstro.jl for use by astronomers. Similarly, other extensions exist for Unitful.jl:

- [UnitfulAngles.jl](https://github.com/yakir12/UnitfulAngles.jl): units for different angle systems
- [UnitfulUS.jl](https://github.com/PainterQubits/UnitfulUS.jl): support for US customary units
- [UnitfulEquivalences.jl](https://github.com/sostock/UnitfulEquivalences.jl): conversion of quantities of different dimensions, like the energy and wavelength of a photon.
- [NaturallyUnitful.jl](https://github.com/MasonProtter/NaturallyUnitful.jl): Natural units
- [UnitfulAtomic.jl](https://github.com/sostock/UnitfulAtomic.jl): Atomic units
"""

# ╔═╡ Cell order:
# ╠═f38cfc06-81aa-11ef-3139-af52386aa47a
# ╠═e7981cc7-882f-4edb-a2a8-df6f1bf05a2a
# ╟─dc38f2b1-635b-4331-8b21-2a22f06974a6
# ╟─13f0294c-8f0a-4be4-b167-00b0beb1604a
# ╟─fb6a64b8-1785-4e40-9555-05bac33e8c76
# ╟─8f92a638-0d5c-4158-8ad4-f4a0013328e7
# ╟─b96e76bf-16d6-4b38-b893-dbd31e49551f
# ╠═719d7037-baac-4855-a57d-6eac29401ea2
# ╟─e8dd3759-9c1b-409b-9157-a9ea2cf4b9b9
# ╟─c3954184-141e-421b-ba2f-96012ef1e868
# ╟─aeb7f07a-0914-4675-b1ca-7bb891672025
# ╠═8bcc51de-39e5-43d3-96d1-2f8e52b2e668
# ╟─a90701d6-0396-40f2-b16b-87d07547ca7d
# ╠═27f28dff-d17b-476e-b05c-25d83795997b
# ╟─4ec88f8e-f98c-4cd2-a00c-3a6ef7dafc84
# ╟─053e0ab1-3bf0-47b8-81cc-970badc00019
# ╠═4b4c3352-ebe8-400e-9e4a-c30a68242d1c
# ╟─48d69c4f-8d20-4388-a8b7-ba5c6888acf5
# ╟─dad07605-2a2c-4137-af14-01b83d17b13f
# ╠═213bd052-a49f-42e0-a604-f0b31c5d28ce
# ╟─73957fc7-ca46-4ab1-83e1-9776b8f7ff93
# ╟─390b6958-31c0-4178-98d3-e329ea7d046a
# ╠═516f94c9-a43a-4cf7-adb1-455ea7970c6d
# ╠═6790961b-88e4-44b2-a47a-99c7b74d9367
# ╠═5490f990-ec78-433f-a580-2b58842b15d4
# ╠═3b63b03c-00da-4178-8b9a-59b4ff8db31d
# ╟─a0ef6b7a-3289-4730-ad2b-1efb07a57a8e
# ╠═5a37ca8f-f7ce-4b01-b364-7a2caedfae7d
# ╟─3be02ac2-63f4-4d98-92bc-194ce914c3f9
# ╟─dfdffa39-a2a7-4093-a8d6-da98b5fd7988
# ╟─cd2c5d48-5105-4443-9f1e-b81c8a56b0a3
# ╠═48baf5ad-a733-4950-9efd-991e7eeddad0
# ╠═59d96cd1-d2f5-4e5c-ba87-b42571f9f0c2
# ╠═e5f03292-4294-4cc2-9085-034f9eb12b18
# ╟─564185de-ab79-4e7e-8de6-4aa585ea57dd
# ╟─79dd9f59-2caa-4c7d-9bd6-890cab454515
# ╠═debbc427-afcb-4819-8ef3-c8359a278340
# ╠═666abdfb-a2ff-48b6-a533-c869d33d800d
# ╟─aeeb94a9-68f9-405d-a0e5-c7d727859586
# ╠═309af238-b4f8-49cb-9be4-a3f14ef2be25
# ╠═072107dc-cb23-47d6-8cc4-944ac394b46b
# ╠═172a863a-bee2-4915-8ce3-133ba925e158
# ╟─687b8ab2-27f4-4fbd-86ff-4ac8778df573
# ╟─a9d4d25d-042d-4a1e-bc2a-a1029aa322c4
# ╠═3eb2c9e4-94fe-4c94-ab9b-d6e2aa788e32
# ╟─7660e99c-b520-41d8-bd44-e77b1ffb6fa6
# ╠═1aefe863-1eb7-400e-83a8-7c89939e3dc6
# ╠═3d21a3ba-da61-434f-bcbf-122ccd4a546b
# ╟─780ec62f-e237-4ddc-a834-761e67bd718c
# ╟─82814d6e-09bb-4a69-b532-0e9bbd355949
