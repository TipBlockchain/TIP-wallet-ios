//
//  SelectCountryViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-07.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

protocol SelectCountryDelegate: class {
    func countrySelected(_ country: Country)
}

class SelectCountryViewController: ModalViewController {

    @IBOutlet private var tableView: UITableView!
    var countries: [Country] = [] {
        didSet {
            debugPrint("countries set")
            createSections()
        }
    }
    var sectionedCountries: [NamedSection<Country>] = []
    var selectedCountry: Country? = nil {
        didSet {
            if let selectedCountry = selectedCountry {
                self.delegate?.countrySelected(selectedCountry)
            }
        }
    }
    weak var delegate: SelectCountryDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "CountryTableViewCell", bundle: nil), forCellReuseIdentifier: "CountryTableViewCell")
        tableView.reloadData()
        debugPrint("ViewDidLoad")
        // Do any additional setup after loading the view.
    }

    private func createSections() {
        var countryDict: [Character: NamedSection<Country>] = [:]
        sectionedCountries = []
        var sections: [NamedSection<Country>] = []
        for country in countries {
            if let firstChar = country.name.uppercased().first {
                var section = countryDict[firstChar]
                if section != nil {
                    section!.items.append(country)
                } else {
                    section = NamedSection(key: firstChar.description, items: [country])
                    sections.append(section!)
                    countryDict[firstChar] = section
                }
            }
        }
        sectionedCountries = sections
    }
    
}

extension SelectCountryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionedCountries.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sectionedList = self.section(atIndex: section) {
            return sectionedList.items.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CountryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as! CountryTableViewCell
        if let country = country(atIndexPath: indexPath) {
            cell.country = country
        }
        return cell
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionedCountries.map({ section -> String in
            return section.key
        })
    }

    private func section(atIndex index: Int) -> NamedSection<Country>? {
        if index < sectionedCountries.count {
            return sectionedCountries[index]
        }
        return nil
    }

    private func country(atIndexPath indexPath: IndexPath) -> Country? {
        if let section = section(atIndex: indexPath.section) {
            let country = section.items[indexPath.row]
            return country
        }
        return nil
    }
}

extension SelectCountryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let country = self.country(atIndexPath: indexPath) {
            self.selectedCountry = country
        }
    }
}

// Note: bMust use class not struct. Structs will not work for building sectioned list due to pass by value
class NamedSection<T> {
    var key: String
    var items: [T]

    init(key: String, items: [T]) {
        self.key = key
        self.items = items
    }
}

