data23= """
...........
##D#A#C#C##
##D#A#B#B##
"""

insertstring = """##D#C#B#A##\n##D#B#A#C##"""

targetstring = """
...........
##A#B#C#D##
##A#B#C#D##
"""

C = CartesianIndex{2}

function printmat(m)
    println("#" ^ 13)
    for i in 1:size(m, 1)
        println("#", join(m[i, begin:end]), "#")
    end
    println("#" ^ 13, "\n")
end

function day23(part1 = true)
    nrows, ncols = 3, 11
    nrgmax = part1 ? 19_100 : 48_350

    function readmat(s, r = nrows, c = ncols)
        mat = Matrix{Char}(undef, r, c)
        lines = split(s, "\n")
        for (i, line) in enumerate(lines[begin:begin+r-1])
            length(line) < c && (line = rpad(line, c))
            mat[i, :] .= collect(line)
        end
        return mat
    end

    original = readmat(data23)
    target = readmat(targetstring)
    if !part1
        nrows = 5
        original = vcat(original[1:3, :], original[2:3, :])
        original[3, :] .= collect(insertstring[1:11])
        original[4, :] .= collect(insertstring[13:23])
        target = [target[1:3, :]; target[2:3, :]]
        println(length(original))
    end

    amphitypes = ['A', 'B', 'C', 'D']
    energy = Dict('A' => 1, 'B' => 10, 'C' => 100, 'D' => 1000)
    destcol = Dict('A' => 3, 'B' => 5, 'C' => 7, 'D' => 9)
    function allnotinplace(mat)
        ret = C[]
        for col in [3, 5, 7, 9], row in 2:nrows
            a = mat[row, col]
            a ∉ amphitypes && continue
            if col != destcol[a] || (row < nrows && any(mat[row+1:nrows, col] .!= a))
                push!(ret, C(row, col))
            end
        end
        append!(ret, [C(1, col) for col in 1:ncols if mat[1, col] != '.'])
        return ret
    end
    function movecost(mat, c1, c2)
        a, x1, y1, x2, y2 = mat[c1], c1[1], c1[2], c2[1], c2[2]
        return energy[a] * (y1 == y2 ? abs(x1 - x2) : abs(y1 - y2) + x1 + x2 - 2)
    end
    function homeready(mat, a, top=1)
        dcol = destcol[a]
        return top < nrows && all(b -> b ∈ [a, '.'], mat[top:nrows, dcol]) &&
           any(mat[top:nrows, dcol] .== '.') && issorted(mat[top:nrows, dcol])
    end
    function goalmove(mat, c)
        a, x, y = mat[c], c[1], c[2]
        a ∉ amphitypes && return nothing
        dcol = destcol[a]
        d = sign(dcol - y)
        drow = findlast(mat[1:nrows, dcol] .== '.')
        drow == nothing && return nothing
        if d == 0 && homeready(mat, a, x + 1) ||
           d != 0 && homeready(mat, a) && all(mat[1, y+d:d:dcol] .== '.') &&
              (x == 1 || all(mat[1:x-1, y] .== '.'))
            return C(drow, dcol)
        end
        return nothing
    end

    function allmoves(omat = deepcopy(original))
        positions = [(omat, 0)]
        wins = Int[]
        while !isempty(positions)
            newpositions = empty(positions)
            for p in positions
                mat, cost = p
                cost > nrgmax && continue
                if mat == target
                    push!(wins, cost)
                    continue
                end
                notinplace, newmat, newcost = allnotinplace(mat), deepcopy(mat), 0
                for prev in notinplace
                    if (c = goalmove(newmat, prev)) != nothing
                        a, x, y = newmat[prev], prev[1], prev[2]
                        @assert newmat[c] == '.' && a ∈ amphitypes
                        newmat[prev], newmat[c] = newmat[c], newmat[prev]
                        newcost += movecost(mat, prev, c)
                    end
                end
                if newcost > 0
                    push!(newpositions, (newmat, cost + newcost))
                else
                    for prev in notinplace
                        a, x, y = mat[prev], prev[1], prev[2]
                        if x > 1 && all(mat[1:x-1, y] .== '.')
                            for col in [1, 2, 4, 6, 8, 10, 11]
                                if all(mat[1, y:sign(col-y):col] .== '.')
                                    c = C(1, col)
                                    @assert mat[c] == '.' && a ∈ amphitypes
                                    newmat = deepcopy(mat)
                                    newmat[prev] = mat[c]
                                    newmat[c] = mat[prev]
                                    push!(newpositions, (newmat, cost + movecost(mat, prev, c)))
                                end
                            end
                        end
                    end
                end
            end
            positions = newpositions
        end
        return minimum(wins)
    end

    return allmoves()

end

part = [day23(), day23(false)]

println("Part 1: ", part[1]) # 19046
println("Part 2: ", part[2]) # 47484

