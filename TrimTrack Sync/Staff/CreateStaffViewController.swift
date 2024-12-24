//
//  CreateStaffViewController.swift
//  TrimTrack Sync
//
//  Created by Unique Consulting Firm on 20/12/2024.
//

import UIKit

class CreateStaffViewController: UIViewController {


    @IBOutlet weak var nameLbl: UITextField!
    @IBOutlet weak var ContactLbl: UITextField!
    @IBOutlet weak var joiningdateLbl: UITextField!
    @IBOutlet weak var designbl: UITextField!
    @IBOutlet weak var otherlb: UITextField!
    @IBOutlet weak var addresslb: UITextField!
    @IBOutlet weak var Save_btn: UIButton!
    
    var staff: [Staff] = []
    var selected_staff_record: Staff?
    var staff_id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDatePicker(for: joiningdateLbl, target: self, doneAction: #selector(donePressedDate))
        if selected_staff_record?.id != ""
        {
            nameLbl.text = selected_staff_record?.Name
            ContactLbl.text = selected_staff_record?.contact
            joiningdateLbl.text = selected_staff_record?.joiningDate
            designbl.text = selected_staff_record?.designation
            otherlb.text = selected_staff_record?.other
            addresslb.text = selected_staff_record?.address
        }
    }
    
    
    @objc func donePressedDate() {
        // Get the date from the picker and set it to the text field
        if let datePicker = joiningdateLbl.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy" // Same format as in convertStringToDate
            joiningdateLbl.text = dateFormatter.string(from: datePicker.date)
        }
        // Dismiss the keyboard
        joiningdateLbl.resignFirstResponder()
    }

    func saveData(_ sender: Any) {
        // Check if any of the text fields are empty
        guard let name = nameLbl.text, !name.isEmpty,
              let Contact = ContactLbl.text, !Contact.isEmpty,
              let design = designbl.text, !design.isEmpty,
              let joiningDate = joiningdateLbl.text
             

        else {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }
        
        let address = addresslb.text ?? "No Address Available"
        let otherlb = otherlb.text ?? ""
        
        var id = ""
        if (selected_staff_record?.id != "") && (selected_staff_record?.id != nil)
        {
            id = selected_staff_record?.id ?? ""
        }
        else
        {
            id = "\(generateCustomerId())"
        }
     
       
        let newDetail = Staff(
            id: id,
             Name: name,
             contact: Contact,
             joiningDate: joiningDate,
             address: address,
             designation: design,
             other: otherlb
           
        )
        
        if let index = findRecordIndex(by: id) {
                // Update existing record
                updateSavedData(newDetail, at: index)
            } else {
                // Save new record
                saveCreateSaleDetail(newDetail)
            }
       
    }
    
    
    
    
    func saveCreateSaleDetail(_ employee: Staff)
    {
        var orders = UserDefaults.standard.object(forKey: "staffRecord") as? [Data] ?? []
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(employee)
            orders.append(data)
            UserDefaults.standard.set(orders, forKey: "staffRecord")
            clearTextFields()
           
        } catch {
            print("Error encoding medication: \(error.localizedDescription)")
        }
        showAlert(title: "Success", message: "Staff information has been saved successfully.")
        
    }
    
    func updateSavedData(_ updatedTranslation: Staff, at index: Int) {
        if var savedData = UserDefaults.standard.array(forKey: "staffRecord") as? [Data] {
            let encoder = JSONEncoder()
            do {
                let updatedData = try encoder.encode(updatedTranslation)
                savedData[index] = updatedData // Update the specific index
                UserDefaults.standard.set(savedData, forKey: "staffRecord")
            } catch {
                print("Error encoding data: \(error.localizedDescription)")
            }
        }
        showAlert(title: "Updated", message: "Staff information has Been Updated Successfully.")
    }
    
    
    func convertStringToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust according to your string date format
        return dateFormatter.date(from: dateString)
    }
//    

    func findRecordIndex(by id: String) -> Int? {
        if let records = UserDefaults.standard.array(forKey: "staffRecord") as? [Data] {
            let decoder = JSONDecoder()
            for (index, recordData) in records.enumerated() {
                do {
                    let record = try decoder.decode(Staff.self, from: recordData)
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
    
    func clearTextFields() {
        nameLbl.text = ""
        otherlb.text = ""
        designbl.text = ""
        joiningdateLbl.text = ""
        ContactLbl.text = ""
        addresslb.text = ""
        
    }
    
    @IBAction func SaveButton(_ sender: Any) {
        saveData(sender)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
