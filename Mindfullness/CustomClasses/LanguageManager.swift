//
//  LanguageManager.swift
//  Mindfullness
//
//  Created by aditya sharma on 25/03/25.
//

import Foundation

import Foundation

class LanguageManager {
    static let shared = LanguageManager()
    
    private let selectedLanguageKey = "SelectedLanguage"

    // Mapping language names to language codes
    private let languageMapping: [String: String] = [
        "English": "en",
        "हिंदी |Hindi": "hi",
        "తెలుగు | Telugu": "te",
        "ਪੰਜਾਬੀ | Punjabi": "pa"
    ]

    var selectedLanguage: String {
        get {
            return UserDefaults.standard.string(forKey: selectedLanguageKey) ?? "en" // Default to English
        }
        set {
            UserDefaults.standard.set(newValue, forKey: selectedLanguageKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    func localizedString(forKey key: String) -> String {
        let languageCode = selectedLanguage
        if let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return NSLocalizedString(key, bundle: bundle, comment: "")
        }
        return key // Return key if translation is missing
    }
    
    func getLanguageCode(for languageName: String) -> String {
        return languageMapping[languageName] ?? "en"
    }

    func getLanguageName(for languageCode: String) -> String {
        return languageMapping.first(where: { $0.value == languageCode })?.key ?? "English"
    }
}
