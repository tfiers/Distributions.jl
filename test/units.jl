using Distributions
using Unitful
using Unitful: mV, DimensionError
using Test

MilliVoltage = Quantity{Float64, dimension(mV), typeof(mV)}

d = Exponential(8.0mV)

@testset begin
    @test unit(d) == 1mV
    @test eltype(d) == MilliVoltage
    @test partype(d) == MilliVoltage
    @test extrema(d) == (0mV, Inf*mV)
    @test islowerbounded(d) == true
    @test isupperbounded(d) == false
    @test insupport(d, 3mV)
    @test rate(d) == 1/8mV
    @test mean(d) == 8mV
    @test mode(d) == 0mV
    @test var(d) == 64mV^2
    @test kurtosis(d) == 6mV
    @test entropy(d) ≈ 3.07944154
    @test kldivergence(d, Exponential(7mV)) ≈ 0.0085313926
    @test_throws DimensionError kldivergence(d, Exponential(7mV^2))
    @test pdf(d, 1mV)  ≈ 0.110312112 / mV
    @test cdf(d, 1mV)  ≈ 0.117503097
    @test ccdf(d, 1mV) ≈ 0.8824969
    @test logpdf(d, 1mV) ≈ -2.20444154
    @test logcdf(d, 1mV) ≈ -2.14129058
    @test logccdf(d, 1mV) ≈ -0.125
    @test quantile(d, 0.6) ≈ 7.33032585 * mV
    @test cquantile(d, 0.4) ≈ 7.33032585 * mV
    @test invlogcdf(d, -1) ≈ 3.66940116 * mV
    @test invlogccdf(d, -1) ≈ 8 * mV
    @test gradlogpdf(d, 1mV) == -0.125/mV
    @test gradlogpdf(d, -1mV) == 0/mV
    @test mgf(d, 1/mV) ≈ -0.142857143
    @test cf(d, 1/mV) ≈ 0.015384615 + 0.123076923im
    @test typeof(rand(d)) == MilliVoltage
    @test typeof(rand(d, (3,3))) == Matrix{MilliVoltage}
    @test fit(Exponential, [3,2,1]mV) == Exponential(2mV)
    @test fit(Exponential, [3,2,1]mV, float([1,1,2])) == Exponential(1.75mV)
end
