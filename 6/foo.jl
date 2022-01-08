using DataStructures

lines = open(readlines, "in.txt")

root = "COM"

nodes = DefaultDict(Deque{String})
for line in lines
    s, e = split(line, ")")
    push!(nodes[s], e)
end

function calculate1()
    seen = Set(["COM"])

    stack = Deque{Tuple{String, Int}}()
    push!(stack, ("COM", 0))
    count = 0
    while length(stack) > 0
        n, o = pop!(stack)
        count += o
        o += 1
        if !(n in keys(nodes))
            continue
        end
        for ne in nodes[n]
            if ne in seen
                error("NOT A TREE")
            end
            push!(seen, ne)

            push!(stack, (ne, o))
        end
    end

    return count
end

println(calculate1())

for line in lines
    e, s = split(line, ")")
    push!(nodes[s], e)
end

function calculate2()
    seen = Dict("YOU"=>-2)

    q = Deque{String}()
    push!(q, "YOU")
    while length(q) > 0
        n = popfirst!(q)
        if n == "SAN"
            return seen[n]
        end
        d = seen[n] + 1
        for ne in nodes[n]
            if ne in keys(seen)
                continue
            end
            seen[ne] = d

            push!(q, ne)
        end
    end

    return -1


end

println(calculate2())
