
import UIKit
import RealmSwift

enum DetailSection: Int, CaseIterable {
    case image // 画像
    case kicksName // 名称
    case brand // ブランド
    case series // シリーズ
    case styleCode // スタイルコード
    case color // カラー
    case threeDate // 発売日・購入日・下ろした日
    case oneDate // 手放した日
    case purchaseLocation // 購入先
    case listPrice // 定価
    case amount // 購入金額
    case size // サイズ
    case memo // メモ
}

class KicksDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var isNow: Bool = true // 出し分けフラグ
    var sectionArray: [DetailSection] = DetailSection.allCases
    
    var nowKicksDetail: NowKicksDataModel?
    var pastKicksDetail: PastKicksDataModel?
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // xibの登録
        tableView.register(UINib(nibName: "ImageDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "imageDetailCell")
        tableView.register(UINib(nibName: "SingleLabelDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "singleLabelDetailCell")
        tableView.register(UINib(nibName: "ThreeLabelDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "threeLabelDetailCell")
        tableView.register(UINib(nibName: "AmountDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "amountDetailCell")
        
        // DateFormatter
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        // メニューボタンのアクションを追加
        addButtonAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // 画像取得メソッド
    func getImage(image: String?) -> UIImage? {
        guard let fileName = image else { return nil }
        // ドキュメントディレクトリのURLを取得
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        // ファイルのURLを取得
        let fileURL = documentsDirectoryURL.appendingPathComponent(fileName)
        // ファイルからデータを読み込む
        do {
            let imageData = try Data(contentsOf: fileURL)
            // データをUIImageに変換して返却する
            return UIImage(data: imageData)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    // 編集画面への遷移処理
    func tappedEditButton() {
        let storyboard = UIStoryboard(name: "InputKicksInfoView", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "inputKicksInfo") as! InputKicksInfoViewController
        if isNow {
            vc.isNow = true
            vc.nowKicksEditData = nowKicksDetail!
            vc.selectedImageName = nowKicksDetail?.image
            vc.selectedImage = getImage(image: nowKicksDetail?.image)
            vc.inputKicksName = nowKicksDetail?.kicksName
            vc.inputBrand = nowKicksDetail?.brand
            vc.inputSeries = nowKicksDetail?.series
            vc.inputStyleCode = nowKicksDetail?.styleCode
            vc.inputColor1 = nowKicksDetail?.color1
            vc.inputColor2 = nowKicksDetail?.color2
            vc.inputColor3 = nowKicksDetail?.color3
            vc.selectedReleaseDate = nowKicksDetail?.releaseDate
            vc.selectedBuyDate = nowKicksDetail?.buyDate
            vc.selectedFirstDay = nowKicksDetail?.firstDay
            vc.inputPurchaseLocation = nowKicksDetail?.purchaseLocation
            vc.inputListPrice = nowKicksDetail?.listPrice
            vc.inputKicksFee = nowKicksDetail?.kicksFee
            vc.inputSystemFee = nowKicksDetail?.systemFee
            vc.inputShippingFee = nowKicksDetail?.shippingFee
            vc.inputCustomsDuty = nowKicksDetail?.customsDuty
            vc.inputOtherCosts = nowKicksDetail?.otherCosts
            vc.totalAmount = nowKicksDetail?.totalAmount
            vc.inputSize = nowKicksDetail?.size
            vc.inputMemo = nowKicksDetail?.memo
        } else {
            vc.isNow = false
            vc.pastKicksEditData = pastKicksDetail!
            vc.selectedImageName = pastKicksDetail?.image
            vc.selectedImage = getImage(image: pastKicksDetail?.image)
            vc.inputKicksName = pastKicksDetail?.kicksName
            vc.inputBrand = pastKicksDetail?.brand
            vc.inputSeries = pastKicksDetail?.series
            vc.inputStyleCode = pastKicksDetail?.styleCode
            vc.inputColor1 = pastKicksDetail?.color1
            vc.inputColor2 = pastKicksDetail?.color2
            vc.inputColor3 = pastKicksDetail?.color3
            vc.selectedReleaseDate = pastKicksDetail?.releaseDate
            vc.selectedBuyDate = pastKicksDetail?.buyDate
            vc.selectedFirstDay = pastKicksDetail?.firstDay
            vc.selectedLostDate = pastKicksDetail?.lostDate
            vc.inputPurchaseLocation = pastKicksDetail?.purchaseLocation
            vc.inputListPrice = pastKicksDetail?.listPrice
            vc.inputKicksFee = pastKicksDetail?.kicksFee
            vc.inputSystemFee = pastKicksDetail?.systemFee
            vc.inputShippingFee = pastKicksDetail?.shippingFee
            vc.inputCustomsDuty = pastKicksDetail?.customsDuty
            vc.inputOtherCosts = pastKicksDetail?.otherCosts
            vc.totalAmount = pastKicksDetail?.totalAmount
            vc.inputSize = pastKicksDetail?.size
            vc.inputMemo = pastKicksDetail?.memo
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // NowKicksをPastKicksへ移行
    func tappedLostButton() {
        let storyboard = UIStoryboard(name: "InputKicksInfoView", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "inputKicksInfo") as! InputKicksInfoViewController
        let lostKicksData = PastKicksDataModel()
        for property in Mirror(reflecting: lostKicksData).children {
            if let propertyName = property.label {
                // NowデータはlostDateプロパティを持っていないので除外
                if propertyName == "lostDate" {
                    continue
                }
                let value = nowKicksDetail!.value(forKey: propertyName)
                lostKicksData.setValue(value, forKey: propertyName)
            }
        }
        vc.isNow = false
        vc.lostKicksData = lostKicksData
        vc.selectedImageName = nowKicksDetail?.image
        vc.selectedImage = getImage(image: nowKicksDetail?.image)
        vc.inputKicksName = nowKicksDetail?.kicksName
        vc.inputBrand = nowKicksDetail?.brand
        vc.inputSeries = nowKicksDetail?.series
        vc.inputStyleCode = nowKicksDetail?.styleCode
        vc.inputColor1 = nowKicksDetail?.color1
        vc.inputColor2 = nowKicksDetail?.color2
        vc.inputColor3 = nowKicksDetail?.color3
        vc.selectedReleaseDate = nowKicksDetail?.releaseDate
        vc.selectedBuyDate = nowKicksDetail?.buyDate
        vc.selectedFirstDay = nowKicksDetail?.firstDay
        vc.selectedLostDate = Date()
        vc.inputPurchaseLocation = nowKicksDetail?.purchaseLocation
        vc.inputListPrice = nowKicksDetail?.listPrice
        vc.inputKicksFee = nowKicksDetail?.kicksFee
        vc.inputSystemFee = nowKicksDetail?.systemFee
        vc.inputShippingFee = nowKicksDetail?.shippingFee
        vc.inputCustomsDuty = nowKicksDetail?.customsDuty
        vc.inputOtherCosts = nowKicksDetail?.otherCosts
        vc.totalAmount = nowKicksDetail?.totalAmount
        vc.inputSize = nowKicksDetail?.size
        vc.inputMemo = nowKicksDetail?.memo
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 削除ボタンタップ時にアラートを表示する
    func tappedDeleteButton() {
        let alert = UIAlertController(title: "Kicks delete", message: "リストから削除してもよろしいですか？", preferredStyle: .alert)
        let delete = UIAlertAction(title: "削除", style: .destructive) { [self] _ in
            deleteDate()
            // 一覧画面に戻る
            navigationController?.popViewController(animated: true)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // 画像ファイルの削除処理
    func deleteImageFile(image: String?) {
        if let fileName = image {
            // ドキュメントディレクトリのURLを取得
            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            // ファイルのURLを取得
            let fileURL = documentsDirectoryURL.appendingPathComponent(fileName)
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // データの削除処理
    func deleteDate() {
        let realm = try! Realm()
        try! realm.write{
            if let image = nowKicksDetail?.image, isNow {
                deleteImageFile(image: image)
                realm.delete(nowKicksDetail!)
            } else if let image = pastKicksDetail?.image, !isNow {
                deleteImageFile(image: image)
                realm.delete(pastKicksDetail!)
            }
        }
    }
    
    
    // ボタンをメニューに追加
    func addButtonAction() {
        // 編集ボタン
        let edit = UIAction(title: "編集", image: UIImage(systemName: "pencil")) { _ in
            self.tappedEditButton()
        }
        
        // 手放すボタン
        let lost = UIAction(title: "手放す", image: UIImage(named: "past")) { _ in
            // 処理を書く（PastInputInfoに遷移して、該当データを渡す）
            self.tappedLostButton()
        }
        
        // 削除ボタン
        let delete = UIAction(title: "削除", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            self.tappedDeleteButton()
        }
        // PastDetailページでは手放すボタンを追加しない
        if nowKicksDetail != nil {
            menuButton.menu = UIMenu(title: "", children: [edit, lost, delete])
        } else {
            menuButton.menu = UIMenu(title: "", children: [edit, delete])
        }
    }
}


extension KicksDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var sectionCount: Int // 表示するセクション数
        // セクションの出し分け
        if isNow {
            // NowKicksを追加するあ場合は[下ろした日]セルを表示しな(配列から削除)
            sectionArray.removeAll(where: { $0 == DetailSection.oneDate })
            sectionCount = sectionArray.count
        } else {
            sectionCount = sectionArray.count
        }
        return sectionCount
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // xibを配列に格納
        // if文でNowかPastを判別してデータを出し分け
        switch sectionArray[indexPath.section] {
        case .image:
            let imageCell = tableView.dequeueReusableCell(withIdentifier: "imageDetailCell", for: indexPath) as! ImageDetailTableViewCellController
            if let now = nowKicksDetail {
                imageCell.kicksImage.image = getImage(image: now.image)
            } else if let past = pastKicksDetail {
                imageCell.kicksImage.image = getImage(image: past.image)
            }
            return imageCell
            
        case .kicksName:
            let kicksNameCell = tableView.dequeueReusableCell(withIdentifier: "singleLabelDetailCell", for: indexPath) as! SingleLabelDetailTableViewCellController
            kicksNameCell.titleLabel.text = "名称"
            if let now = nowKicksDetail {
                kicksNameCell.detailLabel.text = now.kicksName
            } else if let past = pastKicksDetail {
                kicksNameCell.detailLabel.text = past.kicksName
            }
            return kicksNameCell
            
        case .brand:
            let brandCell = tableView.dequeueReusableCell(withIdentifier: "singleLabelDetailCell", for: indexPath) as! SingleLabelDetailTableViewCellController
            brandCell.titleLabel.text = "ブランド"
            if let now = nowKicksDetail {
                brandCell.detailLabel.text = now.brand
            } else if let past = pastKicksDetail {
                brandCell.detailLabel.text = past.brand
            }
            return brandCell
            
        case .series:
            let seriesCell = tableView.dequeueReusableCell(withIdentifier: "singleLabelDetailCell", for: indexPath) as! SingleLabelDetailTableViewCellController
            seriesCell.titleLabel.text = "シリーズ"
            if let now = nowKicksDetail {
                seriesCell.detailLabel.text = now.series
            } else if let past = pastKicksDetail {
                seriesCell.detailLabel.text = past.series
            }
            return seriesCell
            
        case .styleCode:
            let styleCodeCell = tableView.dequeueReusableCell(withIdentifier: "singleLabelDetailCell", for: indexPath) as! SingleLabelDetailTableViewCellController
            styleCodeCell.titleLabel.text = "スタイルコード"
            if let now = nowKicksDetail {
                styleCodeCell.detailLabel.text = now.styleCode
            } else if let past = pastKicksDetail {
                styleCodeCell.detailLabel.text = past.styleCode
            }
            return styleCodeCell
            
        case .color:
            let colorCell = tableView.dequeueReusableCell(withIdentifier: "threeLabelDetailCell", for: indexPath) as! ThreeLabelDetailTableViewCellController
            colorCell.titleLabel1.text = "カラー①"
            colorCell.titleLabel2.text = "カラー②"
            colorCell.titleLabel3.text = "カラー③"
            if let now = nowKicksDetail {
                colorCell.detailLabel1.text = now.color1
                colorCell.detailLabel2.text = now.color2
                colorCell.detailLabel3.text = now.color3
            } else if let past = pastKicksDetail {
                colorCell.detailLabel1.text = past.color1
                colorCell.detailLabel2.text = past.color2
                colorCell.detailLabel3.text = past.color3
            }
            return colorCell
            
        case .threeDate:
            let threeDateCell = tableView.dequeueReusableCell(withIdentifier: "threeLabelDetailCell", for: indexPath) as! ThreeLabelDetailTableViewCellController
            threeDateCell.titleLabel1.text = "発売日"
            threeDateCell.titleLabel2.text = "購入日"
            threeDateCell.titleLabel3.text = "下ろした日"
            if let now = nowKicksDetail {
                threeDateCell.detailLabel1.text = dateFormatter.string(from: now.releaseDate)
                threeDateCell.detailLabel2.text = dateFormatter.string(from: now.buyDate)
                threeDateCell.detailLabel3.text = dateFormatter.string(from: now.firstDay)
            } else if let past = pastKicksDetail {
                threeDateCell.detailLabel1.text = dateFormatter.string(from: past.releaseDate)
                threeDateCell.detailLabel2.text = dateFormatter.string(from: past.buyDate)
                threeDateCell.detailLabel3.text = dateFormatter.string(from: past.firstDay)
            }
            return threeDateCell
            
        case .oneDate:
            let oneDateCell = tableView.dequeueReusableCell(withIdentifier: "singleLabelDetailCell", for: indexPath) as! SingleLabelDetailTableViewCellController
            oneDateCell.titleLabel.text = "手放した日"
            if let past = pastKicksDetail {
                oneDateCell.detailLabel.text = dateFormatter.string(from: past.lostDate)
            }
            return oneDateCell
            
        case .purchaseLocation:
            let purchaseLocationCell = tableView.dequeueReusableCell(withIdentifier: "singleLabelDetailCell", for: indexPath) as! SingleLabelDetailTableViewCellController
            purchaseLocationCell.titleLabel.text = "購入先"
            if let now = nowKicksDetail {
                purchaseLocationCell.detailLabel.text = now.purchaseLocation
            } else if let past = pastKicksDetail {
                purchaseLocationCell.detailLabel.text = past.purchaseLocation
            }
            return purchaseLocationCell
            
        case .listPrice:
            let listPriceCell = tableView.dequeueReusableCell(withIdentifier: "singleLabelDetailCell", for: indexPath) as! SingleLabelDetailTableViewCellController
            listPriceCell.titleLabel.text = "定価"
            if let now = nowKicksDetail {
                listPriceCell.detailLabel.text = "\(now.listPrice)円"
            } else if let past = pastKicksDetail {
                listPriceCell.detailLabel.text = "\(past.listPrice)円"
            }
            return listPriceCell
            
        case .amount:
            let amountCell = tableView.dequeueReusableCell(withIdentifier: "amountDetailCell", for: indexPath) as! AmountDetailTableViewCellController
            amountCell.amountTitleLabel.text = "購入金額"
            amountCell.kicksFeeTitleLabel.text = "スニーカー"
            amountCell.systemFeeTitleLabel.text = "システム手数料"
            amountCell.shippingFeeTitleLabel.text = "送料"
            amountCell.customsDutyTitleLabel.text = "関税"
            amountCell.otherCostsTitleLabel.text = "その他"
            amountCell.totalAmountTitleLabel.text = "合計"
            if let now = nowKicksDetail {
                amountCell.kicksFeeLabel.text = "\(now.kicksFee)円"
                amountCell.systemFeeLabel.text = "\(now.systemFee)円"
                amountCell.shippingFeeLabel.text = "\(now.shippingFee)円"
                amountCell.customsDutyLabel.text = "\(now.customsDuty)円"
                amountCell.otherCostsLabel.text = "\(now.otherCosts)円"
                amountCell.totalAmountLabel.text = "\(now.totalAmount)円"
            } else if let past = pastKicksDetail {
                amountCell.kicksFeeLabel.text = "\(past.kicksFee)円"
                amountCell.systemFeeLabel.text = "\(past.systemFee)円"
                amountCell.shippingFeeLabel.text = "\(past.shippingFee)円"
                amountCell.customsDutyLabel.text = "\(past.customsDuty)円"
                amountCell.otherCostsLabel.text = "\(past.otherCosts)円"
                amountCell.totalAmountLabel.text = "\(past.totalAmount)円"
            }
            return amountCell
            
        case .size:
            let sizeCell = tableView.dequeueReusableCell(withIdentifier: "singleLabelDetailCell", for: indexPath) as! SingleLabelDetailTableViewCellController
            sizeCell.titleLabel.text = "サイズ"
            if let now = nowKicksDetail {
                sizeCell.detailLabel.text = "\(now.size) cm"
            } else if let past = pastKicksDetail {
                sizeCell.detailLabel.text = "\(past.size) cm"
            }
            return sizeCell
            
        case .memo:
            let memoCell = tableView.dequeueReusableCell(withIdentifier: "singleLabelDetailCell", for: indexPath) as! SingleLabelDetailTableViewCellController
            memoCell.titleLabel.text = "メモ"
            if let now = nowKicksDetail {
                memoCell.detailLabel.text = now.memo
            } else if let past = pastKicksDetail {
                memoCell.detailLabel.text = past.memo
            }
            return memoCell
        }
    }
}
