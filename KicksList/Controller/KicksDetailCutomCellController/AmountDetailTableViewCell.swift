
import UIKit

class AmountDetailTableViewCellController: UITableViewCell {
    @IBOutlet weak var amountTitleLabel: UILabel!
    @IBOutlet weak var kicksFeeTitleLabel: UILabel!
    @IBOutlet weak var kicksFeeLabel: UILabel!
    @IBOutlet weak var systemFeeTitleLabel: UILabel!
    @IBOutlet weak var systemFeeLabel: UILabel!
    @IBOutlet weak var shippingFeeTitleLabel: UILabel!
    @IBOutlet weak var shippingFeeLabel: UILabel!
    @IBOutlet weak var customsDutyTitleLabel: UILabel!
    @IBOutlet weak var customsDutyLabel: UILabel!
    @IBOutlet weak var otherCostsTitleLabel: UILabel!
    @IBOutlet weak var otherCostsLabel: UILabel!
    @IBOutlet weak var totalAmountTitleLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
