//
//  Grid.swift
//  Day20
//
//  Created by Marc-Antoine Malépart on 2021-12-20.
//

import Foundation
import Algorithms

struct Grid {
    var pixelsByPoint: [Point: Pixel]
    var pixelOutside: Pixel = .dark
    var rangeOfX: ClosedRange<Int>
    var rangeOfY: ClosedRange<Int>
    
    func numberOfLitPixels() -> Int {
        pixelsByPoint.count(where: { _, pixel in
            pixel == .light
        })
    }
    
    func enhancementIndex(for point: Point) -> Int {
        let offsets = -1 ... 1
        
        let pixels: [Pixel] = product(offsets, offsets)
            .reduce(into: [], { result, pair in
                let (deltaY, deltaX) = pair
                let offsetPoint = Point(x: point.x + deltaX, y: point.y + deltaY)
                let pixel = pixelsByPoint[offsetPoint, default: pixelOutside]
                result.append(pixel)
            })
        
        return Int(pixels: pixels)
    }
    
    mutating func enhance(using enhancement: Enhancement) {
        let rangeOfX = (rangeOfX.lowerBound - 1) ... (rangeOfX.upperBound + 1)
        let rangeOfY = (rangeOfY.lowerBound - 1) ... (rangeOfY.upperBound + 1)
        var newPixelsByPoint = [Point: Pixel]()
        
        for (x, y) in product(rangeOfX, rangeOfY) {
            let point = Point(x: x, y: y)
            let enhancementIndex = enhancementIndex(for: point)
            newPixelsByPoint[point] = enhancement.pixel(at: enhancementIndex)
        }
        
        self.pixelsByPoint = newPixelsByPoint
        let outsideIndex = Int(pixels: [Pixel](repeating: pixelOutside, count: 9))
        self.pixelOutside = enhancement.pixel(at: outsideIndex)
        self.rangeOfX = rangeOfX
        self.rangeOfY = rangeOfY
    }
}

extension Grid {
    init(rawValue: String) {
        let lines = rawValue.components(separatedBy: .newlines)
        
        var maxY = 0
        var maxX = 0
        self.pixelsByPoint = lines.enumerated()
            .reduce(into: [:], { result, pair in
                let (y, line) = pair
                
                for (x, character) in line.enumerated() {
                    guard let pixel = Pixel(rawValue: character) else {
                        continue
                    }
                    
                    let point = Point(x: x, y: y)
                    result[point] = pixel
                    
                    maxX = max(maxX, x)
                }
                
                maxY = max(maxY, y)
            })
        
        self.rangeOfX = 0 ... maxX
        self.rangeOfY = 0 ... maxY
    }
}

struct Point {
    var x: Int
    var y: Int
}

extension Point: Hashable {}

enum Pixel: Character {
    case light = "#"
    case dark = "."
    
    var binaryValue: Int {
        switch self {
        case .light:
            return 1
            
        case .dark:
            return 0
        }
    }
}

struct Enhancement {
    let pixels: [Pixel]
    
    func pixel(at index: Int) -> Pixel {
        pixels[index]
    }
}

extension Enhancement {
    init(rawValue: String) {
        self.pixels = rawValue.compactMap(Pixel.init)
    }
}

extension Int {
    init(pixels: [Pixel]) {
        self = pixels.reversed().enumerated().reduce(into: 0, { result, pair in
            let (index, pixel) = pair
            
            result += Int(pow(2, Double(index))) * pixel.binaryValue
        })
    }
}
