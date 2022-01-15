using DataStructures

include("../lib/intcode.jl")

code = loadcode("in.txt")

dirs = [
        CartesianIndex(0,-1),
        CartesianIndex(0,1),
        CartesianIndex(-1,0),
        CartesianIndex(1,0),
       ]
op(d) = d%2 + 2*((d-1)÷2) + 1

task, input, output = astask(code)
schedule(task)

function move(d)
    put!(input, d)
    return take!(output)
end


# Build the grid

# 0 = wall, 1 = empty, 2 = goal
grid = Dict()

# Iterative DFS
q = [[CartesianIndex(0,0), 0]]
while !isempty(q)
    top = q[end]

    if top[2] > 0
        # move back
        move(op(top[2]))
    end

    if top[2] == -1
        pop!(q)
        continue
    end

    nd = top[2]
    top[2] = -1

    while nd < 4
        nd += 1
        npos = top[1] + dirs[nd]
        if npos in keys(grid)
            continue
        end
        grid[npos] = move(nd)
        if grid[npos] == 0
            continue
        else
            top[2] = nd
            push!(q, [npos, 0])
            break
        end
    end
end


# Search the grid

function search(start, target)
    q = Deque{Tuple{CartesianIndex, Int}}()
    push!(q, (start, 0))

    seen = Set()
    push!(seen, start)

    maxdist = 0

    while !isempty(q)
        pos, dist = popfirst!(q)
        maxdist = max(dist, maxdist)

        for d in values(dirs)
            npos = pos + d
            if grid[npos] == 0 || npos in seen
                continue
            end
            push!(seen, npos)
            if grid[npos] == target
                return dist+1
            end
            push!(q, (npos, dist+1))
        end
    end
    return maxdist
end
println(search(CartesianIndex(0, 0), 2))
println(search(findfirst(x -> x == 2, grid), -1))
