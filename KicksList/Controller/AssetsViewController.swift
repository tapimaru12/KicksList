
import UIKit
import RealmSwift

class AssetsViewController: UIViewController {
    @IBOutlet weak var totalKicksCountLabel: UILabel!
    @IBOutlet weak var totalListPriceLabel: UILabel!
    @IBOutlet weak var totalKicksFeeLabel: UILabel!
    @IBOutlet weak var totalSystemFeeLabel: UILabel!
    @IBOutlet weak var totalShippingFeeLabel: UILabel!
    @IBOutlet weak var totalCustomsDutyLabel: UILabel!
    @IBOutlet weak var totalOtherCostsLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    // 各データの合計値を保持
    var totalKicksCount: Int32 = 0
    var totalListPrice: Int32 = 0
    var totalKicksFee: Int32 = 0
    var totalSystemFee: Int32 = 0
    var totalShippingFee: Int32 = 0
    var totalCustomsDuty: Int32 = 0
    var totalOtherCosts: Int32 = 0
    var totalAmount: Int32 = 0
    
    var currentSegment: Int = 0 // フラグ
    
    var nowKicksDataList: [NowKicksDataModel] = []
    var pastKicksDataList: [PastKicksDataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        calculateTotal()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        calculateTotal()
        setData()
    }
    
    @IBAction func tappedSegmentedControl(_ sender: UISegmentedControl) {
        currentSegment = sender.selectedSegmentIndex
        getData()
        calculateTotal()
        setData()
    }
    
    // データを取得
    func getData() {
        let realm = try! Realm()
        let nowData = realm.objects(NowKicksDataModel.self)
        let pastData = realm.objects(PastKicksDataModel.self)
        nowKicksDataList = Array(nowData)
        pastKicksDataList = Array(pastData)
    }
    
    // 各データの合計値を算出
    func calculateTotal() {
        if currentSegment == 0 {
            // Nowデータの算出
            totalKicksCount = Int32(nowKicksDataList.count)
            totalListPrice = Int32(nowKicksDataList.reduce(0) {$0 + $1.listPrice})
            totalKicksFee = Int32(nowKicksDataList.reduce(0) { $0 + $1.kicksFee})
            totalSystemFee = Int32(nowKicksDataList.reduce(0) { $0 + $1.systemFee})
            totalShippingFee = Int32(nowKicksDataList.reduce(0) { $0 + $1.shippingFee})
            totalCustomsDuty = Int32(nowKicksDataList.reduce(0) { $0 + $1.customsDuty})
            totalOtherCosts = Int32(nowKicksDataList.reduce(0) { $0 + $1.otherCosts})
            totalAmount = Int32(nowKicksDataList.reduce(0) { $0 + $1.totalAmount})
        } else {
            // Pastデータの算出
            totalKicksCount = Int32(pastKicksDataList.count)
            totalListPrice = Int32(pastKicksDataList.reduce(0) {$0 + $1.listPrice})
            totalKicksFee = Int32(pastKicksDataList.reduce(0) { $0 + $1.kicksFee})
            totalSystemFee = Int32(pastKicksDataList.reduce(0) { $0 + $1.systemFee})
            totalShippingFee = Int32(pastKicksDataList.reduce(0) { $0 + $1.shippingFee})
            totalCustomsDuty = Int32(pastKicksDataList.reduce(0) { $0 + $1.customsDuty})
            totalOtherCosts = Int32(pastKicksDataList.reduce(0) { $0 + $1.otherCosts})
            totalAmount = Int32(pastKicksDataList.reduce(0) { $0 + $1.totalAmount})
        }
    }
    
    // 各UILabelに値をセットする
    func setData() {
        totalKicksCountLabel.text = "\(totalKicksCount)足"
        totalListPriceLabel.text = "\(totalListPrice)円"
        totalKicksFeeLabel.text = "\(totalKicksFee)円"
        totalSystemFeeLabel.text = "\(totalSystemFee)円"
        totalShippingFeeLabel.text = "\(totalShippingFee)円"
        totalCustomsDutyLabel.text = "\(totalCustomsDuty)円"
        totalOtherCostsLabel.text = "\(totalOtherCosts)円"
        totalAmountLabel.text = "\(totalAmount)円"
    }
}
