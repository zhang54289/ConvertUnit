//
//  ColorSettingView.swift
//  UnitConverter
//
//  Created by zhanghuan on 3/2/24.
//

import SwiftUI
import Foundation

extension String {
    var local: String {
        if let preferredLanguage = Locale.preferredLanguages.first {
            let components = preferredLanguage.components(separatedBy: "-")
            let primaryLanguage = components.first ?? preferredLanguage
            if primaryLanguage == "en" {
                return self
            }
        }
        
        return NSLocalizedString(self, comment: "")
    }
}

extension UserDefaults {
  func colorForKey(key: String) -> UIColor? {
    var colorReturnded: UIColor?
    if let colorData = data(forKey: key) {
      do {
        if let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
          colorReturnded = color
        }
      } catch {
        print("Error UserDefaults")
      }
    }
    return colorReturnded
  }
  
  func setColor(color: UIColor?, forKey key: String) {
    var colorData: NSData?
    if let color = color {
      do {
        let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData?
        colorData = data
      } catch {
        print("Error UserDefaults")
      }
    }
    set(colorData, forKey: key)
  }
}

class ColorSettings: ObservableObject {
    static let shared = ColorSettings()
    
    @Published var focusColor: Color {
        didSet {
            UserDefaults.standard.setColor(color: UIColor(focusColor), forKey: "FocusColor")
        }
    }
    
    @Published var unitPadColor: Color {
        didSet {
            UserDefaults.standard.setColor(color: UIColor(unitPadColor), forKey: "UnitPadColor")
        }
    }
    
    @Published var menuBackgroudColor: Color {
        didSet {
            UserDefaults.standard.setColor(color: UIColor(menuBackgroudColor), forKey: "MenuBackgroundColor")
        }
    }

    @Published var toastBackgroudColor: Color {
        didSet {
            UserDefaults.standard.setColor(color: UIColor(toastBackgroudColor), forKey: "ToastBackgroundColor")
        }
    }

    @Published var keypadBackgroudColor: Color {
        didSet {
            UserDefaults.standard.setColor(color: UIColor(keypadBackgroudColor), forKey: "KeypadBackgroundColor")
        }
    }

    @Published var numberKeyColor: Color {
        didSet {
            UserDefaults.standard.setColor(color: UIColor(numberKeyColor), forKey: "NumberKeyColor")
        }
    }

    init() {
        self.focusColor  = Color(UserDefaults.standard.colorForKey(key: "FocusColor") ?? .yellow)
        self.unitPadColor  = Color(UserDefaults.standard.colorForKey(key: "UnitPadColor") ?? UIColor(Color(.lightGray)))
        self.menuBackgroudColor  = Color(UserDefaults.standard.colorForKey(key: "MenuBackgroundColor") ?? .white)
        self.toastBackgroudColor  = Color(UserDefaults.standard.colorForKey(key: "ToastBackgroundColor") ?? .white)
        self.keypadBackgroudColor  = Color(UserDefaults.standard.colorForKey(key: "KeypadBackgroundColor") ?? .black)
        self.numberKeyColor  = Color(UserDefaults.standard.colorForKey(key: "NumberKeyColor") ?? UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1))
    }
}

struct ColorSettingView: View {
    @ObservedObject var settings = ColorSettings.shared

    var body: some View {
        ColorPicker("Focus color".local, selection: $settings.focusColor)
        ColorPicker("Unit pad color".local, selection: $settings.unitPadColor)
        ColorPicker("Menu background color".local, selection: $settings.menuBackgroudColor)
        ColorPicker("Toast background color".local, selection: $settings.toastBackgroudColor)
        ColorPicker("Keypad background color".local, selection: $settings.keypadBackgroudColor)
        ColorPicker("Number key color".local, selection: $settings.numberKeyColor)
    }
}
