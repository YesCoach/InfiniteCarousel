//
//  ContactCouponSearchCell.swift
//  InfiniteCarousel
//
//  Created by Twave on 2022/07/18.
//

import UIKit

class ContactCouponSearchCell: UITableViewCell {
    static let identifier = "ContactCouponSearchCell"
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "이름을 검색해 보세요"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = .white
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.borderStyle = .none
        searchBar.searchTextField.layer.cornerRadius = 10
        searchBar.searchTextField.layer.borderColor = UIColor.separator.cgColor
        searchBar.searchTextField.layer.borderWidth = 1
        return searchBar
    }()

    private var completion: ((String) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(completion: @escaping (String) -> Void) {
        self.completion = completion
    }
    
    private func setUpLayout() {
        contentView.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }
    
    private func setUpUI() {
        backgroundColor = .white
        selectionStyle = .none
    }
}

extension ContactCouponSearchCell: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        completion?(searchText)
    }
}
