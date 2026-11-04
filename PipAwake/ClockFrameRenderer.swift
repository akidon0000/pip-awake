import CoreVideo
import SwiftUI

struct ClockFrame: Equatable {
    var elapsed: TimeInterval
    var isPluggedIn: Bool
}

@MainActor
struct ClockFrameRenderer {
    // 横長の帯。ビットマップの解像度だけを決め、PiP 窓の実際の幅は系が比率から決める
    static let width = 640
    static let height = 50

    func render(_ frame: ClockFrame) -> CVPixelBuffer? {
        guard let image = makeImage(frame), let buffer = makePixelBuffer() else {
            return nil
        }
        CVPixelBufferLockBaseAddress(buffer, [])
        defer { CVPixelBufferUnlockBaseAddress(buffer, []) }
        guard
            let context = CGContext(
                data: CVPixelBufferGetBaseAddress(buffer),
                width: Self.width,
                height: Self.height,
                bitsPerComponent: 8,
                bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
                    | CGBitmapInfo.byteOrder32Little.rawValue
            )
        else {
            return nil
        }
        context.draw(image, in: CGRect(x: 0, y: 0, width: Self.width, height: Self.height))
        return buffer
    }

    /// SwiftUI のビューを 1 倍で画像にする。レイアウトは HStack に任せる
    private func makeImage(_ frame: ClockFrame) -> CGImage? {
        let renderer = ImageRenderer(content: ClockFrameView(frame: frame))
        renderer.proposedSize = ProposedViewSize(
            width: CGFloat(Self.width),
            height: CGFloat(Self.height)
        )
        renderer.scale = 1
        return renderer.cgImage
    }

    private func makePixelBuffer() -> CVPixelBuffer? {
        let attributes: [CFString: Any] = [
            kCVPixelBufferCGImageCompatibilityKey: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey: true,
            kCVPixelBufferIOSurfacePropertiesKey: [String: Any]()
        ]
        var buffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            Self.width,
            Self.height,
            kCVPixelFormatType_32BGRA,
            attributes as CFDictionary,
            &buffer
        )
        guard status == kCVReturnSuccess else {
            return nil
        }
        return buffer
    }
}
