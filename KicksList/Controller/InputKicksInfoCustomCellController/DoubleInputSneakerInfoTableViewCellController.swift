
import UIKit

class DoubleInputSneakerInfoTableViewCellController: UITableViewCell {
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var textView2: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextView(tv: textView1)
        setupTextView(tv: textView2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupTextView(tv: UITextView) {
        tv.layer.borderWidth = 1.0
        tv.layer.borderColor = UIColor.black.cgColor
        tv.layer.cornerRadius = 3.0
        tv.layer.masksToBounds = true
    }
}
