import UIKit
import Firebase
import FirebaseDatabase

class ListViewController: UIViewController {
    
    
    @IBOutlet weak var TipRate: UILabel!
    @IBOutlet weak var totalTip: UITextField!
    @IBOutlet weak var totalHours: UILabel!
    
    
    @IBOutlet var table: UITableView!
    
    var models = [Worker]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        
        // Get the current user's unique ID
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        // Load data from Firebase for the specific user
        let db = Database.database().reference()
        db.child("users").child(userId).child("workers").observeSingleEvent(of: .value) { snapshot in
            guard let workersData = snapshot.value as? [[String: Any]] else { return }
            
            self.models = workersData.compactMap { dict in
                guard let name = dict["name"] as? String,
                      let role = dict["role"] as? String,
                      let hours = dict["hours"] as? Double,
                      let tip = dict["tip"] as? Double,
                      let id = dict["id"] as? String else { return nil }
                return Worker(name: name, role: role, hours: hours, id: id, tip: tip)
            }
            self.table.reloadData()
            self.updateTotalHours()  // Update total hours based on loaded data
        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Get the current user's unique ID
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        // Save data to Firebase under the specific user ID
        let db = Database.database().reference()
        let workersData: [[String: Any]] = models.map { worker in
            return [
                "name": worker.name,
                "role": worker.role,
                "hours": worker.hours,
                "tip": worker.tip ?? 0.0,
                "id": worker.id
            ]
        }
        db.child("users").child(userId).child("workers").setValue(workersData) { error, _ in
            if let error = error {
                print("Error saving data: \(error)")
            } else {
                print("Data successfully saved!")
            }
        }
    }
    
    @IBAction func didTapAdd() {
            guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddWorkerViewController else {
                return
            }
            vc.title = "New Employee"
            
            vc.completion = { [weak self] name, role, time in
                guard let self = self else { return }
                let hours = self.convertTimeToHours(time: time) // Convert time to hours
                let new = Worker(name: name, role: role, hours: hours, id: "id_\(name)")
                self.models.append(new)
                self.table.reloadData()
                self.updateTotalHours()  // Update total hours after adding a worker
                self.saveAllWorkersToFirebase()
            }
            
            present(vc, animated: true, completion: nil)
           
        
        }
    
    
   
    
    @IBAction func didTapClean() {
        models.removeAll()
        table.reloadData()
        updateTotalHours()  // Reset total hours to 0 when the list is cleared
        saveAllWorkersToFirebase()
    }
    
    
    // Convert time (String) to hours (Double)
    private func convertTimeToHours(time: String) -> Double {
        // Assuming time is in "HH:mm" format
        let components = time.split(separator: ":").compactMap { Double($0) }
        if components.count == 2 {
            return components[0] + (components[1] / 60.0) // Convert minutes to hours
        }
        return 0.0
    }
    
    // Calculate and update total hours
    private func updateTotalHours() {
        let total = models.reduce(0.0) { $0 + $1.hours }
        totalHours.text = String(format: "%.2f", total)
    }
    
    
    
    @IBAction func didTapCalculate() {
        // Check if the totalTip text field is empty or contains a non-numeric value
        guard let totalTipText = totalTip.text, !totalTipText.isEmpty, let totalTip = Double(totalTipText), totalTip > 0 else {
            // Optionally, display an alert to the user
            let alert = UIAlertController(title: "Invalid Input", message: "Please enter a valid total tip greater than zero.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Calculate total hours
        let totalHoursValue = models.reduce(0.0) { $0 + $1.hours }
        
        // Check if total hours is zero
        guard totalHoursValue > 0 else {
            // Optionally, display an alert to the user
            let alert = UIAlertController(title: "Invalid Data", message: "Total hours must be greater than zero.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Calculate the tip rate per hour
        let tipRate = totalTip / totalHoursValue
        
        // Update the tip rate label with the calculated tip rate
        TipRate.text = String(format: "%.2f", tipRate)
        
        // Calculate the tip for each worker
        for index in 0..<models.count {
            var worker = models[index]
            worker.tip = worker.hours * tipRate  // Calculate and assign tip
            models[index] = worker  // Update the array with the new worker data
        }
        
        table.reloadData()  // Refresh TableView to display updated tips
        
        
        // Update Firebase with the calculated tips
        saveAllWorkersToFirebase()
    }
    
    
    
    func saveAllWorkersToFirebase() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let db = Database.database().reference()
        let workersData: [[String: Any]] = models.map { worker in
            return [
                "name": worker.name,
                "role": worker.role,
                "hours": worker.hours,
                "tip": worker.tip ?? 0.0,
                "id": worker.id
            ]
        }
        
        db.child("users").child(userId).child("workers").setValue(workersData) { error, _ in
            if let error = error {
                print("Error saving data: \(error)")
            } else {
                print("All workers' data successfully updated!")
            }
        }
    }
    
}
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100.0 // Set the desired height for each cell
        }
}

extension ListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let worker = models[indexPath.row]
        let formattedHours = String(format: "%.2f", worker.hours)
        let formattedTip = worker.tip != nil ? String(format: "%.2f", worker.tip!) : ""
        
        // Update the cell to show name, role, hours, and tip
        cell.textLabel?.text = worker.name
        cell.detailTextLabel?.text = "\(worker.role) - \(formattedHours) hours - Tip: \(formattedTip)"
        
        cell.backgroundColor = UIColor(red: 0.68, green: 0.85, blue: 0.95, alpha: 1.0) // Light blue color
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18) // Optional: change font size
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16) // Optional: change font size
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let workerToDelete = models[indexPath.row]
            
            // Remove the worker from the Firebase //chack
        
            // Remove the worker locally
            models.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            updateTotalHours()
            
            saveAllWorkersToFirebase()
        }
    }
}

// Updated Worker struct with hours as Double
struct Worker {
    let name: String
    let role: String
    let hours: Double
    let id: String
    var tip: Double?  // Optional property for storing tip
}
 
