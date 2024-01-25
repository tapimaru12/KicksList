
import UIKit

class TwoGridCollectionViewCellController: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var kicksNameLabel: UILabel!
    
    // このクラスがロードされた直後に実行されるメソッド
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // xib読み込み
        Bundle.main.loadNibNamed("TwoGridCollectionViewCell", owner: self, options: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
