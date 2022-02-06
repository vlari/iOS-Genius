//
//  ChartsViewController.swift
//  LyricsApp
//
//  Created by Obed Garcia on 3/2/22.
//

import UIKit

class ChartsViewController: UIViewController {
    private var tableView = UITableView()
    private var charts: [ChartCellViewModel] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureTableView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCharts()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        title = "Charts"
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.register(ChartTableViewCell.self, forCellReuseIdentifier: ChartTableViewCell.identifier)
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = 100
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    private func fetchCharts() {
        ApiService.shared.request(endpoint: SiteEndpoint.getCharts) { [weak self] result in
            switch result {
            case .success(let data):
                
                let chartData = UtilManager.shared.getCharts(from: data)
                self?.charts = chartData
                
                self?.tableView.reloadData()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension ChartsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !charts.isEmpty else {
            return UITableViewCell()
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChartTableViewCell.identifier, for: indexPath) as? ChartTableViewCell else {
            return UITableViewCell()
        }
        
        let chart = charts[indexPath.row]
        cell.configure(with: chart)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charts.count
    }
}
