//
//  GuestViewController.swift
//  Mindfullness
//
//  Created by aditya sharma on 25/03/25.
//

import UIKit
class GuestViewControllerCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.layer.cornerRadius = 20
            profileImageView.layer.masksToBounds = true
            profileImageView.layer.borderWidth = 2
             
        }
    }
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 20
            containerView.layer.masksToBounds = true
            containerView.layer.backgroundColor = UIColor.white.cgColor
        }
    }
    override class func awakeFromNib() {
        
    }
}

class GuestViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
            profileImageView.layer.masksToBounds = true
            profileImageView.layer.borderWidth = 2
            profileImageView.layer.borderColor = UIColor.blue.cgColor
        }
    }
    @IBOutlet weak var greetingsLabel: UILabel!
    @IBOutlet weak var languageImageView: UIImageView!
    @IBOutlet weak var signUpLabel: UILabel!
    
    @IBOutlet weak var learn_toLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        updateLanguageText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguageText), name: Notification.Name("LanguageChanged"), object: nil)

    }
    @objc func updateLanguageText() {
        greetingsLabel.text = LanguageManager.shared.localizedString(forKey: "greetings")
        learn_toLabel.text = LanguageManager.shared.localizedString(forKey: "learn_to_meditate")
    }
    func setUpUI() {
        self.navigationController?.isNavigationBarHidden = true
        applyGradientBackground()
        addGradientBorder(to: profileImageView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        makeElementsTouchable()
    }
    func makeElementsTouchable() {
        // Enable user interaction for stack views
        languageImageView.isUserInteractionEnabled = true
        profileImageView.isUserInteractionEnabled = true
        signUpLabel.isUserInteractionEnabled = true
        
        
        // Add tap gesture recognizers
        let languageTapped = UITapGestureRecognizer(target: self, action: #selector(tappedOnLanguage))
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(tappedOnLanguage))
        let signUpLabelTapped = UITapGestureRecognizer(target: self, action: #selector(signUpLabelTapped))
        
        languageImageView.addGestureRecognizer(languageTapped)
        profileImageView.addGestureRecognizer(profileTap)
        signUpLabel.addGestureRecognizer(signUpLabelTapped)
    }
    
    @objc func tappedOnLanguage() {
        let halfScreenVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectLanguageTableViewController")
        // Set modal presentation style
        halfScreenVC.modalPresentationStyle = .pageSheet
        if let sheet = halfScreenVC.sheetPresentationController {
            sheet.detents = [.medium()] // Presents half-screen
            sheet.prefersGrabberVisible = true // Optional: Add grabber at the top
        }
        self.present(halfScreenVC, animated: true, completion: nil)
    }
    
    @objc func signUpLabelTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
extension GuestViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GuestViewControllerCell", for: indexPath) as! GuestViewControllerCell
        cell.contentView.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.firstLabel.text = Singleton.shared.firstLabel_Arr[indexPath.row]
        cell.secondLabel.text = Singleton.shared.secondLabel_Arr[indexPath.row]
        self.addGradientBorder(to: cell.profileImageView)

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }

}
