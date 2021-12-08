//
//  main.swift
//  Day8
//
//  Created by Marc-Antoine Malépart on 2021-12-08.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day8: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    static let digitsBySegments: [Set<Segment>: Character] = [
        [.a, .b, .c, .e, .f, .g]: "0",
        [.c, .f]: "1",
        [.a, .c, .d, .e, .g]: "2",
        [.a, .c, .d,. f,. g]: "3",
        [.b, .c, .d, .f]: "4",
        [.a,. b, .d, .f, .g]: "5",
        [.a, .b, .d, .e, .f, .g]: "6",
        [.a, .c, .f]: "7",
        [.a, .b, .c, .d, .e, .f, .g]: "8",
        [.a, .b, .c, .d, .f, .g]: "9"
    ]
    
    func run() throws {
        let entries = try readLines().compactMap(Entry.init)
        
        let numberOfUniqueDigitsInOutput = part1(entries: entries)
        print("Number of digits 1, 4, 7 and 8 in output:", numberOfUniqueDigitsInOutput, terminator: "\n\n")
        
        let sumOfOutputValues = part2(entries: entries)
        print("Sum of output values:", sumOfOutputValues)
    }
    
    func part1(entries: [Entry]) -> Int {
        return entries.reduce(into: 0, { total, entry in
            total += entry.outputSignals.count(where: { value in
                switch value.count {
                case 2,
                    4,
                    3,
                    7:
                    return true
                    
                default:
                    return false 
                }
            })
        })
    }
    
    func part2(entries: [Entry]) -> Int {
        return entries.reduce(into: 0, { total, entry in
            let segmentsBySignal = segmentsBySignal(signalPatterns: entry.signalPatterns)
            let outputSegments = entry.outputSignals.map({ signal in
                Set(signal.map({ segmentsBySignal[$0]! }))
            })
            let outputRawValue = String(outputSegments.map({ Self.digitsBySegments[$0]! }))
            let outputValue = Int(outputRawValue)!
            
            total += outputValue
        })
    }
    
    private func segmentsBySignal(signalPatterns: [Set<SignalWire>]) -> [SignalWire: Segment] {
        var possibleSignalsBySegment = [Segment: Set<SignalWire>]()
        
        let signalsForDigit1 = signalPatterns.first(where: { $0.count == 2 })!
        let signalsForDigit7 = signalPatterns.first(where: { $0.count == 3 })!
        
        // 1. Find signal for segment a
        // The signal for segment a is the signal in digit 7 that does not appear in the signal pattern for digit 1.
        // The possible signals for segments c and f are the signals that appear in the signal pattern for digit 1.
        possibleSignalsBySegment[.a] = signalsForDigit7.subtracting(signalsForDigit1)
        [Segment.c, Segment.f].forEach({ possibleSignalsBySegment[$0] = signalsForDigit1.intersection(signalsForDigit7) })
        
        // 2. Find signal for segments b and d
        // The two possible signals for segments b and d are the signals that do not appear in the signal pattern for digit 1.
        let signalsForDigit4 = signalPatterns.first(where: { $0.count == 4 })!
        [Segment.b, Segment.d].forEach({ possibleSignalsBySegment[$0] = signalsForDigit4.subtracting(signalsForDigit1) })
        
        // The signal for segment b is the only signal in the posible signals for segment b that do not appear in a pattern of count 6. The pattern
        // where it does not appear is the pattern for digit 0.
        let signalsOfCount6 = signalPatterns.filter({ $0.count == 6 })
        let signalForDigit0 = signalsOfCount6.first(where: { $0.intersection(possibleSignalsBySegment[.b]!).count == 1 })!
        let signalForSegmentB = signalForDigit0.intersection(possibleSignalsBySegment[.b]!)
        possibleSignalsBySegment[.b] = signalForSegmentB
        possibleSignalsBySegment[.d]?.subtract(signalForSegmentB)
        
        // 3. Find signal for segments c and f
        // The signal for segment f is the only signal in the possible signals for segment f that do not appear in a pattern of count 6. The pattern
        // where is does not appear is the pattern for digit 6.
        let signalForDigit6 = signalsOfCount6.first(where: { $0.intersection(possibleSignalsBySegment[.f]!).count == 1 })!
        let signalForSegmentF = signalForDigit6.intersection(possibleSignalsBySegment[.f]!)
        possibleSignalsBySegment[.f] = signalForSegmentF
        possibleSignalsBySegment[.c]?.subtract(signalForSegmentF)
        
        // 4. Find signal for segments e and g
        // The signal for segment e is the signal that does not appear in the signal pattern for digit 9. The pattern for digit 9 is the remaining
        // pattern of count 6.
        let signalForDigit9 = signalsOfCount6.first(where: { $0 != signalForDigit0 && $0 != signalForDigit6 })!
        let signalForSegmentE = Set(SignalWire.allCases).subtracting(signalForDigit9)
        possibleSignalsBySegment[.e] = signalForSegmentE
        
        // The signal for segment g is the only remaining signal to match.
        let signalForSegmentG = Set(SignalWire.allCases).subtracting(Set(possibleSignalsBySegment.values.flatMap({ $0 })))
        possibleSignalsBySegment[.g] = signalForSegmentG
        
        assert(possibleSignalsBySegment.count == 7, "All segments are accounted for")
        assert(possibleSignalsBySegment.values.allSatisfy({ $0.count == 1 }), "Only one possible signal by segment")
        
        return possibleSignalsBySegment.reduce(into: [SignalWire: Segment](), { result, pair in
            result[pair.value.first!] = pair.key
        })
    }
}

Day8.main()

