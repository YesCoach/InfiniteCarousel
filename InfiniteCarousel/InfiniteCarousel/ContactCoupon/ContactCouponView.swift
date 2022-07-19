//
//  ContactCouponView.swift
//  InfiniteCarousel
//
//  Created by Twave on 2022/07/18.
//

import UIKit

class ContactCouponView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .grouped)
        setUpTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpTableView() {
        backgroundColor = .white
        separatorStyle = .none
        register(ContactCouponDescriptionCell.self, forCellReuseIdentifier: ContactCouponDescriptionCell.identifier)
        register(ContactCouponRefreshCell.self, forCellReuseIdentifier: ContactCouponRefreshCell.identifier)
        register(ContactCouponListCell.self, forCellReuseIdentifier: ContactCouponListCell.identifier)
    }
}
