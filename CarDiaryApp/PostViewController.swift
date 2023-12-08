//
//  PostViewController.swift
//  CarDiaryApp
//
//  Created by naoya on 2023/12/07.
//

import UIKit
import RealmSwift
import MapKit

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate, UITextFieldDelegate {
//    @IBOutlet weak var itemField: UITextField!
    @IBOutlet weak var itemField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var contentField: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapView: MKMapView!
    
    let realm = try! Realm()
    let diary = DiaryModel() //作成したモデルのインスタンス
    let imagePicker = UIImagePickerController()
    let totalContentHeight: CGFloat = 10000 // 例として高さを1000に設定
    
    // 画面読み込み時の処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: totalContentHeight)

        datePicker.timeZone = TimeZone.current
        datePicker.locale = Locale.current
        contentField.layer.borderWidth = 1.0
        contentField.layer.borderColor = UIColor.black.cgColor
        itemField.delegate = self
        mapView.delegate = self
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    //タイトルの文字数制限
    @objc(textField:shouldChangeCharactersInRange:replacementString:) func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newText = (text as NSString).replacingCharacters(in: range, with: string)
        
        // 最大文字数を設定（例えば3文字）
        let maxLength = 39
        
        // 入力された文字数が制限を超えていないか確認
        return newText.count <= maxLength
    }

    
    // 写真を選択するボタンがタップされた時の処理
    @IBAction func selectPhotoButton(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    // 写真が選択された時の処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            // 画像を表示する
            imageView.image = selectedImage
            // 画像を圧縮してデータに変換
            if let imageData = selectedImage.jpegData(compressionQuality: 1) {
                diary.photoData = imageData
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    // 写真選択がキャンセルされた時の処理
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //画像をリサイズするメソッド
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    //保存ボタンが押された時の処理
    @IBAction func onAdd(_ sender: Any) {
        
        diary.title = itemField.text!
        diary.date = datePicker.date
        diary.content = contentField.text!
        diary.id = String(Int.random(in: 0...9999))
        try! realm.write{
            realm.add(diary)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        // このcoordinateを使用して選択された位置情報を処理する
        // print(coordinate)
        // 例えば、ピンを表示するなどの処理を行う
        addAnnotationToMap(coordinate: coordinate)
        //緯度経度を格納する
        diary.latitude = coordinate.latitude
        diary.longitude = coordinate.longitude
    }
    
    func addAnnotationToMap(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        let allAnnotations = mapView.annotations
        mapView.removeAnnotations(allAnnotations)
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
