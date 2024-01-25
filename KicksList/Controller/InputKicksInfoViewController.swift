
import UIKit
import PhotosUI
import RealmSwift

enum InputSection: Int, CaseIterable {
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

class InputKicksInfoViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, TapImageDelegateProtocol, DidChangeDatePickerDelegateProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    // 出し分けフラグ
    var isNow: Bool = true
    
    // 表示するセクションを保持
    var sectionArray: [InputSection] = InputSection.allCases
    
    // Modelをインスタンス化
    var nowKicksData = NowKicksDataModel()
    var pastKicksData = PastKicksDataModel()
    
    // 編集用データ
    var nowKicksEditData: NowKicksDataModel?
    var pastKicksEditData: PastKicksDataModel?
    
    // NowデータをPastデータに移行する際に、移行するNowデータを保持
    var lostKicksData: PastKicksDataModel?
    
    // 編集時にすでに登録されている画像を保持 (画像が変更された時にファイル削除するため)
    var selectedImageName: String?
    
    // データの一時保存用プロパティ
    var selectedImage: UIImage?
    var inputKicksName: String?
    var inputBrand: String?
    var inputSeries: String?
    var inputStyleCode: String?
    var inputColor1: String?
    var inputColor2: String?
    var inputColor3: String?
    var selectedReleaseDate: Date?
    var selectedBuyDate: Date?
    var selectedFirstDay: Date?
    var selectedLostDate: Date?
    var inputPurchaseLocation: String?
    var inputListPrice: Int32?
    var inputKicksFee: Int32?
    var inputSystemFee: Int32?
    var inputShippingFee: Int32?
    var inputCustomsDuty: Int32?
    var inputOtherCosts: Int32?
    var totalAmount: Int32?
    var inputSize: Float?
    var inputMemo: String?
    
    private var observation: NSKeyValueObservation?
    
    // TextViewとTextFieldを編集した際に、そのセクション値を保持する
    var selectedSection: Int?
    
    // 画像選択しなかった場合に表示する画像
    var kicksDefaultImage: UIImage! = UIImage(named: "NoImage")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // xibの登録
        tableView.register(UINib(nibName: "ImageSetKicksInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "imageSetCell")
        tableView.register(UINib(nibName: "SingleTextViewInputKicksInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "singleTextViewInputCell")
        tableView.register(UINib(nibName: "SingleTextFieldInputKicksInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "singleTextFieldInputCell")
        tableView.register(UINib(nibName: "ColorInputKicksInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "colorInputCell")
        tableView.register(UINib(nibName: "ThreeDateInputKicksInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "threeDateInputCell")
        tableView.register(UINib(nibName: "OneDateInputKicksInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "oneDateInputCell")
        tableView.register(UINib(nibName: "AmountInputKicksInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "amountInputCell")
    }
    
    
    // imageViewを押した時
    func didTapImageView() {
        var config = PHPickerConfiguration() // カメラロール表示設定
        config.filter = .images // 選択できるファイルタイプ
        config.selectionLimit = 1 // 選択枚数
        let picker = PHPickerViewController(configuration: config) // インスタンス生成
        picker.delegate = self
        present(picker, animated: true) // カメラロールを表示
    }
    
    // ファイル名生成メソッド
    func generateFileName(image: UIImage?) -> String? {
        // 画像がnilだったらnilを返却して処理から抜ける (ファイル名を生成しない)
        guard let _ = image else { return nil }
        // ファイル名を生成（UUID + 拡張子".jpeg"）
        let fileName = UUID().uuidString + ".jpeg"
        return fileName
    }
    
    // 画像の保存先ファイル名を出力
    func setImage(image: UIImage?, fileName: String?) -> String? {
        // 画像がnilだったらnilを返却して処理から抜ける
        guard let image = image, let fileName = fileName else { return nil }
        // ドキュメントディレクトリのURLを取得
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        // ファイルのURLを作成
        var fileURL = documentsDirectoryURL.appendingPathComponent(fileName)
        // UIImageをJPEGデータに変換
        let data = image.jpegData(compressionQuality: 1.0)
        // URLResourceValuesをインスタンス化
        var values = URLResourceValues()
        // iCloudの自動バックアップから除外する
        values.isExcludedFromBackup = true
        do {
            // JPEGデータをファイルに書き込み
            try data!.write(to: fileURL)
            // iCloudの自動バックアップから除外する設定の登録
            try fileURL.setResourceValues(values)
        } catch {
            print(error.localizedDescription)
        }
        return fileName
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
    
    
    // TextViewの高さに合わせてセルの高さを変更する
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    // TextViewの入力値を一時的に保持
    func textViewDidEndEditing(_ textView: UITextView) {
        // 編集したTextFieldが設置されたセルのセクション値を取得
        selectedSection = textView.tag
        
        // 編集されたセルのセクション値を引数sectionに割り当てる
        if let selectedCell = tableView.cellForRow(at: IndexPath(row: 0, section: selectedSection!)) as? SingleTextViewInputKicksInfoTableViewCellController, textView == selectedCell.textView {
            switch selectedCell.titleLabel.text {
            case .some("名称"):
                inputKicksName = textView.text
            case .some("ブランド"):
                inputBrand = textView.text
            case .some("シリーズ"):
                inputSeries = textView.text
            case .some("メモ"):
                inputMemo = textView.text
            default:
                break
            }
        }
    }
    
    
    // TextFieldの入力値を一時的に保持
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 編集したTextFieldが設置されたセルのセクション値を取得
        selectedSection = textField.tag
        
        // 編集されたセルのセクション値を引数sectionに割り当てる
        if let selectedCell = tableView.cellForRow(at: IndexPath(row: 0, section: selectedSection!)) as? SingleTextFieldInputKicksInfoTableViewCellController, textField == selectedCell.textField {
            switch selectedCell.titleLabel.text {
            case .some("スタイルコード"):
                inputStyleCode = textField.text
            case .some("購入先"):
                inputPurchaseLocation = textField.text
            case .some("定価"):
                inputListPrice = Int32(textField.text ?? "0")
            case .some("サイズ"):
                inputSize = Float(textField.text ?? "0")
            default:
                break
            }
            
        } else if let colorCell = tableView.cellForRow(at: IndexPath(row: 0, section: selectedSection!)) as? ColorInputKicksInfoTableViewCellController {
            if textField == colorCell.colorTextField1 {
                inputColor1 = textField.text
            } else if textField == colorCell.colorTextField2 {
                inputColor2 = textField.text
            } else if textField == colorCell.colorTextField3 {
                inputColor3 = textField.text
            }
            
        } else if let amountCell = tableView.cellForRow(at: IndexPath(row: 0, section: selectedSection!)) as? AmountInputKicksInfoTableViewCellController {
            if textField == amountCell.kicksFeeTextField {
                inputKicksFee = Int32(textField.text ?? "0")
            } else if textField == amountCell.systemFeeTextField {
                inputSystemFee = Int32(textField.text ?? "0")
            } else if textField == amountCell.shippingFeeTextField {
                inputShippingFee = Int32(textField.text ?? "0")
            } else if textField == amountCell.customsDutyTextField {
                inputCustomsDuty = Int32(textField.text ?? "0")
            } else if textField == amountCell.otherCostsTextField {
                inputOtherCosts = Int32(textField.text ?? "0")
            }
            
            // totalAmountの値も一時的に保持
            if let newValue = amountCell.totalAmount.text {
                // 数字以外の文字を削除して数字だけを抽出
                let characterSet = CharacterSet.decimalDigits.inverted
                totalAmount = Int32(newValue.components(separatedBy: characterSet).joined())
            }
        }
    }
    
    // DatePickerの値を一時的に保持
    func didChangeDate(_ datePicker: UIDatePicker) {
        // 編集したTextFieldが設置されたセルのセクション値を取得
        selectedSection = datePicker.tag
        
        // 編集されたセルのセクション値を引数sectionに割り当てる
        if let threeDateCell = tableView.cellForRow(at: IndexPath(row: 0, section: selectedSection!)) as? ThreeDateInputKicksInfoTableViewCellController {
            if datePicker == threeDateCell.releaseDatePicker {
                selectedReleaseDate = datePicker.date
            } else if datePicker == threeDateCell.buyDatePicker {
                selectedBuyDate = datePicker.date
            } else if datePicker == threeDateCell.firstDayPicker {
                selectedFirstDay = datePicker.date
            }
            
        } else if let lostDateCell = tableView.cellForRow(at: IndexPath(row: 0, section: selectedSection!)) as? OneDateInputKicksInfoTableViewCellController, datePicker == lostDateCell.lostDatePicker {
            selectedLostDate = datePicker.date
        }
    }
    
    // 画像が変更された場合、保存されていた画像ファイルを削除する
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
    
    
    // 保存ボタンを押したらデータを保存して、一覧ページに画面遷移
    @IBAction func saveButton(_ sender: Any) {
        // 合計金額の計算
        let inputValues: [Int32?] = [inputKicksFee, inputSystemFee, inputShippingFee, inputCustomsDuty, inputOtherCosts]
        let validValues = inputValues.compactMap { $0 }
        let totalAmount = validValues.reduce(0, +)
        
        let realm = try! Realm()
        if self.nowKicksEditData != nil {
            // Nowデータの更新
            // 編集するデータをidで検索
            let targetNowKicksData = realm.objects(NowKicksDataModel.self)
            // NSPredicateを使用して安全なクエリを構築
            let predicate = NSPredicate(format: "id == %@", self.nowKicksEditData!.id as CVarArg)
            let filteredNowKicksData = targetNowKicksData.filter(predicate)
            try! realm.write {
                for nowData in filteredNowKicksData {
                    if nowData.image != selectedImageName {
                        // 別画像が選択された場合、元画像ファイルを削除する
                        deleteImageFile(image: nowData.image)
                        // 新たに選択された画像を保村する
                        nowData.image = setImage(image: selectedImage, fileName: selectedImageName)!
                    }
                    nowData.kicksName = inputKicksName ?? ""
                    nowData.brand = inputBrand ?? ""
                    nowData.series = inputSeries ?? ""
                    nowData.styleCode = inputStyleCode ?? ""
                    nowData.color1 = inputColor1 ?? ""
                    nowData.color2 = inputColor2 ?? ""
                    nowData.color3 = inputColor3 ?? ""
                    nowData.releaseDate = selectedReleaseDate ?? Date()
                    nowData.buyDate = selectedBuyDate ?? Date()
                    nowData.firstDay = selectedFirstDay ?? Date()
                    nowData.purchaseLocation = inputPurchaseLocation ?? ""
                    nowData.listPrice = inputListPrice ?? 0
                    nowData.kicksFee = inputKicksFee ?? 0
                    nowData.systemFee = inputSystemFee ?? 0
                    nowData.shippingFee = inputShippingFee ?? 0
                    nowData.customsDuty = inputCustomsDuty ?? 0
                    nowData.otherCosts = inputOtherCosts ?? 0
                    nowData.totalAmount = totalAmount
                    nowData.size = inputSize ?? 0
                    nowData.memo = inputMemo ?? ""
                }
            }
            // 詳細ページに戻る
            self.navigationController?.popViewController(animated: true)
        } else if self.pastKicksEditData != nil {
            // Pastデータの更新
            // 編集するデータをidで検索
            let targetPastKicksData = realm.objects(PastKicksDataModel.self)
            // NSPredicateを使用して安全なクエリを構築
            let predicate = NSPredicate(format: "id == %@", self.pastKicksEditData!.id as CVarArg)
            let filteredPastKicksData = targetPastKicksData.filter(predicate)
            try! realm.write {
                for pastData in filteredPastKicksData {
                    if pastData.image != selectedImageName {
                        // 別画像が選択された場合、元画像ファイルを削除する
                        deleteImageFile(image: pastData.image)
                        // 新たに選択された画像を保村する
                        pastData.image = setImage(image: selectedImage, fileName: selectedImageName)!
                    }
                    pastData.kicksName = inputKicksName ?? ""
                    pastData.brand = inputBrand ?? ""
                    pastData.series = inputSeries ?? ""
                    pastData.styleCode = inputStyleCode ?? ""
                    pastData.color1 = inputColor1 ?? ""
                    pastData.color2 = inputColor2 ?? ""
                    pastData.color3 = inputColor3 ?? ""
                    pastData.releaseDate = selectedReleaseDate ?? Date()
                    pastData.buyDate = selectedBuyDate ?? Date()
                    pastData.firstDay = selectedFirstDay ?? Date()
                    pastData.lostDate = selectedLostDate ?? Date()
                    pastData.purchaseLocation = inputPurchaseLocation ?? ""
                    pastData.listPrice = inputListPrice ?? 0
                    pastData.kicksFee = inputKicksFee ?? 0
                    pastData.systemFee = inputSystemFee ?? 0
                    pastData.shippingFee = inputShippingFee ?? 0
                    pastData.customsDuty = inputCustomsDuty ?? 0
                    pastData.otherCosts = inputOtherCosts ?? 0
                    pastData.totalAmount = totalAmount
                    pastData.size = inputSize ?? 0
                    pastData.memo = inputMemo ?? ""
                }
            }
            // 詳細ページに戻る
            self.navigationController?.popViewController(animated: true)
        } else if self.lostKicksData != nil {
            // 手放すボタンが押されて、さらに保存ボタンが押された場合
            let targetNowKicksData = realm.objects(NowKicksDataModel.self)
            let predicate = NSPredicate(format: "id == %@", self.lostKicksData!.id as CVarArg)
            let filteredNowKicksData = targetNowKicksData.filter(predicate)
            
            try! realm.write {
                // 別画像が選択された場合、元画像ファイルを削除する
                if let nowData = filteredNowKicksData.first {
                    if nowData.image != selectedImageName{
                        deleteImageFile(image: nowData.image)
                    }
                }
                pastKicksData.image = setImage(image: selectedImage, fileName: selectedImageName)!
                pastKicksData.kicksName = inputKicksName ?? ""
                pastKicksData.brand = inputBrand ?? ""
                pastKicksData.series = inputSeries ?? ""
                pastKicksData.styleCode = inputStyleCode ?? ""
                pastKicksData.color1 = inputColor1 ?? ""
                pastKicksData.color2 = inputColor2 ?? ""
                pastKicksData.color3 = inputColor3 ?? ""
                pastKicksData.releaseDate = selectedReleaseDate ?? Date()
                pastKicksData.buyDate = selectedBuyDate ?? Date()
                pastKicksData.firstDay = selectedFirstDay ?? Date()
                pastKicksData.lostDate = selectedLostDate ?? Date()
                pastKicksData.purchaseLocation = inputPurchaseLocation ?? ""
                pastKicksData.listPrice = inputListPrice ?? 0
                pastKicksData.kicksFee = inputKicksFee ?? 0
                pastKicksData.systemFee = inputSystemFee ?? 0
                pastKicksData.shippingFee = inputShippingFee ?? 0
                pastKicksData.customsDuty = inputCustomsDuty ?? 0
                pastKicksData.otherCosts = inputOtherCosts ?? 0
                pastKicksData.totalAmount = totalAmount
                pastKicksData.size = inputSize ?? 0
                pastKicksData.memo = inputMemo ?? ""
                realm.add(pastKicksData)
                
                // 該当のNowKicksデータを削除する
                realm.delete(filteredNowKicksData)
            }
            // 詳細ページに戻る
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            // 新規データの作成
            try! realm.write {
                if isNow {
                    if selectedImage != nil {
                        nowKicksData.image = setImage(image: selectedImage, fileName: selectedImageName)!
                    } else {
                        selectedImageName = generateFileName(image: kicksDefaultImage)
                        nowKicksData.image = setImage(image: kicksDefaultImage, fileName: selectedImageName)!
                    }
                    nowKicksData.kicksName = inputKicksName ?? ""
                    nowKicksData.brand = inputBrand ?? ""
                    nowKicksData.series = inputSeries ?? ""
                    nowKicksData.styleCode = inputStyleCode ?? ""
                    nowKicksData.color1 = inputColor1 ?? ""
                    nowKicksData.color2 = inputColor2 ?? ""
                    nowKicksData.color3 = inputColor3 ?? ""
                    nowKicksData.releaseDate = selectedReleaseDate ?? Date()
                    nowKicksData.buyDate = selectedBuyDate ?? Date()
                    nowKicksData.firstDay = selectedFirstDay ?? Date()
                    nowKicksData.purchaseLocation = inputPurchaseLocation ?? ""
                    nowKicksData.listPrice = inputListPrice ?? 0
                    nowKicksData.kicksFee = inputKicksFee ?? 0
                    nowKicksData.systemFee = inputSystemFee ?? 0
                    nowKicksData.shippingFee = inputShippingFee ?? 0
                    nowKicksData.customsDuty = inputCustomsDuty ?? 0
                    nowKicksData.otherCosts = inputOtherCosts ?? 0
                    nowKicksData.totalAmount = totalAmount
                    nowKicksData.size = inputSize ?? 0
                    nowKicksData.memo = inputMemo ?? ""
                    realm.add(nowKicksData)
                } else {
                    if selectedImage != nil {
                        pastKicksData.image = setImage(image: selectedImage, fileName: selectedImageName)!
                    } else {
                        selectedImageName = generateFileName(image: kicksDefaultImage)
                        pastKicksData.image = setImage(image: kicksDefaultImage, fileName: selectedImageName)!
                    }
                    pastKicksData.kicksName = inputKicksName ?? ""
                    pastKicksData.brand = inputBrand ?? ""
                    pastKicksData.series = inputSeries ?? ""
                    pastKicksData.styleCode = inputStyleCode ?? ""
                    pastKicksData.color1 = inputColor1 ?? ""
                    pastKicksData.color2 = inputColor2 ?? ""
                    pastKicksData.color3 = inputColor3 ?? ""
                    pastKicksData.releaseDate = selectedReleaseDate ?? Date()
                    pastKicksData.buyDate = selectedBuyDate ?? Date()
                    pastKicksData.firstDay = selectedFirstDay ?? Date()
                    pastKicksData.lostDate = selectedLostDate ?? Date()
                    pastKicksData.purchaseLocation = inputPurchaseLocation ?? ""
                    pastKicksData.listPrice = inputListPrice ?? 0
                    pastKicksData.kicksFee = inputKicksFee ?? 0
                    pastKicksData.systemFee = inputSystemFee ?? 0
                    pastKicksData.shippingFee = inputShippingFee ?? 0
                    pastKicksData.customsDuty = inputCustomsDuty ?? 0
                    pastKicksData.otherCosts = inputOtherCosts ?? 0
                    pastKicksData.totalAmount = totalAmount
                    pastKicksData.size = inputSize ?? 0
                    pastKicksData.memo = inputMemo ?? ""
                    realm.add(pastKicksData)
                }
            }
            // 一覧ページに戻る
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}



extension InputKicksInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var sectionCount: Int // 表示するセクション数
        // セクションの出し分け
        if isNow {
            sectionArray.removeAll(where: { $0 == InputSection.oneDate }) // [下ろした日]を配列から削除する
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
        // xibを描画
        switch sectionArray[indexPath.section] {
        case .image:
            let imageCell = tableView.dequeueReusableCell(withIdentifier: "imageSetCell", for: indexPath) as! ImageSetKicksInfoTableViewCellController
            imageCell.delegate = self
            if selectedImage != nil {
                imageCell.picImageView.image = selectedImage
            }
            return imageCell
            
        case .kicksName:
            let kicksNameCell = tableView.dequeueReusableCell(withIdentifier: "singleTextViewInputCell", for: indexPath) as! SingleTextViewInputKicksInfoTableViewCellController
            kicksNameCell.textView.delegate = self
            kicksNameCell.textView.tag = indexPath.section
            kicksNameCell.titleLabel.text = "名称"
            kicksNameCell.textView.placeHolder = "名称"
            kicksNameCell.textView.text = inputKicksName ?? ""
            return kicksNameCell
            
        case .brand:
            let brandCell = tableView.dequeueReusableCell(withIdentifier: "singleTextViewInputCell", for: indexPath) as! SingleTextViewInputKicksInfoTableViewCellController
            brandCell.textView.delegate = self
            brandCell.textView.tag = indexPath.section
            brandCell.titleLabel.text = "ブランド"
            brandCell.textView.placeHolder = "ブランド名"
            brandCell.textView.text = inputBrand ?? ""
            return brandCell
            
        case .series:
            let seriesCell = tableView.dequeueReusableCell(withIdentifier: "singleTextViewInputCell", for: indexPath) as! SingleTextViewInputKicksInfoTableViewCellController
            seriesCell.textView.delegate = self
            seriesCell.textView.tag = indexPath.section
            seriesCell.titleLabel.text = "シリーズ"
            seriesCell.textView.placeHolder = "シリーズ名"
            seriesCell.textView.text = inputSeries ?? ""
            return seriesCell
            
        case .styleCode:
            let styleCodeCell = tableView.dequeueReusableCell(withIdentifier: "singleTextFieldInputCell", for: indexPath) as! SingleTextFieldInputKicksInfoTableViewCellController
            styleCodeCell.textField.delegate = self
            styleCodeCell.textField.tag = indexPath.section
            styleCodeCell.titleLabel.text = "スタイルコード"
            styleCodeCell.textField.placeholder = "style-code"
            styleCodeCell.textField.text = inputStyleCode ?? ""
            return styleCodeCell
            
        case .color:
            let colorCell = tableView.dequeueReusableCell(withIdentifier: "colorInputCell", for: indexPath) as! ColorInputKicksInfoTableViewCellController
            colorCell.colorTextField1.delegate = self
            colorCell.colorTextField2.delegate = self
            colorCell.colorTextField3.delegate = self
            colorCell.colorTextField1.tag = indexPath.section
            colorCell.colorTextField2.tag = indexPath.section
            colorCell.colorTextField3.tag = indexPath.section
            colorCell.colorLabel1.text = "カラー①"
            colorCell.colorTextField1.placeholder = "カラー①"
            colorCell.colorLabel2.text = "カラー②"
            colorCell.colorTextField2.placeholder = "カラー②"
            colorCell.colorLabel3.text = "カラー③"
            colorCell.colorTextField3.placeholder = "カラー③"
            colorCell.colorTextField1.text = inputColor1 ?? ""
            colorCell.colorTextField2.text = inputColor2 ?? ""
            colorCell.colorTextField3.text = inputColor3 ?? ""
            return colorCell
            
        case .threeDate:
            let threeDateCell = tableView.dequeueReusableCell(withIdentifier: "threeDateInputCell", for: indexPath) as! ThreeDateInputKicksInfoTableViewCellController
            threeDateCell.delegate = self
            threeDateCell.releaseDatePicker.tag = indexPath.section
            threeDateCell.buyDatePicker.tag = indexPath.section
            threeDateCell.firstDayPicker.tag = indexPath.section
            threeDateCell.releaseDateLabel.text = "発売日"
            threeDateCell.buyDateLabel.text = "購入日"
            threeDateCell.firstDayLabel.text = "下ろした日"
            threeDateCell.releaseDatePicker.date = selectedReleaseDate ?? Date()
            threeDateCell.buyDatePicker.date = selectedBuyDate ?? Date()
            threeDateCell.firstDayPicker.date = selectedFirstDay ?? Date()
            return threeDateCell
            
        case .oneDate:
            let oneDateCell = tableView.dequeueReusableCell(withIdentifier: "oneDateInputCell", for: indexPath) as! OneDateInputKicksInfoTableViewCellController
            oneDateCell.delegate = self
            oneDateCell.lostDatePicker.tag = indexPath.section
            oneDateCell.lostDateLabel.text = "手放した日"
            oneDateCell.lostDatePicker.date = selectedLostDate ?? Date()
            return oneDateCell
            
        case .purchaseLocation:
            let purchaseLocationCell = tableView.dequeueReusableCell(withIdentifier: "singleTextFieldInputCell", for: indexPath) as! SingleTextFieldInputKicksInfoTableViewCellController
            purchaseLocationCell.textField.delegate = self
            purchaseLocationCell.textField.tag = indexPath.section
            purchaseLocationCell.titleLabel.text = "購入先"
            purchaseLocationCell.textField.placeholder = "購入先"
            purchaseLocationCell.textField.keyboardType = .default
            purchaseLocationCell.textField.text = inputPurchaseLocation ?? ""
            return purchaseLocationCell
            
        case .listPrice:
            let listPriceCell = tableView.dequeueReusableCell(withIdentifier: "singleTextFieldInputCell", for: indexPath) as! SingleTextFieldInputKicksInfoTableViewCellController
            listPriceCell.textField.delegate = self
            listPriceCell.textField.tag = indexPath.section
            listPriceCell.titleLabel.text = "定価"
            listPriceCell.textField.placeholder = "円"
            listPriceCell.textField.keyboardType = .numberPad
            if inputListPrice != nil {
                listPriceCell.textField.text = String(inputListPrice!)
            }
            return listPriceCell
            
        case .amount:
            let amountCell = tableView.dequeueReusableCell(withIdentifier: "amountInputCell", for: indexPath) as! AmountInputKicksInfoTableViewCellController
            amountCell.kicksFeeTextField.delegate = self
            amountCell.systemFeeTextField.delegate = self
            amountCell.shippingFeeTextField.delegate = self
            amountCell.customsDutyTextField.delegate = self
            amountCell.otherCostsTextField.delegate = self
            amountCell.kicksFeeTextField.tag = indexPath.section
            amountCell.systemFeeTextField.tag = indexPath.section
            amountCell.shippingFeeTextField.tag = indexPath.section
            amountCell.customsDutyTextField.tag = indexPath.section
            amountCell.otherCostsTextField.tag = indexPath.section
            amountCell.amountTitleLabel.text = "購入金額"
            amountCell.kicksFeeLabel.text = "スニーカー"
            amountCell.kicksFeeTextField.placeholder = "円"
            amountCell.systemFeeLabel.text = "システム手数料"
            amountCell.systemFeeTextField.placeholder = "円"
            amountCell.shippingFeeLabel.text = "送料"
            amountCell.shippingFeeTextField.placeholder = "円"
            amountCell.customsDutyLabel.text = "関税"
            amountCell.customsDutyTextField.placeholder = "円"
            amountCell.otherCostsLabel.text = "その他"
            amountCell.otherCostsTextField.placeholder = "円"
            amountCell.totalAmountLabel.text = "合計"
            amountCell.totalAmount.text = "\(totalAmount ?? 0)円"
            if inputKicksFee != nil {
                amountCell.kicksFeeTextField.text = String(inputKicksFee!)
            }
            if inputSystemFee != nil {
                amountCell.systemFeeTextField.text = String(inputSystemFee!)
            }
            if inputShippingFee != nil {
                amountCell.shippingFeeTextField.text = String(inputShippingFee!)
            }
            if inputCustomsDuty != nil {
                amountCell.customsDutyTextField.text = String(inputCustomsDuty!)
            }
            if inputOtherCosts != nil {
                amountCell.otherCostsTextField.text = String(inputOtherCosts!)
            }
            return amountCell
            
        case .size:
            let sizeCell = tableView.dequeueReusableCell(withIdentifier: "singleTextFieldInputCell", for: indexPath) as! SingleTextFieldInputKicksInfoTableViewCellController
            sizeCell.textField.delegate = self
            sizeCell.textField.tag = indexPath.section
            sizeCell.titleLabel.text = "サイズ"
            sizeCell.textField.placeholder = "cm"
            sizeCell.textField.keyboardType = .numbersAndPunctuation
            if inputSize != nil {
                sizeCell.textField.text = String(inputSize!)
            }
            return sizeCell
            
        case .memo:
            let memoCell = tableView.dequeueReusableCell(withIdentifier: "singleTextViewInputCell", for: indexPath) as! SingleTextViewInputKicksInfoTableViewCellController
            memoCell.textView.delegate = self
            memoCell.textView.tag = indexPath.section
            memoCell.titleLabel.text = "メモ"
            memoCell.textView.placeHolder = "メモ"
            memoCell.textView.text = inputMemo ?? ""
            return memoCell
        }
    }
}


extension InputKicksInfoViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // カメラロールを閉じる
        picker.dismiss(animated: true, completion: nil)
        
        // 選択された画像にアクセス
        for result in results {
            // itemProviderメソッドで画像を非同期にロード
            result.itemProvider.loadObject(ofClass: UIImage.self) { [self] (object, error) in
                // ロードが成功し、取得したオブジェクトがUIImage型である場合に処理実行
                if let image = object as? UIImage {
                    // 選択された画像をUIImage型とString型で保持
                    selectedImage = image
                    selectedImageName = generateFileName(image: selectedImage)
                    
                    // メインスレッドで実行(UI更新)
                    // セルに選択した画像を表示
                    DispatchQueue.main.async {
                        if let imageCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ImageSetKicksInfoTableViewCellController {
                            imageCell.picImageView.image = image
                        }
                    }
                }
            }
        }
    }
}
