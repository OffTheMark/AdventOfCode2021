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
            
        case .operator(let subpackets):
            let subpacketVersions = subpackets.flatMap({ $0.allVersions })
            versions.append(contentsOf: subpacketVersions)
        }
        
        return versions
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
        case literal(Int)
        case `operator`([Packet])
    }
}

extension Packet {
    init(rawValue: String) {
        let (packet, _) = Self.packet(rawValue: rawValue, startIndex: rawValue.startIndex)
        
        self = packet
    }
    
    private static func packet(rawValue: String, startIndex: String.Index) -> (packet: Packet, offset: Int) {
        var totalOffset = 3
        var currentIndex = startIndex
        
        let version = Int(
            rawValue[startIndex ..< rawValue.index(currentIndex, offsetBy: 3)],
            radix: 2
        )!
    
        currentIndex = rawValue.index(currentIndex, offsetBy: 3)
        totalOffset += 3
        
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
                totalOffset += 5
            }
            while currentFiveBits.first == "1"
                    
            let value = Int(String(bitsOfLiteral), radix: 2)!
    
            packetType = .literal(value)
            
        default:
            let lengthTypeID = Int(String(rawValue[currentIndex]), radix: 2)!
            
            totalOffset += 1
            currentIndex = rawValue.index(currentIndex, offsetBy: 1)
            
            var subpackets = [Packet]()
            switch lengthTypeID {
            case 0:
                let lengthInBitsOfSubpackets = Int(
                    rawValue[currentIndex ..< rawValue.index(currentIndex, offsetBy: 15)],
                    radix: 2
                )!
                
                totalOffset += 15
                currentIndex = rawValue.index(currentIndex, offsetBy: 15)
                
                var consumedBits = 0
                
                while consumedBits < lengthInBitsOfSubpackets {
                    let (subpacket, offset) = packet(rawValue: rawValue, startIndex: currentIndex)
                    subpackets.append(subpacket)
                    
                    totalOffset += offset
                    currentIndex = rawValue.index(currentIndex, offsetBy: offset)
                    
                    consumedBits += offset
                }

            case 1:
                let numberOfSubpackets = Int(
                    rawValue[currentIndex ..< rawValue.index(currentIndex, offsetBy: 11)],
                    radix: 2
                )!
                
                totalOffset += 11
                currentIndex = rawValue.index(currentIndex, offsetBy: 11)
                
                for _ in 0 ..< numberOfSubpackets {
                    let (subpacket, offset) = packet(rawValue: rawValue, startIndex: currentIndex)
                    subpackets.append(subpacket)
                    
                    totalOffset += offset
                    currentIndex = rawValue.index(currentIndex, offsetBy: offset)
                }
                
            default:
                fatalError("Invalid length type ID")
            }
            
            packetType = .operator(subpackets)
            break
        }
        
        let packet = Packet(version: version, typeID: typeID, packetType: packetType)
        return (packet, totalOffset)
    }
}
