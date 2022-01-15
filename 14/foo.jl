using DataStructures

lines = open(readlines, "in.txt")

# Load input
outs = DefaultDict(() -> [])
ins = Dict()
ins["ORE"] = (1, [])

part(x) = (parse(Int, split(x, " ")[1]), split(x, " ")[2])
for line in lines
    inputs, output = split(line, " => ")
    inputs = map(part, split(inputs, ", "))
    output = part(output)

    for input in inputs
        push!(outs[input[2]], output[2])
        ins[output[2]] = (output[1], inputs)
    end
end


function ore_for_fuel(f::Int)
    req = DefaultDict(0)
    req["FUEL"] = f

    pushed = Set(["ORE"])
    stack = [["ORE", 0]]

    while !isempty(stack)
        top, p = stack[end]
        if p == length(outs[top])
            count = ceil(Int, req[top] / ins[top][1])
            for (amount, input) in ins[top][2]
                req[input] += amount*count
            end

            pop!(stack)
            continue
        end

        p += 1
        stack[end][2] = p
        ne = outs[top][p]
        if !(ne in pushed)
            push!(stack, [ne, 0])
            push!(pushed, ne)
        end
    end
    return req["ORE"]
end


x = ore_for_fuel(1)
println(x)


m = Int(1e12)
upper = 1
while ore_for_fuel(upper) < m
    global upper
    upper *= 2
end
println(searchsorted(1:upper, 0, by=guess -> sign(ore_for_fuel(guess) - m))[end])
