# Variates and distribution parameters with physical dimensions.
# 
# See `units.md` in the docs.

using Unitful: Unitful, Quantity, DimensionlessQuantity, NoUnits

const Units = Union{Unitful.Units, Real}

"""
    units(d::Distribution)

Retrieve the physical [`Units`](@ref) of the distribution's variate.
"""
units(::Distribution)::Units
#   To be implemented by distributions wishing to support unitful variates.

"""
    units(x::Number)

Retrieve the physical [`Units`](@ref) of a variate or parameter.
If `x` is dimensionless or has no units specified, this is `one(T)`, with `T <: Real`
(*i.e.* `1`, `1.0`, …).

Note the difference with Unitful's [`unit`](https://painterqubits.github.io/Unitful.jl/stable/manipulations/#Unitful.unit),
which returns the singleton `NoUnits` for non-Unitful types, instead of `one(T)`.
"""
units(::Number)::Units

units(::Quantity{T,D,U}) where {T,D,U} = U()
units(::DimensionlessQuantity{T}) where T = one(T)
units(::T) = one(T)

"""
    dimensionless(x::DimensionlessQuantity)
    dimensionless(x::Real)

Given a dimensionless `Quantity`, strip it off its units. A `Real` is passed through as is.

Explicit unit stripping of dimensionless units is needed because Unitful does not
automatically strip the units when they cancel out (as with *e.g.* `Hz·s` or `mV/V`).
"""
dimensionless(x::DimensionlessQuantity{T}) where {T <: Real} = NoUnits(x)
dimensionless(x::Real) = x
