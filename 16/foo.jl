line = strip(open(f -> read(f, String), "in.txt"))
vec = map(x -> parse(Int, x), collect(line))
n = length(vec)


mat = transpose(hcat([repeat([0, 1, 0, -1], outer=n, inner=i)[2:n+1] for i in 1:n]...))
r = foldr((i, x) -> abs.(mat * x) .% 10, 1:100, init=vec)
println(join(map(string, r[1:8])))


offset = parse(Int, line[1:7])
if offset < (n*10000)/2
    error("Unexpected")
end

digs = reverse(repeat(vec, 10000)[offset+1:end])

r = foldr((i, x) -> cumsum(x) .% 10, 1:100, init=digs)
println(join(map(string, reverse(r)[1:8])))

