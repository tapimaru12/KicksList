
import UIKit

extension UIView {
    // キーボードにDoneボタンを追加
    func addDoneButton() {
        let toolBar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton))
        toolBar.items = [space, done]
        toolBar.sizeToFit()
        
        if let textField = self as? UITextField {
            textField.inputAccessoryView = toolBar
        } else if let textView = self as? UITextView {
            textView.inputAccessoryView = toolBar
        } 
    }
    
    // Doneボタンを押した時の処理
    @objc func didTapDoneButton() {
        self.endEditing(true)
    }
}
