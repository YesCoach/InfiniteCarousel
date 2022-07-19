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
        contactCouponView.tableHeaderView = searchBar
        return contactCouponView
    }()

    private lazy var searchBar: UISearchBar = {
        let directionalMargins = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.7, height: 50))
        searchBar.delegate = self
        searchBar.directionalLayoutMargins = directionalMargins
        searchBar.placeholder = "이름을 검색해 보세요"
        searchBar.barTintColor = .white
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.borderStyle = .none
        searchBar.searchTextField.layer.cornerRadius = 17
        searchBar.searchTextField.layer.borderColor = UIColor(red: 209/255, green: 213/255, blue: 220/255, alpha: 1).cgColor
        searchBar.searchTextField.layer.borderWidth = 1
        return searchBar
    }()

    private lazy var leftBarButton: UIBarButtonItem = {
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(didTapBackButton(_:)))
        return leftBarButton
    }()

    private var contacts: [CNContact] = []
    private var filteredContacts: [CNContact] = []
    
    override func viewDidLoad() {
        setUpLayout()
        fetchContacts()
        setupNavigationBar()
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
                self.filteredContacts = self.contacts
                DispatchQueue.main.async {
                    print("aaa")
                    self.contactCouponView.reloadData()
                }
            }
            catch {
                print("unable to fetch contacts")
            }
        }
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
    
    private func setupNavigationBar() {
        navigationItem.title = "목돈지원금 쿠폰 보내기"
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationItem.leftBarButtonItem = leftBarButton
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
    }

    @objc private func didTapBackButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

extension ContactCouponViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return filteredContacts.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 where indexPath.row == 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactCouponDescriptionCell.identifier,
                                                           for: indexPath) as? ContactCouponDescriptionCell
            else { fatalError() }
            cell.configure(remainCount: 8, todayCount: 0, totalCount: 0)
            return cell
        case 0 where indexPath.row == 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactCouponRefreshCell.identifier,
                                                           for: indexPath) as? ContactCouponRefreshCell
            else { fatalError() }
            cell.delegate = self
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactCouponListCell.identifier,
                                                           for: indexPath) as? ContactCouponListCell
            else { fatalError() }
            cell.configure(with: filteredContacts[indexPath.row])
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
        case 0 where indexPath.row == 0:
            return UIScreen.main.bounds.height * 0.25
        case 0 where indexPath.row == 1:
            return UIScreen.main.bounds.height * 0.07
        case 1:
            return 60
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

}

extension CNContact {
    func name() -> String {
        return self.familyName + self.givenName
    }
    
    static func < (lhd: CNContact, rhd: CNContact) -> Bool {
        let lhdName = lhd.name()
        let rhdName = rhd.name()
        
        return lhdName < rhdName
    }
}

extension ContactCouponViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredContacts = searchText.isEmpty ? contacts : contacts.filter{($0.familyName+$0.givenName).contains(searchText)}.sorted(by: <)
        DispatchQueue.main.async {
            self.contactCouponView.reloadData()
        }
    }
}

extension ContactCouponViewController: RefreshContactsList {
    func refresh() {
        fetchContacts()
    }
}
