const C = CartesianIndex{2}

function day25()
    part = [0, 0]

    lines = filter(s -> !isempty(strip(s)), strip.(readlines("AoCdata/AoC_2021_day25.txt")))
    nrows, ncols = length(lines), length(first(lines))
    mat = fill('.', nrows, ncols)
    for i in 1:nrows
        mat[i, :] .= collect(lines[i])
    end
    tmat, moved, steps = deepcopy(mat), 1, 0
    while moved > 0
        moved = 0
        for c in CartesianIndices(mat)
            if mat[c] == '>'
                dest = C(c[1], mod1(c[2] + 1, ncols))
                if mat[dest] == '.'
                    tmat[c] = '.'
                    tmat[dest] = '>'
                    moved += 1
                end
            end
        end
        mat = deepcopy(tmat)
        for c in CartesianIndices(mat)
            if mat[c] == 'v'
                dest = C(mod1(c[1] + 1, nrows), c[2])
                if mat[dest] == '.'
                    tmat[c] = '.'
                    tmat[dest] = 'v'
                    moved += 1
                end
            end
        end
        mat = deepcopy(tmat)
        steps += 1
    end

    part[1] = steps

    return part
end

part = day25()
println("Part 1: ", part[1])
