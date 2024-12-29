### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ 24ed10e8-aa86-11ef-1455-4944c38e57ec


# ╔═╡ a2947b42-a36c-4d8e-a4e4-4f9bcbb54126
using PlutoUI; TableOfContents()

# ╔═╡ 7b3b8d55-85b7-4ccf-af69-a9709049d832


# ╔═╡ 90b1a6eb-e101-4e29-a536-10293f8ad6e7


# ╔═╡ f6746346-2510-42e9-a551-f0fc3ad13311


# ╔═╡ ab2fc214-e958-4075-9132-49b86a8ccc15
md"""
# X-ray Spectral Analysis Using SpectralFitting
"""

# ╔═╡ 6db17a8f-3c0a-4d91-a6c5-8bb12ce10b9b
md"""
SpectralFitting.jl is an X-ray spectral fitting package like **jaxspec**, **sherpa**, **spex**, and **Xspec**.

This example walkthrough is the SpectralFitting.jl equivalent of the [Walk through XSPEC](https://heasarc.gsfc.nasa.gov/docs/xanadu/xspec/manual/node35.html) from the XSPEC manual. We will use the same dataset, available for download from this link to the [data](https://heasarc.gsfc.nasa.gov/docs/xanadu/xspec/walkthrough.tar.gz).

SpectalFitting has implemented all of the models contained in XSPEC. All of the common, simple models such as `powerlaw` and `phabs` are written Julia, whereas the complex models are still in C or FORTRAN. The associated XSPECModels package contains these complex models.

!!! note
	The long term plan is to have all models written in Julia for improved performance.
"""

# ╔═╡ 932e65e7-023c-4f47-8a12-05cef4cb328d
md"""
Begin by installing SpectralFitting, XSPECModels, and Plots:

```julia
begin
	import Pkg
	Pkg.Registry.add(url="https://github.com/astro-group-bristol/AstroRegistry")
end
```

```julia
using SpectralFitting, XSPECModels, Plots
```

```julia
SpectralFitting.download_all_model_data()
```
"""

# ╔═╡ 22008395-3cbf-4a11-ac2e-2a5aa71a3588


# ╔═╡ d06acb32-2dad-491d-8283-5238d2b1c17c
md"""
The first thing we want to do is load our datasets. Unlike in XSPEC, we have no requirement of being in the same directory as the data, or even that all of the response, ancillary, and spectral files be in the same place. For simplicity, we'll assume they are:

```julia
using Downloads, CodecZlib, Tar
```

```julia
begin
	url = "https://heasarc.gsfc.nasa.gov/docs/xanadu/xspec/"
	xrayfile = "walkthrough.tar.gz"
	tmpdir = mktempdir(tempdir(), prefix="s54405_")
	Downloads.download(joinpath(url, xrayfile), joinpath(tmpdir, xrayfile))
	datadir = Tar.extract(GzipDecompressorStream(open(joinpath(tmpdir, xrayfile))), mktempdir(tempdir(), prefix="s54405_"))
	data = OGIPDataset(joinpath(datadir, "walkthrough", "s54405.pha"))
end
```
"""

# ╔═╡ 28fd9267-db54-4187-ada1-96e23ad36987


# ╔═╡ 66cd0225-31bf-4800-b0c7-accba53f83ee
md"""
This will print a little card about our data, which shows us what else SpectralFitting.jl loaded. We can see the Primary Spectrum, the Response, but that the Background and Ancillary response files are missing. That's to be expected, since we don't have those files in the dataset.

We can check what paths it used by looking at:

```julia
data.paths
```
"""

# ╔═╡ 3007cd6d-01aa-4758-9bd3-70ec84532801


# ╔═╡ 6daeafd4-8fda-4c6c-bd9e-aece1c394808
md"""
We can load and alter any part of a dataset as we do our fitting. For example, if you have multiple different ancillary files at hand, switching them between fits is a one-liner.

To visualize our data, we can use some of the Plots.jl recipes included in SpectralFitting.jl:

```julia
plot(data, xlims = (0.5, 70), xscale = :log10, label="1E 1048.1-5937")
```
"""

# ╔═╡ 78ecc9b4-aa64-45d1-9a8a-3338542d5620


# ╔═╡ 8c74ded3-f798-426f-bd3c-99b3ba63946d
md"""
Note that the units are currently not divided by the energy bin widths. We can either do that manually, or use the normalize! to convert whatever units the data is currently in to the defacto standard counts s⁻¹ keV⁻¹ for fitting. Whilst we're at it, we see in the model card that there are 40 bad quality bins still present in our data. We can drop those as well, and plot the data on log-log axes:

```julia
begin
	normalize!(data)
	drop_bad_channels!(data)
	plot(data, ylims = (0.001, 2.0), yscale=:log10, xscale=:log10, label="1E 1048.1-5937")
end
```

!!! note
	The scale defaults to log on the plot unless otherwise specified, when the axes are non-negative.
"""

# ╔═╡ 90301284-cd55-40bb-8d7f-2cf83e110fa3


# ╔═╡ 76e44052-c9d9-4bb6-9728-b504468b9424
md"""
Next we want to specify a model to fit to this data. Models that are prefixed with XS_ are models that are linked from the XSPEC model library, provided via [LibXSPEC_jll](https://github.com/astro-group-bristol/LibXSPEC_jll.jl). For a full list of the models, see [Models](https://fjebaker.github.io/SpectralFitting.jl/dev/walkthrough/@ref) library.

!!! note
	To see information about a model, use (1) the Live Docs' in Pluto, or (2) the ? in the Julia REPL:

```julia-repl
julia> ?PowerLaw
PowerLaw(K, a)

•  K: Normalisation.

•  a: Photon index.

Example
≡≡≡≡≡≡≡
...
```
"""

# ╔═╡ c3ef9493-40ca-40bb-8660-4fed4e38ba2e
md"""
!!! tip
	It is advised to use the Julia implemented models. This allows various calculations to benefit from automatic differentiation (AD), efficient multi-threading, GPU offloading, and various other useful optimizations.

	AD provides a three times performance improvement over most other spectral fitting applications, such as XSpec and Sherpa. The one exception is jaxspec because JAX also has AD.

	Julia also provides better performance by performming global optimization of models, whereas most other spectal fitting apps only optimize each component of a model.
"""

# ╔═╡ 2ea069da-86ac-4b74-bd6d-3e642fa17612
md"""
We will start by fitting a photoelectric absorption model that acts on a power law model:

```julia
model = PhotoelectricAbsorption() * PowerLaw()
```
"""

# ╔═╡ 140faeec-7794-476a-9d5b-9fd1a598d981


# ╔═╡ cd6ac36d-1eb1-43d6-b8b7-b58cc3cbb9c8
md"""
!!! note
	Julia does not require the implementation of a sublanguage. Each model is implemented in Julia, so Julia parses the model expressions. In the case of XSpec, special code is required to parse the model expressions, increasing the apps complexity and maintenance, and decreasing *productivity*.
"""

# ╔═╡ 287273d1-9b82-45ed-aceb-13deb7a51137
md"""
If we want to specify paramters of our model at instantiation, we can do that with:

```julia
example = PhotoelectricAbsorption() * PowerLaw(a = FitParam(3.0))
```
"""

# ╔═╡ a20eed5d-debf-4a15-a3b0-1c300609919f


# ╔═╡ dc2d56bf-c022-44ac-a7d0-a981066b797a
md"""
SpectralFitting.jl adopts the SciML problem-solver abstraction, so to fit a model to data we specify a FittingProblem:

```julia
prob = FittingProblem(model1 => data)
```
"""

# ╔═╡ 6863b72c-cacc-4b4d-b12b-71a81fc97e41


# ╔═╡ ed1ed1f3-da1a-4af9-8b11-e483103ecdce
md"""
SpectralFitting.jl makes a huge wealth of optimizers availble from [Optimizations.jl](https://github.com/SciML/Optimization.jl), and others from further afield. For consistency with XSPEC, we'll use here a delayed-gratification least-squares algorithm from [LsqFit.jl](https://github.com/JuliaNLSolvers/LsqFit.jl):

```julia
result0 = SpectralFitting.fit(prob, LevenbergMarquadt())
```
"""

# ╔═╡ 177d4e11-970f-4f96-8729-45836ec9999f


# ╔═╡ 04de68d6-fda8-4389-abb4-d276ffb78b22
md"""
Here we can see the parameter vector, the estimated error on each parameter, and the measure of the fit statistic (here chi squared). We can overplot our result on our data easily:

```julia
begin
	plot(data,
    	ylims = (0.001, 2.0),
    	xscale = :log10,
    	yscale = :log10,
		label = "1E 1048.1-5937"
	)
	plot!(result0, label = "Powerlaw: χ² = $(round(result0.χ2))")
end
```
"""

# ╔═╡ 369b486a-5968-4a01-a348-b21d573f433f


# ╔═╡ ea55b01a-0a77-43fc-8448-ae4c74a164be
md"""
Our model does not account for the high energy range well. We can ignore that range for now, and select everything from 0 to 15 keV and refit:

```julia
begin
	mask_energies!(data, 0, 15)
	result1 = SpectralFitting.fit(prob, LevenbergMarquadt())
end
```
"""

# ╔═╡ 81f302d1-01a2-4211-8431-65094785ce96


# ╔═╡ bb874264-ecc1-42d2-a019-f3e7cca11c1d
md"""
```julia
begin
	plot(data,
    	ylims = (0.001, 2.0),
    	xscale = :log10,
    	yscale = :log10,
		label = "1E 1048.1-5937"
	)
	plot!(result1, label = "PowerLaw")
end
```
"""

# ╔═╡ 16cc5cf2-4b8b-42e2-a27c-e8888685e861


# ╔═╡ bff64ea1-602b-4b59-bffa-e85f1d765860
md"""
The result is not yet baked into our model, and represents just the outcome of the fit. To update the parameters and errors in the model, we can use [update_model!](https://fjebaker.github.io/SpectralFitting.jl/dev/walkthrough/@ref)

```julia
update_model!(model1, result1)
```
"""

# ╔═╡ c22b426e-4086-44ce-b562-79d7c0b1a1fe


# ╔═╡ 6ad6075a-6119-424b-a5b2-b8ed2dc9fe7f
md"""
!!! note
	Since fitting and updating a model is often done in tandem, SpectralFitting.jl has both a [fit](https://fjebaker.github.io/SpectralFitting.jl/dev/walkthrough/@ref) and [fit!](https://fjebaker.github.io/SpectralFitting.jl/dev/walkthrough/@ref) method, the latter automatically updates the model parameters after fit.
"""

# ╔═╡ 5d7f391f-8085-4089-a447-69fc6b30d523
md"""
To estimate the goodness of our fit, we can mimic the goodness command from XSPEC. This will use the [simulate](https://fjebaker.github.io/SpectralFitting.jl/dev/walkthrough/@ref) function to simulate spectra for a dataset (here determined by the result), and fit the model to the simulated dataset. The fit statistic for each fit is then appended to an array, which we can use to plot a histogram:

```julia
spread = goodness(result1; N = 1000, seed = 42, exposure_time = data.data.spectrum.exposure_time)
```

```julia
begin
	histogram(spread, ylims = (0, 300), label = "Simulated")
	vline!([result1.χ2], label = "Best fit")
end
```
"""

# ╔═╡ cdb01ccc-2d6f-4e5e-a4e7-177ca0a0e1aa


# ╔═╡ 10fafc36-9e70-44b9-a77b-f5d0ead58fa9


# ╔═╡ 936daf32-91c0-4f9a-b37a-a26b27333b58
md"""
Note we have set the random number generator seed with seed = 42 to allow our results to be strictly reproduced.

The goodness command will log the percent of simulations with a fit statistic better than the result, but we can equivalently calculate that ourselves:

```julia
count(<(result1.χ2), spread) * 100 / length(spread)
```
"""

# ╔═╡ 8b54c69f-9129-45f0-90bf-a91324ff6b01


# ╔═╡ e2da09ef-0eef-4f5d-bae9-ef139522790d
md"""
Next we want to calculate the flux in an energy range observed by the detector. We can do this with [LogFlux](https://fjebaker.github.io/SpectralFitting.jl/dev/walkthrough/@ref) or [XS_CalculateFlux](https://fjebaker.github.io/SpectralFitting.jl/dev/models/xspec-models/#XSPECModels.XS_CalculateFlux), as they are both equivalent implementations.

We can modify our model by accessing properties from the model card and writing a new expression:

```julia
calc_flux = XS_CalculateFlux(
    E_min = FitParam(0.2, frozen = true),
    E_max = FitParam(2.0, frozen = true),
    log10Flux = FitParam(-10.3, lower_limit = -100, upper_limit = 100),
)
```

```julia
flux_model1 = model1.m1 * calc_flux(model1.a1)
```
"""

# ╔═╡ d2cc6013-ca48-4a32-a2b1-aa7a064f9a48


# ╔═╡ 173e94f9-4bd6-4efc-9772-238601d106e9


# ╔═╡ dcd354ab-57de-4a0e-968f-a8c39a76b233
md"""
Since we used the old model to define the new one, our best fit values are automatically copied into the new model. We can now freeze the normalization, as we are using the flux integrating model to scale the powerlaw component:

```julia
begin
	flux_model1.a1.K.frozen = true
	flux_model1
end
```
"""

# ╔═╡ bdb48e95-998f-4d19-a4ca-d2a8fca40ac5


# ╔═╡ 617f0e78-b2f8-42fe-98dc-1d1d6d6dbcf5
md"""
Looking at the data card, we see the fit domain does not include the full region that we want to integrate the flux over. We therefore need to extend the fitting domain:

```julia
flux_problem = FittingProblem(flux_model1 => data)
```
"""

# ╔═╡ 2abc998c-1cc7-4d4f-b113-6bf653eb5d2c


# ╔═╡ 9986a311-4a98-4a9d-84c8-23f02c7c508d
md"""
Now to fit we can repeat the above procedure, and even overplot the region of flux we integrated:

```julia
flux_result1 = SpectralFitting.fit(flux_problem, LevenbergMarquadt());
```

```julia
begin
	plot(data,
    	ylims = (0.001, 2.0),
    	xscale = :log10,
    	yscale = :log10,
		label = "1E 1048.1-5937"
	)
	plot!(flux_result1, label = "powerlaw")
	vspan!([flux_model1.c1.E_min.value, flux_model1.c1.E_max.value], alpha = 0.5)
end
```
"""

# ╔═╡ 27d19c95-d102-45c4-b5e8-20766970b4d6


# ╔═╡ f604ac19-02bf-414d-b831-d8d3cd6b88d0


# ╔═╡ a222aa7c-ae50-4581-9cda-ea9847a40e1d
md"""
Let's try alternative models to see how they fit the data. First, an absorbed black body:

```julia
model2 = PhotoelectricAbsorption() * XS_BlackBody()
```
"""

# ╔═╡ f202c548-fb0b-4fa4-997f-c84841fbde0e


# ╔═╡ aedb879c-5b95-4fdb-8bfc-8dc335ee370a
md"""
We fit in the same way as before:

```julia
begin
	prob2 = FittingProblem(model2 => data)
 	result2 = SpectralFitting.fit!(prob2, LevenbergMarquadt())
end
```
"""

# ╔═╡ 9958ffcb-148a-4210-b919-31c32b5a7180


# ╔═╡ f05b0d11-66ff-4de9-9043-814f267554c9
md"""
Let's overplot this result against our power law result:

```julia
begin
	dp = plot(data,
    	ylims = (0.001, 2.0),
    	xscale = :log10,
    	yscale = :log10,
    	legend = :bottomleft,
		label = "1E 1048.1-5937"
	)
	plot!(dp, result1, label = "PowerLaw: χ² = $(round(result1.χ2))")
	plot!(dp, result2, label = "BlackBody: χ² = $(round(result2.χ2))")
end
```
"""

# ╔═╡ 125c9ed1-060f-4415-bb2e-f1c93eab2364


# ╔═╡ bb9aece5-dcb0-4b65-a159-555798187398
md"""
Or a bremsstrahlung model:

```julia
begin
	model3 = PhotoelectricAbsorption() * XS_BremsStrahlung()
	prob3 = FittingProblem(model3 => data)
	result3 = SpectralFitting.fit(prob3, LevenbergMarquadt())
end
```
"""

# ╔═╡ b8ddd394-fcfc-48f1-8c1b-4c51f1ba0b9d


# ╔═╡ 3ae7cda8-1501-4033-bbf8-b36d78e78e21
md"""
```julia
plot!(dp, result3, label = "Brems: χ² = $(round(result3.χ2))")
```
"""

# ╔═╡ e932d6c0-0961-481c-81d2-21e0cca87806


# ╔═╡ db43cc8a-901f-4ca4-8de5-7e03cc4edee8
md"""

```julia
function calc_residuals(result)
    r = result[1]
    y = invoke_result(r)
    @. (r.objective - y) / sqrt(r.variance)
end
```

!!! note
	Select which result we want (only have one, but for generalisation to multi-model fits)
"""

# ╔═╡ 0517ac1e-0f94-4a7c-8d50-d668e60ead13


# ╔═╡ 2fa86b40-e642-422f-a7f9-fd438891086a
md"""
Let's take a look at the residuals of these three models. There are utility methods for this in SpectralFitting.jl, but we can easily just interact with the result directly:

```julia
begin
	domain = SpectralFitting.plotting_domain(data)

	rp = hline([0], linestyle = :dash, legend = false)
	plot!(rp,domain, calc_residuals(result1), seriestype = :stepmid)
	plot!(rp, domain, calc_residuals(result2), seriestype = :stepmid)
	plot!(rp, domain, calc_residuals(result3), seriestype = :stepmid)
	rp
end
```
"""

# ╔═╡ ae780e1e-3ab0-4a74-b258-8ca03f2aa4ad


# ╔═╡ f401a3bb-c65e-4b45-b6be-f04475adc8f0
md"""
We can compose this figure with our previous one, and change to a linear x scale:

```julia
plot(dp, rp, layout=grid(2, 1, heights=[0.7, 0.3]), link=:x, xscale=:linear)
```
"""

# ╔═╡ 1ee01f05-4e78-4a70-a634-6677df3981b4


# ╔═╡ 9ff3dc33-d639-4bad-95b7-149c6a4f8274
md"""
We can do all that plotting work in one go with the [plotresult](https://fjebaker.github.io/SpectralFitting.jl/dev/walkthrough/@ref) recipe:

```julia
plotresult(
    data,
    [result1, result2, result3],
    ylims = (0.001, 2.0),
    xscale = :log10,
    yscale = :log10,
    legend = :bottomleft,
)
```
"""

# ╔═╡ 25548d3e-7fbc-4413-921b-870b67bccb01


# ╔═╡ 816093ed-2857-48f8-8166-b8aba99a86f6
md"""
Let's modify the black body model with a continuum component:

```julia
bbpl_model = model2.m1 * (PowerLaw() + model2.a1) |> deepcopy
```

!!! note
	We pipe the model to `deepcopy` to create a copy of all the model parameters. Not doing this means the parameters in `bbpl_model` will be aliased to the parameters in `model2`, and changing one with change the other.
"""

# ╔═╡ 2790f469-2e40-4b48-8440-f612091a05f9


# ╔═╡ fa49bd3e-5bc0-48f9-be60-f7a4720319ff
md"""
We'll freeze the hydrogen column density parameter to the galactic value and refit:

```julia
begin
	bbpl_model.ηH_1.value = 4
	bbpl_model.ηH_1.frozen = true
	bbpl_model
end
```
"""

# ╔═╡ b4b429bb-20d9-40d1-84ba-e38cfaf63002


# ╔═╡ 67818c4b-ddca-4d11-8a4a-c3dd2634e12f
md"""
And fitting:

```julia
bbpl_result = SpectralFitting.fit(
    FittingProblem(bbpl_model => data),
    LevenbergMarquadt()
)
```
"""

# ╔═╡ ff6aebd2-4a58-44c4-a357-80f9de717c7d


# ╔═╡ 3db1f154-9156-4a6c-8278-ca75a4936cce
md"""
Let's plot the result:

```julia
begin
	plot(data,
    	ylims = (0.001, 2.0),
   	 	xscale = :log10,
    	yscale = :log10,
    	legend = :bottomleft,
	)
	plot!(bbpl_result, label="Blackbody+Powerlaw: χ² = $(round(bbpl_result.χ2))")
end
```
"""

# ╔═╡ 53007e4d-4807-419a-a21e-18e49dba11cb


# ╔═╡ d4d9f097-999e-42e7-8960-d717b0f881e6
md"""
Update the model and fix the black body temperature to 2 keV:

```julia
begin
	update_model!(bbpl_model, bbpl_result)

	bbpl_model.T_1.value = 2.0
	bbpl_model.T_1.frozen = true
	bbpl_model
end
```
"""

# ╔═╡ b4947886-60e6-4835-91e2-89a2a9c62dbd


# ╔═╡ bcfdfb61-fc2f-4f8a-ad3e-b7292e9fc502
md"""
Fitting:

```julia
bbpl_result2 = SpectralFitting.fit(
    FittingProblem(bbpl_model => data),
    LevenbergMarquadt()
)
```
"""

# ╔═╡ 643d3ab3-8dfe-478f-96cd-28c7e78cb76d


# ╔═╡ 154cb9ea-44c5-4560-b6eb-2ce84ea2ebd5
md"""
Overplotting this new result:

```julia
plot!(bbpl_result2, label="Blackbody+Powerlaw: χ² = $(round(bbpl_result2.χ2))")
```
"""

# ╔═╡ f4b5ce4d-6b48-4402-9b10-1e91bcd1df7f


# ╔═╡ 0e0b1dda-0728-428a-aa9d-913ba65233ce
md"""
## Markov Chain Monte Carlo (MCMC)
"""

# ╔═╡ 6ecd81a8-bf93-4980-a4b4-d5a04559131a
md"""
We can use libraries like [Pigeons.jl](https://pigeons.run/dev/) or [Turing.jl](https://turinglang.org/) to perform Bayesian inference on our paramters. SpectralFitting.jl is designed with BYOO (Bring Your Own Optimizer) in mind, and so makes it relatively easy to get at the core fitting functions to be used with other packages.
"""

# ╔═╡ c7bef432-ed76-4fdd-9944-7e98d0adf163
md"""
Let's use Turing.jl here, which means we'll also want to use StatsPlots.jl to plot our walker chains.

```julia
using StatsPlots, Turing
```
"""

# ╔═╡ 6a0d8313-d0e6-4470-9c9a-bf17608e477c
md"""
Turing.jl provides enormous control over the definition of the model, and this is not control SpectralFitting.jl wants to take away from you. Although we will provide utility scripts to do the basics, here we'll show you everything step by step to give you an overview of what you can do.

Let's go back to our first model:

```julia
model1
```
"""

# ╔═╡ d7933ed7-7c42-4aa5-a141-0b1a5034b75e


# ╔═╡ f3c798c0-0361-4776-8208-7d9a3b5ffa41
md"""
This gave a pretty good fit but the errors on our paramters are not well defined, being estimated only from a convariance matrix in the least-squares solver. MCMC can give us better confidence regions, and even help us uncover dependencies between paramters. Here we'll take all of our parameters and convert them into a Turing.jl model with use of their macro:

```julia
@model function mcmc_model(domain, objective, variance, f)
    K ~ Normal(20.0, 1.0)
    a ~ Normal(2.2, 0.3)
    ηH ~ truncated(Normal(0.5, 0.1); lower = 0)
    pred = f(domain, [K, a, ηH])
    return objective ~ MvNormal(pred, sqrt.(variance))
end
```
"""

# ╔═╡ 13decdf9-1271-4456-a90e-7d897845f0a7


# ╔═╡ f68b7bd9-4f01-420e-becd-f57e065b0261
md"""
A few things to note here: we use the Turing.jl sampling syntax ~ to say that a variable is sampled from a certain type of prior distribution. There are no fixed criteria for what a distribution can be, and we encourage you to consult the Turing.jl documentation to learn how to define your own custom probability distributions. In this case, we will use Gaussians for all our parameters, and for the means and standard deviations use the best fit and estimated errors.

At the moment we haven't explicitly used our model, but f in this case takes the roll of invoking our model, and folding through instrument responses. We call it in much the same way as invokemodel, despite it going the extra step to fold our model. To instantiate this, we can use the SpectralFitting.jl helper functions:
"""

# ╔═╡ 820bdfb5-a81d-4b63-b09b-f9104f1c6ab5
md"""
```julia
config = FittingConfig(FittingProblem(model => data));
```
"""

# ╔═╡ 60c6334f-1109-4c95-b9f0-417bd35a2d8c
# ╠═╡ show_logs = false


# ╔═╡ d04d209a-e804-491c-9bcd-8929490f39c1
md"""
```julia
mm = mcmc_model(
	make_model_domain(ContiguouslyBinned(), data),
	make_objective(ContiguouslyBinned(), data),
	make_objective_variance(ContiguouslyBinned(), data),
	SpectralFitting._f_objective(config),
)
```

!!! note
	`_f_objective` returns a function used to evaluate and fold the model through the data
"""

# ╔═╡ 61a0827c-ccd3-459b-a981-4f6406be37d2


# ╔═╡ cba5de80-bc2e-40e0-b549-abe8ecfd6bb1
md"""
That's it! We're now ready to sample our model. Since all our models are implemented in Julia, we can use gradient-boosted samplers with automatic differentiation, such as NUTS. We'll walk 5000 itterations, just as a small example:

```julia
chain = sample(mm, NUTS(), 5_000)
```
"""

# ╔═╡ 74b7d927-c28d-4970-9898-2bb4713c58a2


# ╔═╡ e9ed5191-cdd1-4cb9-9f13-21d996621113
md"""
In the printout we see summary statistics about or model, in this case that it has converged well (rhat close to 1 for all parameters), better estimates of the standard deviation, and various quantiles. We can plot our chains to make sure the caterpillers are healthy and fuzzy, making use of StatsPlots.jl recipes:

```julia
plot(chain)
```
"""

# ╔═╡ e89f819c-1248-41a1-932b-3600255563a5


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.60"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.2"
manifest_format = "2.0"
project_hash = "8aa109ae420d50afa1101b40d1430cf3ec96e03e"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

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

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

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

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"

    [deps.Pkg.extensions]
    REPLExt = "REPL"

    [deps.Pkg.weakdeps]
    REPL = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eba4810d5e6a01f612b948c9fa94f905b49087b0"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.60"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [deps.Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.Tricks]]
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

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

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

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
# ╟─a2947b42-a36c-4d8e-a4e4-4f9bcbb54126
# ╟─ab2fc214-e958-4075-9132-49b86a8ccc15
# ╟─6db17a8f-3c0a-4d91-a6c5-8bb12ce10b9b
# ╟─932e65e7-023c-4f47-8a12-05cef4cb328d
# ╠═24ed10e8-aa86-11ef-1455-4944c38e57ec
# ╠═7b3b8d55-85b7-4ccf-af69-a9709049d832
# ╠═22008395-3cbf-4a11-ac2e-2a5aa71a3588
# ╟─d06acb32-2dad-491d-8283-5238d2b1c17c
# ╠═90b1a6eb-e101-4e29-a536-10293f8ad6e7
# ╠═28fd9267-db54-4187-ada1-96e23ad36987
# ╟─66cd0225-31bf-4800-b0c7-accba53f83ee
# ╠═3007cd6d-01aa-4758-9bd3-70ec84532801
# ╟─6daeafd4-8fda-4c6c-bd9e-aece1c394808
# ╠═78ecc9b4-aa64-45d1-9a8a-3338542d5620
# ╟─8c74ded3-f798-426f-bd3c-99b3ba63946d
# ╠═90301284-cd55-40bb-8d7f-2cf83e110fa3
# ╟─76e44052-c9d9-4bb6-9728-b504468b9424
# ╟─c3ef9493-40ca-40bb-8660-4fed4e38ba2e
# ╟─2ea069da-86ac-4b74-bd6d-3e642fa17612
# ╠═140faeec-7794-476a-9d5b-9fd1a598d981
# ╟─cd6ac36d-1eb1-43d6-b8b7-b58cc3cbb9c8
# ╟─287273d1-9b82-45ed-aceb-13deb7a51137
# ╠═a20eed5d-debf-4a15-a3b0-1c300609919f
# ╟─dc2d56bf-c022-44ac-a7d0-a981066b797a
# ╠═6863b72c-cacc-4b4d-b12b-71a81fc97e41
# ╟─ed1ed1f3-da1a-4af9-8b11-e483103ecdce
# ╠═177d4e11-970f-4f96-8729-45836ec9999f
# ╟─04de68d6-fda8-4389-abb4-d276ffb78b22
# ╠═369b486a-5968-4a01-a348-b21d573f433f
# ╟─ea55b01a-0a77-43fc-8448-ae4c74a164be
# ╠═81f302d1-01a2-4211-8431-65094785ce96
# ╟─bb874264-ecc1-42d2-a019-f3e7cca11c1d
# ╠═16cc5cf2-4b8b-42e2-a27c-e8888685e861
# ╟─bff64ea1-602b-4b59-bffa-e85f1d765860
# ╠═c22b426e-4086-44ce-b562-79d7c0b1a1fe
# ╟─6ad6075a-6119-424b-a5b2-b8ed2dc9fe7f
# ╟─5d7f391f-8085-4089-a447-69fc6b30d523
# ╠═cdb01ccc-2d6f-4e5e-a4e7-177ca0a0e1aa
# ╠═10fafc36-9e70-44b9-a77b-f5d0ead58fa9
# ╟─936daf32-91c0-4f9a-b37a-a26b27333b58
# ╠═8b54c69f-9129-45f0-90bf-a91324ff6b01
# ╟─e2da09ef-0eef-4f5d-bae9-ef139522790d
# ╠═d2cc6013-ca48-4a32-a2b1-aa7a064f9a48
# ╠═173e94f9-4bd6-4efc-9772-238601d106e9
# ╟─dcd354ab-57de-4a0e-968f-a8c39a76b233
# ╠═bdb48e95-998f-4d19-a4ca-d2a8fca40ac5
# ╟─617f0e78-b2f8-42fe-98dc-1d1d6d6dbcf5
# ╠═2abc998c-1cc7-4d4f-b113-6bf653eb5d2c
# ╟─9986a311-4a98-4a9d-84c8-23f02c7c508d
# ╠═27d19c95-d102-45c4-b5e8-20766970b4d6
# ╠═f604ac19-02bf-414d-b831-d8d3cd6b88d0
# ╟─a222aa7c-ae50-4581-9cda-ea9847a40e1d
# ╠═f202c548-fb0b-4fa4-997f-c84841fbde0e
# ╟─aedb879c-5b95-4fdb-8bfc-8dc335ee370a
# ╠═9958ffcb-148a-4210-b919-31c32b5a7180
# ╟─f05b0d11-66ff-4de9-9043-814f267554c9
# ╠═125c9ed1-060f-4415-bb2e-f1c93eab2364
# ╟─bb9aece5-dcb0-4b65-a159-555798187398
# ╠═b8ddd394-fcfc-48f1-8c1b-4c51f1ba0b9d
# ╟─3ae7cda8-1501-4033-bbf8-b36d78e78e21
# ╠═e932d6c0-0961-481c-81d2-21e0cca87806
# ╟─db43cc8a-901f-4ca4-8de5-7e03cc4edee8
# ╠═0517ac1e-0f94-4a7c-8d50-d668e60ead13
# ╟─2fa86b40-e642-422f-a7f9-fd438891086a
# ╠═ae780e1e-3ab0-4a74-b258-8ca03f2aa4ad
# ╟─f401a3bb-c65e-4b45-b6be-f04475adc8f0
# ╠═1ee01f05-4e78-4a70-a634-6677df3981b4
# ╟─9ff3dc33-d639-4bad-95b7-149c6a4f8274
# ╠═25548d3e-7fbc-4413-921b-870b67bccb01
# ╟─816093ed-2857-48f8-8166-b8aba99a86f6
# ╠═2790f469-2e40-4b48-8440-f612091a05f9
# ╟─fa49bd3e-5bc0-48f9-be60-f7a4720319ff
# ╠═b4b429bb-20d9-40d1-84ba-e38cfaf63002
# ╟─67818c4b-ddca-4d11-8a4a-c3dd2634e12f
# ╠═ff6aebd2-4a58-44c4-a357-80f9de717c7d
# ╟─3db1f154-9156-4a6c-8278-ca75a4936cce
# ╠═53007e4d-4807-419a-a21e-18e49dba11cb
# ╟─d4d9f097-999e-42e7-8960-d717b0f881e6
# ╠═b4947886-60e6-4835-91e2-89a2a9c62dbd
# ╟─bcfdfb61-fc2f-4f8a-ad3e-b7292e9fc502
# ╠═643d3ab3-8dfe-478f-96cd-28c7e78cb76d
# ╟─154cb9ea-44c5-4560-b6eb-2ce84ea2ebd5
# ╠═f4b5ce4d-6b48-4402-9b10-1e91bcd1df7f
# ╟─0e0b1dda-0728-428a-aa9d-913ba65233ce
# ╟─6ecd81a8-bf93-4980-a4b4-d5a04559131a
# ╟─c7bef432-ed76-4fdd-9944-7e98d0adf163
# ╠═f6746346-2510-42e9-a551-f0fc3ad13311
# ╟─6a0d8313-d0e6-4470-9c9a-bf17608e477c
# ╠═d7933ed7-7c42-4aa5-a141-0b1a5034b75e
# ╟─f3c798c0-0361-4776-8208-7d9a3b5ffa41
# ╠═13decdf9-1271-4456-a90e-7d897845f0a7
# ╟─f68b7bd9-4f01-420e-becd-f57e065b0261
# ╟─820bdfb5-a81d-4b63-b09b-f9104f1c6ab5
# ╠═60c6334f-1109-4c95-b9f0-417bd35a2d8c
# ╟─d04d209a-e804-491c-9bcd-8929490f39c1
# ╠═61a0827c-ccd3-459b-a981-4f6406be37d2
# ╟─cba5de80-bc2e-40e0-b549-abe8ecfd6bb1
# ╠═74b7d927-c28d-4970-9898-2bb4713c58a2
# ╟─e9ed5191-cdd1-4cb9-9f13-21d996621113
# ╠═e89f819c-1248-41a1-932b-3600255563a5
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
