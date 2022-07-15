//
//  Main.swift
//  InfiniteCarousel
//
//  Created by Twave on 2022/07/08.
//

import UIKit

class Main: UIViewController {
    private lazy var banner: Banner = {
        let carouselView = Banner(frame: .zero)
        carouselView.configureTimeInterval(with: 3)
        carouselView.configureSpacing(with: 40)
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        return carouselView
    }()
    
    private lazy var sheetBanner: SheetBanner = {
        let sheetBannerView = SheetBanner(frame: .zero)
        sheetBannerView.configureSpacing(with: 0)
        sheetBannerView.configureTimeInterval(with: 3)
        sheetBannerView.translatesAutoresizingMaskIntoConstraints = false
        return sheetBannerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        banner.show(images: (1...5).map{UIImage(named: "\($0).png")!}) { index in
            print(index)
        }
        sheetBanner.show(images: (1...5).map{UIImage(named: "\($0).png")!}) { index in
            print(index)
        }
    }
    
    private func setUpLayout() {
        view.backgroundColor = .white
        view.addSubview(banner)
        view.addSubview(sheetBanner)

        NSLayoutConstraint.activate([
            banner.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            banner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            banner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            banner.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            sheetBanner.leadingAnchor.constraint(equalTo: banner.leadingAnchor),
            sheetBanner.trailingAnchor.constraint(equalTo: banner.trailingAnchor),
            sheetBanner.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            sheetBanner.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
