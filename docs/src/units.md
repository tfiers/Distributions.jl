# Physical Units

There is currently no common interface for units / physical dimensions in the Julia ecosystem, so we directly support the current standard package: [Unitful](https://github.com/PainterQubits/Unitful.jl).

{*repl example*}

Distributions that support `Unitful.Quantity` variates and parameters:

- `Exponential`


## Supporting more distributions

To make a Distribution `D` support [`Unitful.Quantity`](https://painterqubits.github.io/Unitful.jl/stable/types/#Unitful.Quantity)'s:

1. Change the type of the variate `x` from `Real` to `Number`, wherever it appears. (`Number` is a supertype of both `Quantity` and `Real`).

{*before after example*} 
<!-- eg with "(like in the signature of `pdf(d::D, x)`)" -->

2. Identify distribution parameters that should have the same units as the variate, and change their type to `Number` too. If there are no such parameters (as in e.g. `LogNormal`), add a `units` field to `D`'s `struct`. In `D`'s constructors, give this field a default value of `1` (or `1.0`, as appropriate).

{*before after example*}

3. Implement `units(d::D)`. This should return either the `units` field, or obtain the units via one of the parameters (using the `units(::Number)` function defined below).

4. Implement `Base.eltype(::Type{D})` to return the variate type.

5. Wherever the `log` of the variate is taken, scale and convert the argument to a `Real` using the `units` and `unitless` functions.
