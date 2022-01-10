using DataStructures
include("../lib/intcode.jl")

code = loadcode("in.txt")

function run(start)
    task, input, output = astask(code)
    
    grid = DefaultDict{Array{Int, 1}, Int}(0)

    dirs = [[0,-1],[1,0],[0,1],[-1,0]]
    pos = [0,0]
    d = 1

    grid[pos] = start
    
    schedule(task)
    while !istaskdone(task)
        put!(input, grid[pos])
        grid[pos] = take!(output)
        d = mod1(d + take!(output)*2-1, 4)
        pos += dirs[d]
    end

    return grid
end

println(length(run(0)))

result = run(1)
coords = hcat(collect(keys(result))...)
mx, Mx = minimum(coords[1, :]), maximum(coords[1, :])
my, My = minimum(coords[2, :]), maximum(coords[2, :])
println(size(coords))
println((mx, my, Mx, My))
map(println, join(result[[x,y]] == 1 ? '■' : ' ' for x in mx:Mx) for y in my:My)
