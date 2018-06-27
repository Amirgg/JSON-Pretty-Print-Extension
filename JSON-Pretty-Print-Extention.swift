//
//  StringExtensions.swift
//  Amirg1992
//
//  Created by Amir Austineh on 27/6/2018
//  Copyright © 2018 Amir Austineh. All rights reserved.
//


import Foundation
import UIKit

extension String {
    func prettyPrintJSON (_ keyColor : UIColor = UIColor.init(red: 175/255.0, green: 0/255.0, blue: 65/255.0, alpha: 1), _ valueColor : UIColor = UIColor.init(red: 0/255.0, green: 174/255.0, blue: 114/255.0, alpha: 1), _ levelSpace : Int = 4) -> NSMutableAttributedString {
        var valid = false
        if let jsonDataToVerify = self.data(using: String.Encoding.utf8)
        {
            do {
                _ = try JSONSerialization.jsonObject(with: jsonDataToVerify)
                valid = true
            } catch {
                valid = false
            }
        }
        if valid {
            let string = self
            var tab = ""
            for _ in 0..<levelSpace {
                tab = "\(tab) "
            }
            var open = false
            var level = 0
            var result = ""
            var keyRange = [NSRange]()
            var valRange = [NSRange]()
            var openIndex = 0
            var isKey = false
            
            for index in 0..<string.count {
                let char = string[index]
                switch char.description {
                case "[":
                    if open {
                        result = "\(result)\(char)"
                    } else {
                        level += 1
                        result = "\(result)[\n"
                        for _ in 0..<level {
                            result = "\(result)\(tab)"
                        }
                    }
                case "]":
                    if open {
                        result = "\(result)\(char)"
                    } else {
                        level -= 1
                        result = "\(result)\n"
                        for _ in 0..<level {
                            result = "\(result)\(tab)"
                        }
                        result = "\(result)]"
                    }
                case "{":
                    if open {
                        result = "\(result)\(char)"
                    } else {
                        isKey = true
                        level += 1
                        result = "\(result){\n"
                        for _ in 0..<level {
                            result = "\(result)\(tab)"
                        }
                    }
                case "}":
                    if open {
                        result = "\(result)\(char)"
                    } else {
                        level -= 1
                        result = "\(result)\n"
                        for _ in 0..<level {
                            result = "\(result)\(tab)"
                        }
                        result = "\(result)}"
                    }
                case ",":
                    if open {
                        result = "\(result)\(char)"
                    } else {
                        isKey = true
                        result = "\(result),\n"
                        for _ in 0..<level {
                            result = "\(result)\(tab)"
                        }
                    }
                case ":":
                    if open {
                        result = "\(result)\(char)"
                    } else {
                        isKey = false
                        result = "\(result) : "
                    }
                case "\"":
                    if result[result.count-1] != "\\" {
                        open = !open
                        if open {
                            openIndex = result.count - 1
                        } else {
                            if isKey {
                                keyRange.append(NSMakeRange(openIndex, result.count - openIndex + 1))
                            } else {
                                valRange.append(NSMakeRange(openIndex, result.count - openIndex + 1))
                            }
                        }
                    }
                    result = "\(result)\""
                case " ","\n":
                    break
                default:
                    result = "\(result)\(char)"
                }
            }
            let attributedString = NSMutableAttributedString(string: result)
            for range in keyRange {
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: keyColor, range: range)
            }
            for range in valRange {
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: valueColor, range: range)
            }
            return attributedString
        } else {
            return NSMutableAttributedString()
        }
    }
}
