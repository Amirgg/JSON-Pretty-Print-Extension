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
    func prettyPrintJSON (
        fontSize : CGFloat = 13,
        keyColor : UIColor = UIColor.init(red: 195/255.0, green: 58/255.0, blue: 76/255.0, alpha: 1),
        valueColor : UIColor = UIColor.init(red: 153/255.0, green: 163/255.0, blue: 48/255.0, alpha: 1),
        levelSpace : Int = 4,
        trueColor : UIColor = UIColor.init(red: 57/255.0, green: 24/255.0, blue: 148/255.0, alpha: 1),
        falseColor : UIColor = UIColor.init(red: 57/255.0, green: 24/255.0, blue: 148/255.0, alpha: 1),
        intColor : UIColor = UIColor.init(red: 57/255.0, green: 24/255.0, blue: 148/255.0, alpha: 1),
        nullColor : UIColor = UIColor.gray) -> NSMutableAttributedString {
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
            var trueRange = [NSRange]()
            var falseRange = [NSRange]()
            var intRange = [NSRange]()
            var nullRange = [NSRange]()
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
                        if result.suffix(4) == "true" {
                            trueRange.append(NSMakeRange(result.count - 4, 4))
                        } else if result.suffix(5) == "false" {
                            falseRange.append(NSMakeRange(result.count - 5, 5))
                        }
                        else if result.suffix(4) == "null" {
                            nullRange.append(NSMakeRange(result.count - 4, 4))
                        } else if result[result.count-1] != "\"" && result[result.count-1] != "}" && result[result.count-1] != "]"  && result[result.count-1] != " " {
                            let range = result.range(of: ":", options: .backwards)!
                            let intIndex = result.distance(from: result.startIndex, to: range.lowerBound)
                            intRange.append(NSMakeRange(intIndex + 2, result.count - intIndex - 1))
                        }
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
                        if result.suffix(4) == "true" {
                            trueRange.append(NSMakeRange(result.count - 4, 4))
                        } else if result.suffix(5) == "false" {
                            falseRange.append(NSMakeRange(result.count - 5, 5))
                        }
                        else if result.suffix(4) == "null" {
                            nullRange.append(NSMakeRange(result.count - 4, 4))
                        } else if result[result.count-1] != "\"" && result[result.count-1] != "}" && result[result.count-1] != "]"  && result[result.count-1] != " " {
                            let range = result.range(of: ":", options: .backwards)!
                            let intIndex = result.distance(from: result.startIndex, to: range.lowerBound)
                            intRange.append(NSMakeRange(intIndex + 2, result.count - intIndex - 1))
                        }
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
            attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: fontSize), range: NSMakeRange(0, result.count))
            for range in keyRange {
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: keyColor, range: range)
            }
            for range in valRange {
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: valueColor, range: range)
            }
            for range in trueRange {
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: trueColor , range: range)
                attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: fontSize) , range: range)
            }
            for range in falseRange {
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: falseColor , range: range)
                attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: fontSize) , range: range)
            }
            for range in intRange {
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: intColor , range: range)
                attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: fontSize) , range: range)
            }
            for range in nullRange {
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: nullColor , range: range)
                attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: fontSize) , range: range)
            }
            
            return attributedString
        } else {
            return NSMutableAttributedString()
        }
    }
}
