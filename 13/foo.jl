using IterTools

include("../lib/intcode.jl")

code = loadcode("in.txt")

function read(data, grid=Dict())
    for (x, y, i) in partition(data, 3)
        grid[(x,y)] = i
    end
    return grid
end
println(count(x -> x == 2, values(read(execute(code, [])))))


struct Blocking
    grid
    output
    manual
end

EMPTY = 0
WALL = 1
BLOCK = 2
PADDLE = 3
BALL = 4
chars = Dict(
             EMPTY => ' ',
             WALL => '■',
             BLOCK => '#',
             PADDLE => '_',
             BALL => 'o',
            )

function render!(x)
    read(x.output, x.grid)
    empty!(x.output)

    rows = maximum(p[2] for p in keys(x.grid))
    cols = maximum(p[1] for p in keys(x.grid))

    for r in 0:rows
        println(join(chars[x.grid[(c, r)]] for c in 0:cols))
    end
    println("Score: ", x.grid[(-1, 0)])
end

writeto!(x::Blocking, value) = push!(x.output, value)
function readfrom!(x::Blocking)
    render!(x)
    if x.manual
        return parse(Int, readline())
    end
    return sign(findfirst(x -> x == BALL, x.grid)[1]
                - findfirst(x -> x == PADDLE, x.grid)[1])
end

code[1] = 2
io = Blocking(DefaultDict(0), [], false)
execute(code, io, io)
render!(io)
