//
//  LeftMenuVC.swift
//  ParkOye
//
//  Created by Gaurav Prakash on 31/10/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import UIKit

class LeftMenuVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var type:HomeScreenType!
    var menuItems = ["Home","Valet","Search NearBy","S.O.S","Share this App","Contact Us","Suggestions & Feedback", "Logout"]
    var contactType:ContactType!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor =  .white
        tableView.separatorColor = .clear
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Logout":
            DefaultManager.setLogged(value: false)
        case "Suggestions & Feedback":
            (segue.destination.children.last as? SuggestionVC)?.contactType = .SUGGESTION
        case "Contact Us":
            (segue.destination.children.last as? SuggestionVC)?.contactType = .CONTACTUS
        case "Share this App":
            (segue.destination.children.last as? DashboardVC)?.type = .SHARE
        case "Home":
            (segue.destination.children.last as? DashboardVC)?.type = .HOME
        case "Valet":
            (segue.destination.children.last as? DashboardVC)?.type = .VALET
        default:
            break
        }
    }
}

extension LeftMenuVC:UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return menuItems.count
        default:
            break
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
            if let userData  = DefaultManager.sharedInstance.getUserdata(){
                cell.setUpUserData(data: userData)
            }
        
        case 1:
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: Theme.Strings.cellIdentifier, for: indexPath)
            cell.textLabel?.text = menuItems[indexPath.row]
            cell.textLabel?.textColor = .black
            return cell
        default:
           return UITableViewCell()
        }
         return UITableViewCell()
    }
    
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
        return 160
    default:
        return UITableView.automaticDimension
    }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: menuItems[indexPath.row], sender: nil)
    }
    
    }

class UserCell: UITableViewCell{
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var useremail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpUserData(data:UserData){
        if let name = data.name{
            self.username.text = "Welcome \(name)"
        }
        if let email = data.email{
            self.useremail.text = email
        }
        else{
           self.useremail.text = data.mobile ?? "NA"
        }
    }
    
}
