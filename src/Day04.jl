# Advent of code 2021, day 4

function parseinput()
    lines = readlines("AoCdata/AoC_2021_day4.txt")
    draworder = [parse(Int, num) for num in split(strip(first(lines)), ",")]
    matrices, picks = Matrix{Int}[], Matrix{Int}[]
    curline = 3
    while curline <= length(lines)
        mat = zeros(Int, 5, 5)
        push!(picks, zeros(Int, 5, 5))
        for row in 1:5
            mat[row, :] .= [parse(Int, s) for s in split(strip(lines[curline]))]
            curline += 1
        end
        push!(matrices, mat)
        curline += 1
    end
    return draworder, matrices, picks
end

function part1and2()
    win(mat) = any(i -> sum(mat[i, 1:5]) == 5 || sum(mat[1:5, i]) == 5, 1:5)
    draw, mats, picks = parseinput()
    totalwinners, part1, winners, pastwinners = 0, 0, Int[], Int[]
    for d in draw
        for n in eachindex(mats)
            if (idx = findfirst(j -> j == d, mats[n])) != nothing
                picks[n][idx] = 1
            end
        end
        winners = filter(x -> !(x in pastwinners), findall(i -> win(picks[i]), eachindex(mats)))
        isempty(winners) && continue
        push!(pastwinners, winners...)
        winmat, winpick = mats[winners[end]], picks[winners[end]]
        unpicksum = sum([winmat[n] for n in eachindex(winmat) if winpick[n] == 0])
        if part1 == 0
            part1 = winners[1]
            println("Part 1: ", unpicksum * d)
        elseif length(pastwinners) == length(mats)  # all have won
            lastwinner = last(pastwinners)
            println("Last winner is $lastwinner: ", unpicksum * d)
            break
        end
    end
end

part1and2()

                      
