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

""" recursive depth first search """
function allpaths(dverts, startvertex, currentpath, part1=true)
    startvertex == "end" && return [currentpath]
    paths = Vector{String}[]
    for nextvertex in dverts[startvertex]
        nextvertex == "start" && continue
        if isuppercase(first(nextvertex)) || !(nextvertex in currentpath)
            append!(
                paths, allpaths(dverts, nextvertex, vcat(currentpath, [nextvertex]), part1)
            )
        elseif !part1 && islowercase(first(nextvertex))
            append!(paths, allpaths(dverts, nextvertex, vcat(currentpath, [nextvertex])))
        end
    end
    return paths
end

function day12()
    part = [0, 0]
    day12lines = filter(!isempty, strip.(split(data12, "\n")))
    vertices = Dict{String,Vector{String}}()
    for line in day12lines
        v1, v2 = split(line, "-")
        push!(get!(vertices, v1, String[]), v2)
        push!(get!(vertices, v2, String[]), v1)
    end

    part[1] = length(allpaths(vertices, "start", ["start"]))
    part[2] = length(allpaths(vertices, "start", ["start"], false))
    return part
end

part = day12()
println("Part 1:", part[1])
println("Part 2:", part[2])
