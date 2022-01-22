# Physical Units

There is currently no common interface for units and physical dimensions in the Julia ecosystem. Therefore, we directly support the package that is most evolved and widely used: [Unitful](https://github.com/PainterQubits/Unitful.jl).

<!-- repl example -->

Distributions that currently support unitful variates and parameters:

- `Exponential`


## Supporting other distributions

If you want to add unit support to a distribution that currently only supports `Real`s (whether this distribution is in _Distributions_'s source code, or custom made according to [Create a Distribution](@ref)), follow the steps below.

1. Change the type of the variate from `Real` to `Quantity`, wherever it appears.
<!-- example of changes, eg `pdf(d::Gamma, x)` -->

`Quantity` is defined as:
```julia
Quantity = Union{Real, Unitful.Quantity{<:Real}}
```
_i.e._ a `Distributions.Quantity` is either a pure `Real`, or a Unitful `Quantity` with a `Real` as numeric backing type.

2. Identify distribution parameters that should have the same units as the variate, and change their type to `Quantity` too. <!-- {*before after example*} -->  
If there are no such parameters (as in _e.g._ `LogNormal`), add a `unit` field to your distribution. In its constructors, give this field a default value of `1` or `1.0`, as appropriate.

3. Define `Base.eltype(::Type{YourDist})` to return the variate type.
    - `eltype` is used in [`unit`](@ref) to determine the distribution's units if the user did not explicitly specify them.
    - Julia's Random API also [asks this](https://docs.julialang.org/en/v1/stdlib/Random/#A-simple-sampler-without-pre-computed-data), so that `rand(::YourDist, dims)` can produce arrays with the correct element type. 

4. Wherever the `log` of a `Quantity` is taken, scale and convert the argument to a `Real` using the provided [`unit`](@ref) and [`dimensionless`](@ref) functions.
