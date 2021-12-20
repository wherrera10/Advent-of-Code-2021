function day19()
    part = [0, 0]
    maxdist = 1000
    scannerblocks = split(read("AoCdata/AoC_2021_day19.txt", String), "\n\n")
    scanners = [Vector{Int}[] for _ in 1:length(scannerblocks)]
    for (i, block) in enumerate(scannerblocks)
        for line in strip.(split(block, "\n"))
            !isempty(line) && line[end] != '-' && push!(scanners[i], parse.(Int, split(line, ",", limit=3)))
        end
    end
    nscan, overlaps, deltas = length(scanners), Dict{Vector{Int}, Int}(), Dict{Vector{Int}, Vector{Int}}()
    # simulate all configurations of scanner j and then look for a substantial subset of readinds between the two
    # which differ by a constant xyz vector such as [0, 0, 0].
    for i in 1:nscan
        print("Test $i\b\b\b\b\b\b\b\b\b")
        mat = sort(scanners[i])
        for j in i+1:nscan
            for xsign in [1, -1], ysign in [1, -1], zsign in [1, -1], ax in ([1,2,3], [2,1,3], [3,2,1], [1,3,2], [2,3,1], [3,1,2])
                newmat = deepcopy(scanners[j])
                for i in eachindex(newmat)
                    newmat[i] .*= [xsign, ysign, zsign]
                end
                for (i, t) in enumerate(newmat)
                    newmat[i] .= [t[ax[1]], t[ax[2]], t[ax[3]]]
                end
                for b in mat, t in newmat
                    diff = b .- t
                    samediffs = count(mat[n] - newmat[m] == diff for n in 1:length(mat), m in 1:length(newmat))
                    if samediffs > 8
                        overlaps[[i, j]] = max(get(overlaps, [i, j], 0), samediffs)
                        deltas[[i, j]] = -diff
                        deltas[[j, i]] = diff
                    end
                end
            end
        end
    end

    distances = Dict(1 => [0, 0, 0])
    while any(i -> !haskey(distances, i), 1:nscan)
        for (k, v) in distances
            for (p, delta) in deltas
                haskey(distances, p[2]) && continue
                if k == p[1]
                    distances[p[2]] = v .+ delta
                end
            end
        end
    end

    # normalize beacon measures versus scanner 0
    for (k, v) in distances
        for i in eachindex(scanners[k])
            scanners[k][i] .-= v
        end
    end
    # number of beacons = total readings - number of overlapping readings + number of doublecounts
    allmeasures = vcat(scanners)
    overlappings = length(overlaps)
    part[1] = length(unique(allmeasures)) - overlappings
@show length(allmeasures), length(unique(allmeasures)), overlappings, sum(values(overlaps))
    manhat(s1, s2) = sum(abs.(distances[s2] - distances[s1]))
    part[2] = maximum(manhat(i, j) for i in 1:nscan, j in 1:nscan)

    return part
end

part = day19()
println("\nPart 1: ", part[1])  # 425
println("Part 2: ", part[2])    # 13354
