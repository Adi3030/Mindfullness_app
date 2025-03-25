//
//  GradientView.swift
//  Mindfullness
//
//  Created by aditya sharma on 24/03/25.
//

import UIKit

struct Color {
    static let appForgroundColor  =  UIColor(red: 82/255.0, green: 63/255.0, blue: 56/255.0, alpha: 1.0)
    static let customColorWhitish = UIColor(red: 241/255.0, green: 234/255.0, blue: 245/255.0, alpha: 1.0)
    static let customColorOrange  =  UIColor(red: 252/255.0, green: 231/255.0, blue: 221/255.0, alpha: 1.0)

}
class Singleton {
    static let shared = Singleton() // Singleton instance
    private init() {} // Private initializer to prevent multiple instances
    
//      MARK: Collections for Sign up screen
    let languageCategories = ["English", "हिंदी |Hindi", "తెలుగు | Telugu", "ਪੰਜਾਬੀ | Punjabi"]
    let lanaguageIcon = ["english_ic", "hindi_ic", "other_ic", "other_ic"]
    
    //      MARK: Collections for Guest screen
    
    let firstLabel_Arr = [LanguageManager.shared.localizedString(forKey: "Relax & Meditation"), LanguageManager.shared.localizedString(forKey: "Rejuvenate"), LanguageManager.shared.localizedString(forKey: "Connect")]
    let secondLabel_Arr = [LanguageManager.shared.localizedString(forKey: "label_2_data_1"), LanguageManager.shared.localizedString(forKey: "label_2_data_2"), LanguageManager.shared.localizedString(forKey: "label_2_data_3")]
    let profileImg_Arr  = ["Mindfulness", "Meditation", "Breathing"]
   
}
