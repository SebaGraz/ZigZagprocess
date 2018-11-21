struct MultiNormal
    μ::Array{Float64, 1}
    Σ::Array{Float64, 2}
end
struct Normal
    μ::Float64
    σ::Float64
end
function ZigZag(N::Normal, ξ0::Float64, T::Float64)
    t = 0.0 ; θ = 1; ξ = ξ0
    Ξ = [ξ0]
    Γ = [t]
    while (t<T)
        τ = sqrt.(-2*N.σ*log(rand()) + max(0, θ*(ξ - N.μ))^2) - θ*(ξ-N.μ)
        t = t + τ
        ξ = ξ + θ*τ
        push!(Ξ, ξ)
        push!(Γ, t)
        θ = -θ
    end
    return(Γ,Ξ)
end
function ZigZag(N::MultiNormal, ξ0 , T)
    d = length(N.μ)
    t = 0.0 ; θ = ones(d); ξ = zeros(d)
    Ξ = [ξ]
    Γ = [t]
    while t<T
        τ = sqrt.(-2*N.Σ*log.(rand(d)) + max.(0 ,θ.*(ξ - N.μ)).^2) - θ.*(ξ-N.μ)
        τ, i0 = findmin(τ)
        t = t + τ
        ξ = ξ + θ.*τ
        push!(Ξ, ξ)
        push!(Γ, t)
        θ[i0] = -θ[i0]
    end
    return(Γ, Ξ)
end
N= MultiNormal([1.0, 1.0],[1.0 0.0; 0.0 1.0])
a = ZigZag(N,1.0,100.0)
# I have to figure out how to plot the coordinate
N= Normal(10.0,1.0)
b = ZigZag(N,1.0,100.0)
plot(b[1],b[2])
