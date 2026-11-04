import CoreVideo
import SwiftUI

struct ClockFrame: Equatable {
    var elapsed: TimeInterval
}

@MainActor
struct ClockFrameRenderer {
    /// 1 フレームを BGRA の CVPixelBuffer にする。大きさは style の横幅と高さに従う
    func render(_ frame: ClockFrame, style: ClockFrameStyle) -> CVPixelBuffer? {
        guard let image = makeImage(frame, style: style), let buffer = makePixelBuffer(style: style)
        else {
            return nil
        }
        CVPixelBufferLockBaseAddress(buffer, [])
        defer { CVPixelBufferUnlockBaseAddress(buffer, []) }
        guard
            let context = CGContext(
                data: CVPixelBufferGetBaseAddress(buffer),
                width: style.width,
                height: style.height,
                bitsPerComponent: 8,
                bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
                    | CGBitmapInfo.byteOrder32Little.rawValue
            )
        else {
            return nil
        }
        context.draw(image, in: CGRect(x: 0, y: 0, width: style.width, height: style.height))
        return buffer
    }

    /// SwiftUI のビューを 1 倍で画像にする。レイアウトは HStack に任せる
    private func makeImage(_ frame: ClockFrame, style: ClockFrameStyle) -> CGImage? {
        let renderer = ImageRenderer(content: ClockFrameView(frame: frame, style: style))
        renderer.proposedSize = ProposedViewSize(
            width: CGFloat(style.width),
            height: CGFloat(style.height)
        )
        renderer.scale = 1
        return renderer.cgImage
    }

    private func makePixelBuffer(style: ClockFrameStyle) -> CVPixelBuffer? {
        let attributes: [CFString: Any] = [
            kCVPixelBufferCGImageCompatibilityKey: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey: true,
            kCVPixelBufferIOSurfacePropertiesKey: [String: Any]()
        ]
        var buffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            style.width,
            style.height,
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
