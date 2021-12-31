const registernames = ["w", "x", "y", "z"]
struct AsmLine
    op::String
    idx1::Int
    idx2::Int
    n::Int
    function AsmLine(str::String)
        s = split(strip(str), r"\s+")
        b = length(s) > 2 ? (s[3] in registernames ? s[3] : tryparse(Int, s[3])) : nothing
        idx1 = findfirst(registernames .== s[2])
        idx2 = (b isa AbstractString) ? findfirst(registernames .== b) : -1
        n = b isa Integer ? b : typemax(Int)
        return new(s[1], idx1, idx2, n)
    end
end

""" Speedup: if we fail to pop a 26-multiplier due to bad input, z becomes large, so drop those"""
function day24(maxz = 26^4)
    rstates = [[[0, 0, 0, 0], [0, 0]]]
    lines = readlines("AoCdata/AoC_2021_day24.txt")
    for (i, line) in enumerate(lines)
        asm = AsmLine(line)
        if asm.op == "inp"
            d = Dict{Vector{Int},Vector{Int}}()
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
        elseif asm.op == "add"
            for i in eachindex(rstates)
                rstates[i][1][asm.idx1] += asm.idx2 > 0 ? rstates[i][1][asm.idx2] : asm.n
            end
        elseif asm.op == "mul"
            for i in eachindex(rstates)
                rstates[i][1][asm.idx1] *= asm.idx2 > 0 ? rstates[i][1][asm.idx2] : asm.n
            end
        elseif asm.op == "div"
            for i in eachindex(rstates)
                rstates[i][1][asm.idx1] ÷= asm.idx2 > 0 ? rstates[i][1][asm.idx2] : asm.n
            end
        elseif asm.op == "mod"
            for i in eachindex(rstates)
                rstates[i][1][asm.idx1] %= asm.idx2 > 0 ? rstates[i][1][asm.idx2] : asm.n
            end
        elseif asm.op == "eql"
            for i in eachindex(rstates)
                p = rstates[i][1][asm.idx1]
                q = asm.idx2 > 0 ? rstates[i][1][asm.idx2] : asm.n
                rstates[i][1][asm.idx1] = p == q
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
