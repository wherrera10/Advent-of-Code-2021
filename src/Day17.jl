"""target area: x=217..240, y=-126..-69"""
function day17(tx1 = 217, ty1 = -126, tx2 = 240, ty2 = -69)
    part = [0, 0]
    maxtuple = Tuple{Int, Int, Int}[]
    for i in 1:1000, j in -1000:1000
        x, y, xvel, yvel, maxy, success = 0, 0, i, j, 0, false
        for t in 1:1000
            x += xvel
            y += yvel
            y > maxy && (maxy = y)
            xvel -= sign(xvel)
            yvel -= 1
            if tx1 <= x <= tx2 && ty1 <= y <= ty2
                !success && push!(maxtuple, (maxy, i, j))
                success = true
            end
            y < min(ty1, ty2) && break
        end
    end
    part[1] = maximum([first(t) for t in maxtuple])
    part[2] = length(maxtuple)
    return part
end


part = day17()
println("Part 1: ", part[1])
println("Part 2: ", part[2])

