//
//  ContactCouponRefreshCell.swift
//  InfiniteCarousel
//
//  Created by Twave on 2022/07/18.
//

import UIKit

class ContactCouponRefreshCell: UITableViewCell {
    static let identifier = "ContactCouponRefreshCell"
    
    // MARK: - Views
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(red: 139/255, green: 148/255, blue: 161/255, alpha: 1)
        label.text = "목록 새로고침 : " + getCurrentDate()
        return label
    }()
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("새로고침", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(UIColor(red: 139/255, green: 148/255, blue: 161/255, alpha: 1), for: .normal)
        button.backgroundColor = UIColor(red: 242/255, green: 243/255, blue: 245/255, alpha: 1)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(refreshList(_:)), for: .touchUpInside)
        return button
    }()
    
    var completion: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(completion: @escaping () -> Void) {
        self.completion = completion
    }
    
    private func setUpLayout() {
        [descriptionLabel, refreshButton].forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            descriptionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            refreshButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            refreshButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            refreshButton.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func setUpUI() {
        backgroundColor = .white
        selectionStyle = .none
    }
    
    private func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일 a h:m"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    @objc private func refreshList(_ sender: UIButton) {
        completion
        descriptionLabel.text = "목록 새로고침 : " + getCurrentDate()
    }
}
