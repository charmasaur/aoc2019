include("../lib/intcode.jl")

code = loadcode("in.txt")

println(execute(code, [1])[end])
println(execute(code, [5])[end])
