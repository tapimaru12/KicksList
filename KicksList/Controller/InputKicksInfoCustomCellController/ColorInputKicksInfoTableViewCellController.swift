
import UIKit

class ColorInputKicksInfoTableViewCellController: UITableViewCell {
    @IBOutlet weak var colorLabel1: UILabel!
    @IBOutlet weak var colorTextField1: UITextField!
    @IBOutlet weak var colorLabel2: UILabel!
    @IBOutlet weak var colorTextField2: UITextField!
    @IBOutlet weak var colorLabel3: UILabel!
    @IBOutlet weak var colorTextField3: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTextField(textField: colorTextField1)
        setupTextField(textField: colorTextField2)
        setupTextField(textField: colorTextField3)
        
        // キーボードにDoneボタンを追加
        colorTextField1.addDoneButton()
        colorTextField2.addDoneButton()
        colorTextField3.addDoneButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupTextField(textField: UITextField) {
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
    }
}
