""" Day19 Advent of Code 2021 """
function day19()
    part = [0, 0]

    scannerblocks = split(read("AoCdata/AoC_2021_day19.txt", String), "\n\n")
    scanners = [Vector{Int}[] for _ in 1:length(scannerblocks)]
    for (i, block) in enumerate(scannerblocks), line in strip.(split(block, "\n"))
        !isempty(line) && line[end] != '-' && push!(scanners[i], parse.(Int, split(line, ",")))
    end
    converted, checked, distances = Set(1), Set{Int}(), Dict{Int, Tuple{Int, Int, Int}}()
    sort!(scanners[1])

    # simulate all configurations of scanner j and then look for a set of 12 between the two
    # which differ by a constant xyz vector such as [0, 0, 0].
    while length(converted) < length(scanners)
        for i in converted
            i in checked && continue
            push!(checked, i)
            mat = sort(scanners[i])
            for j in 1:length(scanners)
                j ∈ converted && continue
                print("Compare $i to $j...\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b")
                for xsign in [1, -1], ysign in [1, -1], zsign in [1, -1], ax in ([1,2,3], [2,1,3], [3,2,1], [1,3,2], [2,3,1], [3,1,2])
                    newmat = deepcopy(scanners[j])
                    for i in eachindex(newmat)
                        newmat[i] .*= [xsign, ysign, zsign]
                    end
                    for (i, t) in enumerate(newmat)
                        newmat[i] .= [t[ax[1]], t[ax[2]], t[ax[3]]]
                    end
                    for b in mat, t in newmat
                        diff = t .- b
                        minindex = min(length(mat), length(newmat))
                        samediffs = count(newmat[n] - mat[m] == diff for n in 1:minindex, m in 1:minindex)
                        if samediffs > 4
                            push!(converted, j)
                            scanners[j] .= [p .-= diff for p in sort!(newmat)]
                            distances[j] = (diff[1], diff[2], diff[3])
                            break
                        end
                    end
                end
            end
        end
    end

    part[1] = length(unique(reduce(vcat, scanners)))
    part[2] = maximum(sum(abs.(d1 .- d2)) for d1 in values(distances), d2 in values(distances))

    return part
end

part = day19()

println("\nPart 1: ", part[1]) # 425
println("Part 2: ", part[2]) # 13354
