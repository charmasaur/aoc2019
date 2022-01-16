using Combinatorics

include("../lib/intcode.jl")

code = loadcode("in.txt")

output = execute(code, [])

grid = map(collect, filter(l -> length(l) > 0, split(join(map(Char, output)), "\n")))
R = length(grid)
C = length(grid[1])

dcs = ['^','>','v','<']
dirs = [
        [-1,0],
        [0,1],
        [1,0],
        [0,-1],
       ]

ishash(p) = 1 <= p[1] <= R && 1 <= p[2] <= C && grid[p[1]][p[2]] == '#'

println(sum(map(prod, ((r-1, c-1) for r in 1:R, c in 1:C
                       if count(d -> ishash([r, c] + d), dirs) == 4))))


# Find segments
p = first([r, c] for r in 1:R, c in 1:C if grid[r][c] in "^v<>")
d = first(indexin(grid[p[1]][p[2]], dcs))

segments = []
dist = 0

while true
    global p, d, dist
    if ishash(p + dirs[d])
        p += dirs[d]
        dist += 1
        continue
    end

    if dist > 0
        push!(segments, string(dist))
        dist = 0
    end

    if ishash(p + dirs[mod1(d-1, 4)])
        d = mod1(d-1, 4)
        push!(segments, "L")
    elseif ishash(p + dirs[mod1(d+1, 4)])
        d = mod1(d+1, 4)
        push!(segments, "R")
    else
        break
    end
end


# Check whether a set of subsegments works
function dosubsegmentswork(subsegments)
    works = falses(length(segments)+1)
    works[1] = true
    prev = zeros(Int, length(segments)+1)

    for p in 2:length(works)
        foos = map(s -> (
                         p-1 >= length(s)
                         && works[p-length(s)]
                         && segments[p-length(s):p-1] == s),
                   subsegments)
        if any(foos)
            works[p] = true
            prev[p] = findfirst(foos)
        end
    end

    if !works[end]
        return nothing
    end

    order = []
    p = length(works)

    while prev[p] > 0
        push!(order, prev[p])
        p = p - length(subsegments[prev[p]])
    end

    if length(order) > 10
        return nothing
    end

    return reverse(order)
end


# Try all sets of three subsegments, evaluate with the one that works
allsubsegments = vcat([[segments[s:e] for e in s+1:2:length(segments)]
                       for s in 1:2:length(segments)]...)
shortenough = filter(x -> length(join(x, ",")) <= 20, allsubsegments)

code[1] = 2
for subsegments in combinations(shortenough, 3)
    r = dosubsegmentswork(subsegments)
    if r == nothing
        continue
    end
    functions = [join(s, ",") for s in subsegments]
    prog = join([["A", "B", "C"][o] for o in r], ",")
    command = join([prog, functions..., "n", ""], "\n")

    o = execute(code, collect(map(Int, collect(command))))
    println(o[end])
    break
end

# Manual version
## ≥33 segments
## 10 function calls
## 3.3 segments per function call
## ~5 chars per segment
## ≤4 segments per function
#
#A = "L,12,L,10,R,8,L,12"
#B = "R,8,R,10,R,12"
#C = "L,10,R,12,R,8"
#
#prog = "A,B,A,B,C,C,B,A,B,C"
#
#command = join([prog, A, B, C, "n", ""], "\n")
#output = execute(code, collect(map(Int, collect(command))))
#println(output[end])
