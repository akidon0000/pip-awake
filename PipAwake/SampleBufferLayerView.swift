import AVFoundation
import SwiftUI

final class LayerHostView: UIView {
    private let hosted: CALayer

    init(hosted: CALayer) {
        self.hosted = hosted
        super.init(frame: .zero)
        backgroundColor = .black
        layer.addSublayer(hosted)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) は使わない")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        hosted.frame = bounds
    }
}

struct SampleBufferLayerView: UIViewRepresentable {
    let displayLayer: AVSampleBufferDisplayLayer

    func makeUIView(context: Context) -> LayerHostView {
        LayerHostView(hosted: displayLayer)
    }

    func updateUIView(_ uiView: LayerHostView, context: Context) {}
}
