# Advent of code 2021, day 5

function multicrossings(fname, countdiagonals)
    grid = zeros(Int, 1000, 1000)
    for txtsegment in [split(s, r"[\D]+") for s in strip.(readlines(fname)) if !isempty(s)]
        x1, y1, x2, y2 = map(s -> parse(Int, s), txtsegment)
        xsign, ysign = sign(x2 - x1), sign(y2 - y1)
        if xsign * ysign == 0 || countdiagonals
            for p in [[x1 + xsign * i, y1 + ysign * i] for i in 0: abs(xsign == 0 ? y1 - y2 : x1 - x2)]
                grid[first(p), last(p)] += 1
            end
        end
    end
    return count(grid .> 1)
end

println("Part 1: ", multicrossings("AoCdata/AoC_2021_day5.txt", false))
println("Part 2: ", multicrossings("AoCdata/AoC_2021_day5.txt", true))

