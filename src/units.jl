# Variates and distribution parameters with physical dimensions.

using Unitful: Unitful, Quantity, DimensionlessQuantity, NoUnits

"""
    units(d::Distribution)

Retrieve the physical units of the distribution's variate. If the distribution does not have
units attached (*i.e.* it is over real values), this is simply `1` or `1.0`. In general,
`units(::Distribution{T}) == oneunit(T)` (see [`Base.oneunit`](https://docs.julialang.org/en/v1/base/numbers/#Base.oneunit)),
or, if the user has specified a custom units scale, `units(d::Distribution) == d.units`.
"""
units(d::D) where {D <: Distribution} = hasfield(D, :units) ? d.units : oneunit(eltype(D))

"""
    dimensionless(x::DimensionlessQuantity)
    dimensionless(x::Real)

Given a dimensionless `Quantity`, strip it off its units. A `Real` is passed through as is.

Explicit unit stripping of dimensionless units is needed because Unitful does not
automatically strip the units when they cancel out (as with *e.g.* `Hz·s` or `mV/V`).
"""
dimensionless(x::DimensionlessQuantity{T}) where {T <: Real} = NoUnits(x)
dimensionless(x::Real) = x
