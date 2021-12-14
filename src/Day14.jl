using BenchmarkTools

function day14()
    part = [0, 0]
    lines = strip.(readlines("AoCdata/AoC_2021_day14.txt"))
    template, rulelines = lines[begin], lines[begin+2:end]
    rules = Dict(s[begin:begin+1] => s[end] for s in rulelines)

    function steps(N)
        lettercounts = zeros(Int, 26)
        paircounts = Dict(template[i:i+1] => 1 for i in 1:length(template)-1)
        paircounts[template[end:end]] = 1
        for step in 1:N
            tmpdict = Dict{String, Int}()
            for (k, v) in paircounts
                if haskey(rules, k)
                    tmpdict[k[begin] * rules[k]] = get!(tmpdict, k[begin] * rules[k], 0) + v
                    tmpdict[rules[k] * k[end]] = get!(tmpdict, rules[k] * k[end], 0) + v
                else
                    tmpdict[k] = get!(tmpdict, k, 0) + v
                end
            end
            paircounts = tmpdict
        end
        for (k, v) in paircounts
            lettercounts[Int(k[begin]) - Int('A') + 1] += v
        end
        filter!(k -> k > 0, lettercounts)
        return maximum(lettercounts) - minimum(lettercounts)
    end

    part .= steps(10), steps(40)
    return part
end

part = day14()
println("Part 1: ", part[1])
println("Part 2: ", part[2])

@btime day14()

#=
Part 1: 2170
Part 2: 2422444761283
  1.191 ms (17812 allocations: 870.38 KiB)
=#
