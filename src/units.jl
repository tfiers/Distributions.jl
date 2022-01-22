# Variates and distribution parameters with physical dimensions.

using Unitful: Unitful, NoDims, NoUnits, unit

const RealQuantity{T} = Union{T, Unitful.Quantity{<:T}} where {T <: Real}

"""
    unit(d::Distribution)

Retrieve the physical units of the distribution's variate. If the distribution does not have
units attached (*i.e.* it is over real values), this is `Unitful.NoUnits`, which is a 0-size
singleton that gets pruned away in mathematical expressions at compile-time. If the
distribution does have units attached, this is either `unit(eltype(d))`, if the units are
implicit from the distribution's parameters; or `d.unit` if not.
"""
Unitful.unit(d::D) where {D <: Distribution} = hasfield(D, :unit) ? d.unit : unit(eltype(D))

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
