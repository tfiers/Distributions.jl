```@meta
CurrentModule = Distributions  # So that non-exported names don't need to be prefixed
                               # to be referenced.
```

# Physical Units

There is currently no common interface for units and physical dimensions in the Julia ecosystem. Therefore, we directly support the package that is the most widely used and evolved: [Unitful](https://github.com/PainterQubits/Unitful.jl).

## Usage example




## Supported distributions
Distributions that currently support unitful variates and (when appropriate) unitful parameters:

- [`Exponential`](@ref)
- [`LogNormal`](@ref)


## How it works, or: How to support other distributions

If you want to add unit support to a distribution that currently only supports `Real`s (whether this distribution is in _Distributions_'s source, or custom made according to [Create a Distribution](@ref)), follow the steps below.

**1.** Change the type of the variate from `Real` to [`RealQuantity`](@ref), wherever it appears.
```@meta
# example of changes, eg `pdf(d::Gamma, x)`
```
```@docs
RealQuantity
```

**2.** Identify distribution parameters that should have the same units as the variate, and change their type to `RealQuantity`, too.
```@meta
# before after example
```
If there are no such parameters (as in _e.g._ `LogNormal`), add a "`U`" type parameter to your distribution (with `U <: Units`). Add a `units` keyword argument to the distribution's constructors, with a default value of `NoUnits`:

`Unitful.NoUnits` is a 0-size singleton that gets pruned away in mathematical expressions at compile-time

**3.** Define `Base.eltype(::Type{YourDist})` to return the variate's data type.

- This is necessary for `rand(::YourDist, dims)` to work correctly, as Julia's Random API [asks](https://docs.julialang.org/en/v1/stdlib/Random/#A-simple-sampler-without-pre-computed-data) for `eltype` to be implemented so that it can pre-allocate arrays with the correct element type.
- `eltype` is also used by [`unit`](@ref) to determine the distribution's units.

**4.** Wherever the `log` of a `RealQuantity` is taken, scale and convert the argument to a `Real` using the provided [`unit`](@ref) method.

```@meta
# also mention extrema
# and that `oneunit` is useful.
```

```@docs
unit
```
