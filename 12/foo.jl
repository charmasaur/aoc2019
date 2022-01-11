lines = open(readlines, "in.txt")
# [3,4]
ipos = hcat([[parse(Int, x) for x in match(r"<x=(.*), y=(.*), z=(.*)>", line).captures]
            for line in lines]...)

function run()
    pos = reshape(ipos, 3, :, 1)
    vel = zero(pos)
    
    for s in 1:1000
        vel = vel .- mapslices(sum, sign.(pos .- reshape(pos, 3, 1, :)), dims=3)
        pos = pos .+ vel
    end
    return sum(mapslices(sum, abs.(pos), dims=1) .*
               mapslices(sum, abs.(vel), dims=1))
end

println(run())

function cycletime(pos)
    pos = reshape(pos, :, 1)
    vel = zero(pos)
    endpos = pos
    endvel = vel
    
    for s in 1:10000000
        vel = vel .- mapslices(sum, sign.(pos .- reshape(pos, 1, :)), dims=2)
        pos = pos .+ vel
        if pos == endpos && vel == endvel
            return s
        end
    end
end

println(lcm(map(cycletime, eachrow(ipos))...))
