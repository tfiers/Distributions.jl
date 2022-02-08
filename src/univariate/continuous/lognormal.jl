"""
    LogNormal(μ, σ, [units])

The *log normal distribution* is the distribution of the exponential of a [`Normal`](@ref) variate: if ``X \\sim \\operatorname{Normal}(\\mu, \\sigma)`` then
``\\exp(X) \\sim \\operatorname{LogNormal}(\\mu,\\sigma)``. The probability density function is

```math
f(x; \\mu, \\sigma) = \\frac{1}{x \\sqrt{2 \\pi \\sigma^2}}
\\exp \\left( - \\frac{(\\log(x) - \\mu)^2}{2 \\sigma^2} \\right),
\\quad x > 0
```

```julia
LogNormal()          # Log-normal distribution with zero log-mean and unit scale
LogNormal(μ)         # Log-normal distribution with log-mean mu and unit scale
LogNormal(μ, σ)      # Log-normal distribution with log-mean mu and scale sig

params(d)            # Get the parameters, i.e. (μ, σ)
meanlogx(d)          # Get the mean of log(X), i.e. μ
varlogx(d)           # Get the variance of log(X), i.e. σ^2
stdlogx(d)           # Get the standard deviation of log(X), i.e. σ
```

Both parameters μ and σ are dimensionless, and can thus not be used to specify physical
units for the variate. Rather, you can pass a third argument for this purpose:
```jldoctest
julia> using Unitful: mV
       d = LogNormal(0, 1, mV)
       mean(d)
1.6487212707001282 mV
```

External links

* [Log normal distribution on Wikipedia](http://en.wikipedia.org/wiki/Log-normal_distribution)

"""
struct LogNormal{T<:Real,U<:Units} <: ContinuousUnivariateDistribution
    μ::T
    σ::T
    LogNormal{T,U}(μ::T, σ::T) where {T,U} = new{T,U}(μ, σ)
end

function LogNormal(μ::T, σ::T, units::Units=NoUnits; check_args::Bool=true) where {T <: Real}
    check_args && @check_args(LogNormal, σ ≥ zero(σ))
    return LogNormal{T,typeof(units)}(μ, σ)
end

LogNormal(μ::Real, σ::Real, units::Units=NoUnits; check_args::Bool=true) = LogNormal(promote(μ, σ)..., units; check_args=check_args)
LogNormal(μ::Integer, σ::Integer, units::Units=NoUnits; check_args::Bool=true) = LogNormal(float(μ), float(σ), units; check_args=check_args)
LogNormal(μ::Real=0.0, units::Units=NoUnits) = LogNormal(μ, one(μ), units; check_args=false)

Base.eltype(::Type{<:LogNormal{T,typeof(NoUnits)}}) where {T<:Real} = T
Base.eltype(::Type{<:LogNormal{T,U}}) where {T<:Real,U<:Units{N,D}} where {N,D} = Quantity{T,D,U}

minimum(::LogNormal{T,U}) where {T,U} = 0.0 * U()
maximum(::LogNormal{T,U}) where {T,U} = Inf * U()

#### Conversions
convert(::Type{LogNormal{T}}, μ::S, σ::S) where {T<:Real, S<:Real} = LogNormal(T(μ), T(σ), NoUnits)
convert(::Type{LogNormal{T,U}}, d::LogNormal{S,U}) where {T<:Real, S<:Real, U<:Units} = LogNormal(T(d.μ), T(d.σ), U(), check_args=false)

#### Parameters

params(d::LogNormal) = (d.μ, d.σ)
partype(::LogNormal{T}) where {T} = T

#### Statistics

meanlogx(d::LogNormal) = d.μ
varlogx(d::LogNormal) = abs2(d.σ)
stdlogx(d::LogNormal) = d.σ

mean(d::LogNormal) = ((μ, σ) = params(d); exp(μ + σ^2/2) * unit(d))
median(d::LogNormal) = exp(d.μ) * unit(d)
mode(d::LogNormal) = ((μ, σ) = params(d); exp(μ - σ^2) * unit(d))

function var(d::LogNormal)
    (μ, σ) = params(d)
    σ2 = σ^2
    (exp(σ2) - 1) * exp(2μ + σ2) * unit(d)^2
end

function skewness(d::LogNormal)
    σ2 = varlogx(d)
    e = exp(σ2)
    (e + 2) * sqrt(e - 1) * unit(d)
end

function kurtosis(d::LogNormal)
    σ2 = varlogx(d)
    e = exp(σ2)
    e2 = e * e
    e3 = e2 * e
    e4 = e3 * e
    (e4 + 2*e3 + 3*e2 - 6) * unit(d)
end

function entropy(d::LogNormal)
    (μ, σ) = params(d)
    (1 + log(twoπ * σ^2))/2 + μ
end


#### Evalution

function pdf(d::LogNormal, x::RealQuantity)
    if x ≤ zero(x)
        logx = log(zero(x) / unit(d))
        x = oneunit(x)
    else
        logx = log(x / unit(d))
    end
    return pdf(Normal(d.μ, d.σ), logx) / x
end

function logpdf(d::LogNormal, x::RealQuantity)
    if x ≤ zero(x)
        logx = log(zero(x) / unit(d))
        b = zero(logx)
    else
        logx = log(x / unit(d))
        b = logx
    end
    return logpdf(Normal(d.μ, d.σ), logx) - b
end

function cdf(d::LogNormal, x::RealQuantity)
    logx = x ≤ zero(x) ? log(zero(x) / unit(d)) : log(x / unit(d))
    return cdf(Normal(d.μ, d.σ), logx)
end

function ccdf(d::LogNormal, x::RealQuantity)
    logx = x ≤ zero(x) ? log(zero(x) / unit(d)) : log(x / unit(d))
    return ccdf(Normal(d.μ, d.σ), logx)
end

function logcdf(d::LogNormal, x::RealQuantity)
    logx = x ≤ zero(x) ? log(zero(x) / unit(d)) : log(x / unit(d))
    return logcdf(Normal(d.μ, d.σ), logx)
end

function logccdf(d::LogNormal, x::RealQuantity)
    logx = x ≤ zero(x) ? log(zero(x) / unit(d)) : log(x / unit(d))
    return logccdf(Normal(d.μ, d.σ), logx)
end

quantile(d::LogNormal, q::Real) = exp(quantile(Normal(params(d)...), q)) * unit(d)
cquantile(d::LogNormal, q::Real) = exp(cquantile(Normal(params(d)...), q)) * unit(d)
invlogcdf(d::LogNormal, lq::Real) = exp(invlogcdf(Normal(params(d)...), lq)) * unit(d)
invlogccdf(d::LogNormal, lq::Real) = exp(invlogccdf(Normal(params(d)...), lq)) * unit(d)

function gradlogpdf(d::LogNormal, x::RealQuantity)
    outofsupport = x ≤ zero(x)
    y = outofsupport ? oneunit(x) : x
    z = (gradlogpdf(Normal(d.μ, d.σ), log(y / unit(d))) - 1) / y
    return outofsupport ? zero(z) : z
end

# mgf(d::LogNormal)
# cf(d::LogNormal)


#### Sampling

rand(rng::AbstractRNG, d::LogNormal) = exp(randn(rng) * d.σ + d.μ) * unit(d)

## Fitting

fit_mle(dt::Type{<:LogNormal}, x::AbstractArray{<:Real}) = LogNormal(_ml_params(dt, x)..., NoUnits)
fit_mle(dt::Type{<:LogNormal}, x::AbstractArray{<:Quantity{<:Real,D,U}}) where {D,U} = LogNormal(_ml_params(dt, ustrip(x))..., U())

_ml_params(::Type{<:LogNormal}, x::AbstractArray{<:Real}) = mean_and_std(log.(x))


"""
    _ml_params(::Type{<:Distribution}, x::AbstractArray)

Calculate the parameters of the given distribution type that make the observations `x` most
likely.
"""
_ml_params(::Type{<:Distribution}, x::AbstractArray)
