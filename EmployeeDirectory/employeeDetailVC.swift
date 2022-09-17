//
//  employeeDetailVC.swift
//  EmployeeDirectory
//
//  Created by Gobinath on 17/09/22.
//

import Foundation
import UIKit
import CoreData

class employeeDetailVC : ViewController {
    
    @IBOutlet weak var db: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var emailIdLbl: UILabel!
    @IBOutlet weak var citylbl: UILabel!
    
    @IBOutlet weak var streetlbl: UILabel!
    
    @IBOutlet weak var webLbl: UILabel!
    @IBOutlet weak var zipcodelbl: UILabel!
    
    var selectedEmployeeObject = NSManagedObject()
    
    override func viewDidLoad() {
        setUpView()
    }
    
    func setUpView() {
        db?.imageFromServerURL(urlString: selectedEmployeeObject.value(forKey: "profile_image") as? String ?? "", PlaceHolderImage: UIImage.init(named: "placeholder")!)
        nameLbl.text = selectedEmployeeObject.value(forKey: "name") as? String ?? ""
        userNameLbl.text = selectedEmployeeObject.value(forKey: "username") as? String ?? ""
        emailIdLbl.text = selectedEmployeeObject.value(forKey: "email") as? String ?? ""
        streetlbl.text = selectedEmployeeObject.value(forKey: "street") as? String ?? ""
        citylbl.text = selectedEmployeeObject.value(forKey: "city") as? String ?? ""
        zipcodelbl.text = selectedEmployeeObject.value(forKey: "zipcode") as? String ?? ""
        webLbl.text = selectedEmployeeObject.value(forKey: "website") as? String ?? ""
    }
    
}
