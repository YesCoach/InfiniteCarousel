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
        return contactCouponView
    }()
    
    override func viewDidLoad() {
        setUpLayout()
    }
    
    private func setUpLayout() {
        view.addSubview(contactCouponView)
        NSLayoutConstraint.activate([
            contactCouponView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contactCouponView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contactCouponView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contactCouponView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ContactCouponViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension ContactCouponViewController: UITableViewDelegate {
    
}
