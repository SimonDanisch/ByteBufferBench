immutable StandardChunk
    i32::Int32
    i64::Int64
    i8::Int8
end
immutable ByteBuffer{Chunk}
    data::Vector{Chunk}
    ptr::Ptr{Int8}
end
ByteBuffer{T}(data::Vector{T}) = ByteBuffer{T}(data, convert(Ptr{Int8}, pointer(data)))

@inline offset(::Type{Int8}) = 12
@inline offset(::Type{Int32}) = 0
@inline offset(::Type{Int64}) = 4

@inline function setvalue{Chunk, T}(a::ByteBuffer{Chunk}, value::T, i::Integer)
    unsafe_store!(convert(Ptr{T}, a.ptr + ((sizeof(Chunk)*i)+offset(T))), value, 1)
end
@inline function getint(a::ByteBuffer, i::Integer)
    a.data[i].i32
end
@inline function getlong(a::ByteBuffer, i::Integer)
    a.data[i].i64
end
@inline function getbyte(a::ByteBuffer, i::Integer)
    a.data[i].i8
end


function main(nElements)
    println("testing objects[", nElements, "]")
    
    const idx = rand(1:nElements, nElements)

    t = ByteBuffer(Array(StandardChunk, nElements))
    ONE_MILLION = 1000000
    NANO = 1_000_000_000
    reads = Float64[]
    writes = Float64[]
    rreads = Float64[]

    #compile
    write(t, nElements)
    read(t, nElements)
    randomRead(t, nElements, idx)

    for i=1:100
        tic()
        resWrite     = write(t, nElements)
        totalWrite   = toq()

        tic()
        resRead      = read(t, nElements)
        totalRead    = toq()

        tic()
        rresRead     = randomRead(t, nElements, idx)
        rtotalRead   = toq()

        push!(reads, totalRead)
        push!(writes, totalWrite)
        push!(rreads, rtotalRead)
    end
    readsmean = mean(reads)
    writesmean = mean(writes)
    rreadsmean = mean(rreads)

    readsmax  = maximum(reads)
    writesmax = maximum(writes)
    rreadsmax = maximum(rreads)

    readsmin  = minimum(reads)
    writesmin = minimum(writes)
    rreadsmin = minimum(rreads)

    println("\"Julia 0.4 Linux\" => [")
    println("\"Reads\" => ", (nElements / readsmean) / ONE_MILLION, ",")
    println("\"Writes\" => ", (nElements / writesmean) / ONE_MILLION, ",")
    println("\"Random Reads\" =>", (nElements / rreadsmean) / ONE_MILLION, ",")

    println("\"Reads Max\" => ", (nElements / readsmin) / ONE_MILLION, ",")
    println("\"Writes Max\" => ", (nElements / writesmin) / ONE_MILLION, ",")
    println("\"Random Reads Max\" =>", (nElements / rreadsmin) / ONE_MILLION, ",")

    println("\"Reads Min\" => ", (nElements / readsmax) / ONE_MILLION, ",")
    println("\"Writes Min\" => ", (nElements / writesmax) / ONE_MILLION, ",")
    println("\"Random Reads Min\" =>", (nElements / rreadsmax) / ONE_MILLION, ",")
    println("]")

end


function write(t, items)
    @inbounds for index=1:items
        setvalue(t, index % Int8, index)
        setvalue(t, index % Int32, index)
        setvalue(t, index % Int64, index)
    end
    return items
end

function read(t, items)
    sum = 0
    @inbounds for index=1:items
        # consume ie use all read values to avoid dead code elimination
        sum += getint(t, index) + getlong(t, index) + getbyte(t, index)
    end
    return sum
end

function randomRead(t, items, idx)
    sum = 0
    @inbounds for index=1:items
        i = idx[index]
        # consume ie use all read values to avoid dead code elimination
        sum += getint(t, i) + getlong(t, i) + getbyte(t, i)
    end
    return sum
end

main(10000000)
