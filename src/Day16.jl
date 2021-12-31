using BenchmarkTools

day16data = """E0525D9802FA00B80021B13E2D4260004321DC648D729DD67B2412009966D76C0159ED274F6921402E9FD4AC1B0F652CD339D7B82240083C9A54E819802B369DC0082CF90CF9280081727DAF41E6A5C1B9B8E41A4F31A4EF67E2009834015986F9ABE41E7D6080213931CB004270DE5DD4C010E00D50401B8A708E3F80021F0BE0A43D9E460007E62ACEE7F9FB4491BC2260090A573A876B1BC4D679BA7A642401434937C911CD984910490CCFC27CC7EE686009CFC57EC0149CEFE4D135A0C200C0F401298BCF265377F79C279F540279ACCE5A820CB044B62299291C0198025401AA00021D1822BC5C100763A4698FB350E6184C00A9820200FAF00244998F67D59998F67D5A93ECB0D6E0164D709A47F5AEB6612D1B1AC788846008780252555097F51F263A1CA00C4D0946B92669EE47315060081206C96208B0B2610E7B389737F3E2006D66C1A1D4ABEC3E1003A3B0805D337C2F4FA5CD83CE7DA67A304E9BEEF32DCEF08A400020B1967FC2660084BC77BAC3F847B004E6CA26CA140095003900BAA3002140087003D40080022E8C00870039400E1002D400F10038C00D100218038F400B6100229500226699FEB9F9B098021A00800021507627C321006E24C5784B160C014A0054A64E64BB5459DE821803324093AEB3254600B4BF75C50D0046562F72B1793004667B6E78EFC0139FD534733409232D7742E402850803F1FA3143D00042226C4A8B800084C528FD1527E98D5EB45C6003FE7F7FCBA000A1E600FC5A8311F08010983F0BA0890021F1B61CC4620140EC010100762DC4C8720008641E89F0866259AF460C015D00564F71ED2935993A539C0F9AA6B0786008D80233514594F43CDD31F585005A25C3430047401194EA649E87E0CA801D320D2971C95CAA380393AF131F94F9E0499A775460"""

function bint(bits, offset, len)
    return parse(Int, bits[(begin + offset):(begin + offset + len - 1)]; base=2)
end
const part = [0, 0]

function parsepacket(bits::String, idx=0)
    results, result = Int[], 0
    version = bint(bits, idx, 3)
    part[1] += version
    idx += 3
    typeid = bint(bits, idx, 3)
    idx += 3
    if typeid == 4 # literal value
        numbits, firstwas1 = "", true
        while firstwas1
            numbits *= bits[(begin + idx + 1):(begin + idx + 4)]
            firstwas1 = (bits[begin + idx] == '1')
            idx += 5
        end
        result = bint(numbits, 0, length(numbits))
    else  # or else typeid is one of the operators
        lengthtypeid = bits[begin + idx]
        idx += 1
        if lengthtypeid == '1'  # vector of nresults child packets follows
            nresults = bint(bits, idx, 11)
            idx += 11
            for _ in 1:nresults
                child, idx = parsepacket(bits, idx)
                push!(results, child)
            end
        else  # length of subresults format when length type id is 0
            subpacketlength = bint(bits, idx, 15)
            idx += 15
            subpacketend = idx + subpacketlength
            while idx < subpacketend
                child, idx = parsepacket(bits, idx)
                push!(results, child)
            end
        end
    end
    # part 2 computations on packets which depend on operator (the typeid)
    if typeid == 0
        result = sum(results)
    elseif typeid == 1
        result = prod(results)
    elseif typeid == 2
        result = minimum(results)
    elseif typeid == 3
        result = maximum(results)
    elseif typeid == 5
        result = first(results) > last(results)
    elseif typeid == 6
        result = first(results) < last(results)
    elseif typeid == 7
        result = first(results) == last(results)
    end
    return result, idx
end

function day16(s)
    part[1] = 0
    part[2], _ = parsepacket(string(parse(BigInt, s; base=16); base=2))
    return part
end

part = day16(day16data)
println("Part 1: ", part[1])
println("Part 2: ", part[2])

@btime day16(day16data)
