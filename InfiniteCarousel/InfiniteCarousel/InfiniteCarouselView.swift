//
//  InfiniteCarousel.swift
//  InfiniteCarousel
//
//  Created by Twave on 2022/07/06.
//

import UIKit

protocol InfiniteCarouselViewDelegate: AnyObject {
    func dataChanged(data: [UIImage])
}

class InfiniteCarouselView: UIView {
    
    // MARK: Views
    private lazy var carouselView: UICollectionView = {
        let carouselLayout = CarouselLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: carouselLayout)
        dataSource = InfiniteCarouselDataSource(withData: images)
        collectionView.register(InfiniteCarouselCell.self, forCellWithReuseIdentifier: InfiniteCarouselCell.cellIdentifier)
        collectionView.dataSource = dataSource
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: Properties
    private var images: [UIImage] = [] {
        didSet {
            dataSource?.dataChanged(data: images)
        }
    }
    private var dataSource: InfiniteCarouselDataSource?
//    private var delegate = InfiniteCarouselDelegateFlowLayout()
    
    // MARK: Initialize
    init(frame: CGRect, images: [UIImage] = []) {
        /// images: 각 카드에 들어갈 이미지 배열 입니다.
        super.init(frame: frame)
        self.backgroundColor = .white
        self.images = images
        setUpLayout()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    private func setUpLayout() {
        self.addSubview(carouselView)
        NSLayoutConstraint.activate([
            carouselView.topAnchor.constraint(equalTo: topAnchor),
            carouselView.leadingAnchor.constraint(equalTo: leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: trailingAnchor),
            carouselView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
}
