//
//  StatusViewController.swift
//  Worklist
//
//  Created by Bimalesh Sahoo on 04/11/18.
//  Copyright © 2018 Bimalesh Sahoo. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var statusTableView: UITableView!
    
    @IBOutlet weak var lblStatusCount: UILabel!
    
    @IBOutlet weak var btnAutoApproval: UIButton!
    @IBOutlet weak var btnFloatStatus: UIButton!
    @IBOutlet weak var btnFloatTask: UIButton!
    @IBOutlet weak var btnFloatApproval: UIButton!
    @IBOutlet weak var btnFloatClose: UIButton!
    @IBOutlet weak var floatingBtnView: UIView!

    var statusDataList = [StatusData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusData()
        lblStatusCount.text = String(statusDataList.count)
        lblStatusCount.layer.cornerRadius = lblStatusCount.frame.width / 2
        lblStatusCount.layer.masksToBounds = true
        
	//floating btn actions
        btnFloatClose.addTarget(self, action: #selector(close), for: .touchUpInside)
        btnFloatApproval.addTarget(self, action: #selector(approval), for: .touchUpInside)
        btnFloatTask.addTarget(self, action: #selector(task), for: .touchUpInside)
        btnFloatStatus.addTarget(self, action: #selector(status), for: .touchUpInside)
        btnAutoApproval.addTarget(self, action: #selector(autoApproval), for: .touchUpInside)
	
    }
    
    //table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = statusTableView.dequeueReusableCell(withIdentifier: "status", for: indexPath as IndexPath) as! StatusViewCell
        
        var data = StatusData()
        
        data = statusDataList[indexPath.row]
        
        cell.statusType.text = data.statusType
        cell.profileImage.image = data.profileImage
        cell.daysLeft.text = "Days Left: " + String(data.daysLeft)
        cell.escalation.text = data.escalationType
        
        //priority color setting property
        if data.daysLeft == 0 {
            cell.priorityIndicator.backgroundColor = #colorLiteral(red: 0.8941176471, green: 0.1921568627, blue: 0.2431372549, alpha: 1)
        } else if data.daysLeft < 5 && data.daysLeft > 0 {
            cell.priorityIndicator.backgroundColor = #colorLiteral(red: 1, green: 0.6823529412, blue: 0, alpha: 1)
        } else if data.daysLeft > 4 {
            cell.priorityIndicator.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            cell.priorityIndicator.layer.borderWidth = 1.0
            cell.priorityIndicator.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        // yes and no colour property setting
        if cell.escalation.text == "Yes" {
            cell.escalation.textColor = #colorLiteral(red: 0.1215686275, green: 0.7137254902, blue: 1, alpha: 1)
        } else if cell.escalation.text == "No" {
            cell.escalation.textColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //swipe Row Actions
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let reminder = UIContextualAction.init(style: .normal, title: "Send Reminder") { (action, view, nil) in
            
            self.statusTableView.reloadData()
            
            utilities.displayAlert(title: "Alert !", message: "Reminder Successfully Sent.")
        }
        
        reminder.image = UIImage(named: "reminder-icon")
        reminder.backgroundColor = #colorLiteral(red: 0, green: 0.6352941176, blue: 0.8784313725, alpha: 1)
        
        let config = UISwipeActionsConfiguration(actions: [reminder])
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
    
    
    func statusData() {
        
        var statusType : [String] = ["My Time", "My Learning", "My Career", "My Time","My Time", "My Goal", "My Career", "My Time"]
        var escalation : [String] = ["Yes", "Yes", "No", "Yes", "No", "Yes", "No", "Yes"]
        
        var profileImage : [UIImage] = [UIImage(named: "profile1")!,UIImage(named: "profile2")!, UIImage(named: "profile3")!,UIImage(named: "profile2")!, UIImage(named: "profile1")!,UIImage(named: "profile3")!, UIImage(named: "profile1")!,UIImage(named: "profile2")!]
        
        var daysLeft : [Int] = [2, 0, 1, 2, 5, 7, 8, 2]
        
        for i in 0...7 {
            
            let statusData = StatusData()
            
            statusData.statusType = statusType[i]
            statusData.profileImage = profileImage[i]
            statusData.daysLeft = daysLeft[i]
            statusData.escalationType = escalation[i]
            
            statusDataList.append(statusData)
        
        }
            
    }
    
    //objc function definations
    
    @objc func showMoreTaskViewButton()  {
        
        let taskView = self.storyboard?.instantiateViewController(withIdentifier: "TaskApprovalViewController") as! TaskApprovalViewController
        
        taskView.segmentControlIndex = 0
        
        self.navigationController?.pushViewController(taskView, animated: true)
        
    }
    
    @objc func seeAllApprovalViewButton()  {
        
        let approvalView = self.storyboard?.instantiateViewController(withIdentifier: "TaskApprovalViewController") as! TaskApprovalViewController
        
        approvalView.segmentControlIndex = 1
        
        self.navigationController?.pushViewController(approvalView, animated: true)
        
    }
    
    
    @objc func close() {
        floatingBtnView.isHidden = true
    }
    
    @objc func approval() {
        floatingBtnView.isHidden = true
        
        seeAllApprovalViewButton()
    }
    
    @objc func task() {
        floatingBtnView.isHidden = true
        
        showMoreTaskViewButton()
    }
    
    @objc func autoApproval() {
        floatingBtnView.isHidden = true
        
        let autoApprovalView = self.storyboard?.instantiateViewController(withIdentifier: "AutoApprovalViewController") as! AutoApprovalViewController
       
        self.navigationController?.pushViewController(autoApprovalView, animated: true)
    }
    
    @objc func status() {
        floatingBtnView.isHidden = true
        
    }
    
    @IBAction func profileTapped(_ sender: Any) {
        let profileView = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        self.navigationController?.pushViewController(profileView, animated: true)
        
    }
    
    @IBAction func notificationTapped(_ sender: Any) {
        let notificationView = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        
        self.navigationController?.pushViewController(notificationView, animated: true)
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        utilities.logoutAlert()

    }
    
    @IBAction func homeTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle : nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        
        let navigationController = UINavigationController(rootViewController: viewController)
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window!.rootViewController = navigationController
    }
    
    @IBAction func menuTapped(_ sender: Any) {
    
            floatingBtnView.isHidden = false
       
    }
    
    @IBAction func searchTapped(_ sender: Any) {
    }
    
}
