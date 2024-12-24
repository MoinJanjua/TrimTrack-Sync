//
//  OverviewViewController.swift
//  TrimTrack Sync
//
//  Created by Unique Consulting Firm on 21/12/2024.
//

import UIKit

class OverviewViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var noDataLabel: UIImageView!
    @IBOutlet weak var FromDatePicker: UIDatePicker!
    @IBOutlet weak var ToDatePicker: UIDatePicker!
    
    var datasource: [salesList] = []
    var selectedRceord: salesList?
    var ID = String()
    var customer_record = [Clint]()
    var filteredOrderDetails: [salesList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.dataSource = self
        TableView.delegate = self
        
        
        FromDatePicker.addTarget(self, action: #selector(fromDatePickerChanged(_:)), for: .valueChanged)
        ToDatePicker.addTarget(self, action: #selector(toDatePickerChanged(_:)), for: .valueChanged)
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
            print(datasource)  // Check if data is loaded
            TableView.reloadData()
           
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
    
    @objc func fromDatePickerChanged(_ sender: UIDatePicker) {
        filterTransactions()
    }

    @objc func toDatePickerChanged(_ sender: UIDatePicker) {
        filterTransactions()
    }
    
    func filterTransactions() {
        let fromDate = FromDatePicker.date
        let toDate = ToDatePicker.date
        
        // Debugging logs
        print("From Date: \(fromDate), To Date: \(toDate)")

        // Create a DateFormatter to parse the string into Date objects
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Match the format of your bookingdate string

        // Filter the orders using Date comparison
        filteredOrderDetails = datasource.filter { order in
            if let bookingDate = dateFormatter.date(from: order.date) {
                return bookingDate >= fromDate && bookingDate <= toDate
            }
            return false // If the bookingdate string is not valid, exclude the order
        }

        print("Filtered Results Count: \(filteredOrderDetails.count)")
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
        return filteredOrderDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! salesTableViewCell
        
        let rec = filteredOrderDetails[indexPath.item]
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
              filteredOrderDetails.remove(at: indexPath.row)

              // Update UserDefaults
              let encoder = JSONEncoder()
              let updatedData = filteredOrderDetails.compactMap { try? encoder.encode($0) }
              UserDefaults.standard.set(updatedData, forKey: "salesList")

              // Delete row from table view
              tableView.deleteRows(at: [indexPath], with: .fade)

              // Update UI
              updateUI()
          }
      }
    

    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }

 

}
