include("../lib/intcode.jl")
code = loadcode("in.txt")
println(execute(code, [1])[1])
println(execute(code, [2])[1])
