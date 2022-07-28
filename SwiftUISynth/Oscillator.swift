import Foundation

typealias Signal = (_ frequency: Float, _ time: Float) -> Float

enum Oscillator {
    static var frequency: Float = 440

    static let sine: Signal = { frequency, time in
        return sin(2.0 * Float.pi * frequency * time)
    }
}
