# Physical Units

There is currently no common interface for units and physical dimensions in the Julia ecosystem. Therefore, we directly support the package that is the most widely used and evolved: [Unitful](https://github.com/PainterQubits/Unitful.jl).

<!-- repl example -->

Distributions that currently support unitful variates and parameters:

- `Exponential`


## Supporting other distributions

If you want to add unit support to a distribution that currently only supports `Real`s (whether this distribution is in _Distributions_'s source, or custom made according to [Create a Distribution](@ref)), follow the steps below.

1. Change the type of the variate from `Real` to `RealQuantity`, wherever it appears.
<!-- example of changes, eg `pdf(d::Gamma, x)` -->

`RealQuantity` is defined as:
```julia
RealQuantity{T} = Union{T, Quantity{<:T}} where {T <: Real}
```
_i.e._ a `RealQuantity` is either a pure `Real`, or a Unitful `Quantity` with a `Real` as numeric backing type.

2. Identify distribution parameters that should have the same units as the variate, and change their type to `RealQuantity`, too. <!-- {*before after example*} -->  
If there are no such parameters (as in _e.g._ `LogNormal`), add a `unit` field to your distribution. In its constructors, give this field a default value of `NoUnits`.

`Unitful.NoUnits` is a 0-size singleton that gets pruned away in mathematical
expressions at compile-time

3. Define `Base.eltype(::Type{YourDist})` to return the variate's data type.
    - `eltype` is used by [`unit`](@ref) to determine the distribution's units if the user did not explicitly specify them.
    - Julia's Random API also [asks](https://docs.julialang.org/en/v1/stdlib/Random/#A-simple-sampler-without-pre-computed-data) for `eltype` to be implemented so that it can pre-allocate arrays with the correct element type for `rand(::YourDist, dims)`.

4. Wherever the `log` of a `RealQuantity` is taken, scale and convert the argument to a `Real` using the provided [`unit`](@ref) and [`dimensionless`](@ref) functions.
