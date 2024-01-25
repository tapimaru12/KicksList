
import UIKit

class SingleTextFieldInputKicksInfoTableViewCellController: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.borderStyle = .none
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 3.0
        textField.layer.masksToBounds = true
        
        // textField内左端に余白を追加
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 1))
        paddingView.backgroundColor = UIColor.clear
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        // キーボードにDoneボタンを追加
        textField.addDoneButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
