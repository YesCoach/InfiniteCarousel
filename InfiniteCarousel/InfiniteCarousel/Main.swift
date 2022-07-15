//
//  Main.swift
//  InfiniteCarousel
//
//  Created by Twave on 2022/07/08.
//

import UIKit

class Main: UIViewController {
    private lazy var banner: Banner = {
        let banner = Banner(frame: .zero)
        banner.configureTimeInterval(with: 4)
        banner.configureSpacing(with: 40)
        banner.translatesAutoresizingMaskIntoConstraints = false
        return banner
    }()
    
    private lazy var banner2: Banner = {
        let banner2 = Banner(frame: .zero)
        banner2.configureTimeInterval(with: 4)
        banner2.configureSpacing(with: 40)
        banner2.translatesAutoresizingMaskIntoConstraints = false
        return banner2
    }()
    
    private lazy var sheetBanner: SheetBanner = {
        let sheetBannerView = SheetBanner(frame: .zero)
        sheetBannerView.configureSpacing(with: 0)
        sheetBannerView.configureTimeInterval(with: 4)
        sheetBannerView.translatesAutoresizingMaskIntoConstraints = false
        return sheetBannerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        banner.show(images: (1...5).map{UIImage(named: "\($0).png")!}) { index in
            print(index)
        }
        banner2.show(images: (1...3).map{UIImage(named: "\($0).png")!}) { index in
            print(index)
        }
        let data = ["1.png","2.png","3.png","4.png","5.png","1.png","2.png","3.png","4.png","5.png","1.png","2.png"].map{UIImage(named: $0)!}
        sheetBanner.show(images: (1...5).map{UIImage(named: "\($0).png")!}) { index in
            print(index)
        }
    }
    
    private func setUpLayout() {
        view.backgroundColor = .white
        view.addSubview(banner)
        view.addSubview(banner2)
        view.addSubview(sheetBanner)

        NSLayoutConstraint.activate([
            banner.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            banner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            banner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            banner.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            banner2.topAnchor.constraint(equalTo: banner.bottomAnchor, constant: 36),
            banner2.leadingAnchor.constraint(equalTo: banner.leadingAnchor),
            banner2.trailingAnchor.constraint(equalTo: banner.trailingAnchor),
            banner2.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.13),
            sheetBanner.leadingAnchor.constraint(equalTo: banner.leadingAnchor),
            sheetBanner.trailingAnchor.constraint(equalTo: banner.trailingAnchor),
            sheetBanner.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            sheetBanner.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
