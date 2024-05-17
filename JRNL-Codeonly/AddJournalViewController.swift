//
//  AddJournalViewController.swift
//  JRNL-Codeonly
//
//  Created by 어재선 on 5/13/24.
//

import UIKit
import CoreLocation

protocol AddJournalControllerDelegate: NSObject {
    func saveJournalEntry(_ journalEntry: JournalEntry)
}

class AddJournalViewController: UIViewController, CLLocationManagerDelegate, UITextViewDelegate {
    weak var delegate: AddJournalControllerDelegate?
    // 의존 분리를 위해 직접 뷰 컨트롤러를 담기보다. 델리게이트 프로토콜을 이용한다.
    // weak var journalListViewController JournalListViewController?
    final let LABEL_VIEW_TAG = 1001
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    var locationSwitchIsOn = false {
        didSet {
            updateSaveButtonState()
        }
    }
    
    
    private lazy var mainContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 40
        return stackView
    }()
    
    private lazy var ratingView: UIStackView = {
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 252, height: 44))
        stackView.axis = .horizontal
        stackView.backgroundColor = .systemCyan
        return stackView
        
    }()
    
    private lazy var toggleView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        let switchComponent = UISwitch()
        switchComponent.isOn = false
        switchComponent.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)
        
        let labelComponent = UILabel()
        labelComponent.text = "get Location"
        labelComponent.tag = LABEL_VIEW_TAG
        
        stackView.addArrangedSubview(switchComponent)
        stackView.addArrangedSubview(labelComponent)
        
        return stackView
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Journal Title"
        textField.addTarget(self, action: #selector(textChanged(textField:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var bodyTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Journal body"
        textView.delegate = self
        
        return textView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "face.smiling")
        return imageView
    }()
    
    private lazy var saveButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .save,
                               target: self
                               , action: #selector(save))
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "New Entry"
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = saveButton
        saveButton.isEnabled = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cencel))
        
        mainContainer.addArrangedSubview(ratingView)
        mainContainer.addArrangedSubview(toggleView)
        mainContainer.addArrangedSubview(titleTextField)
        mainContainer.addArrangedSubview(bodyTextView)
        mainContainer.addArrangedSubview(imageView)
        
        view.addSubview(mainContainer)
        
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
        toggleView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeAree = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            mainContainer.topAnchor.constraint(equalTo: safeAree.topAnchor, constant: 20),
            mainContainer.leadingAnchor.constraint(equalTo: safeAree.leadingAnchor, constant: 20),
            mainContainer.trailingAnchor.constraint(equalTo: safeAree.trailingAnchor, constant: -20),
            
            ratingView.widthAnchor.constraint(equalToConstant: 252),
            ratingView.heightAnchor.constraint(equalToConstant: 44),
            
            titleTextField.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 8),
            titleTextField.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: -8),
            
            bodyTextView.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 8),
            bodyTextView.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: -8),
            bodyTextView.heightAnchor.constraint(equalToConstant: 128),
            
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200)
            
        ])
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        
        
    }
    // MARK: - MEthods
    func updateSaveButtonState() {
        if locationSwitchIsOn{
            guard let title = titleTextField.text, !title.isEmpty,
                  let body = bodyTextView.text, !body.isEmpty,
                    let _ = currentLocation else {
                saveButton.isEnabled = false
                return
            }
            saveButton.isEnabled = true
            
        } else {
            guard let title = titleTextField.text, !title.isEmpty,
                  let body = bodyTextView.text, !body.isEmpty else {
                saveButton.isEnabled = false
                return
            }
            saveButton.isEnabled = true
        
        }
    }
    
    @objc func textChanged(textField: UITextField) {
        updateSaveButtonState()
    }
    
    @objc func save() {
        guard let title = titleTextField.text, !title.isEmpty,
              let body = bodyTextView.text, !body.isEmpty else {
            return
        }
        
        let lat = currentLocation?.coordinate.latitude
        let long = currentLocation?.coordinate.longitude
        
        let journalEntry = JournalEntry(rating: 3, title: title, body: body, photo: UIImage(systemName: "face.smiling"), latitude: lat, longitude: long)!
        delegate?.saveJournalEntry(journalEntry)
        dismiss(animated: true)
        
    }
    
    @objc func cencel(){
        dismiss(animated: true)
    }
    
    
    @objc func valueChanged(sender: UISwitch){
        locationSwitchIsOn = sender.isOn
        if sender.isOn {
            if let label = toggleView.viewWithTag(LABEL_VIEW_TAG) as? UILabel{
                label.text = "Getting Location..."
            }
            locationManager.requestLocation()
        } else {
            currentLocation = nil
            if let label = toggleView.viewWithTag(LABEL_VIEW_TAG) as? UILabel{
                label.text = "Get location"
            }
            
        }
        updateSaveButtonState()
    }
    
    // MARK: - CLLocationMAnagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let myCurrentLocation = locations.first {
            currentLocation = myCurrentLocation
            if let label: UILabel = toggleView.viewWithTag(LABEL_VIEW_TAG) as? UILabel{
                label.text = "Done"
            }
            // TODO: updateButtonState
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
}
