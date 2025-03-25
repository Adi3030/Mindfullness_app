//
//  SelectLanguageTableViewController.swift
//  Mindfullness
//
//  Created by aditya sharma on 25/03/25.
//

import UIKit

class SelectLanguageTVCell: UITableViewCell {
    
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var checkImg: UIImageView!
    @IBOutlet weak var languageLabel: UILabel!
    
    override class func awakeFromNib() {
        
    }
}

class SelectLanguageTableViewController: UITableViewController {
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = UserDefaults.standard.integer(forKey: "SelectedLanguageIndex")
        
        // Load saved language code and get its corresponding index
        let savedLanguageCode = LanguageManager.shared.selectedLanguage
        if let index = Singleton.shared.languageCategories.firstIndex(where: { LanguageManager.shared.getLanguageCode(for: $0) == savedLanguageCode }) {
            selectedIndex = index
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Singleton.shared.languageCategories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectLanguageTVCell", for: indexPath) as! SelectLanguageTVCell
        cell.languageLabel.text = Singleton.shared.languageCategories[indexPath.row]
        cell.checkImg.isHidden = indexPath.row != selectedIndex
        cell.iconImg.image = UIImage(named: Singleton.shared.lanaguageIcon[indexPath.row])
        return cell
    }
  
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLanguageName = Singleton.shared.languageCategories[indexPath.row]
        let selectedLanguageCode = LanguageManager.shared.getLanguageCode(for: selectedLanguageName)

        // Save selected language
        LanguageManager.shared.selectedLanguage = selectedLanguageCode
        UserDefaults.standard.set(selectedIndex, forKey: "SelectedLanguageIndex")
        UserDefaults.standard.synchronize()

        // Reload UI with new language
        NotificationCenter.default.post(name: Notification.Name("LanguageChanged"), object: nil)

        tableView.reloadData()
        self.dismiss(animated: true)
    }


}
