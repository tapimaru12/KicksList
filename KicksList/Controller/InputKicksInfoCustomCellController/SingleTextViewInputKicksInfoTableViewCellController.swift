
import UIKit

class SingleTextViewInputKicksInfoTableViewCellController: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: PlaceHolderTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.cornerRadius = 3.0
        textView.layer.masksToBounds = true
        
        // キーボードにDoneボタンを追加
        textView.addDoneButton()
        
        // textViewが空欄かどうかチェック(プレースホルダー用)
        // 各TextViewのプレースホルダーテキストが代入されたあとに実行されるように実行タイミングを遅らせる
        DispatchQueue.main.async { [self] in
            textView.textViewEmptyCheck(textView: textView)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

