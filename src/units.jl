# Variates and distribution parameters with physical dimensions.

using Unitful: Unitful, Quantity, Units, NoDims, NoUnits, unit, ustrip

"""
Type of the variate of a distribution that supports both pure `Real`s and real Unitful
Quantities. If a parameter of the distribution is dimensioned, it is also a `RealQuantity`.
```julia
const RealQuantity = Union{Real, Unitful.Quantity{<:Real}}
```
_i.e._ a `RealQuantity` is either a pure `Real`, or a Unitful `Quantity` with a `Real` as
numeric backing type.
"""
const RealQuantity = Union{Real, Unitful.Quantity{<:Real}}

"""
    unit(d::Distribution)

Retrieve the physical units of the distribution's variate, as a
[`Unitful.Units`](https://painterqubits.github.io/Unitful.jl/stable/types/).

 - If the distribution does not have units attached (*i.e.* it is over real values), this
   returns `NoUnits`, which is a 0-size singleton that gets pruned away in mathematical
   expressions at compile-time.

 - If the distribution does have units attached, this is `unit(eltype(d))`.
"""
Unitful.unit(::D) where {D <: Distribution} = unit(eltype(D))
