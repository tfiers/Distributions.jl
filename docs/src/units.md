# Physical Units

There is currently no common interface for units and physical dimensions in the Julia ecosystem. Therefore, we directly support the package that is the most evolved and widely used: [Unitful](https://github.com/PainterQubits/Unitful.jl).

<!-- repl example -->

Distributions that currently support unitful variates and parameters:

- `Exponential`


## Supporting other distributions

If you want to add unit support to some Distribution "`YourDist`" (whether it is defined in Distributions.jl's source code, or it is [custom made](@ref Create a Distribution)), follow the steps below.
<!-- check when built: does this work, or do we need 
      - # [Create a Distribution](@id create-a-distribution)
      - [custom made](@ref create-a-distribution)
 -->


1. Change the type of the variate from `Real` to `Quantity`, wherever it appears.
<!-- example of changes, eg `pdf(d::Gamma, x)` -->

`Quantity` is defined as:
```julia
Quantity = Union{Real, Unitful.Quantity{<:Real}}
```
*i.e.* a `Distributions.Quantity` is either a pure `Real`, or a Unitful `Quantity` with `Real` as numeric backing type.

2. Identify distribution parameters that should have the same units as the variate, and change their type to `Quantity` too. <!-- {*before after example*} -->  
If there are no such parameters (as in e.g. `LogNormal`), add a `units` field to `YourDist`. In `YourDist`'s constructors, give this field a default value of `1` or `1.0`, as appropriate.

3. Define `Base.eltype(::Type{YourDist})` to return the variate type.
    - Julia's Random API [asks](https://docs.julialang.org/en/v1/stdlib/Random/#A-simple-sampler-without-pre-computed-data) this, so that `rand(::YourDist, dims)` can produce arrays with the correct element type. 
    - `eltype` is also used in [`units`](@ref) to determine the distribution's units if the user did not explicitly specify them.

4. Wherever the `log` of a `Quantity` is taken, scale and convert the argument to a `Real` using the provided [`units`](@ref) and [`dimensionless`](@ref) functions.
