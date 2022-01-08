lines = open(readlines, "in.txt")

println(sum(map(x -> parse(Int, x)÷3-2, lines)))

function fuel(x)
    x = parse(Int, x)
    f = 0
    while true
        x = div(x,3)-2
        if x <= 0
            break
        end
        f += x
    end
    return f
end

println(sum(map(fuel, lines)))

