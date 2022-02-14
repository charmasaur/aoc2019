using DataStructures

grid = hcat(map(collect, open(readlines, "in.txt"))...)
numkeys = count(islowercase, grid)

start = findfirst(x -> x == '@', grid)

dirs = [
        CartesianIndex(0, 1),
        CartesianIndex(1, 0),
        CartesianIndex(0, -1),
        CartesianIndex(-1, 0),
       ]

function alldists(start, grid)
    q = Deque{Tuple{CartesianIndex, Int}}()
    push!(q, (start, 0))
    seen = Dict(q)
    output = Dict(q)
    
    while !isempty(q)
        pos, dist = popfirst!(q)
    
        for dir in dirs
            np = pos + dir
            if np[1] < 1 || np[2] < 1 || np[1] > size(grid)[1] || np[2] > size(grid)[2] || grid[np] == '#'
                continue
            end
            if np in keys(seen)
                continue
            end
            ndist = dist+1
            seen[np] = ndist
            if grid[np] != '.'
                output[np] = ndist
                continue
            end
            push!(q, (np, ndist))
        end
    end
    return output
end

# reduced graph
graph = Dict((n => alldists(n, grid) for n in findall(x -> x != '.' && x != '#', grid)))

function allkeysdist(graph, start, grid)
    # (dist, (pos, keys))
    q = BinaryMinHeap{Tuple{Int, Tuple{CartesianIndex, String}}}()
    push!(q, (0, (start, "")))
    seen = DefaultDict(2^32, [((start, ""), 0)])
    
    while !isempty(q)
        dist, node = pop!(q)
        pos, wkeys = node
        if length(wkeys) == numkeys
            return dist
        end
    
        for out in graph[pos]
            np, ddist = out
            ndist = dist + ddist
            nkeys = wkeys

            if isuppercase(grid[np]) && !occursin(lowercase(grid[np]), nkeys)
                continue
            end
            if islowercase(grid[np]) && !occursin(grid[np], nkeys)
                nkeys = join(sort(vcat(collect(nkeys), [grid[np]])))
            end
            nnode = (np, nkeys)
            if ndist < seen[nnode]
                seen[nnode] = ndist
                push!(q, (ndist, nnode))
            end
        end
    end
    return -1
end

println(allkeys(graph, start, grid))

## is it a tree (modulo the block in the center)?
#q = Deque{Tuple{CartesianIndex, Int}}()
#for x in -1:1
#    for y in -1:1
#        push!(q, (CartesianIndex(x, y)+start, abs(x)+abs(y)))
#    end
#end
#
#seen = Dict(q)
#allowlist = Set(keys(seen))
#
#while !isempty(q)
#    p, d = popfirst!(q)
#    println(p, " ", d)
#
#    for dir in dirs
#        np = p + dir
#        if np[1] < 1 || np[2] < 1 || np[1] > size(grid)[1] || np[2] > size(grid)[2] || grid[np] == '#'
#            continue
#        end
#        if np in keys(seen) && abs(d+1-seen[np]) != 2 && !(np in allowlist)
#            error("Not a tree", p, " ", d, " ", np)
#        end
#        if np in keys(seen)
#            continue
#        end
#        push!(q, (np, d+1))
#        seen[np] = d+1
#    end
#end


# BFS with state explosion

function find()
    q = Deque{Tuple{Tuple{CartesianIndex, String}, Int}}()
    push!(q, ((start, ""), 0))
    seen = Dict(q)
    
    while !isempty(q)
        node, dist = popfirst!(q)
        pos, wkeys = node
    
        for dir in dirs
            np = pos + dir
            nkeys = wkeys
            if np[1] < 1 || np[2] < 1 || np[1] > size(grid)[1] || np[2] > size(grid)[2] || grid[np] == '#'
                continue
            end
            if isuppercase(grid[np]) && !occursin(lowercase(grid[np]), nkeys)
                continue
            end
            if islowercase(grid[np]) && !occursin(grid[np], nkeys)
                nkeys = join(sort(vcat(collect(nkeys), [grid[np]])))
            end
            nnode = (np, nkeys)
            if nnode in keys(seen)
                continue
            end
            ndist = dist+1
            seen[nnode] = ndist
            push!(q, (nnode, ndist))
    
            if length(nkeys) == numkeys
                return ndist
            end
        end
    end
    return -1
end

#println(find())
