
import UIKit

class AmountInputKicksInfoTableViewCellController: UITableViewCell {
    @IBOutlet weak var amountTitleLabel: UILabel!
    @IBOutlet weak var kicksFeeLabel: UILabel!
    @IBOutlet weak var kicksFeeTextField: UITextField!
    @IBOutlet weak var systemFeeLabel: UILabel!
    @IBOutlet weak var systemFeeTextField: UITextField!
    @IBOutlet weak var shippingFeeLabel: UILabel!
    @IBOutlet weak var shippingFeeTextField: UITextField!
    @IBOutlet weak var customsDutyLabel: UILabel!
    @IBOutlet weak var customsDutyTextField: UITextField!
    @IBOutlet weak var otherCostsLabel: UILabel!
    @IBOutlet weak var otherCostsTextField: UITextField!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    
    private var observation: NSKeyValueObservation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 数字のみキーボード
        kicksFeeTextField.keyboardType = .numberPad
        systemFeeTextField.keyboardType = .numberPad
        shippingFeeTextField.keyboardType = .numberPad
        customsDutyTextField.keyboardType = .numberPad
        otherCostsTextField.keyboardType = .numberPad
        
        // キーボードにDoneボタンを追加
        kicksFeeTextField.addDoneButton()
        systemFeeTextField.addDoneButton()
        shippingFeeTextField.addDoneButton()
        customsDutyTextField.addDoneButton()
        otherCostsTextField.addDoneButton()
        
        kicksFeeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        systemFeeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        shippingFeeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        customsDutyTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otherCostsTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    // 各UITextFieldの編集が変更されるたびに呼ばれるメソッド
    @objc func textFieldDidChange(_ textField: UITextField) {
        // 合計を計算してUILabelに表示
        updateTotalAmount()
    }
    
    // UITextFieldの合計を計算してUILabelに表示するメソッド
    func updateTotalAmount() {
        // 各UITextFieldのテキストをInt32に変換して合計を計算
        let kicksFee = Int32(kicksFeeTextField.text ?? "0")
        let systemFee = Int32(systemFeeTextField.text ?? "0")
        let shippingFee = Int32(shippingFeeTextField.text ?? "0")
        let customsDuty = Int32(customsDutyTextField.text ?? "0")
        let otherCosts = Int32(otherCostsTextField.text ?? "0")
        
        let inputValues: [Int32?] = [kicksFee, systemFee, shippingFee, customsDuty, otherCosts]
        let validValues = inputValues.compactMap { $0 }
        let sum = validValues.reduce(0, +)
        totalAmount.text = "\(sum)円"
    }
}
