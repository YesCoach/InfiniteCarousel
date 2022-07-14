//
//  InfiniteCarouselCell.swift
//  InfiniteCarousel
//
//  Created by Twave on 2022/07/06.
//

import UIKit

class BannerCell: UICollectionViewCell {

    // MARK: - Views
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = cellRadius
        return imageView
    }()
    
    // MARK: - Properties
    static let cellIdentifier = "BannerCell"
    
    /// 애니메이션 관련 프로퍼티
    /// targetScale: 크기 늘어나는 비율
    /// targetDuration: 지속 시간
    private let targetScale = 1.1
    private let targetDuration = 0.3
    private let cellRadius = 25.0
    private var animation: UIViewPropertyAnimator?
    
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
    
    /// 셀에 크기가 커지는 애니메이션 효과를 적용합니다.
    func animationToExpand(_ completion: (()->Void)? = nil) {
        animation = UIViewPropertyAnimator(duration: targetDuration, curve: .easeInOut) {
            self.transform = CGAffineTransform(scaleX: self.targetScale, y: self.targetScale)
        }
        animation?.startAnimation()
    }
    
    /// 셀에 적용된 애니메이션 효과를 제거합니다.
    func animationToShrink() {
        animation = UIViewPropertyAnimator(duration: targetDuration, curve: .easeOut) {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        animation?.startAnimation()
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

    override func prepareForReuse() {
        imageView.image = nil
        animation = nil
    }
}
