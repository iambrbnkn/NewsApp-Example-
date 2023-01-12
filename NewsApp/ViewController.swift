//
//  ViewController.swift
//  NewsApp
//
//  Created by Vitaliy on 11.01.2023.
//

//TODO:
//- Add activity indicator while loading data
//- Add search news functionality
//- Refactor code

import UIKit
import SafariServices

class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    private var viewModels = [NewsTableViewCellViewModel]()
    private var articles = [Article]()
    private var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    private let tableView: UITableView = {
       let table = UITableView()
        table.register(
            NewsTableViewCell.self,
            forCellReuseIdentifier: NewsTableViewCell.identifier
        )
        return table
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsTableViewCell.identifier,
            for: indexPath
        ) as? NewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else { return }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    private func fetchData() {
        ApiCaller.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(
                        title: $0.title,
                        subtitle: $0.description ?? "",
                        imageURL: URL(string: $0.urlToImage ?? ""))
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

