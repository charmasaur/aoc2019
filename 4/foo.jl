using DataStructures

range = 138307:654504

nondecreasing(x) = issorted(reverse(digits(x)))
hassame(x) = length(Set(digits(x))) < length(digits(x))
haspair(x) = 2 in values(counter(digits(x)))

println(count(nondecreasing, filter(hassame, range)))
println(count(nondecreasing, filter(haspair, range)))
