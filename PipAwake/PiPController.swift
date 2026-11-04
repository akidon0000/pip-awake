import AVKit

enum PiPEvent: Equatable {
    case didStart
    case failedToStart(String)
    case didStop(restored: Bool)
    case playingChanged(Bool)
}

@MainActor
protocol PiPControlling: AnyObject {
    var isSupported: Bool { get }
    var onEvent: ((PiPEvent) -> Void)? { get set }
    func start()
    func stop()
}

@MainActor
final class PiPController: NSObject, PiPControlling, AVPictureInPictureControllerDelegate {
    var onEvent: ((PiPEvent) -> Void)?
    var isSupported: Bool { AVPictureInPictureController.isPictureInPictureSupported() }

    private let controller: AVPictureInPictureController
    private let playbackDelegate: SampleBufferPlaybackDelegate
    private var startAttempt: Task<Void, Never>?
    private var restoreRequested = false

    init(displayLayer: AVSampleBufferDisplayLayer) {
        let playbackDelegate = SampleBufferPlaybackDelegate()
        let contentSource = AVPictureInPictureController.ContentSource(
            sampleBufferDisplayLayer: displayLayer,
            playbackDelegate: playbackDelegate
        )
        self.playbackDelegate = playbackDelegate
        controller = AVPictureInPictureController(contentSource: contentSource)
        super.init()
        controller.delegate = self
        controller.requiresLinearPlayback = true
        controller.canStartPictureInPictureAutomaticallyFromInline = false
        playbackDelegate.setOnSetPlaying { [weak self] playing in
            Task { @MainActor in
                self?.onEvent?(.playingChanged(playing))
            }
        }
    }

    /// delegate はメインスレッドから呼ばれる想定だが、保証はないので外れたときだけ hop する
    nonisolated private static func onMain(_ body: @escaping @MainActor @Sendable () -> Void) {
        if Thread.isMainThread {
            MainActor.assumeIsolated {
                body()
            }
        } else {
            Task { @MainActor in
                body()
            }
        }
    }

    func start() {
        playbackDelegate.isPaused = false
        controller.invalidatePlaybackState()
        controller.canStartPictureInPictureAutomaticallyFromInline = true
        startAttempt?.cancel()
        if controller.isPictureInPicturePossible {
            controller.startPictureInPicture()
            return
        }
        // レイヤーがウィンドウに載った直後は isPictureInPicturePossible が false のことがあるので待つ
        startAttempt = Task { [weak self] in
            for _ in 0..<30 {
                try? await Task.sleep(for: .milliseconds(100))
                guard let self, !Task.isCancelled else {
                    return
                }
                if controller.isPictureInPicturePossible {
                    controller.startPictureInPicture()
                    return
                }
            }
            self?.onEvent?(.failedToStart("PiP の準備ができませんでした"))
        }
    }

    func stop() {
        startAttempt?.cancel()
        startAttempt = nil
        controller.canStartPictureInPictureAutomaticallyFromInline = false
        if controller.isPictureInPictureActive {
            controller.stopPictureInPicture()
        }
    }

    nonisolated func pictureInPictureControllerDidStartPictureInPicture(
        _ pictureInPictureController: AVPictureInPictureController
    ) {
        Self.onMain { [weak self] in
            self?.onEvent?(.didStart)
        }
    }

    nonisolated func pictureInPictureController(
        _ pictureInPictureController: AVPictureInPictureController,
        failedToStartPictureInPictureWithError error: any Error
    ) {
        let message = error.localizedDescription
        Self.onMain { [weak self] in
            self?.onEvent?(.failedToStart(message))
        }
    }

    nonisolated func pictureInPictureController(
        _ pictureInPictureController: AVPictureInPictureController,
        restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler:
            @escaping (Bool) -> Void
    ) {
        Self.onMain { [weak self] in
            self?.restoreRequested = true
        }
        completionHandler(true)
    }

    nonisolated func pictureInPictureControllerDidStopPictureInPicture(
        _ pictureInPictureController: AVPictureInPictureController
    ) {
        Self.onMain { [weak self] in
            guard let self else {
                return
            }
            let restored = restoreRequested
            restoreRequested = false
            onEvent?(.didStop(restored: restored))
        }
    }
}
