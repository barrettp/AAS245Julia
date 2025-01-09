### A Pluto.jl notebook ###
# v0.19.36

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 20b9ba30-2685-4535-9244-693f8e653a9a
using  PlutoUI; TableOfContents()

# ╔═╡ b5cce500-d400-4281-af5a-e8fa3945080d
using Unitful, UnitfulAstro

# ╔═╡ ef04a84f-468f-4cb2-866e-75877976c634
using SkyCoords, AstroAngles

# ╔═╡ 225e71b3-6807-460f-aa53-35e5b237fa3f
using StatsBase, Distributions

# ╔═╡ 4df792be-852b-49e3-9f74-43b76bd682dc
using Images

# ╔═╡ e28bad2f-f4ea-4c30-9f08-746ca2f609d8
using AstroImages

# ╔═╡ 98d2310d-a17b-4b0d-877d-9f77020848d3
using Plots 

# ╔═╡ de89f308-a0f2-4ac0-b0f5-561a75461da7
using PSFModels

# ╔═╡ 67cf72e1-a0a9-424f-af0b-f3c211a5dcc1
using Statistics

# ╔═╡ 1877c9ea-77e9-11ed-11b3-4d295a402999
md"""
# JuliaAstro packages

The JuliaAstro community maintains a number of infrastructure-style packages. Documentation for all JuliaAstro packages is available at [juliaastro.org](https://juliaastro.org).

This section includes a tour of packages from the JuliaAstro ecosystem.
We've focused on basic packages that are widely applicable across astronomy.

"""

# ╔═╡ a2a1dc5d-df2b-4123-98bb-15c9050c5a50
md"""
## Coordinates, Dates and Times
"""

# ╔═╡ e02a52c2-87f2-486e-ab07-1ffb4f53d235
md"""
### UnitfulAstro

The [UnitfulAstro.jl](http://juliaastro.org/UnitfulAstro.jl/stable/) package extends Unitful.jl with astro-specific units, like ergs, magnitudes, arcseconds, or megaparsecs.
"""

# ╔═╡ 61113246-41c1-4e66-b94c-f5026210a9d2
dist = 1u"ly" + 3u"pc"

# ╔═╡ 3f024b80-ceb2-4d08-a2f5-58de99df07f7
md"""
The `u" "` syntax is a string macro to create a Unitful object. Putting it next to a number is just multiplication, i.e. `3x`==`3 * x` in Julia.
"""

# ╔═╡ fda9adf6-1e2f-4070-933f-6cc942705759
md"""
!!! tip
	You can directly import units you plan to use to avoid using the `u" " macro:

	```julia
	using UnitfulAstro: ly, pc, Mpc
	dist2 = 1ly + 3pc
	```

"""

# ╔═╡ 36fd0268-75fc-4ba3-8f84-0f3f846caf72
md"""
Try writing a mathematical expression of your own using units from Unitful and/or UnitfulAstro:
"""

# ╔═╡ 5053717e-fd01-459a-b70d-bcac14b951b5


# ╔═╡ e08cdd53-efd8-4edd-8473-7df5a19a5c2e
md"""
### SkyCoords.jl and AstroAngles.jl

The SkyCoords package allows one to use and convert between the following astronomical coordinate systems:

   * ICRSCoords: ICRS coordinates system
   * GalCoords: Galactic coordinates system
   * FK5Coords: FK5 coordinates system (with arbitrary equinox)

The AstroAngles package allows one to parse and format a variety of common coordinate formats. We'll combine the two!
"""

# ╔═╡ 83d22ddc-1604-40b5-b9fa-bad6164c944d
c1 = ICRSCoords(0.0, 0.0)  # inputs are ra, dec in radians

# ╔═╡ f8b980d0-b50a-49fc-a46b-5be5ad3ea076
c1.ra, c1.dec

# ╔═╡ 35ad16d0-553e-43e1-8db2-aae985ad42f0
md"""
We can freely convert between coordinate systems using the Base julia function `convert`:
"""

# ╔═╡ 0c424458-30bd-42a4-a22b-3b67c32c47ac
c2 = convert(GalCoords, c1) # convert to a different system

# ╔═╡ 1a3a84c3-05fa-435d-a530-ac3382a4328d
c2.l, c2.b

# ╔═╡ 27faa59b-38e6-4c5b-8f5f-4ed0b54c5f6a
md"""
Now we will use AstroAngles to parse a coordinate from a human readable format
"""

# ╔═╡ 52414d63-fb02-4947-90b0-d7bc648c31fb
c3 = ICRSCoords(hms"05:34:31.94", dms"+22:00:52.2")

# ╔═╡ 3f8f27ca-79da-4b68-91ee-a25259c31a2b
md"And we can convert back for pretty display"

# ╔═╡ 1249c36b-8965-42ff-8f04-b953f5556d37
rad2hms(c3.ra), rad2dms(c3.dec)

# ╔═╡ 03303442-538d-4ca1-9b29-01526ed811b3
 format_angle(rad2hms(c3.ra); delim=["h", "m", "s"])

# ╔═╡ 076730e8-ff5e-48d6-b021-a1308f3bc510
md"""
You can easily deploy all these functions against a table of data using broadcasting
"""

# ╔═╡ 35ef3963-93b9-43be-a2ae-f7038507e9fc
md"""
#### Separation between points
A common task if determinging the separation between two points. The `separation` function makes this easy regardless of the coordinate system.
"""

# ╔═╡ cde9a068-8ad3-4dce-a2f8-a4e1443bc814
mizar = FK5Coords{2000}(3.507787, 0.958628)

# ╔═╡ 3ce04b87-85d5-4ab5-9ca0-168d9f515003
alcor = GalCoords(1.968189, 1.072829)

# ╔═╡ aba82503-f1ca-44b4-85bc-4016fa121407
separation(mizar, alcor) # radians

# ╔═╡ 5d013ab7-8717-47b3-9d77-aa2e8ca32821
position_angle(mizar, alcor) # radians

# ╔═╡ 8b542f5b-e49a-4fd6-947a-de4738b371c4
md"""
Currently missing from the SkyCoords package is a nice way to represent offset coordinates. That is, point $A$ + $b$ where $b$ is an offset vector in milliarseconds assuming local tangent plane projection.

This would be a great first contribution to the JuliaAstro ecosystem!
"""

# ╔═╡ 3854541f-b144-4c7f-935b-fea45c55b948
md"We will return to WCS (World Coordinate System) handling in the Images section"

# ╔═╡ 4e853fc4-df91-4606-a86c-47f44a7c54dd
md"""
## Statistics and Numerical Utilities

Finally, here are a few general purpose libraries that are useful for various statistical work.

There are two libraries at the moment: Statistics and StatsBase. Statistics is a standard library in Julia and contains basic methods like `mean` of a vector. StatsBase is a separate package that adds advanced functionality on top. For instance, weighted means, statistical tests, modeling fitting, and sampling.

Statistics.jl will likely be removed as a standard library and merged with StatsBase in the next year or so.

Finally, the package Distributions.jl defines a huge range of useful statistical distributions and tools for working with them.
"""

# ╔═╡ 20aaacc9-ecdd-4fca-9c2e-74607c89976c
md"""
The StatsBase package provides statistical tools beyond the built in Statistics package. Note: the Statistics and StatsBase libraries will likely be merged into a single package in the near future.
"""

# ╔═╡ c0640519-50cf-431b-b9f7-24e55c1e5132
# Let's generate some random data
a = rand(1000) .^ rand(1000) 

# ╔═╡ 96dba716-7fb6-4c0f-b5a1-46a0c4df9f45
# Now we can use the `fit` function to fit a histogram model to this data.
# We first put the type of thing we would like to fit to our data, follow by the data itself.
hist1 = fit(Histogram, a)
# full syntax: fit(Histogram, data, weight, edges; closed=:left, nbins)
# Also supports 2D and higher dimensional histograms

# ╔═╡ 6dd88538-c47f-4848-b17a-118dd6bc4210
hist1.weights

# ╔═╡ 81eb1d00-331a-4558-83d4-ef1aeae18e11
md"""
Plot recipes are included. Just type the following to see the histogram:
```julia
plot(hist1)
```
"""

# ╔═╡ 2f3a4cd7-2528-4d16-8e84-dbfb512795b2


# ╔═╡ 54be2acc-25f9-4d97-8033-1fa1fd61f577
md"""
The `Distributions` package provides a vast array of statistical distributions.
Let's use a couple to generate random data.
"""

# ╔═╡ 295497e3-c2fe-44e6-bd14-7607490f7389
d1 = Normal(2, 3) # Gaussian distribution of 2 ± 3

# ╔═╡ ae1f0817-1472-43f9-a552-3a36fec0b988
# Draw 1000 random values from the distribution d1
dat2 = rand(d1, 10000)

# ╔═╡ ccc94c32-0d02-4a9f-9251-513b35283dfb
md"""
Try fitting a histogram to `dat2` and plotting it:
"""

# ╔═╡ bd630d66-76ed-417d-95b3-246a072cb550


# ╔═╡ 24fdd051-539b-4cf3-99df-219f8d490efd
md"""
The `StatsBase.fit` function is implemented by many packages, including Distributions. We can, for example, fit a Normal distribution to `dat2` directly:


```julia
fit(Normal, dat2)
```
"""

# ╔═╡ 9e159efd-2e63-4c98-b324-6be84bf62e00


# ╔═╡ fec3fe38-f06f-420e-89d3-ca67020be665


# ╔═╡ 84ae9cc5-7f3a-46b0-9834-a97fb09e5463
md"""
Many other statistical distributions are supported.
Try `Poisson` and `LogNormal`:
"""

# ╔═╡ 38ff5cc4-53a5-4888-a95c-1de8ec3fd7b1


# ╔═╡ 4b0c3389-8647-4f9a-89d5-0a8590a6a2f6
md"""
You can also "truncate" or "censor" most distributions:
"""

# ╔═╡ 5cff6888-c44c-4510-b6b2-5ce6206e96e9
truncated(
	Normal(3, 2),
	0.0, Inf
)

# ╔═╡ b6444e15-481b-4bca-9c6f-231a7eb664e3
censored(
	Normal(3, 2),
	0.0, Inf
)

# ╔═╡ a0e73b67-d027-40af-a29a-9d13f513cb43
md"""
### Tabular Data

Julia packages across the ecosystem all follow a standard, interpoperable Table format. You'll see this called "Tables.jl compatible".

What this means, is that you can load data from almost any kind of file (CSV, SQLLite, Arrow, HDF5, etc.) store it in your favourite kind of table (DataFrame, TypedTable, a simple named tuple, etc.) and use it with any kind of analysis package that accepts tables.

Let's see a basic example.


The most basic kind of table is just a `NamedTuple` of vectors, each having the same length.
"""

# ╔═╡ 27b6ad8c-110b-4921-ba22-315978a07aa9
# This is a basic kind of table --- a named tuple of vectors.

nt_tbl = (
	θ     = rand(Normal(3, 2), 100_000),
    ϕ     = rand(TruncatedNormal(2,1, 0, 2.5), 100_000),
    ξ₁    = rand(Beta(1.4, 20), 100_000)
)

# ╔═╡ ba77d1a5-d00f-4c53-8c3c-234fd7a8f9d8
nt_tbl.θ

# ╔═╡ e16df48a-4b56-4777-9222-2454de41496b
md"""
For more advanced usages, the [DataFrames.jl](https://dataframes.juliadata.org/stable/) package offers an excellent Pandas-like experience.

[CSV.jl](https://csv.juliadata.org/latest/) can be used to load CSV files into any table.
"""

# ╔═╡ 3d605975-e4a6-4c2f-9204-b0365169bafa
md"""
### Corner Plots
(StatsPlots.jl)[https://sefffal.github.io/PairPlots.jl/dev] includes some functions for quick grids of scatter plots, but a more complete package is the dedicated PairPlots.jl

PairPlots has one function `pairplot` that produces plots similar to those of the Python corner.py

`pairplot` takes one argument, any tables.jl compatible data table, and returns a corner plot. There are various ways of customizing the output.

!!! note
	It would take while to install the Makie plotting package used below. Try this example at a later date.

```julia
using CairoMakie
using PairPlots

mat = randn(10000,6)
pairplot(mat)
```

![](https://github.com/sefffal/PairPlots.jl/blob/master/examples/sample.png?raw=true)
"""

# ╔═╡ 7e89e63c-7aac-4953-99b7-ce3a21a7ebfc
md"""
## Images
A wide range of astronomical data either begins, or ends up represented as a raster image.
Julia possesses packages for loading, manipulating, analyzing, and visualizing image data from a wide range of formats.

Before diving into astronomy specifics, let's look at basic image loading and manipulation.
"""

# ╔═╡ 86c5124e-6200-4f0e-9ae4-602ba1738e73
md"""
### Images.jl
This umbrella package provides basic image loading, manipulation, and display functionalities for Julia/.

The basic way to represent an image in Julia is simply as a `Matrix` of data. It can either be simply numerical values like `Float32` or a composite type like `RGB{Float32}` to represent colour data. 

As we'll see later, hyperspectral data like an IFS cube is best stored as a 3D `Array` where one axis represents wavelength.
"""

# ╔═╡ 0b1606f5-1d5e-40a1-9e51-5da35b5f07ed
# The `load` function will select the right package to load almost any kind of data, provided that it is already installed.
fname = download("https://live.staticflickr.com/3851/14429271030_9abe62b5a2_b.jpg") 
# Image CC BY-NC-ND 2.0 Howard Ignatius 

# ╔═╡ 0598fb2c-ce34-4ff2-8a27-826a5e2bb119
img1 = load(fname)

# ╔═╡ f7ee0602-1687-47b6-b456-062d23116e1f
typeof(img1)

# ╔═╡ 15e8d764-9047-4cfc-8f2e-fd2ddd21734c
eltype(img1)

# ╔═╡ 6220232b-3f76-4d7b-9094-c8e79a0c5ba0
md"""
We can apply arbitrary transformations to images using `warp(image, transformation)`. There are also convenience functions for common transformations like `imresize` and `imrotate`.

!!! tip
	The companion function `warpedview` creates a transformation on the fly that shares memory with the underlying image.

Try rotating `img1` by 35 degrees using `imrotate`, and shirnking it using `imresize(img1; ratio=0.1)`


!!! info
	Use `deg2rad` to convert an angle in degrees into radians

"""

# ╔═╡ 52478779-d923-4979-94de-b60b952f69be


# ╔═╡ d188b1a7-35e9-45ca-afc5-cb3371d06fbd


# ╔═╡ 1866bca0-4d59-4708-8b1e-c157674563b8


# ╔═╡ 0231f3a4-f1d9-41aa-b7bd-4efa12020975
md"""
### FITS Files
FITS, or the Flexible Image Transport System is one of the most common ways of storing raster data in astronomy. 
A FITS file consists of one or more header-data units which are an array (2+D) or table combined with metadata.

In Julia, FITS files can be accessed using the FITSIO.jl library. A higher level interface is provided by AstroImages.jl
"""

# ╔═╡ 5178a7ca-af86-4f46-8a09-335f2a2f75bd
md"""
AstroImages provides the `imview` function. Pass any array to `imview` to visualize it with DS9-style color mappings
"""

# ╔═╡ 19d96665-aa97-44c1-8d6c-5adc7ef0a75f
A = rand(50, 50)

# ╔═╡ 6cc02e65-198f-4065-9482-2297b4c48e5d
imview(A,)

# ╔═╡ 0113f9d3-a75a-40cf-855f-4a24bb39ab09
md"""
Let's see how we can load FITS images using AstroImages.jl.

First, we'll download one:
"""

# ╔═╡ c86ded0d-c9ba-4489-81e8-208103af8389
# Download a Hubble image of the Eagle nebula
download(
    "http://www.astro.uvic.ca/~wthompson/astroimages/fits/656nmos.fits",
    "eagle-656nmos.fits"
)

# ╔═╡ 825c542e-5431-4fe3-8c31-1a427ede5fe0
# The `load` function will select the right package to load almost any kind of data, provided that it is already installed.
eagle = load("eagle-656nmos.fits") # Default is to load the first Image HDU found.

# ╔═╡ 07b03daa-be32-44a0-b8f1-3e7b058a99e4
# Let's force the output into plain-text mode
show(stdout, "text/plain", eagle)

# ╔═╡ 5a25127d-bb63-4ff0-a4e8-a80d72ae76d6
md"""
We see that the data is stored as a special kind of array called an AstroImage. The array also stores the headers:


```julia
header(eagle)
```
"""

# ╔═╡ 550388fa-86ed-4c5d-b564-8a547bdd9acd


# ╔═╡ c2c38c57-459a-4ea0-9ced-a2a2df6e4f91
eagle["DEC_SUN"] # Get header value by key

# ╔═╡ 207dd879-65ee-46ec-b232-7a4055c743a1
eagle["DEC_SUN",Comment] # Access header comment

# ╔═╡ 68ef3a5e-e5a4-4f3a-bcfa-2c1ff90447bb
md"""
The image is displayed automatically, but we can customize it by calling `imview`.
"""

# ╔═╡ 0628d2c4-b441-4ab0-b2f3-40b9dc0eb26e
imview(eagle; cmap=:viridis, stretch=asinhstretch)

# ╔═╡ 0ac24750-ad95-4dca-b168-cb477220cadd
md"The available arguments are similar to both astropy and DS9. Using PlutoUI.jl we can make our own interactive interface."

# ╔═╡ 25406593-9d9a-48dd-ad63-5f61e38533e3
begin
	eagle_small = eagle[begin:4:end, begin:4:end];
	eagle_small[eagle_small .== 0] .= NaN
end;

# ╔═╡ 0e8a9812-f872-4bfe-99f4-24a5a6471db5
@bind cmap Select([:magma, :viridis, :ice, :turbo])

# ╔═╡ 0a080582-c1b7-4996-944a-7a5067b2c9cf
@bind stretch Select([identity, asinhstretch, sqrtstretch])

# ╔═╡ da2f371b-27e9-4e0a-b4a4-ca5051331482
clims = (0, 256)

# ╔═╡ 90de9e65-f11f-4886-a2b9-d19237a55e96
@bind contrast Slider(0:0.1:2, default=1)

# ╔═╡ 2d12d253-b6b3-455f-a26f-18238a6a0bc1
@bind bias Slider(0:0.04:1, default=0.5)

# ╔═╡ 6b007e23-816e-465f-b06f-a689dc2fcb8f
imview(eagle_small; contrast, bias, cmap, stretch, clims)

# ╔═╡ 9c2bc328-0588-486a-978a-55075377bc60
html"""
<br/>
<br/>
"""

# ╔═╡ bcd7422c-25ef-45a2-abbc-e13474743c55
md"""
In addition to `imview`, we can use `implot` with the same arguments to annotate the image with coordinates and a colorbar. This also allows one to overplot the image with lines and points.

Try displaying `eagle` using the `implot` function:
```julia
implot(eagle)
```
"""

# ╔═╡ d2bb443f-cff9-4488-8cc2-09df3d5f2085


# ╔═╡ ab693fa0-af1f-43ee-98a9-c3875b869a1d
md"""
Now try displaying `eagle` with `stretch` set to `logstretch`:
"""

# ╔═╡ e9e75e0f-f788-46c7-b869-7a27b70f6f8b


# ╔═╡ 243123af-9f80-48ab-afc2-e4ca460ca0cd
md"""
Using `world_to_pix` and `pix_to_world` we can convert image coordinates to and from celestial coordinates.

Try the following snipped to add a line 1' long:


```julia
begin
	point1_px = [800,800]
	point1_world = pix_to_world(eagle, point1_px)
	point2_world = point1_world .+ [0, 1/60]
	point2_px = world_to_pix(eagle, point2_world)
	implot(eagle, grid=false)
	plot!(
		# X coordinates
		[point1_px[1], point2_px[1]],
		# Y coordinates
		[point1_px[2], point2_px[2]],
		linewidth=4,
		label="annotation 1",
		color=:white
	)
end
```
"""

# ╔═╡ 88ef0704-4b3e-4a93-b12a-03a1f3af337d


# ╔═╡ d34c051b-42b9-4dc6-8545-cd9d8d3b8522


# ╔═╡ 5ffe3c8c-c4f8-472a-9ff7-a441aec55d00
md"""
### PSF Models and Photometry
A frequent task in optical astronomy is to fit a PSF model and extract position and photometry of a source. We can do this in Julia using PSFModels.jl. 

If we want to apply this on a larger scale like detecting and measuring all sources in an image, background extraction, etc., we can combine PSFModels.jl with Photometry.jl
"""

# ╔═╡ a4a2dbf4-ed31-4f70-a759-500200a2482f
ex1 = PSFModels.airydisk(;fwhm=10, x=0, y=0)

# ╔═╡ ab416b08-d064-496b-9838-dc61c26db1b5
imview( ex1.(-100:100, (-100:100)'), stretch=logstretch )

# ╔═╡ eb4e4f4e-13f2-4f51-a26b-31462dfb7948
cutout = eagle[580:620,1:60];

# ╔═╡ 2a533b46-b77f-4b9f-8716-a55df00b0a03
implot(cutout; clims=extrema)

# ╔═╡ 3acbdc96-0ed2-4e54-9636-3ef65ab7dc17
maximum(cutout)

# ╔═╡ ecbd56d2-3d64-4d07-b39c-a524b33b5f33
# Fit a PSF model given some initial parameter values
bestfitparams, synthetic_psf = PSFModels.fit(
	PSFModels.airydisk,
	# Specify initial values as a named tuple
	(;x=22, y=25, fwhm=4, amp=2.3e3, bkg=median(cutout)),
	cutout
);

# ╔═╡ 99b105f0-cdd8-4275-8351-41f8a5da8c48
# We get updated best fitting parameters back 
bestfitparams

# ╔═╡ fda0176d-ab94-4bd8-abe4-3e9cfc8de389
bestfitparams.amp

# ╔═╡ d32cded1-14a5-44ef-ac29-100a9b49f00d
# Along with a function representing the best fit PSF
synthetic_psf(10,30)

# ╔═╡ 4c1c5567-4d88-44b1-bccb-7e160d53bf6e
imview(
	synthetic_psf.(axes(cutout,1), axes(cutout,2)'),
	clims=extrema
)

# ╔═╡ 9bc0ce60-911e-4983-9f5a-102a41396cef
imview(vcat(
	cutout,
	synthetic_psf.(axes(cutout,1), axes(cutout,2)')
))

# ╔═╡ 212d4291-9b42-4812-a90a-bea344def1c9
md"""
## Cosmology

The `Cosmology.jl` package contains functions for calculating various cosmological properties.

"""

# ╔═╡ 95f6500b-806f-4d1e-8e06-93a3c59a0eb1


# ╔═╡ 0a1e0fe3-0d0a-49a9-98f2-235cf0f67983
md"""
The first step is to create a Cosmolgy object using any of the following parameters:

```julia
cosmo = cosmology(;h = 0.69,
   Neff = 3.04,
   OmegaK = 0,
   OmegaM = 0.29,
   OmegaR = nothing,
   Tcmb = 2.7255,
   w0 = -1,
   wa = 0
)
```
"""

# ╔═╡ e094564a-fc67-43f7-8014-79efcab3aade


# ╔═╡ dd4a275a-a650-4fea-8d60-319af15ec126
md"""
Next, we can calculate a number of useful properties in based on that model:
```julia
angular_diameter_dist(cosmo, 1.2)
angular_diameter_dist(cosmo, 0.7, 1.2)
luminosity_dist(cosmo, 1.5)
luminosity_dist(u"Gpc", cosmo, 1.5) # Can convert to appropriate unit
```
"""

# ╔═╡ be4cdacf-af85-40c6-9c3f-a93888ec4eff


# ╔═╡ 72dbe56b-5b77-4d5e-832d-a198d77eda30


# ╔═╡ f3dc83b0-7a14-4491-89c2-b0935f9c78d1


# ╔═╡ 41a987d7-b1ac-4e51-88b0-66f78afd5481


# ╔═╡ 2f54fd13-9b9a-48ee-94cf-603ed043be8c
md"""
## Orbits & Ephemerides

Ephemerides for Earth and other solar system bodies can be retrieved using [JPLEphemeris.jl](https://github.com/JuliaAstro/JPLEphemeris.jl).

Two body orbits, e.g. for binary stars or exoplanets, can be calculated and plotted using [PlanetOrbits.jl](https://sefffal.github.io/PlanetOrbits.jl/dev/)

![](https://sefffal.github.io/DirectDetections.jl/dev/assets/pma-astrometry-posterior-grid.png)
"""

# ╔═╡ ee25fc3a-09f6-4809-ad8f-a13bf89299fe
md"""
For more astronomy utility packages, see [juliaastro.org](http://juliaastro.org/dev/)!

Missing something? We'll cover creating your own package later today. Contributions are welcome!
"""

# ╔═╡ Cell order:
# ╟─20b9ba30-2685-4535-9244-693f8e653a9a
# ╟─1877c9ea-77e9-11ed-11b3-4d295a402999
# ╟─a2a1dc5d-df2b-4123-98bb-15c9050c5a50
# ╟─e02a52c2-87f2-486e-ab07-1ffb4f53d235
# ╠═b5cce500-d400-4281-af5a-e8fa3945080d
# ╠═61113246-41c1-4e66-b94c-f5026210a9d2
# ╟─3f024b80-ceb2-4d08-a2f5-58de99df07f7
# ╟─fda9adf6-1e2f-4070-933f-6cc942705759
# ╟─36fd0268-75fc-4ba3-8f84-0f3f846caf72
# ╠═5053717e-fd01-459a-b70d-bcac14b951b5
# ╟─e08cdd53-efd8-4edd-8473-7df5a19a5c2e
# ╠═ef04a84f-468f-4cb2-866e-75877976c634
# ╠═83d22ddc-1604-40b5-b9fa-bad6164c944d
# ╠═f8b980d0-b50a-49fc-a46b-5be5ad3ea076
# ╟─35ad16d0-553e-43e1-8db2-aae985ad42f0
# ╠═0c424458-30bd-42a4-a22b-3b67c32c47ac
# ╠═1a3a84c3-05fa-435d-a530-ac3382a4328d
# ╟─27faa59b-38e6-4c5b-8f5f-4ed0b54c5f6a
# ╠═52414d63-fb02-4947-90b0-d7bc648c31fb
# ╟─3f8f27ca-79da-4b68-91ee-a25259c31a2b
# ╠═1249c36b-8965-42ff-8f04-b953f5556d37
# ╠═03303442-538d-4ca1-9b29-01526ed811b3
# ╟─076730e8-ff5e-48d6-b021-a1308f3bc510
# ╟─35ef3963-93b9-43be-a2ae-f7038507e9fc
# ╠═cde9a068-8ad3-4dce-a2f8-a4e1443bc814
# ╠═3ce04b87-85d5-4ab5-9ca0-168d9f515003
# ╠═aba82503-f1ca-44b4-85bc-4016fa121407
# ╠═5d013ab7-8717-47b3-9d77-aa2e8ca32821
# ╟─8b542f5b-e49a-4fd6-947a-de4738b371c4
# ╟─3854541f-b144-4c7f-935b-fea45c55b948
# ╟─4e853fc4-df91-4606-a86c-47f44a7c54dd
# ╠═225e71b3-6807-460f-aa53-35e5b237fa3f
# ╟─20aaacc9-ecdd-4fca-9c2e-74607c89976c
# ╠═c0640519-50cf-431b-b9f7-24e55c1e5132
# ╠═96dba716-7fb6-4c0f-b5a1-46a0c4df9f45
# ╠═6dd88538-c47f-4848-b17a-118dd6bc4210
# ╟─81eb1d00-331a-4558-83d4-ef1aeae18e11
# ╠═2f3a4cd7-2528-4d16-8e84-dbfb512795b2
# ╟─54be2acc-25f9-4d97-8033-1fa1fd61f577
# ╠═295497e3-c2fe-44e6-bd14-7607490f7389
# ╠═ae1f0817-1472-43f9-a552-3a36fec0b988
# ╟─ccc94c32-0d02-4a9f-9251-513b35283dfb
# ╠═bd630d66-76ed-417d-95b3-246a072cb550
# ╟─24fdd051-539b-4cf3-99df-219f8d490efd
# ╠═9e159efd-2e63-4c98-b324-6be84bf62e00
# ╠═fec3fe38-f06f-420e-89d3-ca67020be665
# ╠═84ae9cc5-7f3a-46b0-9834-a97fb09e5463
# ╠═38ff5cc4-53a5-4888-a95c-1de8ec3fd7b1
# ╟─4b0c3389-8647-4f9a-89d5-0a8590a6a2f6
# ╠═5cff6888-c44c-4510-b6b2-5ce6206e96e9
# ╠═b6444e15-481b-4bca-9c6f-231a7eb664e3
# ╟─a0e73b67-d027-40af-a29a-9d13f513cb43
# ╠═27b6ad8c-110b-4921-ba22-315978a07aa9
# ╠═ba77d1a5-d00f-4c53-8c3c-234fd7a8f9d8
# ╟─e16df48a-4b56-4777-9222-2454de41496b
# ╟─3d605975-e4a6-4c2f-9204-b0365169bafa
# ╟─7e89e63c-7aac-4953-99b7-ce3a21a7ebfc
# ╟─86c5124e-6200-4f0e-9ae4-602ba1738e73
# ╠═4df792be-852b-49e3-9f74-43b76bd682dc
# ╠═0b1606f5-1d5e-40a1-9e51-5da35b5f07ed
# ╠═0598fb2c-ce34-4ff2-8a27-826a5e2bb119
# ╠═f7ee0602-1687-47b6-b456-062d23116e1f
# ╠═15e8d764-9047-4cfc-8f2e-fd2ddd21734c
# ╟─6220232b-3f76-4d7b-9094-c8e79a0c5ba0
# ╠═52478779-d923-4979-94de-b60b952f69be
# ╠═d188b1a7-35e9-45ca-afc5-cb3371d06fbd
# ╠═1866bca0-4d59-4708-8b1e-c157674563b8
# ╟─0231f3a4-f1d9-41aa-b7bd-4efa12020975
# ╠═e28bad2f-f4ea-4c30-9f08-746ca2f609d8
# ╟─5178a7ca-af86-4f46-8a09-335f2a2f75bd
# ╠═19d96665-aa97-44c1-8d6c-5adc7ef0a75f
# ╠═6cc02e65-198f-4065-9482-2297b4c48e5d
# ╟─0113f9d3-a75a-40cf-855f-4a24bb39ab09
# ╠═c86ded0d-c9ba-4489-81e8-208103af8389
# ╠═825c542e-5431-4fe3-8c31-1a427ede5fe0
# ╠═07b03daa-be32-44a0-b8f1-3e7b058a99e4
# ╟─5a25127d-bb63-4ff0-a4e8-a80d72ae76d6
# ╠═550388fa-86ed-4c5d-b564-8a547bdd9acd
# ╠═c2c38c57-459a-4ea0-9ced-a2a2df6e4f91
# ╠═207dd879-65ee-46ec-b232-7a4055c743a1
# ╟─68ef3a5e-e5a4-4f3a-bcfa-2c1ff90447bb
# ╠═0628d2c4-b441-4ab0-b2f3-40b9dc0eb26e
# ╟─0ac24750-ad95-4dca-b168-cb477220cadd
# ╠═25406593-9d9a-48dd-ad63-5f61e38533e3
# ╠═0e8a9812-f872-4bfe-99f4-24a5a6471db5
# ╠═0a080582-c1b7-4996-944a-7a5067b2c9cf
# ╠═da2f371b-27e9-4e0a-b4a4-ca5051331482
# ╠═90de9e65-f11f-4886-a2b9-d19237a55e96
# ╠═2d12d253-b6b3-455f-a26f-18238a6a0bc1
# ╠═6b007e23-816e-465f-b06f-a689dc2fcb8f
# ╟─9c2bc328-0588-486a-978a-55075377bc60
# ╠═98d2310d-a17b-4b0d-877d-9f77020848d3
# ╟─bcd7422c-25ef-45a2-abbc-e13474743c55
# ╠═d2bb443f-cff9-4488-8cc2-09df3d5f2085
# ╟─ab693fa0-af1f-43ee-98a9-c3875b869a1d
# ╠═e9e75e0f-f788-46c7-b869-7a27b70f6f8b
# ╟─243123af-9f80-48ab-afc2-e4ca460ca0cd
# ╠═88ef0704-4b3e-4a93-b12a-03a1f3af337d
# ╠═d34c051b-42b9-4dc6-8545-cd9d8d3b8522
# ╟─5ffe3c8c-c4f8-472a-9ff7-a441aec55d00
# ╠═de89f308-a0f2-4ac0-b0f5-561a75461da7
# ╠═a4a2dbf4-ed31-4f70-a759-500200a2482f
# ╠═ab416b08-d064-496b-9838-dc61c26db1b5
# ╠═eb4e4f4e-13f2-4f51-a26b-31462dfb7948
# ╠═2a533b46-b77f-4b9f-8716-a55df00b0a03
# ╠═3acbdc96-0ed2-4e54-9636-3ef65ab7dc17
# ╠═67cf72e1-a0a9-424f-af0b-f3c211a5dcc1
# ╠═ecbd56d2-3d64-4d07-b39c-a524b33b5f33
# ╠═99b105f0-cdd8-4275-8351-41f8a5da8c48
# ╠═fda0176d-ab94-4bd8-abe4-3e9cfc8de389
# ╠═d32cded1-14a5-44ef-ac29-100a9b49f00d
# ╠═4c1c5567-4d88-44b1-bccb-7e160d53bf6e
# ╠═9bc0ce60-911e-4983-9f5a-102a41396cef
# ╟─212d4291-9b42-4812-a90a-bea344def1c9
# ╠═95f6500b-806f-4d1e-8e06-93a3c59a0eb1
# ╟─0a1e0fe3-0d0a-49a9-98f2-235cf0f67983
# ╠═e094564a-fc67-43f7-8014-79efcab3aade
# ╟─dd4a275a-a650-4fea-8d60-319af15ec126
# ╠═be4cdacf-af85-40c6-9c3f-a93888ec4eff
# ╠═72dbe56b-5b77-4d5e-832d-a198d77eda30
# ╠═f3dc83b0-7a14-4491-89c2-b0935f9c78d1
# ╠═41a987d7-b1ac-4e51-88b0-66f78afd5481
# ╟─2f54fd13-9b9a-48ee-94cf-603ed043be8c
# ╟─ee25fc3a-09f6-4809-ad8f-a13bf89299fe
