//
//  CreateClintViewController.swift
//  TrimTrack Sync
//
//  Created by Unique Consulting Firm on 20/12/2024.
//

import UIKit

class CreateClintViewController: UIViewController {
    
    
    @IBOutlet weak var nameLbl: UITextField!
    @IBOutlet weak var ContactLbl: UITextField!
    @IBOutlet weak var genderlb: DropDown!
    @IBOutlet weak var addresslb: UITextField!
    @IBOutlet weak var otherlb: UITextField!
    
    @IBOutlet weak var Save_btn: UIButton!
    
    var clint: [Clint] = []
    var selected_staff_record: Clint?
    var staff_id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setupDatePicker(for: joiningdateLbl, target: self, doneAction: #selector(donePressedDate))
        if selected_staff_record?.id != ""
        {
            nameLbl.text = selected_staff_record?.Name
            ContactLbl.text = selected_staff_record?.contact
            genderlb.text = selected_staff_record?.gender
            otherlb.text = selected_staff_record?.other
            addresslb.text = selected_staff_record?.address
        }
        
        setupNameDropdown()
    }
    
    
    func setupNameDropdown() {
        genderlb.optionArray = ["Male","Female","Other"]
        genderlb.didSelect { [weak self] selectedName, index, _ in
            guard let self = self else { return }
            self.genderlb.text = selectedName
            
        }
    }
    
    
    
    func saveData(_ sender: Any) {
        // Check if any of the text fields are empty
        guard let name = nameLbl.text, !name.isEmpty,
              let Contact = ContactLbl.text, !Contact.isEmpty,
              let gender = genderlb.text, !gender.isEmpty
                
                
                
        else {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }
        
        let address = addresslb.text ?? "No Address Available"
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
        
        
        let newDetail = Clint(
            id: id,
            Name: name,
            contact: Contact,
            gender: gender,
            address: address,
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
    
    
    
    
    func saveCreateSaleDetail(_ employee: Clint)
    {
        var orders = UserDefaults.standard.object(forKey: "clintRecord") as? [Data] ?? []
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(employee)
            orders.append(data)
            UserDefaults.standard.set(orders, forKey: "clintRecord")
            clearTextFields()
            
        } catch {
            print("Error encoding medication: \(error.localizedDescription)")
        }
        showAlert(title: "Success", message: "Clint information has been saved successfully.")
        
    }
    
    func updateSavedData(_ updatedTranslation: Clint, at index: Int) {
        if var savedData = UserDefaults.standard.array(forKey: "clintRecord") as? [Data] {
            let encoder = JSONEncoder()
            do {
                let updatedData = try encoder.encode(updatedTranslation)
                savedData[index] = updatedData // Update the specific index
                UserDefaults.standard.set(savedData, forKey: "clintRecord")
                clearTextFields()
            } catch {
                print("Error encoding data: \(error.localizedDescription)")
            }
        }
        showAlert(title: "Updated", message: "Clint information has Been Updated Successfully.")
    }
    
    
    func convertStringToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust according to your string date format
        return dateFormatter.date(from: dateString)
    }
    //
    
    func findRecordIndex(by id: String) -> Int? {
        if let records = UserDefaults.standard.array(forKey: "clintRecord") as? [Data] {
            let decoder = JSONDecoder()
            for (index, recordData) in records.enumerated() {
                do {
                    let record = try decoder.decode(Clint.self, from: recordData)
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
        genderlb.text = ""
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
