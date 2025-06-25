
//  ChooseCountryViewController.swift
//  CallRecorder
//
//  Created by iapp on 19/06/25.
//  Copyright © 2025 iApp. All rights reserved.
//

import UIKit
import Combine

//MARK: - PROTOCOLS
protocol ChooseCountryProtocol: AnyObject {
    func didSelectCountry(_ countryModel: CountryModel)
}

class ChooseCountryViewController: UIViewController,UIScrollViewDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var topTitleLabel                : UILabel!
    @IBOutlet weak var searchTF                     : UITextField!
    @IBOutlet weak var searchTFOuterView            : UIView!
    @IBOutlet weak var topCardSeparatorView         : UIView!
    @IBOutlet weak var topCardView                  : UIView!
    @IBOutlet weak var topTitleTopConstraint        : NSLayoutConstraint!
    
    @IBOutlet weak var countriesStateLabel  : UILabel!
    @IBOutlet weak var emptyListSV          : UIStackView!
    
    @IBOutlet weak var tableViewBottomConstraint : NSLayoutConstraint!
    
    //MARK: Outlets with Obersvers
    @IBOutlet weak var tableViewCountryList: UITableView! {
        didSet {
            self.tableViewCountryList.register(UINib(nibName: "CountryTableViewCell",
                                                     bundle: nil),
                                               forCellReuseIdentifier: "CountryTableViewCell")
            self.tableViewCountryList.delegate = self
            self.tableViewCountryList.dataSource = self
        }
    }
    
    //MARK: Properties
    //data from previous screen starts
    weak var delegate: ChooseCountryProtocol?
    var showSpecificCountryList = [String]()
    //data from previous screen ends
    
    private let viewModel       = ChooseCountryViewModel()
    private var apiCancellables : Set<AnyCancellable> = []
    
    //MARK: - View Controller Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if !showSpecificCountryList.isEmpty {
            viewModel.showSpecificCountryList = showSpecificCountryList
        }
        
        self.setUpUI()
        self.addViewModelStateObservers()
        Task {
            await viewModel.getCountriesList()
        }
    }
    
    //MARK: - NotificationCenter Selectors
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                
                tableViewBottomConstraint.constant = keyboardSize.height
                view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        tableViewBottomConstraint.constant = 0
        view.layoutIfNeeded()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    //MARK: - UI Related Actions
    func setUpUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.tableViewCountryList.layer.cornerRadius = 6
        self.tableViewCountryList.showsVerticalScrollIndicator = false
        self.topTitleLabel.font = UIFont.figtreeBold(ofSize: 28)
        
        searchTF.returnKeyType = .done
        searchTF.autocorrectionType = .no
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchTF.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.gray,
                NSAttributedString.Key.font : UIFont.figtreeMedium(ofSize: 15)])
        
        countriesStateLabel.font = UIFont.figtreeMedium(ofSize: 16)
        
        emptyListSV.removeFromSuperview()
        tableViewCountryList.backgroundView = emptyListSV
        
        // Add constraints to center the emptyListSV
        NSLayoutConstraint.activate([
            emptyListSV.centerXAnchor.constraint(equalTo: tableViewCountryList.centerXAnchor),
            emptyListSV.centerYAnchor.constraint(equalTo: tableViewCountryList.centerYAnchor),
        ])
        
        // Add a tap gesture recognizer to dismiss the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        topTitleTopConstraint.constant = 20
    }
    
    private func updateCountriesList() {
        if viewModel.countriesListToShow.isEmpty {
            countriesStateLabel.text = "No Countries Found."
            emptyListSV.isHidden = false
            //tableViewCountryList.isHidden = true
        } else {
            emptyListSV.isHidden = true
            //tableViewCountryList.isHidden = false
        }
        tableViewCountryList.reloadData()
    }
    
    private func dismissVC() {
        self.view.endEditing(true)
        self.dismiss(animated: true)
    }
    
    //MARK: - @objc Methods
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let searchText = textField.text else { return }
        viewModel.searchCountries(with: searchText)
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension ChooseCountryViewController: UITableViewDataSource, UITableViewDelegate {
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        // Return the titles of the sections, which are the first letters of the contact names
        return viewModel.sections.map { $0.title }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        guard let section = viewModel.sections[safe: indexPath.section],
        //              let country = section.countries[safe: indexPath.row],
        //              let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseCountryTableViewCell", for: indexPath) as? ChooseCountryTableViewCell else {
        //            return UITableViewCell()
        //        }
        //
        //        cell.labelCountryName?.text = country.name
        //        cell.dialCodeLabel?.text = "(\(country.dialCode ?? "-"))"
        //        cell.imageViewCountryFlag.image = UIImage(forCountryCode: country.code ?? "")
        //
        //        cell.imageViewCountryFlag.clipsToBounds = true
        //        cell.imageViewCountryFlag.layer.borderWidth = 1
        //        cell.imageViewCountryFlag.layer.borderColor = UIColor.BorderColor4.cgColor
        //
        //        return cell
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as? CountryTableViewCell else {
            return UITableViewCell()
        }
        
        let section = viewModel.sections[indexPath.section]
        let countryModel = section.countries[indexPath.row]
        
        cell.selectionStyle = .none
        
        cell.imageVieww.image = UIImage(forCountryCode: countryModel.code ?? "")
        
        cell.titleLabel?.text = countryModel.name ?? ""
        cell.titleLabel.textColor = .black
        cell.titleLabel.font = UIFont.figtreeSemiBold(ofSize: 18)
        cell.dialCodeLabel?.text = "(\(countryModel.dialCode ?? "-"))"
        
        cell.topConstraint.constant = indexPath.row == 0 ? 12 : 0
        cell.bottomConstraint.constant = 12
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        debugPrint("section - \(section), row - \(row)")
        if viewModel.sections.count <= section {
            return
        }
        let country = viewModel.sections[section].countries[row]
        delegate?.didSelectCountry(country)
        dismissVC()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

//MARK: - UITextFieldDelegate
extension ChooseCountryViewController : UITextFieldDelegate{
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let allowedCharacters: StringInTextFieldEnum? = if textField == searchTF {
            .lettersAndWhiteSpaces
        } else {
            nil
        }
        
        let maxLength: Int = 60
        
        return textField.validate(
            withReplacementString: string,
            andRange: range,
            toAllow: allowedCharacters,
            uptoLength: maxLength
        )
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
}

//MARK: - View Model State Observers
extension ChooseCountryViewController {
    func addViewModelStateObservers() {
        viewModel.$getCountriesListAS
            .receive(on: DispatchQueue.main)
            .sink { [weak self] getCountriesListAS in
                guard let self else { return }
                
                if getCountriesListAS.isBeingConsumed {
                    //validations added to show cached list
                    if viewModel.countriesListToShow.isEmpty {
                        self.searchTF.isUserInteractionEnabled = false
                        countriesStateLabel.text = "Fetching Countries..."
                        emptyListSV.isHidden = false
                        //tableViewCountryList.isHidden = true
                    } else {
                        self.searchTF.isUserInteractionEnabled = true
                        emptyListSV.isHidden = true
                        //tableViewCountryList.isHidden = false
                        tableViewCountryList.reloadData()
                    }
                } else if getCountriesListAS.isConsumed {
                    self.searchTF.isUserInteractionEnabled = true
                    self.updateCountriesList()
                }
            }.store(in: &apiCancellables)
        
        viewModel.$countriesSS
            .receive(on: DispatchQueue.main)
            .sink { [weak self] countriesSS in
                guard let self else { return }
                if countriesSS.isComplete {
                    self.updateCountriesList()
                }
            }
            .store(in: &apiCancellables)
    }
}
