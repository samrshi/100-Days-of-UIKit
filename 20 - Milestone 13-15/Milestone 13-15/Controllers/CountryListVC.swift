//
//  ViewController.swift
//  MIlestone 13-15
//
//  Created by Samuel Shi on 4/24/21.
//

import UIKit

class CountryListVC: UIViewController, CountryStoreDelegate {
  let tableView    = UITableView()
  let countryStore = CountryStore()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode =  .always

    title = "Countries"
    countryStore.delegate = self
    
    configureTableView()
  }

  func configureTableView() {
    view.addSubview(tableView)
    setTableViewDelegates()
    tableView.rowHeight = 75
    tableView.register(CountryCell.self, forCellReuseIdentifier: CountryCell.reuseID)

    tableView.pin(to: view)
  }

  func setTableViewDelegates() {
    tableView.delegate   = self
    tableView.dataSource = self
  }
  
  func didReceiveCountries() {
    tableView.reloadData()
  }
}

extension CountryListVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return countryStore.countries.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.reuseID) as! CountryCell
    let country = countryStore.countries[indexPath.row]
    cell.set(country: country)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = DetailVC()
    vc.set(with: countryStore.countries[indexPath.row])
    navigationController?.pushViewController(vc, animated: true)
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
