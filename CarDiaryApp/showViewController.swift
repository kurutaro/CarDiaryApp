//
//  showViewController.swift
//  CarDiaryApp
//
//  Created by naoya on 2023/12/07.
//

import UIKit
import MapKit

class showViewController: UIViewController {
    
    var selectedDiary: DiaryModel?
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(selectedDiary?.latitude as Any)
        titleLabel.text = selectedDiary?.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        if let date = selectedDiary?.date {
            dateLabel.text = formatter.string(from: date)
        } else {
            dateLabel.text = "日付なし"
        }
        
        if let imageData = selectedDiary?.photoData, let image = UIImage(data: imageData) {
            img.image = image
        } else {
            img.image = UIImage(named: "defaultImage") // もしくは適切なデフォルト画像を設定
        }

        if let latitude = selectedDiary?.latitude, let longitude = selectedDiary?.longitude {
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            mapView.addAnnotation(annotation)
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        } else {
            // 位置情報がない場合の処理を記述する（デフォルト位置などを表示する）
        }
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
