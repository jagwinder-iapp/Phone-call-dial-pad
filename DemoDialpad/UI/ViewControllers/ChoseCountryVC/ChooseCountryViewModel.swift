//
//  ChooseCountryViewModel.swift
//  IHSecondLine
//
//  Created by iapp on 19/06/25.
//  Copyright © 2025 iApp. All rights reserved.
//

import Combine
import Foundation


//MARK: - SectionCountryModel
struct SectionCountryModel {
    let title: String
    var countries: [CountryModel]
}

@MainActor class ChooseCountryViewModel: ObservableObject {
    
    //MARK: Publishers
    @Published private(set) var getCountriesListAS  : APIRequestState = .notConsumedOnce
    @Published private(set) var countriesSS         : SearchState = .notStarted
    
    //MARK: - Properties
    private let bundlePath = URL(fileURLWithPath:  Bundle.main.path(forResource: "CountryAssets", ofType: "bundle")!)
    private var countriesList = [CountryModel]()
    private(set) var sections: [SectionCountryModel] = []
    
    var showSpecificCountryList = [String]()
    
    //MARK: Properties with Observers
    private(set) var countriesListToShow = [CountryModel]() {
        didSet {
            // Sort and organize into sections
            let groupedCountries = Dictionary(grouping: countriesListToShow) { $0.name?.prefix(1).uppercased() ?? "" }
            sections = groupedCountries.keys.sorted().map { key in
                SectionCountryModel(title: key, countries: groupedCountries[key] ?? [])
            }
        }
    }
    
    //MARK: Computed Vars
    var isAnyAPIBeingConsumed: Bool {
        return getCountriesListAS.isBeingConsumed
    }
    
    private lazy var CallingCodes = { () -> [[String: String]] in
        let resourceBundle = Bundle(for: ChooseCountryViewController.classForCoder())
        guard let path = resourceBundle.path(forResource: "CallingCodes", ofType: "plist") else { return [] }
        return NSArray(contentsOfFile: path) as! [[String: String]]
    }()
    
    //MARK: Custom Methods
    private func flagExists(countryCode : String)-> Bool{
        let flagImagePath = bundlePath.appendingPathComponent(countryCode.uppercased() + ".png")
        if FileManager.default.fileExists(atPath: flagImagePath.path){
            return true
        }
        return false
    }
    
    private func addCountry(toList countriesList: inout [CountryModel],
                            fromLocale locale: String,
                            withCountryCode countryCode: String) {
        if !flagExists(countryCode: countryCode) {
            return
        }
        
        let country: CountryModel = if let countryData = CallingCodes.first(where: { $0["code"] == countryCode }),
           let dialCode = countryData["dial_code"] {
            CountryModel(name: locale, code: countryCode, dialCode: dialCode)
        } else {
            CountryModel(name: locale, code: countryCode)
        }
        countriesList.append(country)
    }
    
    private func updateCountryList(to newCountryList: [CountryModel]) {
        countriesList = if showSpecificCountryList.isEmpty {
            newCountryList
        } else {
            newCountryList.filter { (country) -> Bool in
                showSpecificCountryList.contains(where: { $0.localizedStandardContains(country.name ?? "") })
            }
        }
        
        countriesListToShow = countriesList
    }
    
    //MARK: Search
    func searchCountries(with searchText: String) {
        countriesSS = .inProgress
        if searchText.trim.isEmpty {
            countriesListToShow = countriesList
        } else {
            countriesListToShow = countriesList.filter({ $0.name?.localizedCaseInsensitiveContains(searchText) == true ||
                $0.code?.localizedCaseInsensitiveContains(searchText) == true ||
                $0.dialCode?.contains(searchText) == true })
        }
        countriesSS = .complete
    }
    
    //MARK: API's
    func getCountriesList() async {
        guard !getCountriesListAS.isBeingConsumed else { return }
        
        getCountriesListAS = .beingConsumed
        
        let locale = Locale.current
        var countriesList = [CountryModel]()
        if #available(iOS 16, *) {
            let isoRegions = Locale.Region.isoRegions
            for isoRegion in isoRegions {
                let countryCode = isoRegion.identifier
                let displayName = (locale as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value: countryCode)
                addCountry(toList: &countriesList,
                           fromLocale: displayName ?? "",
                           withCountryCode: countryCode)
            }
        } else {
            let countriesCodes = Locale.isoRegionCodes
            for countryCode in countriesCodes {
                let displayName = (locale as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value: countryCode)
                addCountry(toList: &countriesList,
                           fromLocale: displayName ?? "",
                           withCountryCode: countryCode)
            }
        }
        
        //            return countryList.filter { (country) -> Bool in
        //                listAvailableCountries.contains(where: { $0.localizedStandardContains(country.name) })
        //            }
        
        updateCountryList(to: countriesList)
        self.getCountriesListAS = .consumedWithSuccess
    }
}
