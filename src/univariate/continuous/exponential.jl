"""
    Exponential(θ)

The *Exponential distribution* with scale parameter `θ` has probability density function

```math
f(x; \\theta) = \\frac{1}{\\theta} e^{-\\frac{x}{\\theta}}, \\quad x > 0
```

```julia
Exponential()      # Exponential distribution with unit scale, i.e. Exponential(1)
Exponential(θ)     # Exponential distribution with scale θ

params(d)          # Get the parameters, i.e. (θ,)
scale(d)           # Get the scale parameter, i.e. θ
rate(d)            # Get the rate parameter, i.e. 1 / θ
```

External links

* [Exponential distribution on Wikipedia](http://en.wikipedia.org/wiki/Exponential_distribution)

"""
struct Exponential{T<:RealQuantity} <: ContinuousUnivariateDistribution
    θ::T        # note: scale not rate
    Exponential{T}(θ::T) where {T} = new{T}(θ)
end

function Exponential(θ::RealQuantity; check_args::Bool=true)
    check_args && @check_args(Exponential, θ > zero(θ))
    return Exponential{typeof(θ)}(θ)
end

Exponential(θ::Integer; check_args::Bool=true) = Exponential(float(θ); check_args=check_args)
Exponential() = Exponential{Float64}(1.0)

Base.eltype(::Type{Exponential{T}}) where {T} = T

minimum(d::Exponential) = 0 * unit(d)
maximum(d::Exponential) = Inf * unit(d)

### Conversions
convert(::Type{Exponential{T}}, θ::S) where {T <: RealQuantity, S <: RealQuantity} = Exponential(T(θ))
convert(::Type{Exponential{T}}, d::Exponential{S}) where {T <: RealQuantity, S <: RealQuantity} = Exponential(T(d.θ), check_args=false)

#### Parameters

scale(d::Exponential) = d.θ
rate(d::Exponential) = inv(d.θ)

params(d::Exponential) = (d.θ,)
partype(::Exponential{T}) where {T} = T

#### Statistics

mean(d::Exponential) = d.θ
median(d::Exponential) = logtwo * d.θ
mode(::Exponential{T}) where {T} = zero(T)

var(d::Exponential) = d.θ^2
skewness(::Exponential{T}) where {T} = T(2)
kurtosis(::Exponential{T}) where {T} = T(6)

entropy(d::Exponential{T}) where {T} = one(T) + log(dimensionless(d.θ / unit(d)))

function kldivergence(p::Exponential, q::Exponential)
    λq_over_λp = scale(q) / scale(p)
    return -logmxp1(dimensionless(λq_over_λp))
end

#### Evaluation

zval(d::Exponential, x::RealQuantity) = max(dimensionless(x / d.θ), 0)
xval(d::Exponential, z::Real) = z * d.θ

function pdf(d::Exponential, x::RealQuantity)
    λ = rate(d)
    z = λ * exp(-λ * max(x, zero(x)))
    return x < zero(x) ? zero(z) : z
end
function logpdf(d::Exponential, x::RealQuantity)
    λ = rate(d)
    z = log(dimensionless(λ * unit(d))) - dimensionless(λ * x)
    return x < zero(x) ? oftype(z, -Inf) : z
end

cdf(d::Exponential, x::RealQuantity) = -expm1(-zval(d, x))
ccdf(d::Exponential, x::RealQuantity) = exp(-zval(d, x))
logcdf(d::Exponential, x::RealQuantity) = log1mexp(-zval(d, x))
logccdf(d::Exponential, x::RealQuantity) = -zval(d, x)

quantile(d::Exponential, p::Real) = -xval(d, log1p(-p))
cquantile(d::Exponential, p::Real) = -xval(d, log(p))
invlogcdf(d::Exponential, lp::Real) = -xval(d, log1mexp(lp))
invlogccdf(d::Exponential, lp::Real) = -xval(d, lp)

gradlogpdf(d::Exponential, x::RealQuantity) = x > zero(x) ? -rate(d) : 0/unit(d)

mgf(d::Exponential, t::RealQuantity) = 1/(1 - dimensionless(t * scale(d)))
cf(d::Exponential, t::RealQuantity) = 1/(1 - im * dimensionless(t * scale(d)))


#### Sampling
rand(rng::AbstractRNG, d::Exponential) = xval(d, randexp(rng))


#### Fit model

struct ExponentialStats <: SufficientStats
    sx::RealQuantity   # (weighted) sum of x
    sw::Float64   # sum of sample weights

    ExponentialStats(sx::RealQuantity, sw::Real) = new(sx, sw)
end

suffstats(::Type{<:Exponential}, x::AbstractArray{<:RealQuantity}) = ExponentialStats(sum(x), length(x))
suffstats(::Type{<:Exponential}, x::AbstractArray{<:RealQuantity}, w::AbstractArray{Float64}) = ExponentialStats(dot(x, w), sum(w))

fit_mle(::Type{<:Exponential}, ss::ExponentialStats) = Exponential(ss.sx / ss.sw)
