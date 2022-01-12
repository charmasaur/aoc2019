lines = open(readlines, "in.txt")

# Finds params m and b such that position x moves to position mx+b.
function get_params(n)
    m = one(n)
    b = zero(n)

    for line in lines
        mat = match(r"deal with increment (-?\d+)", line)
        if mat != nothing
            val = parse(typeof(n), mat.captures[1])
            m = mod(m*val, n)
            b = mod(b*val, n)
            continue
        end
        mat = match(r"cut (-?\d+)", line)
        if mat != nothing
            val = parse(typeof(n), mat.captures[1])
            m = m
            b = mod(b - val, n)
            continue
        end
        m = mod(-m, n)
        b = mod(n-b-1, n)
    end
    return m, b
end

n = 10007
m, b = get_params(n)
println(mod(m*2019+b, n))

n = BigInt(119315717514047)
k = BigInt(101741582076661)
m, b = get_params(n)

# All arithmetic mod n.
#
# One iteration does x -> mx+b.
# Two iterations do x -> m(mx+b) + b = m^2x + mb + b.
# k iterations do x -> m^k x + (m^{k-1} + m^{k-2} + ... + 1) b.
# The second term can be simplified to (m^k - 1) * (m-1)^{-1} * b.
#
# If the forward pass is x -> px + q, the reverse pass is x -> p^{-1} (x - q).
#
# Putting it all together we get x -> (m^k)^{-1} (x - (m^k - 1) * (m-1)^{-1} * b).
println(mod(invmod(powermod(m, k, n), n)
            * (2020 - (powermod(m, k, n) - 1) * invmod(m-1, n) * b), n))
