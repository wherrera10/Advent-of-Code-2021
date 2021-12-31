# Advent of code 2021, day 1

function day01()
    part = [0, 0]
    input1 = map(s -> parse(Int, s), readlines("AoCdata/AoC_2021_day1.txt"))

    increases(arr) = count(arr[i + 1] > arr[i] for i in 1:(length(arr) - 1))
    part[1] = increases(input1) # 1477

    function slidingincreases(arr)
        return count(
            sum(arr[(i + 1):(i + 3)]) > sum(arr[i:(i + 2)]) for i in 1:(length(arr) - 3)
        )
    end
    part[2] = slidingincreases(input1) # 1523
    return part
end

part = day01()

println("Part 1: ", part[1])
println("Part 2: ", part[2])
