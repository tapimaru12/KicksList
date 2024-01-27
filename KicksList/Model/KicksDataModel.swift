import Foundation
import RealmSwift

class NowKicksDataModel: Object {
    @objc dynamic var id: String = UUID().uuidString // 識別子
    @objc dynamic var image: String = ""// 画像
    @objc dynamic var kicksName: String = "" // 名称
    @objc dynamic var brand: String = "" // ブランド
    @objc dynamic var series: String = "" // シリーズ
    @objc dynamic var styleCode: String = "" // スタイルコード
    @objc dynamic var color1: String = "" // カラー①
    @objc dynamic var color2: String = "" // カラー②
    @objc dynamic var color3: String = "" // カラー③
    @objc dynamic var releaseDate: Date = Date() // 発売日
    @objc dynamic var purchaseDate: Date = Date() // 購入日
    @objc dynamic var firstDay: Date = Date() // 下ろした日
    @objc dynamic var purchaseLocation: String = "" // 購入場所
    @objc dynamic var listPrice: Int32 = 0 // 定価
    @objc dynamic var kicksFee: Int32 = 0 // スニーカー代
    @objc dynamic var systemFee: Int32 = 0 // システム手数料
    @objc dynamic var shippingFee: Int32 = 0 // 送料
    @objc dynamic var customsDuty: Int32 = 0 // 関税
    @objc dynamic var otherCosts: Int32 = 0 // その他(金額)
    @objc dynamic var totalAmount: Int32 = 0 // トータル金額
    @objc dynamic var size: Float = 0.0 // サイズ
    @objc dynamic var memo: String = "" // メモ
}


class PastKicksDataModel: Object {
    @objc dynamic var id: String = UUID().uuidString // 識別子
    @objc dynamic var image: String = ""// 画像
    @objc dynamic var kicksName: String = "" // 名称
    @objc dynamic var brand: String = "" // ブランド
    @objc dynamic var series: String = "" // シリーズ
    @objc dynamic var styleCode: String = "" // スタイルコード
    @objc dynamic var color1: String = "" // カラー①
    @objc dynamic var color2: String = "" // カラー②
    @objc dynamic var color3: String = "" // カラー③
    @objc dynamic var releaseDate: Date = Date() // 発売日
    @objc dynamic var purchaseDate: Date = Date() // 購入日
    @objc dynamic var firstDay: Date = Date() // 下ろした日
    @objc dynamic var lostDate: Date = Date() // 手放した日
    @objc dynamic var purchaseLocation: String = "" // 購入場所
    @objc dynamic var listPrice: Int32 = 0 // 定価
    @objc dynamic var kicksFee: Int32 = 0 // スニーカー代
    @objc dynamic var systemFee: Int32 = 0 // システム手数料
    @objc dynamic var shippingFee: Int32 = 0 // 送料
    @objc dynamic var customsDuty: Int32 = 0 // 関税
    @objc dynamic var otherCosts: Int32 = 0 // その他(金額)
    @objc dynamic var totalAmount: Int32 = 0 // トータル金額
    @objc dynamic var size: Float = 0.0 // サイズ
    @objc dynamic var memo: String = "" // メモ
}
