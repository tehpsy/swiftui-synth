import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()

    var body: some View {
        VStack {
            Text("🤪🤪🤪🤪")
                .font(.largeTitle)

            Spacer()

            keys
                .frame(maxHeight: 300)
                .padding(4)
        }
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

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var playedNote: Int?
        @Published var midiNotes = [60, 62, 65, 67, 69, 70, 72]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .previewDevice(PreviewDevice(rawValue: "iPhone 13"))
        ContentView()
            .preferredColorScheme(.light)
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
    }
}
