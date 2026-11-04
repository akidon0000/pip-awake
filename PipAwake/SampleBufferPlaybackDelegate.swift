import AVKit
import os

final class SampleBufferPlaybackDelegate: NSObject, AVPictureInPictureSampleBufferPlaybackDelegate {
    private struct State: Sendable {
        var isPaused = false
        var onSetPlaying: (@Sendable (Bool) -> Void)?
    }

    private let state = OSAllocatedUnfairLock(initialState: State())

    var isPaused: Bool {
        get { state.withLock { $0.isPaused } }
        set { state.withLock { $0.isPaused = newValue } }
    }

    func setOnSetPlaying(_ handler: @escaping @Sendable (Bool) -> Void) {
        state.withLock { $0.onSetPlaying = handler }
    }

    func pictureInPictureController(
        _ pictureInPictureController: AVPictureInPictureController,
        setPlaying playing: Bool
    ) {
        let handler = state.withLock { state in
            state.isPaused = !playing
            return state.onSetPlaying
        }
        handler?(playing)
    }

    func pictureInPictureControllerTimeRangeForPlayback(
        _ pictureInPictureController: AVPictureInPictureController
    ) -> CMTimeRange {
        CMTimeRange(start: .negativeInfinity, duration: .positiveInfinity)
    }

    func pictureInPictureControllerIsPlaybackPaused(
        _ pictureInPictureController: AVPictureInPictureController
    ) -> Bool {
        isPaused
    }

    func pictureInPictureController(
        _ pictureInPictureController: AVPictureInPictureController,
        didTransitionToRenderSize newRenderSize: CMVideoDimensions
    ) {}

    func pictureInPictureController(
        _ pictureInPictureController: AVPictureInPictureController,
        skipByInterval skipInterval: CMTime,
        completion completionHandler: @escaping () -> Void
    ) {
        completionHandler()
    }
}
