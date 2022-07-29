enum Waveform: Int, CaseIterable, Identifiable {
    case sine
    case triangle
    case sawtooth
    case square

    var id: Self { self }

    var signal: Signal {
        switch self {
        case .sine: return Oscillator.sine
        case .triangle: return Oscillator.triangle
        case .sawtooth: return Oscillator.sawtooth
        case .square: return Oscillator.square
        }
    }
}
