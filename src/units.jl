# Variates and distribution parameters with physical dimensions.

using Unitful: Unitful, NoDims, NoUnits

const Quantity = Union{Real, Unitful.Quantity{<:Real}}

"""
    units(d::Distribution)

Retrieve the physical units of the distribution's variate. If the distribution does not have
units attached (*i.e.* it is over real values), this is simply `1` or `1.0`. In general,
`units(::Distribution{T}) == oneunit(T)` (see [`Base.oneunit`](https://docs.julialang.org/en/v1/base/numbers/#Base.oneunit)),
or, if the user has specified a custom units scale, `units(d::Distribution) == d.units`.
"""
units(d::D) where {D <: Distribution} = hasfield(D, :units) ? d.units : oneunit(eltype(D))

"""
    dimensionless(x)

Given a dimensionless `Quantity`, strip it of its units.
A pure `Real` is passed through as is.

Only defined for dimensionless quantities. A logical error where `dimensionless` is called
with a dimensioned quantity will thus be caught by a MethodError.

Explicit unit stripping of dimensionless units is needed because Unitful does not
automatically strip the units when they cancel out (as with *e.g.* `1 Hz·s` or `1 mV/V`).
"""
dimensionless(x::Unitful.Quantity{<:Real, NoDims}) = NoUnits(x)
dimensionless(x::Real) = x
