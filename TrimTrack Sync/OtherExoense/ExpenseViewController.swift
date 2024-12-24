//
//  ExpenseViewController.swift
//  TrimTrack Sync
//
//  Created by Unique Consulting Firm on 21/12/2024.
//

import UIKit

class ExpenseViewController: UIViewController {

    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var noDataLabel: UIImageView!
    @IBOutlet weak var addbrn: UIButton!

    var expense: [ExpenseAmount] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.dataSource = self
        TableView.delegate = self
        roundCorner(button: addbrn)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchRecord()
    }
    
    func fetchRecord()
    {
        if let savedData = UserDefaults.standard.array(forKey: "ExpenseAmount") as? [Data] {
            let decoder = JSONDecoder()
            expense = savedData.compactMap { data in
                do {
                    let medication = try decoder.decode(ExpenseAmount.self, from: data)
                    return medication
                } catch {
                    print("Error decoding medication: \(error.localizedDescription)")
                    return nil
                }
            }
        }
      
               if expense.isEmpty {
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
    
    @IBAction func expenseButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "ExpenseAmount")
        expense.removeAll()
        fetchRecord()
        
    }
    
    @IBAction func addButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CreateExpenseViewController") as! CreateExpenseViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }


}
extension ExpenseViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expense.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! expenseTableViewCell
        
        let UserData = expense[indexPath.row]
        cell.expenseLbl?.text = UserData.expenseName
       // cell.ContactLbl?.text = "Contact :\(UserData.contact)"
        cell.amounlb?.text = "Amount Paid : \(UserData.amount)"
        cell.dateLbl?.text = "\(UserData.date)"
        cell.otherlb.text = "Other :\(UserData.other)"
        if UserData.other.isEmpty
        {
            cell.otherlb.text = "N/A"
        }
       
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
        
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the item from the staff_record array
            expense.remove(at: indexPath.row)
            
            // Re-encode the updated list and save it to UserDefaults
            let encoder = JSONEncoder()
            do {
                let encodedData = try expense.map { try encoder.encode($0) }
                UserDefaults.standard.set(encodedData, forKey: "ExpenseAmount")
            } catch {
                print("Error encoding medications: \(error.localizedDescription)")
            }
            
            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let userData = expense[indexPath.row]
   
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let newViewController = storyBoard.instantiateViewController(withIdentifier: "CreateStaffViewController") as? CreateExpenseViewController {
            newViewController.selected_staff_record = userData
            newViewController.expense_id = userData.id
            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
            
        }
        
    }
}
