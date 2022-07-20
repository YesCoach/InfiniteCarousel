//
//  ContactCouponListThumnailView.swift
//  InfiniteCarousel
//
//  Created by Twave on 2022/07/18.
//

import UIKit

class ThumbnailView: UIView {
    
    // MARK: - Views
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(red: 139/255, green: 148/255, blue: 161/255, alpha: 1)
        return label
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setUpUI()
    }
    
    // MARK: - Methods
    func configure(with string: String) {
        setUpUI()
        guard let initial = string.first else { return }
        label.text = String(initial)
    }
    
    private func setUpLayout() {
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setUpUI() {
        backgroundColor = UIColor(red: 242/255, green: 243/255, blue: 245/255, alpha: 1)
        layer.masksToBounds = true
        layer.cornerRadius = self.frame.height/2
    }
}
