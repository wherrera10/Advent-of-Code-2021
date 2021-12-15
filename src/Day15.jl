using Graphs
using SparseArrays

function day15()
    part = [0,0]
    lines = filter(!isempty, strip.(readlines("AoCdata/AoC_2021_day15.txt")))
    nrows, ncols = length(lines), length(first(lines))
    mat = zeros(Int, nrows, ncols)
    dist = spzeros(Int, length(mat), length(mat))
    for i in 1:nrows
        mat[i, :] .= parse.(Int, collect(lines[i]))
    end
    g = DiGraph(length(mat))
    for i in 1:length(mat)
        if i % nrows != 0
            add_edge!(g, i, i + 1)
            dist[i, i + 1] = mat[i + 1]
            add_edge!(g, i + 1, i)
            dist[i + 1, i] = mat[i]
        end
        if i <= length(mat) - nrows
            add_edge!(g, i, i + nrows)
            dist[i, i + nrows] = mat[i + nrows]
            add_edge!(g, i + nrows, i)
            dist[i + nrows, i] = mat[i]
        end
    end

    as1 = a_star(g, 1, length(mat), dist)
    endpoints = [x.dst for x in as1]
    part[1] = sum(mat[i] for i in endpoints)

    mat2 = zeros(Int, ncols * 5, nrows * 5)
    for c in CartesianIndices(mat2)
        mat2[c] = mat[(c[1] - 1) % nrows + 1, (c[2] - 1) % ncols + 1] +
           (c[1] - 1) ÷ nrows + (c[2] - 1) ÷ ncols
        mat2[c] = (mat2[c] - 1) % 9 + 1
    end
    dist2 = spzeros(Int, length(mat2), length(mat2))
    g2 = DiGraph(length(mat2))
    for i in 1:length(mat2)
        if i % (nrows * 5) != 0
            add_edge!(g2, i, i + 1)
            dist2[i, i + 1] = mat2[i + 1]
            add_edge!(g2, i + 1, i)
            dist2[i + 1, i] = mat2[i]
        end
        if i <= length(mat2) - nrows * 5
            add_edge!(g2, i, i + nrows * 5)
            dist2[i, i + nrows * 5] = mat2[i + nrows * 5]
            add_edge!(g2, i + nrows * 5, i)
            dist2[i + nrows * 5, i] = mat2[i]
        end
    end

    as2 = a_star(g2, 1, length(mat2), dist2)
    endpoints2 = [x.dst for x in as2]
    part[2] = sum(mat2[i] for i in endpoints2)

    return part
end

part = day15()
println("Part 1: ", part[1])
println("Part 2: ", part[2])
