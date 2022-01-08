include("../lib/intcode.jl")

code = loadcode("in.txt")
code[2] = 12
code[3] = 2
println(execute(code, [], [])[1])

target = 19690720
for noun in 1:100
    for verb in 1:100
        this_code = copy(code)
        this_code[2] = noun
        this_code[3] = verb
        if execute(this_code, [], [])[1] == target
            println(100*noun+verb)
        end
    end
end
