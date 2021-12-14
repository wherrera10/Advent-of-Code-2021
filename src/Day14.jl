using BenchmarkTools

struct Polymer
    init::String
    rules::Dict{String, Tuple{String, String}}
end

function Base.iterate(p::Polymer, state=Dict{String, Int}())
    if isempty(state)
        state = Dict(p.init[i:i+1] => 1 for i in 1:length(p.init)-1)
        state[p.init[end:end]] = 1
    end
    tmpdict = Dict{String, Int}()
    for (k, v) in state
        if haskey(p.rules, k)
            tmpdict[first(p.rules[k])] = get!(tmpdict, first(p.rules[k]), 0) + v
            tmpdict[last(p.rules[k])] = get!(tmpdict, last(p.rules[k]), 0) + v
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
    rules = Dict(s[begin:begin+1] => (s[begin]*s[end], s[end]* s[begin+1]) for s in rulelines)

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
  851.600 μs (1004 allocations: 303.16 KiB)
=#
