line = open(readlines, "in.txt")[1]
array = map(c -> parse(Int, c), collect(line))
image = reshape(array, (25, 6, :))

ones_times_twos(x) = sum(x.==1)*sum(x.==2)
println(ones_times_twos(image[:, :, argmin(map(sum, eachslice(image.==0, dims=3)))]))

cs = Dict(0 => ' ', 1 => '■')
reduced = mapslices(slice -> foldr((n, p) -> n == 2 ? p : cs[n], slice, init=' '),
                    image,
                    dims=3)[:, :, 1]
mapslices(println∘join, reduced, dims=1)
