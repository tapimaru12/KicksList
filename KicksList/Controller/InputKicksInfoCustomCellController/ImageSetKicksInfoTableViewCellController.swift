
import UIKit
import PhotosUI

protocol TapImageDelegateProtocol {
    func didTapImageView()
}

class ImageSetKicksInfoTableViewCellController: UITableViewCell {
    @IBOutlet weak var picImageView: UIImageView!
    
    var delegate: TapImageDelegateProtocol?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // previewImageViewにTapGestureをセット
        picImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedImage(_:))))
        picImageView.isUserInteractionEnabled = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func tappedImage(_ sender: UITapGestureRecognizer) {
        delegate?.didTapImageView()
    }
}
