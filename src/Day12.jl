data12 = """
hl-WP
vl-fo
vl-WW
WP-start
vl-QW
fo-wy
WW-dz
dz-hl
fo-end
VH-fo
ps-vl
FN-dz
WP-ps
ps-start
WW-hl
end-QW
start-vl
WP-fo
end-FN
hl-QW
WP-dz
QW-fo
QW-dz
ps-dz
"""

function day12()
    part = [0, 0]
    day12lines = filter(!isempty, strip.(split(data12, "\n")))
    vertices = Dict{String, Vector{String}}()
    for line in day12lines
        v1, v2 = split(line, "-")
        if haskey(vertices, v1)
            push!(vertices[v1], v2)
        else
            vertices[v1] = [v2]
        end
        if haskey(vertices, v2)
            push!(vertices[v2], v1)
        else
            vertices[v2] = [v1]
        end
    end

    """ recursive depth first search """
    function allpaths(startvertex, currentpath, doublecaveok)
        startvertex == "end" && return [currentpath]
        a = Vector{String}[]
        for nextvertex in vertices[startvertex]
            nextvertex == "start" && continue
            if isuppercase(first(nextvertex)) || !(nextvertex in currentpath)
                append!(a, allpaths(nextvertex, vcat(currentpath, [nextvertex]), part1))
            elseif !part1 && islowercase(first(nextvertex))
                append!(a, allpaths(nextvertex, vcat(currentpath, [nextvertex])))
            end
        end
        return a
    end

    part[1] = length(allpaths("start", ["start"], false))
    part[2] = length(allpaths("start", ["start"], true))

    return part
end

part = day12()
println("Part 1:", part[1])
println("Part 2:", part[2])

