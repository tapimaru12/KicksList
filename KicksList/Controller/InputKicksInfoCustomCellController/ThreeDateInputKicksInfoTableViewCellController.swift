
import UIKit

protocol DidChangeDatePickerDelegateProtocol {
    func didChangeDate(_ datePicker: UIDatePicker)
}

class ThreeDateInputKicksInfoTableViewCellController: UITableViewCell {
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var releaseDatePicker: UIDatePicker!
    @IBOutlet weak var buyDateLabel: UILabel!
    @IBOutlet weak var buyDatePicker: UIDatePicker!
    @IBOutlet weak var firstDayLabel: UILabel!
    @IBOutlet weak var firstDayPicker: UIDatePicker!
    
    var delegate: DidChangeDatePickerDelegateProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupDatePicker(datePicker: releaseDatePicker)
        setupDatePicker(datePicker: buyDatePicker)
        setupDatePicker(datePicker: firstDayPicker)
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
