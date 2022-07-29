import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ViewModel
    private let keyHeight: CGFloat = 300

    var body: some View {
        VStack {
            title

            Group {
                waveformPicker
                octaveStepper
                velocityToggle
            }
            .padding()

            Spacer()

            keys
                .frame(height: 300)
                .padding(4)
        }
    }

    private var title: some View {
        Text("🤪🤪🤪🤪")
            .font(.largeTitle)
    }

    private var waveformPicker: some View {
        Picker("Waveform", selection: $viewModel.waveform) {
            ForEach(Waveform.allCases) { waveform in
                Text(waveform.text)
            }
        }
        .pickerStyle(.segmented)
    }

    private var octaveStepper: some View {
        Stepper("Octave: \(viewModel.octaveOffset)", value: $viewModel.octaveOffset, in: -2...2)
    }

    private var velocityToggle: some View {
        Toggle("Enable Velocity", isOn: $viewModel.velocityEnabled)
    }

    private var keys: some View {
        HStack(spacing: 2) {
            ForEach(viewModel.midiNotes, id: \.self) { key(for: $0) }
        }
    }

    private func key(for note: Int) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundColor(viewModel.playedNote == note ? .orange : .blue)
            .gesture(dragGesture(for: note))
    }

    private func dragGesture(for note: Int) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged({ gesture in
                viewModel.playedNote = note
                viewModel.volume = 1 - Float(gesture.location.y / keyHeight)
            })
            .onEnded({ _ in
                viewModel.playedNote = nil
            })
    }
}

extension Waveform {
    var text: String {
        switch self {
        case .sine: return "Sine"
        case .triangle: return "Triangle"
        case .sawtooth: return "Sawtooth"
        case .square: return "Square"
        }
    }
}

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var playedNote: Int? {
            didSet { synth.playedNote = playedNote }
        }
        @Published var octaveOffset: Int = 0 {
            didSet { synth.octaveOffset = octaveOffset }
        }
        @Published var waveform = Waveform.sine {
            didSet { synth.waveform = waveform }
        }
        @Published var velocityEnabled = false {
            didSet { updateVolume() }
        }
        @Published var volume: Float = 0 {
            didSet { updateVolume() }
        }
        @Published var midiNotes = [60, 62, 65, 67, 69, 70, 72]

        var synth: SynthProtocol
        init(synth: SynthProtocol) {
            self.synth = synth
            self.playedNote = nil
        }

        private func updateVolume() {
            synth.volume = velocityEnabled ? volume : 1
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    class SynthStub: SynthProtocol {
        var playedNote: Int?
        var octaveOffset = 0
        var waveform = Waveform.sine
        var volume: Float = 0
    }

    static var previews: some View {
        ContentView(viewModel: ContentView.ViewModel(synth: SynthStub()))
            .preferredColorScheme(.dark)
            .previewDevice(PreviewDevice(rawValue: "iPhone 13"))
        ContentView(viewModel: ContentView.ViewModel(synth: SynthStub()))
            .preferredColorScheme(.light)
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
    }
}
