pos = [6, 2]
rolloutcomes = [[3, 1], [4, 3], [5, 6], [6, 7], [7, 6], [8, 3], [9, 1]]

function roll1000()
    detdie(idx) = 3 * (3 * mod1(idx, 100) - 1)
    scorespart1 = [0, 0]
    positionspart1 = pos
    won = [false, false]
    round = 0
    while !won[1] && !won[2]
        for (i, s) in enumerate(scorespart1)
            round += 1
            score = detdie(round)
            positionspart1[i] = mod1(positionspart1[i] + score, 10)
            scorespart1[i] += positionspart1[i]
            if scorespart1[i] >= 1000
                won[i] = true
                break
            end
        end
    end
    return 3 * round * minimum(scorespart1)
end

println("Part 1: ", roll1000())

function winners(player1, r1, player2, r2)
    if r2 <= 0
        return (0,1)
    end
    wins1, wins2 = 0,0
    for (roll, result) in rolloutcomes
        unis2, unis1 = winners(player2, r2, (player1 + roll) % 10, r1 - 1 - (player1 + roll) % 10)
        wins1 += result * unis1
        wins2 += result * unis2
    end
    return wins1, wins2
end

wins1, wins2 = winners(pos[1] - 1, 21, pos[2] - 1, 21)
println("Part 2: ", max(wins1, wins2))
