mutable struct Program
    code
    pos
end

# Read a value
function next!(p::Program)
    x = p.code[p.pos]
    p.pos += 1
    return x
end

# Read n parameters
function next_parameters!(p::Program, mode::Int, num::Int)
    r = []
    for i in 1:num
        x = next!(p)

        m = mode%10
        mode = mode÷10

        if m == 0
            push!(r, p.code[x+1])
        elseif m == 1
            push!(r, x)
        else
            error(m)
        end
    end

    return r
end

# Read one parameter
next_parameter!(p::Program, mode::Int) = next_parameters!(p, mode, 1)[1]

# Read a location and write the value to that location
function next_write!(p::Program, value::Int)
    x = next!(p)
    p.code[x+1] = value
end
next_write!(p::Program, value::Bool) = next_write!(p, value ? 1 : 0)

# Input/output
readfrom!(x::Array) = popfirst!(x)
writeto!(x::Array, value::Int) = push!(x, value)

# Execute a program, returning the final memory
function execute(code, input, output)
    p = Program(copy(code), 1)
    while true
        op = next!(p)
        mode = op÷100
        op = op%100

        if op == 1
            next_write!(p, sum(next_parameters!(p, mode, 2)))
        elseif op == 2
            next_write!(p, prod(next_parameters!(p, mode, 2)))
        elseif op == 3
            next_write!(p, readfrom!(input))
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
            next_write!(p, <(next_parameters!(p, mode, 2)...))
        elseif op == 8
            next_write!(p, ==(next_parameters!(p, mode, 2)...))
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

# Load code from a file
loadcode(fn::String) = map(x->parse(Int, x), split(open(f->readlines(f), fn)[1], ","))
