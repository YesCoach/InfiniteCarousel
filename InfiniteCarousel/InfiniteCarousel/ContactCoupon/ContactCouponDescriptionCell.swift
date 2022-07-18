//
//  ContactCouponDescriptionCell.swift
//  InfiniteCarousel
//
//  Created by Twave on 2022/07/18.
//

import UIKit

class ContactCouponDescriptionCell: UITableViewCell {
    static let identifier = "ContactCouponDescriptionCell"
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var todayCouponLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(red: 139/255, green: 148/255, blue: 161/255, alpha: 1)
        label.text = "오늘 받은 점핑 쿠폰"
        return label
    }()
    
    private lazy var todayCouponCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(red: 139/255, green: 148/255, blue: 161/255, alpha: 1)
        return label
    }()
    
    private lazy var totalCouponLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(red: 139/255, green: 148/255, blue: 161/255, alpha: 1)
        label.text = "지금까지 받은 점핑 쿠폰"
        return label
    }()
    
    private lazy var totalCouponCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(red: 139/255, green: 148/255, blue: 161/255, alpha: 1)
        return label
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    // MARK: - Properties
    
    private var remainCouponCount: Int = 0 {
        willSet {
            descriptionLabel.text = """
\(newValue)명 에게 더 보내면,
점핑 쿠폰을 \(newValue)장 더 받을 수 있어요!
"""
        }
    }

    private var todayCouponCount: Int = 0 {
        willSet {
            todayCouponCountLabel.text = "\(newValue)장"
        }
    }

    private var totalCouponCount: Int = 0 {
        willSet {
            totalCouponCountLabel.text = "\(newValue)장"
        }
    }
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// remainCount: 금일 쿠폰을 보낼 수 있는 인원 수
    func configure(remainCount: Int, todayCount: Int, totalCount: Int) {
        self.remainCouponCount = remainCount
        self.todayCouponCount = todayCount
        self.totalCouponCount = totalCount
    }
    
    private func setUpLayout() {
        [descriptionLabel, todayCouponLabel, todayCouponCountLabel, separator, totalCouponLabel, totalCouponCountLabel].forEach {
            contentView.addSubview($0)
        }
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: todayCouponLabel.topAnchor, constant: -32),
            todayCouponLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            todayCouponLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            todayCouponCountLabel.topAnchor.constraint(equalTo: todayCouponLabel.topAnchor),
            todayCouponCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separator.topAnchor.constraint(equalTo: todayCouponLabel.bottomAnchor, constant: 8),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            totalCouponLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 8),
            totalCouponLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            totalCouponCountLabel.topAnchor.constraint(equalTo: totalCouponLabel.topAnchor),
            totalCouponCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func setUpUI() {
        contentView.backgroundColor = .white
    }
}
