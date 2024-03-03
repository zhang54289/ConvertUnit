//
//  ColorSettingView.swift
//  UnitConverter
//
//  Created by zhanghuan on 3/2/24.
//

import SwiftUI
import Foundation

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

    init() {
        self.focusColor  = Color(UserDefaults.standard.colorForKey(key: "FocusColor") ?? .yellow)
        self.unitPadColor  = Color(UserDefaults.standard.colorForKey(key: "UnitPadColor") ?? UIColor(Color(.lightGray)))
        self.menuBackgroudColor  = Color(UserDefaults.standard.colorForKey(key: "MenuBackgroundColor") ?? .white)
    }
}

struct ColorSettingView: View {
    @ObservedObject var settings = ColorSettings.shared

    var body: some View {
        ColorPicker("Focus color", selection: $settings.focusColor)
        ColorPicker("Unit pad color", selection: $settings.unitPadColor)
        ColorPicker("Menu background color", selection: $settings.menuBackgroudColor)
    }
}
