//
//  Message.swift
//  Day16
//
//  Created by Marc-Antoine Malépart on 2021-12-16.
//

import Foundation

struct Packet {
    let version: Int
    let typeID: Int
    let packetType: PacketType
    
    var allVersions: [Int] {
        var versions = [version]
        
        switch packetType {
        case .literal:
            return versions
            
        case .operator(_, let subpackets):
            let subpacketVersions = subpackets.flatMap({ $0.allVersions })
            versions.append(contentsOf: subpacketVersions)
        }
        
        return versions
    }
    
    var value: Int {
        switch packetType {
        case .literal(let value):
            return value
            
        case .operator(let operation, let subpackets):
            switch operation {
            case .sum:
                return subpackets.reduce(0, { result, subpacket in
                    result + subpacket.value
                })
                
            case .product:
                return subpackets.reduce(1, { result, subpacket in
                    result * subpacket.value
                })
                
            case .minimum:
                return subpackets.map(\.value).min()!
                
            case .maximum:
                return subpackets.map(\.value).max()!
                
            case .greaterThan:
                if subpackets[0].value > subpackets[1].value {
                    return 1
                }
                else {
                    return 0
                }
                
            case .lessThan:
                if subpackets[0].value < subpackets[1].value {
                    return 1
                }
                else {
                    return 0
                }
                
            case .equalTo:
                if subpackets[0].value == subpackets[1].value {
                    return 1
                }
                else {
                    return 0
                }
            }
        }
    }
    
    struct Hexadecimal {
        let rawValue: String
        
        func binary() -> String {
            return rawValue.reduce(into: "", { result, hexadecimalCharacter in
                guard let hexadecimalValue = Int(String(hexadecimalCharacter), radix: 16) else {
                    return
                }
                
                var binaryForm = String(hexadecimalValue, radix: 2)
                if binaryForm.count < 4 {
                    let paddingZeroes = String(repeating: "0", count: 4 - binaryForm.count)
                    binaryForm = paddingZeroes + binaryForm
                }
                
                result += binaryForm
            })
        }
    }
    
    enum PacketType {
        case literal(value: Int)
        case `operator`(operation: Operation, subpackets: [Packet])
    }
    
    enum Operation: Int {
        case sum = 0
        case product = 1
        case minimum = 2
        case maximum = 3
        case greaterThan = 5
        case lessThan = 6
        case equalTo = 7
    }
    
    enum LengthType: Int {
        case numberOfBits = 0
        case numberOfSubpackets = 1
    }
}

extension Packet {
    init(rawValue: String) throws {
        let (packet, _) = try Self.packet(rawValue: rawValue, startIndex: rawValue.startIndex)
        
        self = packet
    }
    
    private static func packet(rawValue: String, startIndex: String.Index) throws -> (packet: Packet, endIndex: String.Index) {
        var currentIndex = startIndex
        
        let version = Int(
            rawValue[startIndex ..< rawValue.index(currentIndex, offsetBy: 3)],
            radix: 2
        )!
    
        currentIndex = rawValue.index(currentIndex, offsetBy: 3)
        
        let typeID = Int(
            rawValue[currentIndex ..< rawValue.index(currentIndex, offsetBy: 3)],
            radix: 2
        )!
        
        currentIndex = rawValue.index(currentIndex, offsetBy: 3)
        
        let packetType: Packet.PacketType
        switch typeID {
        case 4:
            var bitsOfLiteral = [Character]()
            var currentFiveBits: Substring
            
            repeat {
                currentFiveBits = rawValue[currentIndex ..< rawValue.index(currentIndex, offsetBy: 5)]
                
                bitsOfLiteral.append(contentsOf: currentFiveBits.dropFirst())
                
                currentIndex = rawValue.index(currentIndex, offsetBy: 5)
            }
            while currentFiveBits.first == "1"
                    
            let value = Int(String(bitsOfLiteral), radix: 2)!
            packetType = .literal(value: value)
            
        default:
            guard let operation = Packet.Operation(rawValue: typeID) else {
                throw ParsingError.invalidTypeID(typeID: typeID)
            }
                        
            let lengthTypeID = Int(String(rawValue[currentIndex]), radix: 2)!
            
            currentIndex = rawValue.index(currentIndex, offsetBy: 1)
            
            var subpackets = [Packet]()
            guard let lengthType = LengthType(rawValue: lengthTypeID) else {
                throw ParsingError.invalidLengthTypeID(lengthTypeID: lengthTypeID)
            }
            
            switch lengthType {
            case .numberOfBits:
                let lengthInBitsOfSubpackets = Int(
                    rawValue[currentIndex ..< rawValue.index(currentIndex, offsetBy: 15)],
                    radix: 2
                )!
                
                currentIndex = rawValue.index(currentIndex, offsetBy: 15)
                
                var consumedBits = 0
                
                while consumedBits < lengthInBitsOfSubpackets {
                    let (subpacket, endIndex) = try packet(rawValue: rawValue, startIndex: currentIndex)
                    subpackets.append(subpacket)
                    
                    consumedBits += rawValue.distance(from: currentIndex, to: endIndex)
                    currentIndex = endIndex
                }

            case .numberOfSubpackets:
                let numberOfSubpackets = Int(
                    rawValue[currentIndex ..< rawValue.index(currentIndex, offsetBy: 11)],
                    radix: 2
                )!
                
                currentIndex = rawValue.index(currentIndex, offsetBy: 11)
                
                for _ in 0 ..< numberOfSubpackets {
                    let (subpacket, endIndex) = try packet(rawValue: rawValue, startIndex: currentIndex)
                    subpackets.append(subpacket)
                    
                    currentIndex = endIndex
                }
            }
            
            packetType = .operator(operation: operation, subpackets: subpackets)
            break
        }
        
        let packet = Packet(version: version, typeID: typeID, packetType: packetType)
        return (packet, currentIndex)
    }
    
    enum ParsingError: Error {
        case invalidTypeID(typeID: Int)
        case invalidLengthTypeID(lengthTypeID: Int)
    }
}
