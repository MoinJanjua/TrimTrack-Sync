//
//  salesListViewController.swift
//  TrimTrack Sync
//
//  Created by Unique Consulting Firm on 21/12/2024.
//

import UIKit

class salesListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var noDataLabel: UIImageView!
    @IBOutlet weak var createbtn: UIButton!
    
    var datasource: [salesList] = []
    var selectedRceord: salesList?
    var ID = String()
    var customer_record = [Clint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.dataSource = self
        TableView.delegate = self
        roundCorner(button: createbtn)
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        if !(ID.isEmpty)
        {
            if let savedData = UserDefaults.standard.array(forKey: "salesList") as? [Data]
            {
                let decoder = JSONDecoder()
                datasource = savedData.compactMap { data in
                    do {
                        let productsData = try decoder.decode(salesList.self, from: data)
                        print("productsData",productsData)
                        return productsData
                    } catch {
                        print("Error decoding product: \(error.localizedDescription)")
                        return nil
                    }
                }
             }
            
          
            // Show or hide the table view and label based on data availability
                   if datasource.isEmpty {
                       TableView.isHidden = true
                       noDataLabel.isHidden = false  // Show the label when there's no data
                   } else {
                       TableView.isHidden = false
                       noDataLabel.isHidden = true   // Hide the label when data is available
                   }
            TableView.reloadData()
            print(datasource)  // Check if data is loaded
           
           
            return
        }

        if let savedData = UserDefaults.standard.array(forKey: "salesList") as? [Data] {
            let decoder = JSONDecoder()
            datasource = savedData.compactMap { data in
                do {
                    let productsData = try decoder.decode(salesList.self, from: data)
                    print("productsData",productsData)
                    return productsData
                } catch {
                    print("Error decoding product: \(error.localizedDescription)")
                    return nil
                }
            }
        }
       
        // Show or hide the table view and label based on data availability
               if datasource.isEmpty {
                   TableView.isHidden = true
                   noDataLabel.isHidden = false  // Show the label when there's no data
               } else {
                   TableView.isHidden = false
                   noDataLabel.isHidden = true   // Hide the label when data is available
               }
       // getCustomerrecord()  // Check if data is loaded
        TableView.reloadData()
    }
    

    func updateUI()
    {
     
       if datasource.isEmpty {
           TableView.isHidden = true
           noDataLabel.isHidden = false
       } else {
           TableView.isHidden = false
           noDataLabel.isHidden = true
       }
       TableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! salesTableViewCell
        
        let rec = datasource[indexPath.item]
        cell.clintName.text = rec.clintName
        cell.staffName.text = "\(rec.staffName)"
        cell.discount.text = "Discount : \(rec.discount)"
        cell.date.text =  "Today Date : \(rec.date)"
        cell.amiunt.text = "Amount Paid : \(rec.amount)"
        cell.servicestype.text = "Service Type:\(rec.servictypee)"
        cell.dressingType.text = "\(rec.servictypee)"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 196
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == .delete {
              // Remove record from datasource
              datasource.remove(at: indexPath.row)

              // Update UserDefaults
              let encoder = JSONEncoder()
              let updatedData = datasource.compactMap { try? encoder.encode($0) }
              UserDefaults.standard.set(updatedData, forKey: "salesList")

              // Delete row from table view
              tableView.deleteRows(at: [indexPath], with: .fade)

              // Update UI
              updateUI()
          }
      }
    
    func navigateToUpdate(record: ordersBooking)
    {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "DoctorSaleViewController") as! DoctorSaleViewController
//        newViewController.selectedRecordID = record.id
//        newViewController.selectedRecord = record
//        newViewController.modalPresentationStyle = .fullScreen
//        newViewController.modalTransitionStyle = .crossDissolve
//        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func createButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CreateSalesViewController") as! CreateSalesViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }

}
