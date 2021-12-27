mutable struct Cube
    a::Vector{Int}
    b::Vector{Int}
end


function day22(n = 0)  
    lines = filter(!isempty, strip.(readlines("AoCdata/AoC_2021_day22.txt")))
    oldlist = Cube[]
    for (j, line) in enumerate(lines)
        n != 0 && j > n && break
        arr = split(line, r"[\s\,][xyz]\=|\.\.|\,")
        newc = Cube([parse.(Int, s) for s in arr[2:2:6]],
           [parse.(Int, s) + 1 for s in arr[3:2:7]])
        newlist = Cube[]
	    for oldc in oldlist
			if any(oldc.b .<= newc.a .|| newc.b .<= oldc.a) # no overlap
				push!(newlist, oldc)
			else
				for i in 1:3
				    if oldc.a[i] < newc.a[i] && newc.b[i] < oldc.b[i]
				        c1, c2 = deepcopy(oldc), deepcopy(oldc)
				        c1.b[i], c2.a[i] = newc.a[i], newc.b[i]
				        push!(newlist, c1, c2)
				        oldc.a[i], oldc.b[i] = newc.a[i], newc.b[i]
	                elseif oldc.a[i] < newc.a[i] <= oldc.b[i]
	                    c1 = deepcopy(oldc)
	                    c1.b[i] = newc.a[i]
	                    push!(newlist, c1)
	                    oldc.a[i] = newc.a[i]
	                elseif oldc.a[i] <= newc.b[i] < oldc.b[i]
	                    c1 = deepcopy(oldc)
	                    c1.a[i] = newc.b[i]
	                    push!(newlist, c1)
	                    oldc.b[i] = newc.b[i]
	                end                
				end
			end
		end
	    oldlist = newlist
	    first(arr) == "on" && push!(oldlist, newc)
    end
    return sum(prod(abs.(cub.a .- cub.b)) for cub in oldlist)
end    

println("Part 1: ", day22(20))
println("Part 2: ", day22())

