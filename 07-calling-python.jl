### A Pluto.jl notebook ###
# v0.19.36

using Markdown
using InteractiveUtils

# ╔═╡ 3ba5672b-18ff-4320-a4d2-954e0b873d47
using PlutoUI; TableOfContents()

# ╔═╡ 4c788b44-77e1-11ed-0ce7-5914857ba421
md"""
## Calling Python from Julia

Julia has two packages for calling Python code from Julia: PyCall & PythonCall. PyCall has an easier learning curve, but has a few limitations. Whereas, PythonCall has better performance, because it is more complete and allows for more control.

Both packages have symmetric interfaces, so the user can call Python from Julia and Julia from Python. This session will only focus on calling Python from Julia.
"""

# ╔═╡ f0c6b09d-8b64-4175-aacd-6b3ac72078f6
md"""
### PyCall & PyJulia

    using PyCall
"""

# ╔═╡ 41103ed5-6145-4772-84d6-8858ebb560ac


# ╔═╡ 306378d0-91a3-4f07-94fb-45b8cc474274
md"""
A simple example, calculate 1/√2 using Python. First, import the math module.

    begin
    math = pyimport("math")
    math.sin(math.pi /4)
    end

Try it.
"""

# ╔═╡ 667e42f2-b6b5-4eb9-817f-57aee042d7ca


# ╔═╡ 06d63e41-f9b9-4c75-87d4-241beb454dc5
md"""
Here is another example using matplotlib.pyplot. The example uses the `pyimport_conda` function to load `matplotlib.pyplot`. If `matplotlib.pyplot` fails because `matplotlib` hasn't been installed, then it will automatically install `matplotlib`, which may take some time, or retry `pyimport`.

    let
    plt = pyimport_conda("matplotlib.pyplot", "matplotlib")
    x = range(0; stop=2*pi, length=1000); y = sin.(3 .* x + 4 .* cos.(2. * x));
    plt.plot(x, y, color="red", linewidth=2.0, linestyle="--")
    plt.savefig("plt_example.png")
    LocalResource("plt_example.png")
    end

!!! note
    `x` and `y` are calculated using Julia and the plotting uses Python.
"""

# ╔═╡ 20c226ca-44e6-4565-b601-07f5df7828ac


# ╔═╡ 7728f44a-93e1-4514-8964-6351a5ebff07
md"""
You can also just wrap Python code in `py"..."` or `py\"""...\"""` strings, which are equivalent to Python's `eval` and `exec` commands, respectively.

First install `astropy` using `pyimport_conda`.

    pyimport_conda("astropy.io.fits", "astropy")
"""

# ╔═╡ 8648cd40-d805-49b3-b05a-93a4b6ea0a20


# ╔═╡ f790ac60-d874-4e95-8d34-252f44ff32b1
md"""
For example, try the following block of code to access the `time` and `rate` of some *Newton-XMM* X-ray data from a FITS file.

    begin
    py\"""
    import astropy.io.fits as fits
    mos = fits.open("https://github.com/sefffal/AASJuliaWorkshop/blob/main/P0801780301M1S001SRCTSR8001.FIT?raw=true")
    time, rate = mos[1].data["TIME"], mos[1].data["RATE"]
    \"""
    (py"time"[1:3], py"rate"[1:3])
    end
"""

# ╔═╡ 90c8b0db-f94b-440c-b05a-72e3f6483051


# ╔═╡ 5d883d2b-515f-4286-a2ab-15127ac6b5ea
md"""
#### Specifying the Python version

In Julia,

    ENV["PYTHON"] = path_of_python_executable
    # ENV["PYTHON"] = "/usr/bin/python3.10"
    Pkg.build("PyCall")

To use Julia's Python distribution, set the path to an empty string, i.e., `""`

!!! note
    Usually, the necessary libraries are installed along with Python, but pyenv on  MacOS requires you to install it with env PYTHON\_CONFIGURE\_OPTS="--enable-framework" pyenv install 3.4.3. The Enthought Canopy Python distribution is currently not supported. As a general rule, we tend to recommend the Anaconda Python distribution on MacOS and Windows, or using the Julia Conda package, in order to minimize headaches.
"""

# ╔═╡ 87b3ca0e-93d3-41d3-aa6d-e06ab0fbac26
md"""
### PythonCall & JuliaCall

#### Getting Started

PyCall and PythonCall can be used in the same Julia session on Unix (Linux, OS X, etc.) as long the same interpreter is used for both. On Windows, it appears separate interpreters can be used. Let's ensure the same interpreter is used for both.

    ENV["JULIA_PYTHONCALL_EXE"] = "@PyCall"
"""

# ╔═╡ 0db12101-fcf9-48a3-a337-ad53a4713f6d


# ╔═╡ 93e945de-7ceb-4124-b3db-f6b64e2e46bb
md"""
Now import `PythonCall`:

    using PythonCall
"""

# ╔═╡ fa825783-6f48-4f0d-b346-220ae9e2fb11


# ╔═╡ 99e16357-0113-4a12-8a22-f627c6fdef84
md"""
By default importing the module will initialize a conda environment in your Julia environment, install Python into it, load the corresponding Python library, and initialize an interpreter.

Here is an example using Python's "re" module. Because `PyCall` and `PythonCall` both define pyimport, this example must qualify which one we are using, namely PythonCall's `pyimport`.

    begin
    re = PythonCall.pyimport("re")
    words = re.findall("[a-zA-Z]+", "PythonCall.jl is great")
    sentence = Py(" ").join(words)
    pyconvert(String, sentence)  # convert Python string to Julia string
    end

Try it.
"""

# ╔═╡ 5805328f-cb15-41c7-8b4c-9990cd0df319


# ╔═╡ 56141542-b8eb-4139-8199-acea701449e2
md"""
#### Wrapper Types

A wrapper is a Julia type that wraps a Python object, but gives it Julia semantics. For example, the PyList type wraps Python's list object. 

    begin
    x = pylist([3,4,5])
    y = PyList{Union{Nothing, Int64}}(x)
    push!(y, nothing)
    append!(y, 1:2)
    x
    end

Try it.
"""

# ╔═╡ 966da8a4-6cee-47c3-bca1-a90460218f3f


# ╔═╡ 4adcd9bb-40dc-47dc-941d-66d34465b218
md"""
There are wrappers for other container types, such as PyDict and PySet.

    let
    x = PythonCall.pyimport("array").array("i", [3,4,5])
    y = PythonCall.PyArray(x)
    println(sum(y))
    y[1] = 0
    x
    end

Try this example too.
"""

# ╔═╡ adb77392-c109-4e90-917e-75a23e7f21a9


# ╔═╡ aa641087-0617-45ce-9ad1-69128fd155e9
md"""
PyArray directly wraps the underlying data buffer, so array operations such as indexing are about as fast as an ordinary Array.

#### Configuration

By default, PythonCall uses CondaPkg.jl to manage its dependencies. This will install Conda and use it to create a Conda environment specific to your current Julia project.

#### Using your current Python installation

    ENV["JULIA_CONDAPKG_BACKEND"] = "Null"
    END["JULIA_PYTHONCALL_EXE"] = "/path/to/python"   # optional
    END["JULIA_PYTHONCALL_EXE"] = "@PyCall"   # optional

By setting the CondaPkg backend to Null, no Conda packages will be installed. PythonCall will use your current Python installation.

If Python is not in your `PATH`, you will need to set the `JULIA_PYHTHONCALL_EXE` environment variable to include it in your path.

If you also use PyCall, you can set the `JULIA_PYTHONCALL_EXE` environment variable to use the same interpreter.

#### Using your current Conda environment

    ENV["JULIA_CONDAPKG_BACKEND"] = "Current"
    ENV["JULIA_CONDAPKG_EXE"] = "/path/to/conda"   # optional

Note that this configuration will still install any required Conda packages into your Conda envirnment.

If `conda`, `mamba`, and `micromamba` are not in your `PATH` you will need to set `JULIA_CONDAPKG_EXE` to include them.

#### Using your current Conda, Mamba, and MicroMamba environment

    ENV["JULIA_CONDAPKG_BACKEND"] = "System"
    ENV["JULIA_CONDAPKG_EXE"] = "/path/to/conda"   # optional

The System backend will use your preinstalled Conda environment.

#### Installing Python packages

Assuming you are using `CondaPkg.jl`, PythonCall uses it to automatically install any Python packages. For example,

    using CondaPkg
    # enter package manager
    conda add some_package

"""

# ╔═╡ Cell order:
# ╟─3ba5672b-18ff-4320-a4d2-954e0b873d47
# ╟─4c788b44-77e1-11ed-0ce7-5914857ba421
# ╟─f0c6b09d-8b64-4175-aacd-6b3ac72078f6
# ╠═41103ed5-6145-4772-84d6-8858ebb560ac
# ╟─306378d0-91a3-4f07-94fb-45b8cc474274
# ╠═667e42f2-b6b5-4eb9-817f-57aee042d7ca
# ╟─06d63e41-f9b9-4c75-87d4-241beb454dc5
# ╠═20c226ca-44e6-4565-b601-07f5df7828ac
# ╟─7728f44a-93e1-4514-8964-6351a5ebff07
# ╠═8648cd40-d805-49b3-b05a-93a4b6ea0a20
# ╟─f790ac60-d874-4e95-8d34-252f44ff32b1
# ╠═90c8b0db-f94b-440c-b05a-72e3f6483051
# ╟─5d883d2b-515f-4286-a2ab-15127ac6b5ea
# ╟─87b3ca0e-93d3-41d3-aa6d-e06ab0fbac26
# ╠═0db12101-fcf9-48a3-a337-ad53a4713f6d
# ╟─93e945de-7ceb-4124-b3db-f6b64e2e46bb
# ╠═fa825783-6f48-4f0d-b346-220ae9e2fb11
# ╟─99e16357-0113-4a12-8a22-f627c6fdef84
# ╠═5805328f-cb15-41c7-8b4c-9990cd0df319
# ╟─56141542-b8eb-4139-8199-acea701449e2
# ╠═966da8a4-6cee-47c3-bca1-a90460218f3f
# ╟─4adcd9bb-40dc-47dc-941d-66d34465b218
# ╠═adb77392-c109-4e90-917e-75a23e7f21a9
# ╟─aa641087-0617-45ce-9ad1-69128fd155e9
