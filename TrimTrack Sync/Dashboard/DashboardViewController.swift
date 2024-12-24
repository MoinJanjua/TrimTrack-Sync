//
//  DashboardViewController.swift
//  TrimTrack Sync
//
//  Created by Unique Consulting Firm on 20/12/2024.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var todayexpense: UILabel!
    @IBOutlet weak var totalexoebse: UILabel!
    
    
    var todayExpense = 0
    var totalExpense = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        totalExpense = 0
        todayExpense = 0
        let currentDate = getCurrentDate1() // Get today's date
        let todaycurrentDate1 = getCurrentDate1()
        // Fetch and process expenses
        if let savedData = UserDefaults.standard.array(forKey: "ExpenseAmount") as? [Data] {
            let decoder = JSONDecoder()
            let expenses = savedData.compactMap { data in
                do {
                    let expense = try decoder.decode(ExpenseAmount.self, from: data)
                    return expense
                } catch {
                    print("Error decoding ExpenseAmount: \(error.localizedDescription)")
                    return nil
                }
            }

            // Calculate total and today's expenses
            totalExpense = expenses.compactMap { Int($0.amount) }.reduce(0, +)
            todayExpense = expenses
                .filter { $0.date == todaycurrentDate1 } // Filter by today's date
                .compactMap { Int($0.amount) }
                .reduce(0, +)
        }

        // Fetch and process sales
        if let savedData = UserDefaults.standard.array(forKey: "salesList") as? [Data] {
            let decoder = JSONDecoder()
            let sales = savedData.compactMap { data in
                do {
                    let sale = try decoder.decode(salesList.self, from: data)
                    return sale
                } catch {
                    print("Error decoding SalesList: \(error.localizedDescription)")
                    return nil
                }
            }

            // Add total sales to totalExpense
            totalExpense += sales.compactMap { Int($0.amount) }.reduce(0, +)
            todayExpense += sales
                .filter { $0.date == todaycurrentDate1 } // Filter by today's date
                .compactMap { Int($0.amount) }
                .reduce(0, +)
        }

        // Update UI
        totalexoebse.text = "$\(totalExpense).00"
        todayexpense.text = "$\(todayExpense).00"
    }

    // Helper function to get today's date
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy" // Match your stored date format
        return formatter.string(from: Date())
    }

    func getCurrentDate1() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Match your stored date format
        return formatter.string(from: Date())
    }
   
    @IBAction func staffButton(_ sender: Any) {
        
               let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
               let newViewController = storyBoard.instantiateViewController(withIdentifier: "StaffViewController") as! StaffViewController
               newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
               newViewController.modalTransitionStyle = .crossDissolve
               self.present(newViewController, animated: true, completion: nil)
    }
    @IBAction func clintButton(_ sender: Any) {
        
               let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
               let newViewController = storyBoard.instantiateViewController(withIdentifier: "ClintListViewController") as! ClintListViewController
               newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
               newViewController.modalTransitionStyle = .crossDissolve
               self.present(newViewController, animated: true, completion: nil)
    }
    @IBAction func customerReccordListButton(_ sender: Any) {
        
               let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
               let newViewController = storyBoard.instantiateViewController(withIdentifier: "salesListViewController") as! salesListViewController
               newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
               newViewController.modalTransitionStyle = .crossDissolve
               self.present(newViewController, animated: true, completion: nil)
    }
    @IBAction func salesButton(_ sender: Any) {
        
               let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
               let newViewController = storyBoard.instantiateViewController(withIdentifier: "OverviewViewController") as! OverviewViewController
               newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
               newViewController.modalTransitionStyle = .crossDissolve
               self.present(newViewController, animated: true, completion: nil)
    }
    @IBAction func otherexoenseButton(_ sender: Any) {
        
               let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
               let newViewController = storyBoard.instantiateViewController(withIdentifier: "ExpenseViewController") as! ExpenseViewController
               newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
               newViewController.modalTransitionStyle = .crossDissolve
               self.present(newViewController, animated: true, completion: nil)
    }
    @IBAction func settingdButton(_ sender: Any) {
        
               let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
               let newViewController = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
               newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
               newViewController.modalTransitionStyle = .crossDissolve
               self.present(newViewController, animated: true, completion: nil)
    }
}
