//
//  ContactCouponViewController.swift
//  InfiniteCarousel
//
//  Created by Twave on 2022/07/18.
//

import UIKit

class ContactCouponViewController: UIViewController {
    private lazy var contactCouponView: ContactCouponView = {
        let contactCouponView = ContactCouponView()
        contactCouponView.translatesAutoresizingMaskIntoConstraints = false
        contactCouponView.delegate = self
        contactCouponView.dataSource = self
        return contactCouponView
    }()
    
    override func viewDidLoad() {
        setUpLayout()
    }
    
    private func setUpLayout() {
        view.backgroundColor = .white
        view.addSubview(contactCouponView)
        NSLayoutConstraint.activate([
            contactCouponView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contactCouponView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contactCouponView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            contactCouponView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ContactCouponViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactCouponSearchCell.identifier, for: indexPath) as? ContactCouponSearchCell else { fatalError() }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactCouponDescriptionCell.identifier, for: indexPath) as? ContactCouponDescriptionCell else { fatalError() }
            cell.configure(remainCount: 8, todayCount: 0, totalCount: 0)
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactCouponRefreshCell.identifier, for: indexPath) as? ContactCouponRefreshCell else { fatalError() }
            return cell
        default:
            return UITableViewCell()
        }

    }
}


// self sizing cell 구현하기
extension ContactCouponViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 100
        case 1:
            return 130
        case 2:
            return 100
        default:
            return 100
        }
    }
}
