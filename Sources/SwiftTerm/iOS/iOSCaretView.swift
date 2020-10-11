//
//  iOSCaretView.swift
//
// Implements the caret in the iOS caret view
//
//  Created by Miguel de Icaza on 3/20/20.
//
#if os(iOS)
    import CoreGraphics
    import CoreText
    import Foundation
    import UIKit

    // The CaretView is used to show the cursor
    class CaretView: UIView {
        override public init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        public var caretColor = UIColor.gray {
            didSet {
                setupView()
            }
        }

        func setupView() {
            let isFirst = superview?.isFirstResponder ?? true || true

            if isFirst {
                layer.borderWidth = isFirst ? 0 : 2
                layer.borderColor = caretColor.cgColor
                layer.backgroundColor = isFirst ? caretColor.cgColor : UIColor.clear.cgColor
            }
        }
    }
#endif
