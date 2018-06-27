# JSON-Pretty-Print-Extension
A Swift extention to pretty print the JSON string

This extention returns a `NSMutableAttributedString` 

## How to use:

1-Add `JSON-Pretty-Print-Extension.swift` file to your project

2-Set your view's `.attributedText` to `YourString.prettyPrintJSON()`


## Example:
```
var jsonString = "{\"Sample\":\"Json\"}"
myLable.attributedText = jsonString.prettyPrintJSON()
```


## Customize:

### Edit Key and Value Color and Level Space
```
//key color : UIColor 
//value color : UIColor
//level space : Int
var jsonString = "{\"Sample\":\"Json\"}"
myLable.attributedText = jsonString.prettyPrintJSON(.red, .blue, 6)
```
