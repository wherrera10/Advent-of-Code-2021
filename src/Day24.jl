using BenchmarkTools

""" Speedup: if we fail to pop a 26-multiplier due to bad input, z becomes large, so drop those"""
function day24()
    rstates = rstates = [[[0, 0, 0, 0], [0, 0]]]
    lines = readlines("AoCdata/AoC_2021_day24.txt")
    maxz = 26^4
    for (i, line) in enumerate(lines)
        # println("Parsing line $i of ", length(lines), ", nstates is ", length(rstates))
        s = split(strip(line), r"\s+")
        op = popfirst!(s)
        a, b = "", ""
        if length(s) == 2
                a, b = s[1], s[2]
        else
                a = s[1]
        end
        idx1 = a == "w" ? 1 : a == "x" ? 2 : a == "y" ? 3 : 4
        idx2 = b == "w" ? 1 : b == "x" ? 2 : b == "y" ? 3 : (b == "z" ? 4 : -1)
        if op == "inp"
            d = Dict{Vector{Int}, Vector{Int}}()
            for (reg, (mn, mx)) in rstates
                (w, x, y, z) = reg
                k = [0, x, y, z]
                if haskey(d, k)
                    if d[k][1] > mn || d[k][1] == 0
                        d[k][1] = mn
                    end
                    if d[k][2] < mx
                        d[k][2] = mx
                    end
                elseif z <= maxz
                    d[k] = [mn, mx]
                end
            end
            rstates = [[k, v] for (k, v) in d]
            newstates = empty(rstates)
            for ((w, x, y, z), (mn, mx)) in rstates, i in 1:9
                push!(newstates, [[i, x, y, z], [mn * 10 + i, mx * 10 + i]])
            end
            rstates = newstates
        elseif op == "add"
            for i in eachindex(rstates)
                rstates[i][1][idx1] += idx2 > 0 ? rstates[i][1][idx2] : parse(Int, b)
            end
        elseif op == "mul"
            for i in eachindex(rstates)
                rstates[i][1][idx1] *= idx2 > 0 ? rstates[i][1][idx2] : parse(Int, b)
            end
        elseif op == "div"
            for i in eachindex(rstates)
                rstates[i][1][idx1] ÷= idx2 > 0 ? rstates[i][1][idx2] : parse(Int, b)
            end
        elseif op == "mod"
            for i in eachindex(rstates)
                rstates[i][1][idx1] %= idx2 > 0 ? rstates[i][1][idx2] : parse(Int, b)
            end
        elseif op == "eql"
            for i in eachindex(rstates)
                p = rstates[i][1][idx1]
                q = idx2 > 0 ? rstates[i][1][idx2] : parse(Int, b)
                rstates[i][1][idx1] = p == q
            end
        else
            error("unknown op $op in line $line")
        end
    end
    filter!(x -> x[1][4] == 0, rstates)
    return maximum(x[2][2] for x in rstates), minimum(x[2][1] for x in rstates)
end

part = day24()
println("Part 1: ", part[1])
println("Part 2: ", part[2])

@btime day24()
#=
Part 1: 92928914999991
Part 2: 91811211611981
  608.204 ms (2745075 allocations: 236.98 MiB)
=#

