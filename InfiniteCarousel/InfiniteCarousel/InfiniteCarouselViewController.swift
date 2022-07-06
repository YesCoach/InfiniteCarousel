//
//  InfiniteCarouselViewController.swift
//  InfiniteCarousel
//
//  Created by Twave on 2022/07/06.
//

import UIKit

class InfiniteCarouselViewController: UIViewController {
    // MARK: Views
    private lazy var carouselView: InfiniteCarouselView = {
        let view = InfiniteCarouselView(frame: .zero, images: datas)
        return view
    }()

    // MARK: Properties
    private var datas: [UIImage] = (1...5).map{UIImage(named: "\($0).png")!}
    
    // MARK: Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpLayout()
    }

    // MARK: Methods
    private func setUpLayout() {
        view.backgroundColor = .white
        view.addSubview(carouselView)
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            carouselView.topAnchor.constraint(equalTo: view.topAnchor),
            carouselView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
    }
}

