import Foundation

typealias Signal = (_ frequency: Float, _ time: Float) -> Float

enum Oscillator {
    static var frequency: Float = 440

    static let sine: Signal = { frequency, time in
        return sin(2.0 * Float.pi * frequency * time)
    }

    static let triangle: Signal = { frequency, time in
        let normTime = Self.normTime(time: time, frequency: frequency)

        let result = { (value: Double) -> Double in
            if value < 0.25 { return value * 4 }
            if value < 0.75 { return 2.0 - (value * 4.0) }
            return value * 4 - 4.0
        }

        return Float(result(normTime))
    }

    static let sawtooth: Signal = { frequency, time in
        let normTime = Self.normTime(time: time, frequency: frequency)
        return Float(normTime * 2 - 1.0)
    }

    static let square: Signal = { frequency, time in
        let normTime = Self.normTime(time: time, frequency: frequency)
        return (normTime < 0.5) ? 1 : -1.0
    }

    private static func normTime(time: Float, frequency: Float) -> Double {
        let period = 1.0 / Double(frequency)
        let currentTime = fmod(Double(time), period)
        return currentTime / period
    }
}
