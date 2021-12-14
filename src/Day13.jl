using BenchmarkTools

function day13(printoutput = true)
    folds = Tuple{Char, Int}[]
    dots = Set{Tuple{Int, Int}}()
    for line in filter(!isempty, strip.(readlines("AoCdata/day13.txt")))
        left, right = split(line, r"[ =,]")[end-1:end]
        if left in ["x", "y"]
            push!(folds, (first(left), parse(Int, right)))
        else
            push!(dots, (parse(Int, left) + 1, parse(Int, right) + 1))
        end
    end

    for (i, fold) in enumerate(folds)
        if first(fold) == 'y'  # fold in half horizontally lifting bottom edge up and folding down toward top
            for d in dots
                if last(d) > last(fold)
                    delete!(dots, d)
                    push!(dots, (first(d), 2 * last(fold) - last(d) + 2))
                end
            end
                else           # fold in half vertically lifting right edge up and to left
            for d in dots
                if first(d) > last(fold)
                    delete!(dots, d)
                    push!(dots, (2 * last(fold) - first(d) + 2, last(d)))
                end
            end
        end
        printoutput && i == 1 && println("Part 1: ", length(dots))
    end
    mat = fill('.', maximum([first(d) for d in dots]), maximum([last(d) for d in dots]))
    for d in CartesianIndices(mat)
       Tuple(d) in dots && (mat[d] = '#')
    end

    if printoutput
        println("Part 2 graphic:")
        for line in eachcol(mat)
            for ch in line
                print("$ch ")
            end
            println()
        end
    end

end

day13()

@btime day13(false)

        #=
        Part 1: 724
Part 2 graphic:
. # # . . # # # . . . . # # . # # # . . # # # # . # # # . . # . . # . # . . . 
# . . # . # . . # . . . . # . # . . # . # . . . . # . . # . # . . # . # . . . 
# . . . . # . . # . . . . # . # # # . . # # # . . # . . # . # . . # . # . . . 
# . . . . # # # . . . . . # . # . . # . # . . . . # # # . . # . . # . # . . . 
# . . # . # . . . . # . . # . # . . # . # . . . . # . # . . # . . # . # . . . 
. # # . . # . . . . . # # . . # # # . . # # # # . # . . # . . # # . . # # # # 
  1.541 ms (5296 allocations: 583.14 KiB)
=#
        
