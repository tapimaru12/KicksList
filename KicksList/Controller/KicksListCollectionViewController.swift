
import UIKit
import RealmSwift

class KicksListCollectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    // 一行に表示するセルの数
    var itemsPerRow: Int = 2
    
    var currentTab: Int = 0
    
    var nowKicksDataList: [NowKicksDataModel] = []
    var pastKicksDataList: [PastKicksDataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // collectionViewのxibを登録
        let collectionViewNib = UINib(nibName: "KicksListCollectionView", bundle: .main)
        self.view = collectionViewNib.instantiate(withOwner: self).first as? UIView
        
        // collectionViewCellのxibを登録
        let cellNib = UINib(nibName: "TwoGridCollectionViewCell", bundle: nil)
        collectionView!.register(cellNib, forCellWithReuseIdentifier: "twoGridCell")
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setData(tab: currentTab)
        collectionView.reloadData()
    }
    
    // InputInfoページの出し分け
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextView = segue.destination as! InputKicksInfoViewController
        
        if segue.identifier == "toNowInput" {
            nextView.isNow = true
        } else if segue.identifier == "toPastInput" {
            nextView.isNow = false
        }
    }
    
    // データを取得して表示する
    func setData(tab: Int) {
        let realm = try! Realm()
        // 表示するタブがNowタブ(0)ならNowデータ、Pastタブ(1)ならPastデータを取得
        if tab == 0 {
            let result = realm.objects(NowKicksDataModel.self)
            nowKicksDataList = Array(result)
        } else if tab == 1 {
            let result = realm.objects(PastKicksDataModel.self)
            pastKicksDataList = Array(result)
        }
        
        if let collectionView = collectionView {
            collectionView.reloadData()
        }
    }
    
    // 取得したimageデータを画像として表示する
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
}


extension KicksListCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Nowタブ(0)ならNowデータの数、Pastタブ(1)ならPastデータの数
        var cellCount: Int = 0
        if currentTab == 0 {
            cellCount = nowKicksDataList.count
        } else if currentTab == 1 {
            cellCount = pastKicksDataList.count
        }
        return cellCount
    }
    
    // セルの描画
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "twoGridCell", for: indexPath) as! TwoGridCollectionViewCellController
        if currentTab == 0 {
            let nowKicksDataModel: NowKicksDataModel = nowKicksDataList[indexPath.row]
            // 画像取得
            cell.image.image = getImage(image: nowKicksDataModel.image)
            // ブランド名取得
            let brand = nowKicksDataModel.brand
            // シリーズ名取得
            let series = nowKicksDataModel.series
            // ブランド名またはシリーズ名が空欄かどうかで表示方法を変える
            if !brand.isEmpty && !series.isEmpty {
                cell.brandNameLabel.text = "\(brand) > \(series)"
            } else if brand.isEmpty && series.isEmpty {
                cell.brandNameLabel.text = ""
            } else {
                cell.brandNameLabel.text = brand.isEmpty ? series : brand
            }
            // スニーカー名取得
            cell.kicksNameLabel.text = nowKicksDataModel.kicksName
        } else if currentTab == 1 {
            let pastKicksDataModel: PastKicksDataModel = pastKicksDataList[indexPath.row]
            // 画像取得
            cell.image.image = getImage(image: pastKicksDataModel.image)
            // ブランド名取得
            let brand = pastKicksDataModel.brand
            // シリーズ名取得
            let series = pastKicksDataModel.series
            // ブランド名とシリーズ名が空欄かどうかで表示方法を変える
            if !brand.isEmpty && !series.isEmpty {
                cell.brandNameLabel.text = "\(brand) > \(series)"
            } else if brand.isEmpty && series.isEmpty {
                cell.brandNameLabel.text = ""
            } else {
                cell.brandNameLabel.text = brand.isEmpty ? series : brand
            }
            // スニーカー名取得
            cell.kicksNameLabel.text = pastKicksDataModel.kicksName
        }
        return cell
    }
    
    // セルがタップされた時の挙動
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "KicksDetailView", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "kicksDetailView") as! KicksDetailViewController
        // タップされたスニーカーの詳細ページへ遷移
        if currentTab == 0 {
            vc.isNow = true
            vc.nowKicksDetail = nowKicksDataList[indexPath.row]
        } else if currentTab == 1 {
            vc.isNow = false
            vc.pastKicksDetail = pastKicksDataList[indexPath.row]
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension KicksListCollectionViewController: UICollectionViewDelegateFlowLayout {
    // セルのサイズ計算
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // セル表示に使用するビューの幅：「端末幅 - 横のセル同士の余白」
        let availableWidth = collectionView.frame.width - 2
        // セルの幅：「{端末幅 - 余白} / 一行あたりのセルの数」
        let cellWidth = Int(availableWidth) / itemsPerRow
        // セルの高さ：「セル幅 + brandNameLabelの高さ + KicksNameLabelの高さ + セル内の垂直方向のmarginの合計」
        let cellHeight = cellWidth + 15 + 25 + 6
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
