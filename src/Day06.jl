# Advent of code 2021, day 6

function parseinput(fname = "AoCdata/AoC_2021_day6.txt")
   input6 = read(fname, String)
   return [parse(Int8, x) for x in strip.(split(input6, ",")) if !isempty(input6)]
end

function simulation!(lfvec, days)
    numeach = zeros(Int, 9)
    for n in lfvec
        numeach[n + 1] += 1
    end
    for i in 1:days
        numeach = circshift(numeach, -1)
        numeach[7] += numeach[end]
    end
    return sum(numeach)
end

@show simulation!(parseinput(), 80)
@show simulation!(parseinput(), 256)

