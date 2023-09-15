//
//  ViewController.swift
//  PageViewApproach
//
//  Created by Don Mag on 9/15/23.
//

import UIKit

struct PageData {
	var title: String = ""
	var desc: String = ""
	
	// maybe different images on each page?
	var imgName: String = ""
}

class SamplePageVC: UIViewController {
	
	let titleLabel: UILabel = UILabel()
	let descLabel: UILabel = UILabel()
	let imgView: UIImageView = UIImageView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .clear
		
		guard let customFont1 = UIFont(name: "TimesNewRomanPSMT", size: 32.0),
			  let customFont2 = UIFont(name: "Verdana", size: 16.0)
		else {
			fatalError("Could not load font!")
		}
		
		titleLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFont1)
		descLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFont2)
		
		[titleLabel, descLabel].forEach { v in
			v.adjustsFontForContentSizeCategory = true
			v.textAlignment = .center
			v.textColor = .white
			v.numberOfLines = 0
			v.setContentHuggingPriority(.required, for: .vertical)
			v.setContentCompressionResistancePriority(.required, for: .vertical)
		}
		
		// might want to set a MAX Content Size Category?
		//view.maximumContentSizeCategory = .accessibilityExtraLarge
		
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.spacing = 6
		
		[imgView, titleLabel, descLabel].forEach { v in
			stackView.addArrangedSubview(v)
		}
		
		stackView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(stackView)
		
		let g = view.safeAreaLayoutGuide
		let bc: NSLayoutConstraint = stackView.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: -8.0)
		bc.priority = .required - 1
		
		NSLayoutConstraint.activate([
			
			stackView.topAnchor.constraint(equalTo: g.topAnchor, constant: 0.0),
			stackView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 0.0),
			stackView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: 0.0),
			stackView.bottomAnchor.constraint(lessThanOrEqualTo: g.bottomAnchor, constant: -8.0),
			bc,
			
			imgView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -60.0),
			imgView.heightAnchor.constraint(equalTo: imgView.widthAnchor, multiplier: 1.0),
			
			titleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -20.0),
			descLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -20.0),
			
		])
	}
	
}

class OnboardingVC: UIViewController, UIScrollViewDelegate {
	
	let skipBtn: UIButton = UIButton()
	let subscribeBtn: UIButton = UIButton()
	let loginBtn: UIButton = UIButton()
	
	let pgCtrl: UIPageControl = UIPageControl()
	
	let outerScrollView: UIScrollView = UIScrollView()
	let outerContentView: UIView = UIView()
	
	let pageScrollView: UIScrollView = UIScrollView()
	let pageStackView: UIStackView = UIStackView()
	
	var pageData: [PageData] = [
		PageData(title: "First Page", desc: "Some description about it.", imgName: "pgXC"),
		PageData(title: "Short", desc: "This page has somewhat longer description text.", imgName: ""),
		PageData(title: "A Longer Title", desc: "This page will have even more text in the description label. That will help demonstrate the height matching and resulting layout / scrolling changes.", imgName: ""),
		PageData(title: "Final", desc: "This is the last page.", imgName: ""),
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .init(red: 1.0, green: 0.25, blue: 0.2, alpha: 1.0)
		
		guard let skipFont = UIFont(name: "Verdana", size: 17.0),
			  let btnFont = UIFont(name: "Verdana-Bold", size: 16.0)
		else {
			fatalError("Could not load font!")
		}

		skipBtn.titleLabel?.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: skipFont)
		subscribeBtn.titleLabel?.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: btnFont)
		loginBtn.titleLabel?.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: btnFont)

		for (btn, str) in zip([skipBtn, subscribeBtn, loginBtn], ["Skip", "Subscribe", "Login"]) {
			btn.titleLabel?.adjustsFontForContentSizeCategory = true
			btn.setTitle(str, for: [])
			btn.layer.cornerRadius = 6
		}
		
		skipBtn.setTitleColor(.white, for: .normal)
		skipBtn.setTitleColor(.lightGray, for: .highlighted)
		skipBtn.setContentCompressionResistancePriority(.required, for: .vertical)
		
		subscribeBtn.setTitleColor(.blue, for: .normal)
		subscribeBtn.setTitleColor(.systemBlue, for: .highlighted)
		subscribeBtn.backgroundColor = .white
		
		loginBtn.setTitleColor(.white, for: .normal)
		loginBtn.setTitleColor(.lightGray, for: .highlighted)
		loginBtn.layer.borderColor = UIColor.white.cgColor
		loginBtn.layer.borderWidth = 1
		
		let btnStack: UIStackView = UIStackView()
		btnStack.axis = .vertical
		btnStack.spacing = 12
		
		// let's add top and bottom padding for the buttons
		//	we're not using UIButtonConfiguration so we ignore the deprecation warnings
		[subscribeBtn, loginBtn].forEach { v in
			var edges = v.contentEdgeInsets
			edges.top = 12.0
			edges.bottom = 12.0
			v.contentEdgeInsets = edges
		}
		
		// add Page Control and bottom buttons to vertical stack view
		//	set Hugging and Compression priorities to .required so they
		//	won't stretch or collapse vertically
		[pgCtrl, subscribeBtn, loginBtn].forEach { v in
			btnStack.addArrangedSubview(v)
			v.setContentHuggingPriority(.required, for: .vertical)
			v.setContentCompressionResistancePriority(.required, for: .vertical)
		}
		
		// add "pages" stack view to "page" scroll view
		pageStackView.translatesAutoresizingMaskIntoConstraints = false
		pageScrollView.addSubview(pageStackView)
		
		// add elements to outerContentView
		[skipBtn, pageScrollView, btnStack].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
			outerContentView.addSubview(v)
		}
		
		// add outerContentView to outerScrollView
		outerContentView.translatesAutoresizingMaskIntoConstraints = false
		outerScrollView.addSubview(outerContentView)
		
		// add outerScrollView to (self) view
		outerScrollView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(outerScrollView)
		
		let g = view.safeAreaLayoutGuide
		
		var cg = pageScrollView.contentLayoutGuide
		var fg = pageScrollView.frameLayoutGuide
		
		NSLayoutConstraint.activate([
			
			// constrain all 4 sides of pageStackView to pageScrollView.contentLayoutGuide
			pageStackView.topAnchor.constraint(equalTo: cg.topAnchor, constant: 0.0),
			pageStackView.leadingAnchor.constraint(equalTo: cg.leadingAnchor, constant: 0.0),
			pageStackView.trailingAnchor.constraint(equalTo: cg.trailingAnchor, constant: 0.0),
			pageStackView.bottomAnchor.constraint(equalTo: cg.bottomAnchor, constant: 0.0),
			
			// constrain skip button Top/Trailing
			skipBtn.topAnchor.constraint(equalTo: outerContentView.topAnchor, constant: 12.0),
			skipBtn.trailingAnchor.constraint(equalTo: outerContentView.trailingAnchor, constant: -40.0),
			
			// constrain pageScrollView
			//	Top 8-points below skip button Bottom
			//	Leading/Trailing to outerContentView (so, full width)
			pageScrollView.topAnchor.constraint(equalTo: skipBtn.bottomAnchor, constant: 8.0),
			pageScrollView.leadingAnchor.constraint(equalTo: outerContentView.leadingAnchor, constant: 0.0),
			pageScrollView.trailingAnchor.constraint(equalTo: outerContentView.trailingAnchor, constant: 0.0),
			
			// constrain pageScrollView HEIGHT to pageStackView HEIGHT
			//	now, the scroll view Height will match the "pages" height
			pageScrollView.heightAnchor.constraint(equalTo: pageStackView.heightAnchor, constant: 0.0),
			
			// constrain btnStack
			//	Top >= pageScrollView Bottom plus a little "padding space"
			//	Leading/Trailing to outerContentView plus a little "padding space" on the sides
			//	Bottom to outerContentView plus a little "padding space"
			btnStack.topAnchor.constraint(greaterThanOrEqualTo: pageScrollView.bottomAnchor, constant: 12.0),
			btnStack.leadingAnchor.constraint(equalTo: outerContentView.leadingAnchor, constant: 20.0),
			btnStack.trailingAnchor.constraint(equalTo: outerContentView.trailingAnchor, constant: -20.0),
			btnStack.bottomAnchor.constraint(equalTo: outerContentView.bottomAnchor, constant: -12.0),
			
		])
		
		cg = outerScrollView.contentLayoutGuide
		fg = outerScrollView.frameLayoutGuide
		
		// we want outerContentView to be the same Height as outerScrollView
		//	but less-than-required Priority so it can grow based on its subviews
		let hc: NSLayoutConstraint = outerContentView.heightAnchor.constraint(equalTo: fg.heightAnchor, constant: 0.0)
		hc.priority = .required - 1
		
		NSLayoutConstraint.activate([
			
			// constrain all 4 sides of outerContentView to outerScrollView.contentLayoutGuide
			outerContentView.topAnchor.constraint(equalTo: cg.topAnchor, constant: 0.0),
			outerContentView.leadingAnchor.constraint(equalTo: cg.leadingAnchor, constant: 0.0),
			outerContentView.trailingAnchor.constraint(equalTo: cg.trailingAnchor, constant: 0.0),
			outerContentView.bottomAnchor.constraint(equalTo: cg.bottomAnchor, constant: 0.0),
			
			// outerContentView Width to outerScrollView.frameLayoutGuide Width
			//	so we will never get horizontal scrolling
			outerContentView.widthAnchor.constraint(equalTo: fg.widthAnchor, constant: 0.0),
			hc,
			
			// constrain all 4 sides of outerScrollView to (self) view
			outerScrollView.topAnchor.constraint(equalTo: g.topAnchor, constant: 0.0),
			outerScrollView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 0.0),
			outerScrollView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: 0.0),
			outerScrollView.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: 0.0),
			
		])
		
		// add page view VCs for each data item
		//	we could do this with a "SamplePageView" UIView subclass
		//	but this shows how to use UIViewController if that's how the "pages" are setup
		
		for (idx, d) in pageData.enumerated() {
			
			let vc = SamplePageVC()
			
			addChild(vc)
			
			// add its view to pageStackView
			pageStackView.addArrangedSubview(vc.view)
			
			vc.didMove(toParent: self)
			
			vc.titleLabel.text = d.title
			vc.descLabel.text = d.desc
			
			if !d.imgName.isEmpty, let img = UIImage(named: d.imgName) {
				vc.imgView.image = img
			} else if let img = UIImage(systemName: "\(idx).circle.fill") {
				vc.imgView.image = img
				vc.imgView.tintColor = .orange
			}
			
			// each page view Width is equal to pageScrollView.frameLayoutGuide width
			vc.view.widthAnchor.constraint(equalTo: pageScrollView.frameLayoutGuide.widthAnchor, constant: 0.0).isActive = true
			
		}
		
		// we *probably* do not want to see scroll indicators
		outerScrollView.showsHorizontalScrollIndicator = false
		outerScrollView.showsVerticalScrollIndicator = false
		pageScrollView.showsHorizontalScrollIndicator = false
		pageScrollView.showsVerticalScrollIndicator = false
		
		// enable paging for the "pages"
		pageScrollView.isPagingEnabled = true
		
		// we will implement scrollViewDidScroll() so we can update the page control
		//	when the user drags the pages left/right
		pageScrollView.delegate = self
		
		pgCtrl.numberOfPages = pageData.count
		pgCtrl.addTarget(self, action: #selector(changePage(_:)), for: .valueChanged)
		
	}
	
	@objc func changePage(_ sender: UIPageControl) {
		let x: CGFloat = pageScrollView.frame.width * CGFloat(sender.currentPage)
		UIView.animate(withDuration: 0.3, animations: {
			self.pageScrollView.contentOffset.x = x
		})
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView == pageScrollView {
			let pg: Int = Int(floor((scrollView.contentOffset.x + scrollView.frame.width * 0.5) / scrollView.frame.width))
			pgCtrl.currentPage = pg
		}
	}
	
}

// MARK: subclass of OnboardingVC
//	for use during development
//	colorizes and outlines view elements
//	centers a "simulated" device frame so we can see "outside the frame"

class DevOnboardingVC: OnboardingVC {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let g = view.safeAreaLayoutGuide
		
		// we need to re-build the outerScrollView constraints
		outerScrollView.removeFromSuperview()
		view.addSubview(outerScrollView)
		
		// we'll make the "device frame"
		//	90% of the view height, or
		//	640-points, whichever is smaller
		let targetHeightC: NSLayoutConstraint = outerScrollView.heightAnchor.constraint(equalTo: g.heightAnchor, multiplier: 0.9)
		targetHeightC.priority = .required - 1
		let maxHeightC: NSLayoutConstraint = outerScrollView.heightAnchor.constraint(lessThanOrEqualToConstant: 640.0)
		
		NSLayoutConstraint.activate([
			
			outerScrollView.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			outerScrollView.centerYAnchor.constraint(equalTo: g.centerYAnchor),
			
			outerScrollView.widthAnchor.constraint(equalToConstant: 300.0),
			maxHeightC, targetHeightC,
			
		])
		
		view.backgroundColor = UIColor(white: 0.90, alpha: 1.0)
		
		outerContentView.backgroundColor = .init(red: 1.0, green: 0.25, blue: 0.2, alpha: 1.0)
		
		outerScrollView.clipsToBounds = false
		pageScrollView.clipsToBounds = false
		
		pageStackView.arrangedSubviews.forEach { v in
			v.backgroundColor = .white.withAlphaComponent(0.5)
			v.backgroundColor = .init(red: 1.0, green: 0.25, blue: 0.2, alpha: 1.0).withAlphaComponent(0.5)
			v.layer.borderColor = UIColor.systemBlue.cgColor
			v.layer.borderWidth = 2
		}
		self.children.forEach { vc in
			if let vc = vc as? SamplePageVC {
				vc.titleLabel.backgroundColor = .systemGreen
				vc.descLabel.backgroundColor = .systemGreen
			}
		}
		
		let dashV1 = DashedBorderView()
		dashV1.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(dashV1)
		
		let dashV2 = DashedBorderView()
		dashV2.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(dashV2)
		
		let dashV3 = DashedBorderView()
		dashV3.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(dashV3)
		
		NSLayoutConstraint.activate([
			dashV1.topAnchor.constraint(equalTo: outerScrollView.topAnchor, constant: 0.0),
			dashV1.leadingAnchor.constraint(equalTo: outerScrollView.leadingAnchor, constant: 0.0),
			dashV1.trailingAnchor.constraint(equalTo: outerScrollView.trailingAnchor, constant: 0.0),
			dashV1.bottomAnchor.constraint(equalTo: outerScrollView.bottomAnchor, constant: 0.0),
			
			dashV2.topAnchor.constraint(equalTo: outerScrollView.topAnchor, constant: 0.0),
			dashV2.leadingAnchor.constraint(equalTo: outerScrollView.leadingAnchor, constant: 0.0),
			dashV2.trailingAnchor.constraint(equalTo: outerScrollView.trailingAnchor, constant: 0.0),
			dashV2.bottomAnchor.constraint(equalTo: outerScrollView.bottomAnchor, constant: 0.0),
			
			dashV3.topAnchor.constraint(equalTo: pageScrollView.topAnchor, constant: 0.0),
			dashV3.leadingAnchor.constraint(equalTo: pageScrollView.leadingAnchor, constant: 0.0),
			dashV3.trailingAnchor.constraint(equalTo: pageScrollView.trailingAnchor, constant: 0.0),
			dashV3.bottomAnchor.constraint(equalTo: pageScrollView.bottomAnchor, constant: 0.0),
		])
		
		dashV1.color = .black
		dashV1.lineWidth = 16
		dashV1.position = .outside
		dashV1.dashPattern = []
		
		dashV2.color = .systemYellow
		dashV2.lineWidth = 3
		dashV2.dashPattern = [60, 8]
		
		dashV3.color = .white
		dashV3.lineWidth = 2
		
	}
	
}

