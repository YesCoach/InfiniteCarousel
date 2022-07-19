//
//  ContactListCell.swift
//  InfiniteCarousel
//
//  Created by Twave on 2022/07/18.
//

import UIKit
import Contacts
import MessageUI

protocol ContactCouponListCellDelegate: AnyObject {
    func jumpingCouponReceived(contact: CNContact)
    func isAlreadySend(contact: CNContact) -> Bool
}

class ContactCouponListCell: UITableViewCell {
    static let identifier = "ContactCouponListCell"

    // MARK: - Views

    private lazy var thumbnailView: ThumbnailView = {
        let thumbnailView = ThumbnailView()
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        return thumbnailView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitle("보내기", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.backgroundColor = UIColor(red: 242/255, green: 243/255, blue: 245/255, alpha: 1)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sendButtonClicked(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    private var contact: CNContact? {
        willSet {
            guard let newValue = newValue, let delegate = delegate else { return }
            if newValue.familyName != "" {
                thumbnailView.configure(with: newValue.familyName)
            } else {
                thumbnailView.configure(with: newValue.givenName)
            }
            nameLabel.text = newValue.familyName + newValue.givenName
            phoneNumberLabel.text = newValue.phoneNumbers[0].value.stringValue
            if delegate.isAlreadySend(contact: newValue) {
                sendButton.isHidden = true
            }
        }
    }
    
    private var completion: ((MFMessageComposeViewController) -> Void)?
    weak var delegate: ContactCouponListCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 12.0, left: 16, bottom: 12, right: 16))
    }

    func configure(with contact: CNContact, completion: @escaping (MFMessageComposeViewController) -> Void) {
        self.contact = contact
        self.completion = completion
    }
    
    @objc private func sendButtonClicked(_ sender: UIButton) {
        debugPrint(#function)
        guard let phoneNumber = contact?.phoneNumbers[0].value.stringValue else { return }
        let messageComposer = MFMessageComposeViewController()
        messageComposer.messageComposeDelegate = self
        if MFMessageComposeViewController.canSendText(){
            messageComposer.recipients = [phoneNumber]
            messageComposer.body = "text message"
            completion?(messageComposer)
        }
    }
    
    private func setUpLayout() {
        [thumbnailView, nameLabel, phoneNumberLabel, sendButton].forEach { contentView.addSubview($0)}
        NSLayoutConstraint.activate([
            thumbnailView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thumbnailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailView.widthAnchor.constraint(equalTo: thumbnailView.heightAnchor),
            thumbnailView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 12),
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.45),
            nameLabel.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor),
            phoneNumberLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            phoneNumberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            phoneNumberLabel.heightAnchor.constraint(equalTo: nameLabel.heightAnchor),
            phoneNumberLabel.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor),
            sendButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            sendButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            sendButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.18),
        ])
    }
    
    private func setUpUI() {
        contentView.backgroundColor = .white
        backgroundColor = .white
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        phoneNumberLabel.text = nil
        sendButton.isHidden = false
    }
}

extension ContactCouponListCell: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case MessageComposeResult.sent:
            print("전송 완료")
            guard let contact = contact else { return }
            delegate?.jumpingCouponReceived(contact: contact)
            break
        case MessageComposeResult.cancelled:
            print("취소")
            break
        case MessageComposeResult.failed:
            print("전송 실패")
            break
        @unknown default:
            fatalError()
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
