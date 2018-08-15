//
//  AppearanceProviderProtocol.swift
//  PlusUno
//
//  Created by Mario Solano on 10/22/17.
//  Copyright © 2017 Mario Solano. All rights reserved.
//

import Foundation
import UIKit


class AppearanceProvider {
    
    var tileColor: UIColor?
    var labelColor: UIColor?
    var font: UIFont?
    
    init(forValue value: Int) {
        tileColor = getTileColor(forValue: value)
        labelColor = getLabelColor(forValue: value)
        font = getFont()
    }
    
    func getTileColor(forValue value: Int) -> UIColor {
        
        let alpha: CGFloat = 1.0
        
        switch value {
        case 0: return UIColor(red: 238.0/255.0, green: 58.0/255.0, blue: 140.0/255.0, alpha: alpha)
        case 1: return UIColor(red: 205.0/255.0, green: 150.0/255.0, blue: 205.0/255.0, alpha: alpha)
        case 2: return UIColor(red: 238.0/255.0, green: 130.0/255.0, blue: 238.0/255.0, alpha: alpha)
        case 3: return UIColor(red: 186.0/255.0, green: 85.0/255.0, blue: 211.0/255.0, alpha: alpha)
        case 4: return UIColor(red: 224.0/255.0, green: 102.0/255.0, blue: 255.0/255.0, alpha: alpha)
        case 5: return UIColor(red: 180.0/255.0, green: 82.0/255.0, blue: 205.0/255.0, alpha: alpha)
        case 6: return UIColor(red: 153.0/255.0, green: 50.0/255.0, blue: 204.0/255.0, alpha: alpha)
        case 7: return UIColor(red: 138.0/255.0, green: 43.0/255.0, blue: 226.0/255.0, alpha: alpha)
        case 8: return UIColor(red: 85.0/255.0, green: 26.0/255.0, blue: 139.0/255.0, alpha: alpha)
        case 9: return UIColor(red: 137.0/255.0, green: 104.0/255.0, blue: 205.0/255.0, alpha: alpha)
        case 10: return UIColor(red: 71.0/255.0, green: 60.0/255.0, blue: 139.0/255.0, alpha: alpha)
        case 11: return UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 128.0/255.0, alpha: alpha)
        case 12: return UIColor(red: 61.0/255.0, green: 89.0/255.0, blue: 171.0/255.0, alpha: alpha)
        case 13: return UIColor(red: 65.0/255.0, green: 105.0/255.0, blue: 225.0/255.0, alpha: alpha)
        case 14: return UIColor(red: 72.0/255.0, green: 118.0/255.0, blue: 255.0/255.0, alpha: alpha)
        case 15: return UIColor(red: 67.0/255.0, green: 110.0/255.0, blue: 238.0/255.0, alpha: alpha)
        case 16: return UIColor(red: 58.0/255.0, green: 95.0/255.0, blue: 205.0/255.0, alpha: alpha)
        case 17: return UIColor(red: 100.0/255.0, green: 149.0/255.0, blue: 237.0/255.0, alpha: alpha)
        case 18: return UIColor(red: 30.0/255.0, green: 144.0/255.0, blue: 255.0/255.0, alpha: alpha)
        case 19: return UIColor(red: 70.0/255.0, green: 130.0/255.0, blue: 180.0/255.0, alpha: alpha)
        case 20: return UIColor(red: 135.0/255.0, green: 106.0/255.0, blue: 250.0/255.0, alpha: alpha)
        case 21: return UIColor(red: 141.0/255.0, green: 182.0/255.0, blue: 205.0/255.0, alpha: alpha)
        case 22: return UIColor(red: 126.0/255.0, green: 192.0/255.0, blue: 238.0/255.0, alpha: alpha)
        case 23: return UIColor(red: 0.0/255.0, green: 191.0/255.0, blue: 225.0/255.0, alpha: alpha)
        case 24: return UIColor(red: 51.0/255.0, green: 161.0/255.0, blue: 201.0/255.0, alpha: alpha)
        case 25: return UIColor(red: 176.0/255.0, green: 224.0/255.0, blue: 230.0/255.0, alpha: alpha)
        case 26: return UIColor(red: 95.0/255.0, green: 158.0/255.0, blue: 160.0/255.0, alpha: alpha)
        case 27: return UIColor(red: 0.0/255.0, green: 206.0/255.0, blue: 209.0/255.0, alpha: alpha)
        case 28: return UIColor(red: 141.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: alpha)
        case 29: return UIColor(red: 72.0/255.0, green: 209.0/255.0, blue: 204.0/255.0, alpha: alpha)
        case 30: return UIColor(red: 0.0/255.0, green: 201.0/255.0, blue: 87.0/255.0, alpha: alpha)
        case 31: return UIColor(red: 61.0/255.0, green: 145.0/255.0, blue: 64.0/255.0, alpha: alpha)
        case 32: return UIColor(red: 193.0/255.0, green: 205.0/255.0, blue: 193.0/255.0, alpha: alpha)
        case 33: return UIColor(red: 143.0/255.0, green: 188.0/255.0, blue: 143.0/255.0, alpha: alpha)
        case 34: return UIColor(red: 152.0/255.0, green: 251.0/255.0, blue: 152.0/255.0, alpha: alpha)
        case 35: return UIColor(red: 144.0/255.0, green: 238.0/255.0, blue: 144.0/255.0, alpha: alpha)
        case 36: return UIColor(red: 84.0/255.0, green: 139.0/255.0, blue: 84.0/255.0, alpha: alpha)
        case 37: return UIColor(red: 118.0/255.0, green: 238.0/255.0, blue: 0.0/255.0, alpha: alpha)
        case 38: return UIColor(red: 162.0/255.0, green: 205.0/255.0, blue: 90.0/255.0, alpha: alpha)
        case 39: return UIColor(red: 154.0/255.0, green: 205.0/255.0, blue: 50.0/255.0, alpha: alpha)
        case 40: return UIColor(red: 205.0/255.0, green: 205.0/255.0, blue: 0.0/255.0, alpha: alpha)
        case 41: return UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 0.0/255.0, alpha: alpha)
        case 42: return UIColor(red: 205.0/255.0, green: 198.0/255.0, blue: 115.0/255.0, alpha: alpha)
        case 43: return UIColor(red: 139.0/255.0, green: 134.0/255.0, blue: 78.0/255.0, alpha: alpha)
        case 44: return UIColor(red: 240.0/255.0, green: 230.0/255.0, blue: 140.0/255.0, alpha: alpha)
        case 45: return UIColor(red: 238.0/255.0, green: 232.0/255.0, blue: 170.0/255.0, alpha: alpha)
        case 46: return UIColor(red: 238.0/255.0, green: 233.0/255.0, blue: 191.0/255.0, alpha: alpha)
        case 47: return UIColor(red: 255.0/255.0, green: 236.0/255.0, blue: 139.0/255.0, alpha: alpha)
        case 48: return UIColor(red: 227.0/255.0, green: 207.0/255.0, blue: 87.0/255.0, alpha: alpha)
        case 49: return UIColor(red: 255.0/255.0, green: 215.0/255.0, blue: 0.0/255.0, alpha: alpha)
        case 50: return UIColor(red: 218.0/255.0, green: 165.0/255.0, blue: 32.0/255.0, alpha: alpha)
        case 51: return UIColor(red: 255.0/255.0, green: 193.0/255.0, blue: 37.0/255.0, alpha: alpha)
        case 52: return UIColor(red: 205.0/255.0, green: 155.0/255.0, blue: 29.0/255.0, alpha: alpha)
        case 53: return UIColor(red: 139.0/255.0, green: 105.0/255.0, blue: 20.0/255.0, alpha: alpha)
        case 54: return UIColor(red: 238.0/255.0, green: 154.0/255.0, blue: 0.0/255.0, alpha: alpha)
        case 55: return UIColor(red: 139.0/255.0, green: 90.0/255.0, blue: 0.0/255.0, alpha: alpha)
        case 56: return UIColor(red: 238.0/255.0, green: 216.0/255.0, blue: 174.0/255.0, alpha: alpha)
        case 57: return UIColor(red: 139.0/255.0, green: 126.0/255.0, blue: 102.0/255.0, alpha: alpha)
        case 58: return UIColor(red: 255.0/255.0, green: 228.0/255.0, blue: 181.0/255.0, alpha: alpha)
        case 59: return UIColor(red: 255.0/255.0, green: 153.0/255.0, blue: 18.0/255.0, alpha: alpha)
        case 60: return UIColor(red: 227.0/255.0, green: 168.0/255.0, blue: 105.0/255.0, alpha: alpha)
        case 61: return UIColor(red: 255.0/255.0, green: 165.0/255.0, blue: 79.0/255.0, alpha: alpha)
        case 62: return UIColor(red: 205.0/255.0, green: 133.0/255.0, blue: 63.0/255.0, alpha: alpha)
        case 63: return UIColor(red: 244.0/255.0, green: 164.0/255.0, blue: 96.0/255.0, alpha: alpha)
        case 64: return UIColor(red: 199.0/255.0, green: 97.0/255.0, blue: 20.0/255.0, alpha: alpha)
        case 65: return UIColor(red: 255.0/255.0, green: 127.0/255.0, blue: 36.0/255.0, alpha: alpha)
        case 66: return UIColor(red: 205.0/255.0, green: 122.0/255.0, blue: 29.0/255.0, alpha: alpha)
        case 67: return UIColor(red: 255.0/255.0, green: 125.0/255.0, blue: 64.0/255.0, alpha: alpha)
        case 68: return UIColor(red: 238.0/255.0, green: 121.0/255.0, blue: 66.0/255.0, alpha: alpha)
        case 69: return UIColor(red: 205.0/255.0, green: 129.0/255.0, blue: 98.0/255.0, alpha: alpha)
        case 70: return UIColor(red: 255.0/255.0, green: 127.0/255.0, blue: 80.0/255.0, alpha: alpha)
        case 71: return UIColor(red: 205.0/255.0, green: 55.0/255.0, blue: 0.0/255.0, alpha: alpha)
        case 72: return UIColor(red: 255.0/255.0, green: 114.0/255.0, blue: 86.0/255.0, alpha: alpha)
        case 73: return UIColor(red: 238.0/255.0, green: 106.0/255.0, blue: 80.0/255.0, alpha: alpha)
        case 74: return UIColor(red: 255.0/255.0, green: 99.0/255.0, blue: 71.0/255.0, alpha: alpha)
        case 75: return UIColor(red: 139.0/255.0, green: 54.0/255.0, blue: 38.0/255.0, alpha: alpha)
        case 76: return UIColor(red: 250.0/255.0, green: 128.0/255.0, blue: 114.0/255.0, alpha: alpha)
        case 77: return UIColor(red: 240.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: alpha)
        case 78: return UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 106.0/255.0, alpha: alpha)
        case 79: return UIColor(red: 139.0/255.0, green: 58.0/255.0, blue: 58.0/255.0, alpha: alpha)
        case 80: return UIColor(red: 255.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: alpha)
        case 81: return UIColor(red: 205.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: alpha)
        case 82: return UIColor(red: 139.0/255.0, green: 35.0/255.0, blue: 35.0/255.0, alpha: alpha)
        case 83: return UIColor(red: 255.0/255.0, green: 48.0/255.0, blue: 48.0/255.0, alpha: alpha)
        case 84: return UIColor(red: 205.0/255.0, green: 38.0/255.0, blue: 38.0/255.0, alpha: alpha)
        case 85: return UIColor(red: 139.0/255.0, green: 26.0/255.0, blue: 26.0/255.0, alpha: alpha)
        case 86: return UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: alpha)
        case 87: return UIColor(red: 238.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: alpha)
        case 88: return UIColor(red: 205.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: alpha)
        case 89: return UIColor(red: 128.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: alpha)
        case 90: return UIColor(red: 142.0/255.0, green: 56.0/255.0, blue: 142.0/255.0, alpha: alpha)
        case 91: return UIColor(red: 113.0/255.0, green: 113.0/255.0, blue: 198.0/255.0, alpha: alpha)
        case 92: return UIColor(red: 125.0/255.0, green: 158.0/255.0, blue: 192.0/255.0, alpha: alpha)
        case 93: return UIColor(red: 56.0/255.0, green: 142.0/255.0, blue: 142.0/255.0, alpha: alpha)
        case 94: return UIColor(red: 113.0/255.0, green: 198.0/255.0, blue: 113.0/255.0, alpha: alpha)
        case 95: return UIColor(red: 142.0/255.0, green: 142.0/255.0, blue: 56.0/255.0, alpha: alpha)
        case 96: return UIColor(red: 197.0/255.0, green: 193.0/255.0, blue: 170.0/255.0, alpha: alpha)
        case 97: return UIColor(red: 198.0/255.0, green: 113.0/255.0, blue: 113.0/255.0, alpha: alpha)
        case 98: return UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: alpha)
        case 99: return UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: alpha)
        default: return UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: alpha)
        }
    }
    
    func getLabelColor(forValue value: Int) -> UIColor {
        switch value {
        default:
            return UIColor.white
        }
    }
    
    func getFont() -> UIFont {
        return UIFont(name: "JosefinSans", size: 70) ?? UIFont.systemFont(ofSize: 14.0)
    }
}
