let
    day8lines = filter(!isempty, strip.(readlines("AoCdata/AoC_2021_day8.txt")))
    part = [0, 0]

    patterns = [[String.(sort.(collect.(split(a)))) for a in split(line, "|")] for line in day8lines]

    count1 = sum(count(length(x) == 2 for x in a[2]) for a in patterns)
    count4 = sum(count(length(x) == 4 for x in a[2]) for a in patterns)
    count7 = sum(count(length(x) == 3 for x in a[2]) for a in patterns)
    count8 = sum(count(length(x) == 7 for x in a[2]) for a in patterns)
    part[1] = sum([count1, count4, count7, count8])

    eachlinedig = Vector{String}[]
    for line in patterns
        dig = ["" for _ in 1:10]
        while any(x -> x == "", dig)
            for s in vcat(line...)
                length(s) == 2 && (dig[2] = s) # 1
                length(s) == 3 && (dig[8] = s) # 7
                length(s) == 4 && (dig[5] = s) # 4
                length(s) == 7 && (dig[9] = s) # 8
                if length(s) == 6 # 0, 6 or 9
                    if dig[5] != ""
                        if count(c -> c in s, dig[5]) == 4
                            dig[10] = s  # 9
                        elseif dig[2] != ""
                            if count(c -> c in s, dig[2]) == 2
                                dig[1] = s # 0
                            else
                                dig[7] = s # 6
                            end
                        end
                    end
                elseif length(s) == 5  # 2 or 3 or 5
                    if dig[2] != ""
                        if count(c -> c in s, dig[2]) == 2
                            dig[4] = s     # 3
                        elseif dig[5] != "" && count(c -> c in s, dig[5]) == 3
                            dig[6] = s # 5
                        else
                            dig[3] = s # 2
                        end
                    end
                end
            end
        end
        push!(eachlinedig, dig)
    end

    for (i, line) in enumerate(patterns)
        outputdigits = [findfirst(x -> x == s, eachlinedig[i]) - 1 for s in line[2]]
        part[2] += evalpoly(10, reverse(outputdigits))
    end

    println("Part 1:", part[1])
    println("Part 2:", part[2])
end

