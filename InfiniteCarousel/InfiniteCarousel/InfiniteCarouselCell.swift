//
//  InfiniteCarouselCell.swift
//  InfiniteCarousel
//
//  Created by Twave on 2022/07/06.
//

import UIKit

class InfiniteCarouselCell: UICollectionViewCell {
    
    static let cellIdentifier = "InfiniteCarouselCellIdentifier"
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods

    private func setUpLayout() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    /// 셀에 이미지를 적용합니다.
    func configure(with image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.imageView.image = image
        }
    }
    
    /// 셀에 크기가 커지는 애니메이션 효과를 적용합니다.
    func animation(_ completion: (()->Void)? = nil) {
        let expandAnimation = CABasicAnimation(keyPath: "transform.scale")
        expandAnimation.fromValue = 1.0
        expandAnimation.toValue = 1.05
        expandAnimation.duration = 0.1
        expandAnimation.fillMode = .forwards
        expandAnimation.isRemovedOnCompletion = false
        layer.add(expandAnimation, forKey: expandAnimation.keyPath)
    }
    
    /// 셀에 적용된 애니메이션 효과를 제거합니다.
    func removeAnimation() {
        layer.removeAllAnimations()
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        removeAnimation()
    }
}
