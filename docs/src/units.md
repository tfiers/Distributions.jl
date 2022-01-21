# Physical Units

There is currently no common interface for units / physical dimensions in the Julia ecosystem, so we directly support the current standard package: [Unitful](https://github.com/PainterQubits/Unitful.jl).

{*repl example*}

Distributions that currently support `Unitful.Quantity` variates and parameters:

- `Exponential`


## Supporting more distributions

If you want to add unit support to some Distribution "`MyDist`" (whether it is defined in Distributions.jl's source code, or it is a [custom made](@ref Create a Distribution) one):
<!-- check when built: does this work, or do we need 
      - # [Create a Distribution](@id create-a-distribution)
      - [custom made](@ref create-a-distribution)
 -->

1. Change the type of the variate from `Real` to `Number`, wherever it appears. (`Number` is a supertype of both `Unitful.Quantity` and `Real`).

{*before after example*} 
<!-- eg `pdf(d::MyDist, x)` -->

2. Identify distribution parameters that should have the same units as the variate, and change their type to `Number` too. If there are no such parameters (as in e.g. `LogNormal`), add a `units` field to `MyDist`. In `MyDist`'s constructors, give this field a default value of `1` or `1.0`, as appropriate.

{*before after example*}

3. Implement `Base.eltype(::Type{MyDist})`. It should return the variate type.
    Julia's Random API [asks](https://docs.julialang.org/en/v1/stdlib/Random/#A-simple-sampler-without-pre-computed-data) this, so that `rand(::MyDist, dims)` can produce arrays with the correct element type. `eltype` is also used in [`units`](@ref) to determine the distribution's units if the user did not explicitly specify a unit scale.
    
4. Wherever the `log` of the variate is taken, scale and convert the argument to a `Real` using the `units` and `dimensionless` functions.
