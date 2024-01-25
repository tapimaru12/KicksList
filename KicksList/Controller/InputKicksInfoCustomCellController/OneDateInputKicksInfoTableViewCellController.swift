
import UIKit

class OneDateInputKicksInfoTableViewCellController: UITableViewCell {
    @IBOutlet weak var lostDateLabel: UILabel!
    @IBOutlet weak var lostDatePicker: UIDatePicker!
    
    var delegate: DidChangeDatePickerDelegateProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupDatePicker(datePicker: lostDatePicker)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupDatePicker(datePicker: UIDatePicker) {
        datePicker.datePickerMode = .date
        datePicker.timeZone = TimeZone(identifier: "Asia/Tokyo")
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ja_JP")
        datePicker.addTarget(self, action: #selector(didChangeDatePickerValue(_:)), for: .editingDidEnd)
    }
    
    @objc func didChangeDatePickerValue(_ datePicker: UIDatePicker) {
        delegate?.didChangeDate(datePicker)
    }
}
