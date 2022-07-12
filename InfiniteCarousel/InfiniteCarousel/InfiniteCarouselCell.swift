//
//  InfiniteCarouselCell.swift
//  InfiniteCarousel
//
//  Created by Twave on 2022/07/06.
//

import UIKit
import InfiniteLayout

class InfiniteCarouselCell: UICollectionViewCell {

    // MARK: - Views
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: contentView.bounds)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    // MARK: - Properties
    static let cellIdentifier = "InfiniteCarouselCellIdentifier"
    private var scaleMinimum: CGFloat = 1.0
    private var scaleDivisor: CGFloat = 10.0
    private var alphaMinimum: CGFloat = 0.85
    private var cornerRadius: CGFloat = 20.0
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    /// 셀에 이미지를 적용합니다.
    func configure(with image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.imageView.image = image
        }
    }
    
    private func setUpLayout() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let _ = superview as? InfiniteCollectionView else { return }
        scale()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.transform = CGAffineTransform.identity
        imageView.alpha = 1.0
    }
    
    func scale() {
        guard let superview = superview else { return }
        let bounds = superview.convert(frame, to: superview.superview)
//        let screenCenterX = UIScreen.main.bounds.midX
//        var centerX = bounds.origin.x + bounds.width / 2

//        print(bounds)
        // 셀의 중앙 좌표
        var originX = bounds.origin.x
//        print(originX)
        // 셀의 너비
        var contentWidthOrHeight = frame.size.width
        
        // 수직으로 스크롤 시 필요한 로직
        if let collectionView = superview as? InfiniteCollectionView,
           collectionView.infiniteLayout.scrollDirection == .vertical {
            originX = superview.convert(frame, to: superview.superview).origin.y
            contentWidthOrHeight = frame.size.height
        }
        
        // Calculate our scale values
        let scaleCalculator = abs(contentWidthOrHeight - abs(originX))
        let percentageScale = (scaleCalculator/contentWidthOrHeight)
        
        let scaleValue = scaleMinimum
            + (percentageScale/scaleDivisor)
        
        let alphaValue = alphaMinimum
            + (percentageScale/scaleDivisor)
        
        let affineIdentity = CGAffineTransform.identity
        
//        [originX, contentWidthOrHeight].forEach {
//            print($0)
//        }
        
        // Scale our mainView and set it's alpha value
        imageView.transform = affineIdentity.scaledBy(x: scaleValue, y: scaleValue)
        imageView.alpha = alphaValue
        
        // ..also..round the corners
        imageView.layer.cornerRadius = cornerRadius
    }
}
