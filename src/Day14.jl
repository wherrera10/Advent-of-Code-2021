using BenchmarkTools

struct Polymer
    init::String
    rules::Dict{String, Char}
end

function Base.iterate(p::Polymer, state=Dict{String, Int}())
    if isempty(state)
        state = Dict(p.init[i:i+1] => 1 for i in 1:length(p.init)-1)
        state[p.init[end:end]] = 1
    end
    tmpdict = Dict{String, Int}()
    for (k, v) in state
        if haskey(p.rules, k)
            tmpdict[k[begin] * p.rules[k]] = get!(tmpdict, k[begin] * p.rules[k], 0) + v
            tmpdict[p.rules[k] * k[end]] = get!(tmpdict, p.rules[k] * k[end], 0) + v
        else
            tmpdict[k] = get!(tmpdict, k, 0) + v
        end
    end
    state = tmpdict
    lettercounts = zeros(Int, 26)
    for (k, v) in state
        lettercounts[k[begin] - 'A' + 1] += v
    end
    filter!(k -> k > 0, lettercounts)
    return maximum(lettercounts) - minimum(lettercounts), state
end

function day14()
    part = [0, 0]
    lines = strip.(readlines("AoCdata/AoC_2021_day14.txt"))
    template, rulelines = lines[begin], lines[begin+2:end]
    rules = Dict(s[begin:begin+1] => s[end] for s in rulelines)

    poly = Polymer(template, rules)
    for (i, diff) in enumerate(poly)
        if i == 10
            part[1] = diff
        elseif i == 40
            part[2] = diff
            break
        end
    end

    return part
end

part = day14()
println("Part 1: ", part[1])
println("Part 2: ", part[2])

@btime day14()

#=
Part 1: 2170
Part 2: 2422444761283
1.053 ms (11916 allocations: 637.75 KiB)
=#
