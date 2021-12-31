# Advent of code 2021, day 4

function parseinput()
    paragraphs = split(strip(read("AoCdata/AoC_2021_day4.txt", String)), "\n\n")
    draworder = [parse(Int, num) for num in split(strip(first(paragraphs)), ",")]
    matrices, picks = Matrix{Int}[], Matrix{Int}[]
    for mattxt in paragraphs[(begin + 1):end]
        push!(matrices, reshape([parse(Int, s) for s in split(strip(mattxt))]', (5, 5)))
        push!(picks, zeros(Int, 5, 5))
    end
    return draworder, matrices, picks
end

function part1and2()
    win(mat) = any(sum(mat; dims=1) .== 5) || any(sum(mat; dims=2) .== 5)
    draw, mats, picks = parseinput()
    totalwinners, part1, winners, pastwinners = 0, 0, Int[], Int[]
    for d in draw
        for n in eachindex(mats)
            if (idx = findfirst(j -> j == d, mats[n])) != nothing
                picks[n][idx] = 1
            end
        end
        winners = filter(
            x -> !(x in pastwinners), findall(i -> win(picks[i]), eachindex(mats))
        )
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
