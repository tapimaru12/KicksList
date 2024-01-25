import UIKit

@IBDesignable class PlaceHolderTextView: UITextView {

    // 指定した値をテキストにする
    var placeHolder: String = "" {
        willSet {
            self.placeHolderLabel.text = newValue
            self.placeHolderLabel.sizeToFit()
        }
    }
    
    // ラベルの設定
    private lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping // 折り返しの種類
        label.numberOfLines = 0
        label.font = self.font
        label.textColor = .lightGray
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        return label
    }()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // テキスト欄の変更があった場合に通知
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChanged),
                                               name: UITextView.textDidChangeNotification, object: nil)        
        // プレースホルダーのAutoLayout設定
        NSLayoutConstraint.activate([
                    placeHolderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 7),
                    placeHolderLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 7),
                    placeHolderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
                    placeHolderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5),
        ])
    }
    
    // オブザーバーで通知されるたびに呼び出される
    // プレースホルダーの表示/非表示を切り替える
    @objc private func textDidChanged(notification: NSNotification?) {
        let shouldHidden = self.placeHolder.isEmpty || !self.text.isEmpty
        self.placeHolderLabel.alpha = shouldHidden ? 0 : 1
    }
    
    // textViewが表示されたときにテキストの有無をチェックして、プレースホルダーの表示/非表示を切り替える
    func textViewEmptyCheck(textView: UITextView) {
        let shouldHidden = self.placeHolder.isEmpty || !textView.text.isEmpty
        self.placeHolderLabel.alpha = shouldHidden ? 0 : 1
    }
}
