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
    
    func configure(with image: UIImage) {
        /// 셀에 이미지를 적용합니다.
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.imageView.image = image
        }
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}
