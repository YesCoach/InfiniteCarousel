//
//  ContactCouponViewController.swift
//  InfiniteCarousel
//
//  Created by Twave on 2022/07/18.
//

import UIKit
import ContactsUI

class ContactCouponViewController: UIViewController {
    private lazy var contactCouponView: ContactCouponView = {
        let contactCouponView = ContactCouponView()
        contactCouponView.translatesAutoresizingMaskIntoConstraints = false
        contactCouponView.delegate = self
        contactCouponView.dataSource = self
        return contactCouponView
    }()
    
    private var contacts: [CNContact] = []
    
    override func viewDidLoad() {
        setUpLayout()
        fetchContacts()
    }
    
    private func setUpLayout() {
        view.backgroundColor = .white
        view.addSubview(contactCouponView)
        NSLayoutConstraint.activate([
            contactCouponView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contactCouponView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contactCouponView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contactCouponView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func fetchContacts() {
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        let store = CNContactStore()
        var contactData = [CNContact]()
        contacts.removeAll()
        DispatchQueue.global().async {
            do {
                try store.enumerateContacts(with: request) {
                    (contact, stop) in
                    // Array containing all unified contacts from everywhere
                    if contact.phoneNumbers.isEmpty || (contact.familyName == "" && contact.givenName == "") {
                        return
                    }
                    contactData.append(contact)
                }
                self.contacts = contactData.sorted(by: <)
                DispatchQueue.main.async {
                    self.contactCouponView.reloadData()
                }
            }
            catch {
                print("unable to fetch contacts")
            }
        }
    }
}

extension ContactCouponViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return contacts.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 where indexPath.row == 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactCouponSearchCell.identifier,
                                                           for: indexPath) as? ContactCouponSearchCell
            else { fatalError() }
            cell.configure { text in
                self.contacts.filter {
                    let name = $0.familyName + $0.givenName
                    return name.contains(text)
                }
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            }
            return cell
        case 0 where indexPath.row == 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactCouponDescriptionCell.identifier,
                                                           for: indexPath) as? ContactCouponDescriptionCell
            else { fatalError() }
            cell.configure(remainCount: 8, todayCount: 0, totalCount: 0)
            return cell
        case 0 where indexPath.row == 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactCouponRefreshCell.identifier,
                                                           for: indexPath) as? ContactCouponRefreshCell
            else { fatalError() }
            cell.configure { [weak self] in
                guard let self = self else { return }
                self.fetchContacts()
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactCouponListCell.identifier,
                                                           for: indexPath) as? ContactCouponListCell
            else { fatalError() }
            cell.configure(with: contacts[indexPath.row])
            return cell
        default:
            fatalError()
        }
    }
}


// self sizing cell 구현하기
extension ContactCouponViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        case 1:
            return 60
        default:
            return 100
        }
    }
}

extension CNContact {
    static func < (first: CNContact, second: CNContact) -> Bool {
        guard first.familyName != "" else {
            if second.familyName != "" {
                return first.givenName < second.familyName
            } else {
                return first.givenName < second.givenName
            }
        }
        if second.familyName != "" {
            return first.familyName < second.familyName
        } else {
            return first.familyName < second.givenName
        }
    }
}
