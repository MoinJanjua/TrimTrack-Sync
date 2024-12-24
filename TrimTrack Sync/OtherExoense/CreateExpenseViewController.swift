//
//  CreateExpenseViewController.swift
//  TrimTrack Sync
//
//  Created by Unique Consulting Firm on 21/12/2024.
//

import UIKit

class CreateExpenseViewController: UIViewController {

    @IBOutlet weak var expenseLbl: UITextField!
    @IBOutlet weak var amountLbl: UITextField!
    @IBOutlet weak var dateLbl: UITextField!
    @IBOutlet weak var otherlb: UITextField!
    @IBOutlet weak var Save_btn: UIButton!
    
    var staff: [ExpenseAmount] = []
    var selected_staff_record: ExpenseAmount?
    var expense_id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDatePicker(for: dateLbl, target: self, doneAction: #selector(donePressedDate))
        if selected_staff_record?.id != ""
        {
            expenseLbl.text = selected_staff_record?.expenseName
            amountLbl.text = selected_staff_record?.amount
            dateLbl.text = selected_staff_record?.date
            otherlb.text = selected_staff_record?.other
           
        }
    }
    
    
    @objc func donePressedDate() {
        // Get the date from the picker and set it to the text field
        if let datePicker = dateLbl.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy" // Same format as in convertStringToDate
            dateLbl.text = dateFormatter.string(from: datePicker.date)
        }
        // Dismiss the keyboard
        dateLbl.resignFirstResponder()
    }

    func saveData(_ sender: Any) {
        // Check if any of the text fields are empty
        guard let name = expenseLbl.text, !name.isEmpty,
              let amount = amountLbl.text, !amount.isEmpty,
              let date = dateLbl.text, !date.isEmpty
            
        else {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }
        
        let otherlb = otherlb.text ?? "N/A"
        
        var id = ""
        if (selected_staff_record?.id != "") && (selected_staff_record?.id != nil)
        {
            id = selected_staff_record?.id ?? ""
        }
        else
        {
            id = "\(generateCustomerId())"
        }
     
       
        let newDetail = ExpenseAmount(id: id, expenseName: name, amount: amount, date: date, other: otherlb)
        
        if let index = findRecordIndex(by: id) {
                // Update existing record
                updateSavedData(newDetail, at: index)
            } else {
                // Save new record
                saveCreateSaleDetail(newDetail)
            }
       
    }
    
    
    
    
    func saveCreateSaleDetail(_ employee: ExpenseAmount)
    {
        var orders = UserDefaults.standard.object(forKey: "ExpenseAmount") as? [Data] ?? []
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(employee)
            orders.append(data)
            UserDefaults.standard.set(orders, forKey: "ExpenseAmount")
            clearTextFields()
           
        } catch {
            print("Error encoding medication: \(error.localizedDescription)")
        }
        showAlert(title: "Success", message: "Expense information has been saved successfully.")
        
    }
    
    func updateSavedData(_ updatedTranslation: ExpenseAmount, at index: Int) {
        if var savedData = UserDefaults.standard.array(forKey: "ExpenseAmount") as? [Data] {
            let encoder = JSONEncoder()
            do {
                let updatedData = try encoder.encode(updatedTranslation)
                savedData[index] = updatedData // Update the specific index
                UserDefaults.standard.set(savedData, forKey: "ExpenseAmount")
            } catch {
                print("Error encoding data: \(error.localizedDescription)")
            }
        }
        showAlert(title: "Updated", message: "Expense information has Been Updated Successfully.")
    }
    
    
    func convertStringToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust according to your string date format
        return dateFormatter.date(from: dateString)
    }
//

    func findRecordIndex(by id: String) -> Int? {
        if let records = UserDefaults.standard.array(forKey: "ExpenseAmount") as? [Data] {
            let decoder = JSONDecoder()
            for (index, recordData) in records.enumerated() {
                do {
                    let record = try decoder.decode(ExpenseAmount.self, from: recordData)
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
        expenseLbl.text = ""
        amountLbl.text = ""
        otherlb.text = ""
        
    }
    
    @IBAction func SaveButton(_ sender: Any) {
        saveData(sender)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
