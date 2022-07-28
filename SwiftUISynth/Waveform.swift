enum Waveform: Int, CaseIterable, Identifiable {
    case sine
    case triangle
    case sawtooth
    case square

    var id: Self { self }
}
