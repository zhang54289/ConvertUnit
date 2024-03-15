//
//  ColorSettingView.swift
//  ConverterGuru
//
//  Created by zhanghuan on 3/2/24.
//

import SwiftUI
import Foundation

extension String {
    var local: String {
        if Locale.current.language.languageCode?.identifier.hasPrefix("zh") == true {
            return NSLocalizedString(self, comment: "")
        } else {
            return self
        }
    }
}

extension Color {
    func inverted() -> Color {
        let ciColor = CIColor(color: UIColor(self))
        
        let invertedRed = 1.0 - ciColor.red
        let invertedGreen = 1.0 - ciColor.green
        let invertedBlue = 1.0 - ciColor.blue
        
        return Color(red: invertedRed, green: invertedGreen, blue: invertedBlue)
    }
}

extension UserDefaults {
    func colorForKey(key: String) -> UIColor? {
        var colorReturned: UIColor?
        if let colorData = UserDefaults.standard.data(forKey: key) {
            do {
                colorReturned = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
            } catch {
                print("Error unarchiving color for UserDefaults: \(error)")
            }
        }
        return colorReturned
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
    
    @Published var focusBackgroundColor: Color {
        didSet {
            UserDefaults.standard.setColor(color: UIColor(focusBackgroundColor), forKey: "FocusBackgroundColor")
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
    
    @Published var listBackgroundColor: Color {
        didSet {
            UserDefaults.standard.setColor(color: UIColor(listBackgroundColor), forKey: "ListBackgroundColor")
        }
    }
    
    init() {
        self.focusColor  = Color(UserDefaults.standard.colorForKey(key: "FocusColor") ?? .red)
        self.focusBackgroundColor  = Color(UserDefaults.standard.colorForKey(key: "FocusBackgroundColor") ?? .yellow)
        self.unitPadColor  = Color(UserDefaults.standard.colorForKey(key: "UnitPadColor") ?? UIColor(Color(.lightGray)))
        self.menuBackgroudColor  = Color(UserDefaults.standard.colorForKey(key: "MenuBackgroundColor") ?? .white)
        self.toastBackgroudColor  = Color(UserDefaults.standard.colorForKey(key: "ToastBackgroundColor") ?? .white)
        self.keypadBackgroudColor  = Color(UserDefaults.standard.colorForKey(key: "KeypadBackgroundColor") ?? .black)
        self.numberKeyColor  = Color(UserDefaults.standard.colorForKey(key: "NumberKeyColor") ?? UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1))
        self.listBackgroundColor  = Color(UserDefaults.standard.colorForKey(key: "ListBackgroundColor") ?? .brown)
    }
}

struct ColorSettingView: View {
    @EnvironmentObject var colorSettings: ColorSettings
    
    var body: some View {
        ColorPicker("Focus color".local, selection: $colorSettings.focusColor)
        ColorPicker("Focus background color".local, selection: $colorSettings.focusBackgroundColor)
        ColorPicker("Unit pad color".local, selection: $colorSettings.unitPadColor)
        ColorPicker("Menu background color".local, selection: $colorSettings.menuBackgroudColor)
        ColorPicker("Toast background color".local, selection: $colorSettings.toastBackgroudColor)
        ColorPicker("Keypad background color".local, selection: $colorSettings.keypadBackgroudColor)
        ColorPicker("Number key color".local, selection: $colorSettings.numberKeyColor)
        ColorPicker("Unit List background color".local, selection: $colorSettings.listBackgroundColor)
    }
}
