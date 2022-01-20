# Support distributions on Unitful Quantities.
# 
# Most of this support is implicit when distributions are defined on `Number`s (which is a
# supertype of `Quantity`). What is not implicit is defined below.

using Unitful

# Define the arbitrary scaling factor of the logarithm of a dimensioned quantity to be that
# quantity's unit.
log(x::Quantity) = log(ustrip(x))  # equivalent to `log(x / oneunit(x))`.
