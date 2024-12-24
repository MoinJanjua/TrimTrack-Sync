//
//  StaffViewController.swift
//  TrimTrack Sync
//
//  Created by Unique Consulting Firm on 20/12/2024.
//

import UIKit

class StaffViewController: UIViewController {

    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var noDataLabel: UIImageView!
    @IBOutlet weak var addbrn: UIButton!

    var staff_record: [Staff] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.dataSource = self
        TableView.delegate = self
        roundCorner(button: addbrn)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        // Load data from UserDefaults
        // Retrieve stored medication records from UserDefaults
        if let savedData = UserDefaults.standard.array(forKey: "staffRecord") as? [Data] {
            let decoder = JSONDecoder()
            staff_record = savedData.compactMap { data in
                do {
                    let medication = try decoder.decode(Staff.self, from: data)
                    return medication
                } catch {
                    print("Error decoding medication: \(error.localizedDescription)")
                    return nil
                }
            }
        }
        // Set the message
        // Show or hide the table view and label based on data availability
               if staff_record.isEmpty {
                   TableView.isHidden = true
                   noDataLabel.isHidden = false  // Show the label when there's no data
               } else {
                   TableView.isHidden = false
                   noDataLabel.isHidden = true   // Hide the label when data is available
               }
     TableView.reloadData()
    }
 
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CreateStaffViewController") as! CreateStaffViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }


}
extension StaffViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staff_record.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! staffTableViewCell
        
        let UserData = staff_record[indexPath.row]
        cell.nameLbl?.text = UserData.Name
        cell.ContactLbl?.text = "Contact :\(UserData.contact)"
        cell.designbl?.text = "Designation : \(UserData.designation)"
        cell.addresslb?.text = "Address : \(UserData.address)"
        cell.joiningdateLbl.text = "\(UserData.joiningDate)"
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
        
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the item from the staff_record array
            staff_record.remove(at: indexPath.row)
            
            // Re-encode the updated list and save it to UserDefaults
            let encoder = JSONEncoder()
            do {
                let encodedData = try staff_record.map { try encoder.encode($0) }
                UserDefaults.standard.set(encodedData, forKey: "staffRecord")
            } catch {
                print("Error encoding medications: \(error.localizedDescription)")
            }
            
            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let userData = staff_record[indexPath.row]
   
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let newViewController = storyBoard.instantiateViewController(withIdentifier: "CreateStaffViewController") as? CreateStaffViewController {
            newViewController.selected_staff_record = userData
            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
            
        }
        
    }
}
