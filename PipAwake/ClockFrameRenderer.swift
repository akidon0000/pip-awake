import CoreVideo
import UIKit

struct ClockFrame: Equatable {
    var elapsed: TimeInterval
    var isPluggedIn: Bool
}

struct ClockFrameRenderer {
    static let width = 640
    static let height = 180

    func render(_ frame: ClockFrame) -> CVPixelBuffer? {
        guard let buffer = makePixelBuffer() else {
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
        draw(frame, in: context)
        return buffer
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

    private func draw(_ frame: ClockFrame, in context: CGContext) {
        let width = CGFloat(Self.width)
        context.setFillColor(UIColor.black.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: width, height: CGFloat(Self.height)))
        // UIKit の文字描画は左上原点なので、ビットマップの座標系を上下反転してから描く
        context.translateBy(x: 0, y: CGFloat(Self.height))
        context.scaleBy(x: 1, y: -1)
        UIGraphicsPushContext(context)
        defer { UIGraphicsPopContext() }
        drawCentered(
            ElapsedFormatter.string(from: frame.elapsed),
            font: .monospacedDigitSystemFont(ofSize: 96, weight: .semibold),
            color: .white,
            centerY: 74,
            width: width
        )
        drawCentered(
            frame.isPluggedIn ? "給電中" : "未給電",
            font: .systemFont(ofSize: 28, weight: .regular),
            color: frame.isPluggedIn ? .lightGray : .systemRed,
            centerY: 152,
            width: width
        )
    }

    private func drawCentered(
        _ text: String, font: UIFont, color: UIColor, centerY: CGFloat, width: CGFloat
    ) {
        let attributed = NSAttributedString(
            string: text,
            attributes: [.font: font, .foregroundColor: color]
        )
        let size = attributed.size()
        attributed.draw(at: CGPoint(x: (width - size.width) / 2, y: centerY - size.height / 2))
    }
}
