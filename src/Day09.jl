function day9()
    day9lines = filter(!isempty, strip.(readlines("AoCdata/AoC_2021_day9.txt")))
    mat = zeros(Int, length(day9lines), length(first(day9lines)))
    for col in 1:size(mat)[2], row in 1:size(mat)[1]
        mat[row, col] = parse(Int, day9lines[row][col])
    end
    part = [0, 0]
    function localmin(row, col)
        x = mat[row, col]
        return if (row > 1 && mat[row - 1, col] <= x) ||
            (row < size(mat)[1] && mat[row + 1, col] <= x) ||
            (col > 1 && mat[row, col - 1] <= x) ||
            (col < size(mat)[2] && mat[row, col + 1] <= x)
            false
        else
            true
        end
    end
    minima = [
        (row, col) for col in 1:size(mat)[2], row in 1:size(mat)[1] if localmin(row, col)
    ]
    part[1] = sum(mat[p[1], p[2]] + 1 for p in minima)

    basins = Vector{Tuple{Int,Int}}[]
    function surround(row, col)
        return filter(
            p ->
                1 <= p[1] <= size(mat)[1] &&
                    1 <= p[2] <= size(mat)[2] &&
                    mat[p[1], p[2]] != 9,
            [(row - 1, col), (row + 1, col), (row, col - 1), (row, col + 1)],
        )
    end
    for t in minima
        newbasinlen, newbasin = 0, [t]
        while newbasinlen < length(newbasin)
            newbasinlen = length(newbasin)
            for b in newbasin, p in surround(b[1], b[2])
                !(p in newbasin) && push!(newbasin, p)
            end
        end
        push!(basins, newbasin)
    end
    part[2] = prod(sort([length(b) for b in basins])[(end - 2):end])
    println("Part 1:", part[1])
    println("Part 2:", part[2])
end

day9()
