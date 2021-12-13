function day13()
    dottext, foldtext = split(read("AoCdata/AoC_2021_day13.txt", String), "\n\n")
    dotlines = strip.(split(dottext, "\n"))
    dots = [split(line, ",") .|> s -> parse(Int, s) for line in dotlines]
    ncols, nrows = maximum([first(dot) for dot in dots]) + 1, maximum([last(dot) for dot in dots]) + 1
    mat = zeros(Int, nrows, ncols)
    for dot in dots
        mat[dot[2] + 1, dot[1] + 1] = 1
    end
    foldlines = strip.(split(foldtext, "\n"))
    folds = Tuple{Bool,Int}[]
    for line in filter(!isempty, foldlines)
        isy, pos = split(line, r"[ =]")[(end - 1):end]
        push!(folds, (isy == "y", parse(Int, pos)))
    end

    for (i, fold) in enumerate(folds)
        if first(fold)
            top = mat[begin:last(fold), :]
            bottom = reverse(mat[(last(fold) + 2):end, :]; dims=1)
            toprows, bottomrows = size(top, 1), size(bottom, 1)
            if toprows > bottomrows
                mat = vcat(
                    top[begin:(toprows - bottomrows), :],
                    top[(toprows - bottomrows + 1):end, :] .+ bottom,
                )
            elseif toprows == bottomrows
                mat = top .+ bottom
            else
                mat = vcat(
                    bottom[begin:(bottomrows - toprows), :],
                    bottom[(bottomrows - toprows + 1):end, :] .+ top,
                )
            end
        else
            left = mat[:, begin:last(fold)]
            right = reverse(mat[:, (last(fold) + 2):end]; dims=2)
            leftcols, rightcols = size(left, 2), size(right, 2)
            if leftcols > rightcols
                mat = hcat(
                    left[:, begin:(leftcols - rightcols)],
                    left[:, (leftcols - rightcols + 1):end] .+ right,
                )
            elseif leftcols == rightcols
                mat = left .+ right
            else
                mat = hcat(
                    right[:, begin:(rightcols - leftcols)],
                    right[:, (rightcols - leftcols + 1):end] .+ left,
                )
            end
        end
        i == 1 && println("Part 1: ", count(mat .> 0))
    end

    println("Part 2 graphic:")
    for row in eachrow(mat)
        for n in row
            print(n == 0 ? ". " : "# ")
        end
        println()
    end
end

day13()
