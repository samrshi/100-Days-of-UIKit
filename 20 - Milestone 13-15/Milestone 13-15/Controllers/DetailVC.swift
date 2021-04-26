//
//  DetailVC.swift
//  Milestone 13-15
//
//  Created by Samuel Shi on 4/25/21.
//

import UIKit

class DetailVC: UIViewController {
  enum Section {
    case flag, general, languages, currencies
  }
  let sections: [Section] = [.flag, .general, .languages, .currencies]
  let tableView = UITableView()
  
  private var country: CountryVM!

  override func viewDidLoad() {
    super.viewDidLoad()
    title = country.country.name
    navigationItem.largeTitleDisplayMode = .never

    configureTableView()
    
    let shareButton = UIBarButtonItem(
      barButtonSystemItem: .action,
      target: self,
      action: #selector(shareTapped))
      
    navigationItem.rightBarButtonItem = shareButton
  }
  
  @objc func shareTapped() {
    let vc = UIActivityViewController(
      activityItems: [country.overview()],
      applicationActivities: [])
    vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    present(vc, animated: true)
  }
  
  func set(with country: Country) {
    self.country = CountryVM(country: country)
  }

  func configureTableView() {
    view.addSubview(tableView)
    setTableViewDelegates()
    tableView.rowHeight = UITableView.automaticDimension
    tableView.register(DetailFlagCell.self, forCellReuseIdentifier: DetailFlagCell.reuseID)
    tableView.register(DetailTextCell.self, forCellReuseIdentifier: DetailTextCell.reuseID)

    tableView.pin(to: view)
  }

  func setTableViewDelegates() {
    tableView.delegate   = self
    tableView.dataSource = self
  }
}

extension DetailVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return 5
    case 2:
      return country.languages.count
    default:
      return country.currencies.count
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch sections[indexPath.section] {
    case .flag:
      let id = DetailFlagCell.reuseID
      let cell = tableView.dequeueReusableCell(withIdentifier: id) as! DetailFlagCell
      cell.flagImage.image = UIImage(named: country.alpha2Code)
      return cell
    default:
      let id = DetailTextCell.reuseID
      let cell = tableView.dequeueReusableCell(
        withIdentifier: id) as! DetailTextCell
      
      switch sections[indexPath.section] {
      case .general:
        switch indexPath.row {
        case 0:
          cell.set(with: country.name())
        case 1:
          cell.set(with: country.demonym())
        case 2:
          cell.set(with: country.capital())
        case 3:
          cell.set(with: country.population())
        default:
          cell.set(with: country.area())
        }
        
      case .languages:
        cell.set(with: country.langauge(index: indexPath.row))
        
      case .currencies:
        cell.set(with: country.currency(index: indexPath.row))
        
      default:
        break
      }
      
      return cell
    }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Flag"
    case 1:
      return "General Info"
    case 2:
      return "Languages"
    default:
      return "Currency"
    }
  }
}
