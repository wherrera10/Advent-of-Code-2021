function day10()
    part = [0, 0]
    day10lines = filter(!isempty, strip.(readlines("AoCdata/AoC_2021_day10.txt")))
    leftop, rightop, vals = ['(', '[', '{', '<'], [')', ']', '}', '>'], [3, 57, 1197, 25137]
    scores = []
    for line in day10lines
        corrupted = false
        rights = Char[]
        for c in line
            if c in leftop
                push!(rights, rightop[findfirst(x -> x == c, leftop)])
            elseif c in rightop
                if isempty(rights) || c != rights[end]
                    part[1] += vals[findfirst(x -> x == c, rightop)]
                    corrupted = true
                else
                    pop!(rights)
                end
            end
        end
        !corrupted && push!(scores, reduce((x, y) -> 5x + findfirst(i -> i == y, rightop), reverse(rights), init=0))
    end
    part[2] = sort(scores)[(length(scores) + 1) ÷ 2]
    return part
end

part = day10()
println("Part 1:", part[1])
println("Part 2:", part[2])
