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
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        return carouselView
    }()
    
    private lazy var sheetBanner: SheetBanner = {
        let sheetBannerView = SheetBanner(frame: .zero)
        sheetBannerView.translatesAutoresizingMaskIntoConstraints = false
        sheetBannerView.configureCellSize(width: 400, height: 200)
        sheetBannerView.configureSpacing(with: 0)
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
            banner.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            sheetBanner.topAnchor.constraint(equalTo: banner.bottomAnchor, constant: 128),
            sheetBanner.leadingAnchor.constraint(equalTo: banner.leadingAnchor),
            sheetBanner.trailingAnchor.constraint(equalTo: banner.trailingAnchor),
            sheetBanner.heightAnchor.constraint(equalTo: banner.heightAnchor)
        ])
    }
}
