//
//  DialNumberVC.swift
//  DemoDialpad
//
//  Created by iapp on 18/06/25.
//  Copyright © 2025 iApp. All rights reserved.
//

import UIKit
import PhoneNumberKit

class DialNumberVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var dialCodeIV: UIImageView!
    @IBOutlet weak var dialCodeIVOuterView: UIView!
    @IBOutlet weak var dialCodeLabel: UILabel!
    @IBOutlet weak var phoneNumberTF: PhoneNumberTextField!
    @IBOutlet weak var phoneNumberTFSV: UIStackView!
    @IBOutlet weak var dialNumberView: UIView!
    @IBOutlet weak var dialPadCVWidthConstraint: NSLayoutConstraint!
    
    //MARK: Outlets with Obersvers
    @IBOutlet weak var dialPadCV: UICollectionView! {
        didSet {
            let dialPadNib = UINib(nibName: "DialPadCollectionCell", bundle: nil)
            dialPadCV.register(dialPadNib, forCellWithReuseIdentifier: "DialPadCollectionCell")
            
            let optionsNib = UINib(nibName: "CallOptionsCollectionViewCell", bundle: nil)
            dialPadCV.register(optionsNib, forCellWithReuseIdentifier: "CallOptionsCollectionViewCell")
            
            dialPadCV.delegate = self
            dialPadCV.dataSource = self
        }
    }
    
    //MARK: - Properties
    private let viewModel         = DialNumberVM()
    private let dialTFMenuOptions = EditMenuOptionsController()
    private var longPressTimerOfBackPress : Timer?
    
    private let dialPadNumbers  = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#"]
    private var phoneNumber: String = "" {
        didSet {
            self.phoneNumberTF.text = phoneNumber
        }
    }
    
    //MARK: - Computed Vars
    private var cellSpacing: CGFloat {
        let width = dialPadCV.frame.width
        return width * 0.06
    }
    
    private var dialPadCollectionViewCellSize : CGSize {
        let numberOfCellsPerRow: CGFloat = 3
        let spaceAfterRemovingSpacing = dialPadCV.frame.width - (cellSpacing * (numberOfCellsPerRow - 1))
        let cellWidth = floor(spaceAfterRemovingSpacing / numberOfCellsPerRow)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    private var completeNumber: String {
        return (dialCodeLabel.text ?? "") + phoneNumber
    }
    
    //MARK: - View Controller Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        dialCodeIV.layoutIfNeeded()
        dialCodeIV.layer.cornerRadius = dialCodeIV.frame.width / 2
        dialCodeIV.layer.masksToBounds = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeLongPressTimer()
    }
    
    //MARK: - UI Related Methods
    private func setupView() {
        phoneNumberTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneNumberTF.font = UIFont.figtreeRegular(ofSize: 26)
        phoneNumberTF.withPrefix = true
        phoneNumberTF.withFlag = false
        phoneNumberTF.withExamplePlaceholder = false
        phoneNumberTF.inputView = UIView()
        
        dialCodeLabel.font = UIFont.figtreeRegular(ofSize: 26)
        
        dialCodeIV.layer.cornerRadius =  30
        dialCodeIV.layer.masksToBounds = false
        
        dialCodeIVOuterView.layer.borderWidth = 2.14
        dialCodeIVOuterView.layer.borderColor = UIColor.white.withAlphaComponent(0.9).cgColor
        dialCodeIVOuterView.layer.cornerRadius = 8
        dialCodeIVOuterView.clipsToBounds = false
        
        // Set shadow
        //        dialCodeIVOuterView.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        //        dialCodeIVOuterView.layer.shadowOffset = CGSize(width: 0, height: 1.95)
        //        dialCodeIVOuterView.layer.shadowRadius = 36.3 / 2.0
        //        dialCodeIVOuterView.layer.shadowOpacity = 1.0
        dialCodeIVOuterView.backgroundColor = .lightAppGray
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        dialNumberView.addGestureRecognizer(longPressGesture)
        dialNumberView.isUserInteractionEnabled = true
        
        if UIDevice.current.isIPad {
            dialPadCVWidthConstraint.constant = UIScreen.shared.bounds.width * 0.4
        } else {
            switch UIScreen.shared.getDeviceSizeEnum {
            case .small:
                dialPadCVWidthConstraint.constant = UIScreen.shared.bounds.width * 0.68
            default:
                dialPadCVWidthConstraint.constant = UIScreen.shared.bounds.width * 0.72
                break
            }
        }
        
        let countryCode = UserDefaults.countryCode ?? "US"
        self.setDialCountryCode(countryCode,
                                withISDCode: UserDefaults.isdCode ?? "+1")
    }
    
    private func updateBackspaceVisibility() {
        let hasText = !phoneNumber.isEmpty
        let backspaceIndexPath = IndexPath(item: 2, section: 1)
        
        if let cell = dialPadCV.cellForItem(at: backspaceIndexPath) as? CallOptionsCollectionViewCell {
            //cell.backSpaceButton.isHidden = !hasText
            UIView.animate(withDuration: 0.3, animations: {
                cell.backSpaceButton.alpha = hasText ? 1.0 : 0.0
            }) { _ in
                //cell.backSpaceButton.isHidden = !hasText
            }
        }
    }
    
    //MARK: - Long press for delete button
    private func addLongPressTimer() {
        longPressTimerOfBackPress = Timer.scheduledTimer(timeInterval: 0.1,
                                                         target: self,
                                                         selector: #selector(performBackspace),
                                                         userInfo: nil,
                                                         repeats: true)
    }
    
    private func removeLongPressTimer() {
        longPressTimerOfBackPress?.invalidate()
        longPressTimerOfBackPress = nil
    }
    
    //MARK: - Long Press to Paste number
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let options: [EditOptionType] = if phoneNumber.isEmpty {
                [.paste]
            } else {
                [.copy, .paste]
            }
            dialTFMenuOptions.show(on: gesture.view ?? UIView(), options: options)
        }
    }
    
    //MARK: - Update number related methods
    private func updateNumber(to updatedNumber: String) {
        self.phoneNumber = updatedNumber.replacingOccurrences(of: "+", with: "")
        updateBackspaceVisibility()
    }
    
    private func set(newNumber: String) {
        let data = newNumber.breakNumber()
        if let isdCode = data.isdCode,
           let countryCode = data.countryCode {
            setDialCountryCode(countryCode, withISDCode: isdCode)
            updateNumber(to: data.number)
        } else {
            updateNumber(to: newNumber)
        }
    }
    
    private func setDialCountryCode(_ countryCode: String, withISDCode isdCode: String) {
        UserDefaults.countryCode = countryCode
        UserDefaults.isdCode = isdCode
        self.dialCodeLabel.text = isdCode
        // phoneNumberTF.defaultRegion = countryCode
        let number = phoneNumber
        updateNumber(to: "")
        updateNumber(to: number)
        self.dialCodeIV.image = UIImage(forCountryCode: countryCode)
    }
    
    private func removeLastCharacterFromNumber() {
        updateBackspaceVisibility()
        var textViewText = phoneNumber
        if !textViewText.isEmpty {
            textViewText.removeLast()
            updateNumber(to: textViewText)
        }
    }
    
    //MARK: - Alert Related
    private func presentAlert(withTitle title: String,
                              message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            print("Ok Pressed")
        }

        alert.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Present VC Related
    private func presentCallVC() {
        
    }
    
    private func presentChooseCountryVC() {
        if let controller = UIStoryboard.main.instantiateViewController(
            identifier: String(
                describing: ChooseCountryViewController.self
            )
        ) as? ChooseCountryViewController {
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    //MARK: - @objc TextField Did Change
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateBackspaceVisibility()
    }
    
    //MARK: - IB Actions
    @IBAction func chooseCountryButton(_ sender: UIButton) {
        HapticManager.shared.selectionChanged()
        presentChooseCountryVC()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension DialNumberVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? dialPadNumbers.count : 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DialPadCollectionCell", for: indexPath) as? DialPadCollectionCell else {
                return UICollectionViewCell()
            }
            let digit = dialPadNumbers[indexPath.item]
            cell.numberPadView.padText = digit
            cell.numberPadView.layer.cornerRadius = dialPadCollectionViewCellSize.width / 2
            cell.numberPadView.tag = indexPath.item
            cell.numberPadView.addTarget(self, action: #selector(dialPadNumberTapped(_:)), for: .valueChanged)
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CallOptionsCollectionViewCell", for: indexPath) as? CallOptionsCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            switch indexPath.row {
            case 1:
                cell.acceptCallImageView.isHidden = false
                cell.placeCallButton.isHidden = false
                cell.backSpaceButton.isHidden = true
                cell.placeCallButton.addTarget(self, action: #selector(mainDailerAction), for: .touchUpInside)
            case 2:
                cell.acceptCallImageView.isHidden = true
                cell.placeCallButton.isHidden = true
                cell.backSpaceButton.alpha = phoneNumber.isEmpty ? 0 : 1
                cell.backSpaceButton.addTarget(self, action: #selector(backSpaceAction), for: .touchUpInside)
                let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(backspaceLongPress1(_:)))
                cell.backSpaceButton.addGestureRecognizer(longPressGesture)
                cell.backSpaceButton.isUserInteractionEnabled = true // Just in case it's disabled
            default:
                cell.acceptCallImageView.isHidden = true
                cell.placeCallButton.isHidden = true
                cell.backSpaceButton.isHidden = true
            }
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return dialPadCollectionViewCellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 {
            return UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        }
        return .zero
    }
    
    @objc func dialPadNumberTapped(_ sender: UIButton) {
        //        sender.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        if phoneNumber.count >= 12 {
            return
        }
        let digit = dialPadNumbers[sender.tag]
        DispatchQueue.main.async {
            HapticManager.shared.impact(style: .medium)
        }
        updateNumber(to: phoneNumber + digit)
    }
    
    //MARK: - @objc Tap Methods
    @objc func performBackspace() {
        HapticManager.shared.notification(type: .success)
        
        if phoneNumber.isEmpty {
            removeLongPressTimer()
            return
        }
        removeLastCharacterFromNumber()
    }
    
    @objc func backSpaceAction() {
        HapticManager.shared.impact(style: .light)
        removeLastCharacterFromNumber()
    }
    
    @objc func backspaceLongPress1(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            print("Long press began")
            addLongPressTimer()
        case .ended, .cancelled:
            print("Long press ended")
            removeLongPressTimer()
        default:
            break
        }
    }
    
    @objc func mainDailerAction() {
        //        #if DEBUG
        //        presentCallVC(withDelay: false)
        //        return
        //        #endif
        // Call delegate method with formatted number
        HapticManager.shared.notification(type: .success)
        let number = completeNumber
        
        switch viewModel.canDialCall(toNumber: number) {
        case .success:
            // dial call here
            break
        case .failure(let error):
            switch error {
            case .invalidNumber:
                presentAlert(withTitle: "Alert",
                             message: "Please check number you dialing")
                
            case .noInternetAvailable:
                presentAlert(withTitle: "No Internet",
                             message: "Please check your internet connection")
                
            case .noNumberBought:
                presentAlert(withTitle: "Alert",
                             message: "No number bought")
                
            default:
                break
            }
        }
    }
}

//MARK: - ChooseCountryProtocol
extension DialNumberVC: ChooseCountryProtocol {
    func didSelectCountry(_ countryModel: CountryModel) {
        // dialPadView.set(newNumber: "")
        self.setDialCountryCode(countryModel.code ?? "",
                                withISDCode: countryModel.dialCode ?? "")
    }
}
