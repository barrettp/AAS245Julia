# AAS245Julia
Pluto notebooks for the two day Julia workshop for the 245th AAS Meeting in Washington, DC.

[**Jump to installation instructions**](#installation-instructions)

[**Jump to workshop contents**](#workshop-contents)

This repository contains material for the AAS Workshop *Julia Programming for Astronomy*

Date: **Saturday-Sunday, January 11-12, 2025, 9:00 am - 5:00 pm**

The Julia programming language can be considered the successor to Scientific Python (SciPy). The language is designed for scientific computing by having built-in multidimensional arrays and parallel processing features. Yet, it can also be used as a general-purpose programming language like Python. Unlike Python, Julia solves the two-language problem by using just-in-time (JIT) compilation to generate machine code from high level expressions. In most cases, Julia is as fast as C, and in some cases faster. Julia is also a composable language, so independent libraries or packages usually work well together without any modification. These important features make Julia a very productive language for scientific software development by significantly reducing the number of lines of code. In essence, *Julia is Python with Numba and JAX built-in.* 

The objectives of this tutorial are: (1) to introduce astronomers and software developers to the basic language syntax, features, and power of the Julia programming language, (2) to apply the language and its package to astronomical data analyis, (3) to compare and contrast Julia’s design features to those of C/C++ and Python, and (4) to show that Julia provides an easy migration path from languages such as C/C++, FORTRAN, and Python. In other words, it is not necessary to rewrite all of your code all at once.

The two day workshop is divided into morning and afternoon sessions. Each morning and afternoon session contains three 45 minute tutorials. The Saturday session is an introduction to important features of the language, such as unicode characters, multi-dimensional arrays, and functions, while using various Julia packages to perform data analysis of multiwavelength data. The Sunday session covers advanced topics, such as calling Python, using macros, optimizing code, creating packges, and parallel computation.

## Installation Instructions

We will be using Julia and Pluto notebooks to make the installation process as easy and painless as possible. Please follow these installation instructions before the start of the workshop. If you run into to difficulties, please feel free to contact the organizers or let us know at the start of the workshop.

Note: Pluto notebooks are not compatible with Jupyter.

### Installing Julia
Please [install the latest stable version of Julia](https://julialang.org/downloads/) (1.11.2 as of Dec 1, 2024) on you computer. Make sure to use the links on the official Julia website linked above, rather than any 3rd party package manager (e.g. homebrew, apt, nuget, etc.).

For more advanced users, [JuliaUp](https://github.com/JuliaLang/juliaup) can be used to install, update, and switch between versions of Julia. 

<details>
<summary>MacOS Instructions</summary>
If you have a new mac with an M1 processor, make sure to select the "M-series Processor" link for improved performance.
</details>

<details>
<summary>Windows Instructions</summary>
This <a href="https://www.microsoft.com/store/apps/9NJNWW8PVKMN">Microsoft Store</a> link can also be used to install JuliaUp.

We strongly recomend you use the [Windows Terminal](https://en.wikipedia.org/wiki/Windows_Terminal) included in Windows 11 or downloadable from this <a href="https://aka.ms/terminal">Microsoft Store link</a>. Windows Terminal has improved font and math symbol rendering compared to the antiquated [Windows console/`cmd.exe`](https://en.wikipedia.org/wiki/Windows_Console).
</details>

<details>
<summary>Linux Instructions</summary>
After downloading the correct version of Julia for your operating system, expand the archive (e.g. <code>tar -xvf julia-xyz.tar.gz</code>) and place the binary <code>julia-xyz/bin/julia</code> in your <code>PATH</code>.

The versions of Julia included in OS package managers (yum, apt, pacman, etc) frequently have bugs not seen in the offical binaries and should be avoided. For more information, <a href="https://julialang.org/downloads/platform/#a_brief_note_about_unofficial_binaries">see here</a>.
</details>

<details>
<summary>Docker</summary>
Julia runs in lightweight, self-contained environments. It is therefore not usually necessary to install Julia within Docker for the sake of reproducibility.
</details>

Once you have installed Julia, run the following command in your terminal to install Pluto:
```bash
julia -e 'using Pkg; Pkg.add("Pluto")'
```

Set the desired number of threads Julia should run with using an environment variable:

**Windows:**

In cmd, type
```cmd
SET JULIA_NUM_THREADS=auto
```
or in Powershell, type
```ps1
$ENV:JULIA_NUM_THREADS = "auto"
```

**Mac & Linux:**
```bash
export JULIA_NUM_THREADS=auto
```


Then, in the same terminal, start Julia by running:
```bash
julia
```

To start Pluto, run the following from inside Julia:
```julia-repl
julia> using Pluto
julia> Pluto.run()
```

### Note on Python
In one section, we will demonstrate how you can use Python libraries inside Julia. You do not have to have a Python installed in advance.

## Workshop Contents

The material for each section is stored as a [Pluto notebook](https://plutojl.org/). 

Copy the link for a given section below and paste it into the "Open a Notebook" box in Pluto.

The Saturday content is an introduction to the Julia language and applies it to a few data analysis topics (notebooks 1-6).
The Sunday content covers advanced Julia programming techniques associated with high performance computing.

| Topic | Link | 
|-------|------|
| 01. Introducing Julia | https://github.com/barrettp/AAS245Julia/raw/main/01-intro-to-julia.jl |
| 02. Dataframes | https://github.com/barrettp/AAS245Julia/raw/main/02-dataframes.jl |
| 03. Exoplanets |  |
| 04. Radio Imaging |  |
| 05. X-Ray Spectroscopy |  |
| 06. Astronomy Packages |  |
| 07. Calling Python | https://github.com/barrettp/AAS245Julia/blob/main/07-calling-python.jl |
| 08. Using Macros | https://github.com/barrettp/AAS245Julia/blob/main/08-using-macros.jl |
| 09. Optimizing Code | https://github.com/barrettp/AAS245Julia/blob/main/09-optimizing-code.jl |
| 10. Parallel Computing | https://github.com/barrettp/AAS245Julia/blob/main/10-parallel-computing.jl |
| 11. Creating Packages | https://github.com/barrettp/AAS245Julia/blob/main/11-creating-packages.jl | 
| 12. Questions and Special Topics | |
