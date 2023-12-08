//
//  ViewController.swift
//  CarDiaryApp
//
//  Created by naoya on 2023/12/07.
//

import UIKit
import RealmSwift

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    var diaryModel:Results<DiaryModel>!
    let realm = try! Realm()
    var token:NotificationToken!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        diaryModel = realm.objects(DiaryModel.self).sorted(byKeyPath: "date")
        token = realm.observe{ notification,realm in
            self.tableView.reloadData()
        }
        tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")

    }
    
    //自動生成
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryModel.count
    }
    
    //自動生成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
        let diary = diaryModel[indexPath.row]
        
        
        
        //タイトルを代入
        cell.title.text = diary.title
        cell.title.numberOfLines = 0
        cell.title.lineBreakMode = .byWordWrapping
        
        //画像を代入
        if let imageData = diary.photoData, let image = UIImage(data: imageData) {
            cell.img.image = image
        } else {
            cell.img.image = nil // もし画像がない場合は何も表示しない
        }
        
        //日付を代入
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        cell.date.text = formatter.string(from: diary.date)
        
        return cell
    }
    

//        self.present(self.storyboard!.instantiateViewController(withIdentifier: "showView"), animated: true, completion: nil)
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "showView") {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    //削除機能
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let diary = diaryModel[indexPath.row]
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:  [diary.id])
            try! realm.write(withoutNotifying: [token]){
                realm.delete(diary)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

