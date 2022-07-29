import AVFoundation
import Foundation

protocol SynthProtocol {
    var playedNote: Int? { get set }
    var octaveOffset: Int { get set }
    var waveform: Waveform { get set }
    var volume: Float { get set }
}

class Synth: SynthProtocol {
    private let audioEngine = AVAudioEngine()
    private var frequency = Oscillator.frequency
    private var time = Float(0)
    private let sampleRate: Double
    private let deltaTime: Float
    private var signal: Signal { waveform.signal }
    var playedNote: Int? {
        didSet { update() }
    }
    var octaveOffset = 0 {
        didSet { update() }
    }
    var volume: Float = 0 {
        didSet { update() }
    }
    var waveform = Waveform.sine

    private lazy var sourceNode = AVAudioSourceNode { (_, _, frameCount, audioBufferList) -> OSStatus in
        let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)

        let period = 1 / self.frequency

        for frame in 0..<Int(frameCount) {
            let sampleVal = self.signal(self.frequency, self.time)
            self.time += self.deltaTime
            self.time = fmod(self.time, period)

            for buffer in ablPointer {
                let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                buf[frame] = sampleVal
            }
        }

        return noErr
    }

    init() {
        let mainMixer = audioEngine.mainMixerNode
        let outputNode = audioEngine.outputNode
        let format = outputNode.inputFormat(forBus: 0)

        sampleRate = format.sampleRate
        deltaTime = 1 / Float(sampleRate)

        let inputFormat = AVAudioFormat(commonFormat: format.commonFormat, sampleRate: sampleRate, channels: 1, interleaved: format.isInterleaved)
        audioEngine.attach(sourceNode)

        audioEngine.connect(sourceNode, to: mainMixer, format: inputFormat)
        audioEngine.connect(mainMixer, to: outputNode, format: nil)

        update()

        try! audioEngine.start()
    }

    private func update() {
        if let playedNote = playedNote {
            frequency = 400 * pow(2.0, (Float(playedNote + 12 * octaveOffset) - 69.0) / 12.0)
            audioEngine.mainMixerNode.outputVolume = volume
        } else {
            audioEngine.mainMixerNode.outputVolume = 0
        }
    }
}
