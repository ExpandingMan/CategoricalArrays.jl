# delegate methods for SubArrays to support view

Missings.levels(sa::SubArray{T,N,P}) where {T,N,P<:CategoricalArray} = levels(parent(sa))
isordered(sa::SubArray{T,N,P}) where {T,N,P<:CategoricalArray} = isordered(parent(sa))
# This method cannot support allow_missing=true since that would modify the parent
levels!(sa::SubArray{T,N,P}, newlevels::Vector) where {T,N,P<:CategoricalArray} =
    levels!(parent(sa), levels)

if VERSION ≥ v"0.7.0-DEV.3020"
    function unique(sa::SubArray{T,N,P}) where {T,N,P<:CategoricalArray}
        A = parent(sa)
        refs = view(A.refs, sa.indices...)
        S = eltype(P) >: Missing ? Union{eltype(index(A.pool)), Missing} : eltype(index(A.pool))
        _unique(S, refs, A.pool)
    end

    refs(A::SubArray{<:Any, <:Any, <:CategoricalArray}) = view(A.parent.refs, A.indices...)
else
    function unique(sa::SubArray{T,N,P}) where {T,N,P<:CategoricalArray}
        A = parent(sa)
        refs = view(A.refs, sa.indexes...)
        S = eltype(P) >: Missing ? Union{eltype(index(A.pool)), Missing} : eltype(index(A.pool))
        _unique(S, refs, A.pool)
    end

    refs(A::SubArray{<:Any, <:Any, <:CategoricalArray}) = view(A.parent.refs, A.indexes...)
end

pool(A::SubArray{<:Any, <:Any, <:CategoricalArray}) = A.parent.pool
