dirs = Dict(
            'R'=>[1,0],
            'U'=>[0,-1],
            'L'=>[-1,0],
            'D'=>[0,1],
           )

# Iterable wire data structure
struct Wire
    parts::Array{Tuple{Array{Int, 1}, Int}, 1}
end

parse_part(part) = (dirs[part[1]], parse(Int, part[2:end]))
parse_wire(line::String) = Wire(map(parse_part, split(line, ",")))

Base.length(iter::Wire) = sum(part[2] for part in iter.parts)

function Base.iterate(iter::Wire, state=([0, 0], 1, 0))
    pos, part, amount = state

    if amount == iter.parts[part][2]
        part += 1
        amount = 0
    end
    if part > length(iter.parts)
        return nothing
    end
    pos += iter.parts[part][1]
    return pos, (pos, part, amount+1)
end

# Problem
lines = open(readlines, "in.txt")
wires = map(parse_wire, lines)

# Part 1
println(minimum(sum(abs.(x)) for x in intersect(wires...)))

# Part 2
# Dict of position => distance for first wire
w1 = Dict(map(reverse, reverse(collect(pairs(collect(wires[1]))))))
println(minimum(i[1]+w1[i[2]] for i in pairs(collect(wires[2])) if i[2] in keys(w1)))
