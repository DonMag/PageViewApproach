//
//  DashedBorderView.swift
//  PageViewApproach
//
//  Created by Don Mag on 9/15/23.
//

import UIKit

// MARK: UIView subclass with Dashed or Solid border

class DashedBorderView: UIImageView {

	enum BorderPosition {
		case inside, middle, outside
	}
	
	public var position: BorderPosition = .middle { didSet { setNeedsLayout() } }
	public var dashPattern: [NSNumber] = [16, 16] { didSet { dashedLineLayer.lineDashPattern = dashPattern } }
	public var lineWidth: CGFloat = 1.0 { didSet { dashedLineLayer.lineWidth = lineWidth } }
	public var color: UIColor = .red { didSet { dashedLineLayer.strokeColor = color.cgColor } }
	
	override class var layerClass: AnyClass { CAShapeLayer.self }
	var dashedLineLayer: CAShapeLayer { layer as! CAShapeLayer }
	
	init() {
		super.init(frame: .zero)
		commonInit()
	}
	override init(image: UIImage?) {
		super.init(image: image)
		commonInit()
	}
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		
		// this view will usually be overlaid on top of an interactive view
		//	so disable by default
		isUserInteractionEnabled = false
		
		dashedLineLayer.fillColor = UIColor.clear.cgColor
		dashedLineLayer.strokeColor = color.cgColor
		dashedLineLayer.lineWidth = lineWidth
		dashedLineLayer.lineDashPattern = dashPattern
		
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		switch position {
		case .inside:
			dashedLineLayer.path = CGPath(rect: bounds.insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5), transform: nil)
		case .outside:
			dashedLineLayer.path = CGPath(rect: bounds.insetBy(dx: -lineWidth * 0.5, dy: -lineWidth * 0.5), transform: nil)
		case .middle:
			dashedLineLayer.path = CGPath(rect: bounds, transform: nil)
		}
	}
	
}

