using Graphs
using SparseArrays

function dijkstra_digraph(mat, nrows, ncols, startindex, endindex)
    dist = spzeros(Int, length(mat), length(mat))
    g = SimpleDiGraph(length(mat))
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
    return dijkstra_shortest_paths(g, startindex, dist).dists[endindex]
end

function day15()
    part = [0,0]
    lines = filter(!isempty, strip.(readlines("AoCdata/AoC_2021_day15.txt")))
    nrows, ncols = length(lines), length(first(lines))
    mat = zeros(Int, nrows, ncols)
    for i in 1:nrows
        mat[i, :] = parse.(Int, collect(lines[i]))
    end
    part[1] = dijkstra_digraph(mat, nrows, ncols, 1, length(mat))

    mat2 = zeros(Int, ncols * 5, nrows * 5)
    for c in CartesianIndices(mat2)
        mat2[c] = mod1(mat[mod1(c[1], nrows), mod1(c[2], ncols)] +
           (c[1] - 1) ÷ nrows + (c[2] - 1) ÷ ncols, 9)
    end
    part[2] = dijkstra_digraph(mat2, nrows * 5, ncols * 5, 1, length(mat2))

    return part
end

part = day15()
println("Part 1: ", part[1])
println("Part 2: ", part[2])

@time day15()
