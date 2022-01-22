# Variates and distribution parameters with physical dimensions.

using Unitful: Unitful, NoDims, NoUnits, unit

const RealQuantity = Union{Real, Unitful.Quantity{<:Real}}

"""
    unit(d::Distribution)

Retrieve the physical unit scale of the distribution. If the distribution does not have
units attached (*i.e.* it is over real values), this is simply `1` or `1.0`. In general,
`unit(::Distribution{T}) == oneunit(T)` (see [`Base.oneunit`](https://docs.julialang.org/en/v1/base/numbers/#Base.oneunit)),
or, if the user has specified a custom unit scale, `unit(d::Distribution) == d.unit`.

Note that where `Unitful.unit` returns a `Unitful.Units`, `Distributions.unit` returns a
`RealQuantity`:
```julia
unit(8mV)              == mV
unit(Exponential(8mV)) == 1mV
unit(8)              == NoUnits
unit(Exponential(8)) == 1
```
"""
Unitful.unit(d::D) where {D <: Distribution} = hasfield(D, :unit) ? d.unit
                                                                  : oneunit(eltype(D))

"""
    dimensionless(x)

Given a dimensionless `Quantity`, strip it of its units, obtaining a `Real`.
`Real`s are passed through as is.

Explicit unit stripping of dimensionless quantities is needed because Unitful does not
automatically strip units when they cancel out (as with *e.g.* `1 Hz·s` or `1 mV/V`).
"""
dimensionless(x::Real) = x
dimensionless(x::Unitful.Quantity{<:Real, NoDims}) = NoUnits(x)
dimensionless(x::Unitful.Quantity{<:Real}) = throw(Unitful.DimensionError(x, NoUnits))
