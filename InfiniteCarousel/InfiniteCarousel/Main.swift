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
        banner.configureSpacing(with: 30)
        banner.configureBannerSize(with: .medium)
        banner.translatesAutoresizingMaskIntoConstraints = false
        return banner
    }()
    
    private lazy var banner2: Banner = {
        let banner2 = Banner(frame: .zero)
        banner2.configureTimeInterval(with: 4)
        banner2.configureSpacing(with: 30)
        banner2.configureBannerSize(with: .small)
        banner2.translatesAutoresizingMaskIntoConstraints = false
        return banner2
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("button", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(presentContactCouponViewController(_:)), for: .touchUpInside)
        return button
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
        sheetBanner.show(images: (1...5).map{UIImage(named: "\($0).png")!}) { index in
            print(index)
        }
    }
    
    private func setUpLayout() {
        view.backgroundColor = .white
        view.addSubview(banner)
        view.addSubview(banner2)
        view.addSubview(button)
        view.addSubview(sheetBanner)

        NSLayoutConstraint.activate([
            banner.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            banner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            banner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            banner.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.55),
            banner2.topAnchor.constraint(equalTo: banner.bottomAnchor, constant: 8),
            banner2.leadingAnchor.constraint(equalTo: banner.leadingAnchor),
            banner2.trailingAnchor.constraint(equalTo: banner.trailingAnchor),
            banner2.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            button.topAnchor.constraint(equalTo: banner2.bottomAnchor, constant: 16),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 64),
            sheetBanner.leadingAnchor.constraint(equalTo: banner.leadingAnchor),
            sheetBanner.trailingAnchor.constraint(equalTo: banner.trailingAnchor),
            sheetBanner.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            sheetBanner.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func presentContactCouponViewController(_ sender: UIButton) {
        self.navigationController?.pushViewController(ContactCouponViewController(), animated: true)
    }
}
