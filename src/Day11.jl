using BenchmarkTools

data11 = """
8548335644
6576521782
1223677762
1284713113
6125654778
6435726842
5664175556
1445736556
2248473568
6451473526
"""

function day11()
    part = [0, 0]
    day11lines = filter(!isempty, strip.(split(data11, "\n")))
    nrows, ncols = length(day11lines), length(first(day11lines))
    mat = zeros(Int, nrows, ncols)
    for i in 1:nrows
        mat[i, :] .= parse.(Int, collect(day11lines[i]))
    end

    for step in 1:1000
        mat .+= 1
        while any(mat .> 9)
            for c in CartesianIndices(mat)
                if mat[c] > 9
                    for k in max(1, c[1] - 1):min(c[1] + 1, nrows),
                        l in max(c[2] - 1, 1):min(c[2] + 1, ncols)

                        if mat[k, l] > 0
                            mat[k, l] += 1
                        end
                    end
                    mat[c] = 0
                    step < 101 && (part[1] += 1)
                end
            end
        end
        if all(==(first(mat)), mat)
            part[2] == 0 && (part[2] = step)
            step >= 100 && break
        end
    end
    return part
end

part = day11()
println("Part 1:", part[1])
println("Part 2:", part[2])

@btime day11()

#=
Part 1:1601
Part 2:368
  7.539 ms (86240 allocations: 2.71 MiB)
=#
