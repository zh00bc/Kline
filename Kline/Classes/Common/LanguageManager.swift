import Foundation

class LanguageManager {
    public static let shared = LanguageManager()

    private static let userDefaultsKey = "current_language"
    public static let fallbackLanguage = "en"

    public var currentLanguage: String {
        (UserDefaults.standard.value(forKey: LanguageManager.userDefaultsKey) as? String) ?? LanguageManager.fallbackLanguage
    }

    init() {
        
    }

    private static var storedCurrentLanguage: String? {
        UserDefaults.standard.value(forKey: userDefaultsKey) as? String
    }

    private static var preferredLanguage: String? {
        return "en"
    }

}

extension LanguageManager {

    public var currentLocale: Locale {
        Locale(identifier: currentLanguage)
    }
}

extension LanguageManager {
    
    public func localize(string: String) -> String {
        let mainBundle = Bundle.main
        
        if let languageBundleUrl = mainBundle.url(forResource: currentLanguage, withExtension: "lproj"), let languageBundle = Bundle(url: languageBundleUrl) {
            return languageBundle.localizedString(forKey: string, value: nil, table: nil)
        }
        return string
    }
    
    public func localize(string: String, bundle: Bundle?) -> String {
        
        if let languageBundleUrl = bundle?.url(forResource: currentLanguage, withExtension: "lproj"), let languageBundle = Bundle(url: languageBundleUrl) {
            return languageBundle.localizedString(forKey: string, value: nil, table: nil)
        }

        return string
    }

    public func localize(string: String, bundle: Bundle?, arguments: [CVarArg]) -> String {
        String(format: localize(string: string, bundle: bundle), locale: currentLocale, arguments: arguments)
    }

}
