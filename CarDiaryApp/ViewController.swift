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

    }
    
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let diary = diaryModel[indexPath.row]
        cell?.textLabel?.text = diary.title
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        cell?.detailTextLabel?.text = formatter.string(from: diary.date)
        return cell!
    }
}

