import AVFoundation

@MainActor
protocol FrameFeeding: AnyObject {
    func start(startedAt: Date)
    func pause()
    func resume()
    func stop()
}

@MainActor
final class ClockSampleBufferFeeder: FrameFeeding {
    let displayLayer = AVSampleBufferDisplayLayer()
    /// 毎フレーム呼ぶ。給電状態の表示と、通知が届かない場合のポーリングを兼ねる
    var isPluggedIn: () -> Bool = { true }
    /// 次の start から使う映像の大きさと表示内容
    var style = ClockFrameStyle.standard

    private let renderer = ClockFrameRenderer()
    private let timebase: CMTimebase
    private var timer: Timer?
    private var startedAt = Date()
    private var isRunning = false

    init() {
        do {
            timebase = try CMTimebase(sourceClock: .hostTimeClock)
        } catch {
            fatalError("CMTimebase を作れませんでした: \(error)")
        }
        displayLayer.controlTimebase = timebase
        displayLayer.videoGravity = .resizeAspect
        displayLayer.preventsDisplaySleepDuringVideoPlayback = false
    }

    func start(startedAt: Date) {
        self.startedAt = startedAt
        try? timebase.setTime(.zero)
        play()
    }

    func pause() {
        isRunning = false
        invalidateTimer()
        try? timebase.setRate(0)
        displayLayer.preventsDisplaySleepDuringVideoPlayback = false
    }

    func resume() {
        play()
    }

    func stop() {
        pause()
        let output = displayLayer.sampleBufferRenderer
        output.flush(removingDisplayedImage: true, completionHandler: nil)
    }

    private func play() {
        isRunning = true
        try? timebase.setRate(1)
        displayLayer.preventsDisplaySleepDuringVideoPlayback = true
        enqueueFrame()
        invalidateTimer()
        let timer = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.enqueueFrame()
            }
        }
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }

    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func enqueueFrame() {
        let now = Date()
        let isPluggedIn = isPluggedIn()
        // isPluggedIn() の中で給電切れを検知して stop() が呼ばれることがある
        guard isRunning else {
            return
        }
        let output = displayLayer.sampleBufferRenderer
        if output.status == .failed || output.requiresFlushToResumeDecoding {
            output.flush()
        }
        let frame = ClockFrame(
            elapsed: now.timeIntervalSince(startedAt),
            isPluggedIn: isPluggedIn
        )
        let time = timebase.time
        guard
            let pixelBuffer = renderer.render(frame, style: style),
            let sample = SampleBufferFactory.make(from: pixelBuffer, presentationTime: time)
        else {
            return
        }
        output.enqueue(sample)
    }
}
