//
//  main.swift
//  Day21
//
//  Created by Marc-Antoine Malépart on 2021-12-21.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser
import Algorithms

struct Day21: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let startingPositions: [Position] = try readLines().compactMap({ line in
            let parts = line.components(separatedBy: ": ")
            return Position(rawValue: parts[1])
        })
        
        printTitle("Part 1", level: .title1)
        let losingScoreTimesNumberOfDieRolls = part1(startingPositions: startingPositions)
        print(
            "Product of the score of the losing players and the number of times the die was rolled:",
            losingScoreTimesNumberOfDieRolls,
            terminator: "\n\n"
        )
        
        printTitle("Part 2", level: .title1)
        let numberOfUniverses = part2(startingPositions: startingPositions)
        print("Number of universes where the player that wins the most wins:", numberOfUniverses)
    }
    
    func part1(startingPositions: [Position]) -> Int {
        var players = startingPositions.map({ Player(position: $0, targetScore: 1_000) })
        var die = DeterministicDie()
        var numberOfDieRolls = 0
        
        for (_, playerIndex) in product(1..., players.indices) {
            let positions: Int = (0 ..< 3).reduce(into: 0, { result, _ in
                result += die.roll()
            })
            numberOfDieRolls += 3
            
            players[playerIndex].move(by: positions)
            if players[playerIndex].hasWon {
                break
            }
        }
        
        return players.first(where: { !$0.hasWon })!.score * numberOfDieRolls
    }
    
    func part2(startingPositions: [Position]) -> Int {
        let players = startingPositions.map({ Player(position: $0, targetScore: 21) })
        
        struct PlayerPair: Hashable {
            let active: Player
            let other: Player
        }
        
        struct WinCountPair {
            var activePlayerWins: Int
            var otherPlayerWins: Int
            
            var max: Int {
                Swift.max(activePlayerWins, otherPlayerWins)
            }
        }
        
        var cache = [PlayerPair: WinCountPair]()
        let countByRollCombinations: [Int: Int] = product(1 ... 3, product(1 ... 3, 1 ... 3))
            .reduce(into: [:], { result, element in
                let (firstRoll, (secondRoll, thirdRoll)) = element
                let combination = firstRoll + secondRoll + thirdRoll
                result[combination, default: 0] += 1
            })
        
        func numberOfWins(active: Player, other: Player) -> WinCountPair {
            if active.hasWon {
                return WinCountPair(activePlayerWins: 1, otherPlayerWins: 0)
            }
            
            if other.hasWon {
                return WinCountPair(activePlayerWins: 0, otherPlayerWins: 1)
            }
            
            if let cachedResult = cache[PlayerPair(active: active, other: other)] {
                return cachedResult
            }
            
            var answer = WinCountPair(activePlayerWins: 0, otherPlayerWins: 0)
            
            for (move, count) in countByRollCombinations {
                var active = active
                active.move(by: move)
                
                let localResult = numberOfWins(active: other, other: active)
                answer.activePlayerWins += localResult.otherPlayerWins * count
                answer.otherPlayerWins += localResult.activePlayerWins * count
            }
            
            cache[PlayerPair(active: active, other: other)] = answer
            return answer
        }
        
        let numberOfWins = numberOfWins(active: players[0], other: players[1])
        return numberOfWins.max
    }
}

Day21.main()
