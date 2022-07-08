//
//  Main.swift
//  InfiniteCarousel
//
//  Created by Twave on 2022/07/08.
//

import UIKit

class Main: UIViewController {
    private lazy var banner: InfiniteCarouselView = {
        let carouselView = InfiniteCarouselView(frame: .zero)
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        return carouselView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
    }
    
    private func setUpLayout() {
        view.backgroundColor = .white
        view.addSubview(banner)
        NSLayoutConstraint.activate([
            banner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            banner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            banner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            banner.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
    }
}
