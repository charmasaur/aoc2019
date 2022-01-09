using Base.Iterators
using DataStructures
using IterTools

# (x, -y) coordinates (x points left, y points down)
asteroids = findall(x -> x == '#', hcat(map(collect, open(readlines, "in.txt"))...))

# why is this not already defined??
norm(x) = abs(x[1])+abs(x[2])

# define a "slope" so that the smallest is up and clockwise is increasing; we put elements in the
# right half plane first, and then order by actual gradient
slope(c) = (-sign(c[1]+0.5), c[2]//c[1])

scores = [length(unique(slope(c-p) for c in asteroids if c!=p)) for p in asteroids]
println(maximum(scores))

laser = asteroids[argmax(scores)]

result(x) = (x[1]-1)*100+(x[2]-1)

# create dict of slope -> [pos]
by_slope = DefaultDict(Deque{CartesianIndex})
foreach(x -> push!(by_slope[slope(x-laser)], x), sort(asteroids, by=x->norm(x-laser))[2:end])
all_slopes = sort(collect(keys(by_slope)))
println(result(nth(
                   (popfirst!(by_slope[l]) for l in cycle(all_slopes) if !isempty(by_slope[l])),
                   200)))
