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
    function allpaths(startvertex, currentpath, part1 = true)
        startvertex == "end" && return [currentpath]
        paths = Vector{String}[]
        for nextvertex in vertices[startvertex]
            nextvertex == "start" && continue
            if isuppercase(first(nextvertex)) || !(nextvertex in currentpath)
                append!(paths, allpaths(nextvertex, vcat(currentpath, [nextvertex]), part1))
            elseif !part1 && islowercase(first(nextvertex))
                append!(paths, allpaths(nextvertex, vcat(currentpath, [nextvertex])))
            end
        end
        return paths
    end

    part[1] = length(allpaths("start", ["start"], false))
    part[2] = length(allpaths("start", ["start"], true))

    return part
end

part = day12()
println("Part 1:", part[1])
println("Part 2:", part[2])

