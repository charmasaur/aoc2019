using DataStructures

mutable struct Program
    code
    pos
    base
    t
end

mutable struct Mode
    val
end

function Base.pop!(collection::Mode)
    m = collection.val%10
    collection.val = collection.val÷10
    return m
end

# Read a value
function next!(p::Program)
    x = p.code[p.pos]
    p.pos += 1
    return x
end

# Read n parameters
function next_parameters!(p::Program, mode::Mode, num::Int)
    r = []
    for i in 1:num
        x = next!(p)

        m = pop!(mode)

        if m == 0
            push!(r, p.code[x+1])
        elseif m == 1
            push!(r, x)
        elseif m == 2
            push!(r, p.code[x+1+p.base])
        else
            error(m)
        end
    end

    return r
end

# Read one parameter
next_parameter!(p, mode) = next_parameters!(p, mode, 1)[1]

# Read a location and write the value to that location
function next_write!(p::Program, value, mode::Mode)
    x = next!(p)
    offset = pop!(mode) == 0 ? 0 : p.base
    p.code[x+1+offset] = p.t(value)
end

# Input/output
readfrom!(x::Array) = popfirst!(x)
writeto!(x::Array, value) = push!(x, value)

readfrom!(x::Channel) = take!(x)
writeto!(x::Channel, value) = put!(x, value)

# Execute a program, returning the final memory
function execute(code, input, output)
    p = Program(DefaultDict(0, pairs(code)), 1, 0, eltype(code))
    while true
        op = next!(p)
        mode = Mode(op÷100)
        op = op%100

        if op == 1
            next_write!(p, sum(next_parameters!(p, mode, 2)), mode)
        elseif op == 2
            next_write!(p, prod(next_parameters!(p, mode, 2)), mode)
        elseif op == 3
            next_write!(p, readfrom!(input), mode)
        elseif op == 4
            writeto!(output, next_parameter!(p, mode))
        elseif op == 5
            cond, np = next_parameters!(p, mode, 2)
            if cond != 0
                p.pos = np+1
            end
        elseif op == 6
            cond, np = next_parameters!(p, mode, 2)
            if cond == 0
                p.pos = np+1
            end
        elseif op == 7
            next_write!(p, <(next_parameters!(p, mode, 2)...), mode)
        elseif op == 8
            next_write!(p, ==(next_parameters!(p, mode, 2)...), mode)
        elseif op == 9
            p.base += next_parameter!(p, mode)
        elseif op == 99
            break
        end
    end
    return p.code
end

# Execute a program, returning the output
function execute(code, input)
    output = []
    execute(code, input, output)
    return output
end

# Wrap the program as a task
function astask(code)
    input = Channel(Inf)
    output = Channel(Inf)
    task = Task(() -> execute(code, input, output))
    bind(input, task)
    bind(output, task)
    return (task, input, output)
end

# Load code from a file
loadcode(fn::String, t=Int) = map(x->parse(t, x), split(open(f->readlines(f), fn)[1], ","))
