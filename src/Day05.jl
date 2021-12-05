# Advent of code 2021, day 5

function parseinput()
    lines = Vector{Int}[]
    txtlines = strip.(readlines("AoCdata/AoC_2021_day5.txt"))
    return [[parse(Int, s) for s in split(line, r"[\D]+")] for line in txtlines if !isempty(line)]
end

function allpoints(seg, nodiags)
    x1, y1, x2, y2 = seg
    if x1 != x2 && y1 != y2
        nodiags && return []
        xsign, ysign = sign(x2 - x1), sign(y2 - y1)
        return [[x1 + xsign * i, y1 + ysign * i] for i in 0:abs(x1 - x2)]
    elseif x1 != x2
        return [[x, y1] for x in min(x1, x2):max(x1, x2)]
    else
        return [[x1, y] for y in min(y1, y2):max(y1, y2)]
    end
end

function multicrossings(nodiags = true)
    pointcounts = Dict{Vector{Int}, Int}()
    for segment in parseinput(), p in allpoints(segment, nodiags)
        if haskey(pointcounts, p)
            pointcounts[p] = pointcounts[p] + 1
        else
            pointcounts[p] = 1
        end
    end
    multicross = [p[1] for p in pointcounts if p[2] > 1]
    return length(multicross)
end

println("Part 1: ", multicrossings(true))
println("Part 2: ", multicrossings(false))

