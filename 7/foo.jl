include("../lib/intcode.jl")
using Combinatorics

code = loadcode("in.txt")

tryit(phases) = foldl((prev_output, phase) -> execute(code, [phase, prev_output])[1], phases, init=0)

perms = collect(permutations(0:4))
println(maximum(map(tryit, perms)))


readfrom!(x::Channel) = take!(x)
writeto!(x::Channel, value) = put!(x, value)

function tryit2(phases)
    pipes = [Channel(Inf) for phase in phases]
    map(put!, pipes, phases)
    put!(pipes[1], 0)

    # Wire up pipes: pipe i goes from machine i to i+1
    machines = [Task(() -> execute(code, pipes[i], pipes[1+i%length(phases)])) for i in 1:length(phases)]

    map(schedule, machines)
    map(wait, machines)

    result = take!(pipes[1])

    map(close, pipes)

    return result
end

perms2 = collect(permutations(5:9))
println(maximum(map(tryit2, perms2)))
