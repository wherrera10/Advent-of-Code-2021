using BenchmarkTools

function explode(str::String)
    newstr = str
    while true
        a = [str[i:i] for i in eachindex(str)]
        isdig(s) = isdigit(s[begin])
        int(a, i) = (j = findfirst(!isdig, a[i+1:end]); parse(Int, join(a[i:(j == nothing ? length(a) : j)])))
        nesting = accumulate(+, [c == "[" ? 1 : c == "]" ? -1 : 0 for c in a])
        n = findfirst(>(4), nesting)
        n == nothing && return str
        isdigits = [isdig(s) for s in a]
        nums = [!isdigits[i] ? -1 : isdigits[i - 1] ? -2 : int(join(a[i:end]), 1) for i in eachindex(a)]
        n = findfirst(==(first(findmax(nesting))), nesting)
        x, y = nums[n + 1], nums[n + findfirst(==(-1), nums[n+1:end]) + 1]
        if (prev = findlast(>(-1), nums[begin:n-1])) != nothing
            nums[prev] += x
        end
        rbrack = findfirst(==("]"), a[n+1:end]) + n
        if (succ = findfirst(>(-1), nums[rbrack+1:end])) != nothing
            nums[rbrack+succ] += y
        end
        rbpos = findfirst(==(-1), nums[n+4:end]) + n + 3
        newstr = join([nums[i] == -2 ? "" : nums[i] == -1 ? a[i] : string(nums[i]) for i in
           eachindex(a[begin:n-1])]) * "0" * join([nums[rbpos + i] == -2 ? "" :
           nums[rbpos + i]  == -1 ? a[rbpos + i] : string(nums[rbpos + i])
           for i in eachindex(a[rbpos+1:end])])
        newstr == str && return newstr
        str = newstr
    end
end

function snailsplit(s)
    newstr = s
    while true
        if occursin(r"\d\d+", s)
            newstr = replace(s, r"\d\d+" => (x) -> "[" * string(parse(Int, x) ÷ 2) * ',' *
               string((parse(Int, x) + 1) ÷ 2) * "]", count=1)
            newstr = explode(newstr)
        end
        newstr == s && return newstr
        s = newstr
    end
end

function snailadd(s1, s2)
   s3 = "[" * s1 * "," * s2 * "]"
   while true
       newstring = snailsplit(explode(s3))
       newstring == s3 && break
       s3 = newstring
    end
    return s3
end

listadd(a) = reduce(snailadd, a)

function magnitude(arr::Vector)
    fir, las = first(arr), last(arr)
    return 3 * (fir isa Integer ? fir : magnitude(fir)) +
       2 * (las isa Integer ? las : magnitude(las))
end

magnitude(s::String) = magnitude(eval(Meta.parse(s)))
snailcheck(list) = magnitude(listadd(list))

function day18()
    part = [0, 0]
    part[1] = snailcheck(lines)
    checksums = Int[]
    for x in lines, y in lines
        x == y && continue
        push!(checksums, snailcheck([x, y]))
    end
    part[2] = maximum(part2)
end

part = day18()
println("Part 1: ", part[1])
println("Part 2: ", part[2])

@btime day18()

  
