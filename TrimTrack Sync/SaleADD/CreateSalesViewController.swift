//
//  CreateSalesViewController.swift
//  TrimTrack Sync
//
//  Created by Unique Consulting Firm on 21/12/2024.
//

import UIKit

class CreateSalesViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var staffName: DropDown!
    @IBOutlet weak var clintName: DropDown!
    @IBOutlet weak var dressingType: DropDown!
    @IBOutlet weak var servicestype: DropDown!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var amiunt: UITextField!
    @IBOutlet weak var discount: UITextField!
    
    
    var staff_record: [Staff] = [] // To store fetched records
    var clint_record: [Clint] = [] // To store fetched records
    //var selectedRecord: ordersBooking?
    var dataSource : [salesList] = []
    var staff_id = String()
    var clint_id = String()
    var sale_id = String()
    var stafflist = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
      //  staffName.delegate = self
        fetchRecords()
        // Do any additional setup after loading the view.
    }
    
  
    
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    
    func setupNameDropdown() {
        // Safely populate staff dropdown
        if !staff_record.isEmpty {
            staffName.optionArray = staff_record.compactMap { $0.Name }
            staffName.didSelect { [weak self] selectedName, index, _ in
                guard let self = self else { return }
                let selectedRecord = self.staff_record[index]
                self.staff_id = selectedRecord.id
                self.staffName.text = selectedName
            }
        } else {
            staffName.optionArray = ["No Staff Available"]
        }

        // Safely populate client dropdown
        if !clint_record.isEmpty {
            clintName.optionArray = clint_record.compactMap { $0.Name ?? "Unknown Client" }
            clintName.didSelect { [weak self] selectedName, index, _ in
                guard let self = self else { return }
                let selectedRecord = self.clint_record[index]
                self.clint_id = selectedRecord.id
                self.clintName.text = selectedName
            }
        } else {
            clintName.optionArray = ["No Client Available"]
        }

        // Predefined options for dressing type and service type remain unchanged
        dressingType.optionArray = [
            "Classic Pompadour",
            "Modern Undercut",
            "Buzz Cut",
            "Crew Cut",
            "Slicked Back",
            "Fade with Textured Top",
            "Side Part",
            "Messy Waves",
            "Curly Top with Taper",
            "Man Bun",
            "Full Beard",
            "Goatee",
            "Clean Shaven",
            "Stubble Beard",
            "Mustache with Short Beard"
        ]

        servicestype.optionArray = [
            "Haircut",
            "Beard Trim",
            "Hair Coloring",
            "Hair Wash and Blow-dry",
            "Facial Treatment",
            "Head Massage",
            "Neck and Shoulder Massage",
            "Manicure",
            "Pedicure",
            "Waxing",
            "Scalp Treatment",
            "Hair Spa",
            "Eyebrow Shaping",
            "Hot Towel Shave",
            "Hair Straightening"
        ]
    }


    
    
    func fetchRecords()
    {
        if let savedData = UserDefaults.standard.array(forKey: "staffRecord") as? [Data] {
            let decoder = JSONDecoder()
            staff_record = savedData.compactMap { data in
                do {
                    return try decoder.decode(Staff.self, from: data)
                } catch {
                    print("Error decoding record: \(error.localizedDescription)")
                    return nil
                }
            }
        }
        
        for staff in staff_record {
            stafflist.append(staff.Name)
        }
        
        if let savedData = UserDefaults.standard.array(forKey: "clintRecord") as? [Data] {
            let decoder = JSONDecoder()
            clint_record = savedData.compactMap { data in
                do {
                    return try decoder.decode(Clint.self, from: data)
                } catch {
                    print("Error decoding record: \(error.localizedDescription)")
                    return nil
                }
            }
        }
        
        setupNameDropdown()
    }
    
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        // Retrieve and calculate the adjusted doctor fee
        let doctorFee = Int(amiunt.text ?? "0") ?? 0
        let discount = Int(discount.text ?? "0") ?? 0
        let adjustedDoctorFee = doctorFee - discount
        
        // Ensure adjusted fee is non-negative
        if adjustedDoctorFee < 0 {
            showAlert(title: "Error", message: "Discount cannot be greater than the doctor fee.")
            return
        }
        
        var id = ""
        if (sale_id == "" || sale_id == nil)
        {
            id =  generateOrderNumber()
        }
        else
        {
            id = sale_id
        }
        
//        let id = (((selectedRecordID?.isEmpty) != nil) ? generateOrderNumber() : selectedRecordID) ?? ""
        // Create a new record with the adjusted doctor fee
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strdate = dateFormatter.string(from: date.date)
        
        let newRecord = salesList(
            id:id,
            staffid: staff_id,
            clintid: clint_id,
            staffName: staffName.text ?? "",
            clintName: clintName.text ?? "",
            dressingtype: dressingType.text ?? "",
            date: strdate,
            servictypee: servicestype.text ?? "",
            amount: amiunt.text ?? "0",
            discount: "\(discount)"
        )
        
        if let index = findRecordIndex(by: id) {
            // Update existing record
            updateSavedData(newRecord, at: index)
        } else {
            // Save new record
            saveCreateSaleDetail(newRecord)
        }
        
        // Show success alert
        showAlert(title: "Success", message: "Record saved successfully with adjusted fee.")
    }
    
    func updateSavedData(_ updatedTranslation: salesList, at index: Int) {
        if var savedData = UserDefaults.standard.array(forKey: "salesList") as? [Data] {
            let encoder = JSONEncoder()
            do {
                let updatedData = try encoder.encode(updatedTranslation)
                savedData[index] = updatedData // Update the specific index
                UserDefaults.standard.set(savedData, forKey: "salesList")
                clearTextFields()
            } catch {
                print("Error encoding data: \(error.localizedDescription)")
            }
        }
        showAlert(title: "Updated", message: "Sales information has Been Updated Successfully.")
    }
    
    
    func findRecordIndex(by id: String) -> Int? {
        if let records = UserDefaults.standard.array(forKey: "salesList") as? [Data] {
            let decoder = JSONDecoder()
            for (index, recordData) in records.enumerated() {
                do {
                    let record = try decoder.decode(salesList.self, from: recordData)
                    if record.id == id {
                        return index
                    }
                } catch {
                    print("Error decoding record: \(error.localizedDescription)")
                }
            }
        }
        return nil
    }

    
    
    func saveCreateSaleDetail(_ employee: salesList)
    {
        var orders = UserDefaults.standard.object(forKey: "salesList") as? [Data] ?? []
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(employee)
            orders.append(data)
            UserDefaults.standard.set(orders, forKey: "salesList")
            clearTextFields()
            
        } catch {
            print("Error encoding medication: \(error.localizedDescription)")
        }
        showAlert(title: "Success", message: "Clint information has been saved successfully.")
        
    }

    
    func clearTextFields() {
        staffName.text = ""
        clintName.text = ""
        dressingType.text = ""
        servicestype.text = ""
        amiunt.text = ""
        discount.text = ""
        
    }

    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
