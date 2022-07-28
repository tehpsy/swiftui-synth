import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack {
            Text("🤪🤪🤪🤪")
                .font(.largeTitle)

            waveformPicker

            Stepper("Octave: \(viewModel.octaveOffset)", value: $viewModel.octaveOffset, in: -2...2)
                .padding()

            Spacer()

            keys
                .frame(maxHeight: 300)
                .padding(4)
        }
    }

    private var waveformPicker: some View {
        Picker("Waveform", selection: $viewModel.waveform) {
            ForEach(Waveform.allCases) { waveform in
                Text(waveform.text)
            }
        }
        .pickerStyle(.segmented)
        .padding()
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
            .onChanged({ _ in
                viewModel.playedNote = note
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
        @Published var waveform = Waveform.sine
        @Published var midiNotes = [60, 62, 65, 67, 69, 70, 72]

        var synth: SynthProtocol
        init(synth: SynthProtocol) {
            self.synth = synth
            self.playedNote = nil
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    class SynthStub: SynthProtocol {
        var playedNote: Int?
        var octaveOffset = 0
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
