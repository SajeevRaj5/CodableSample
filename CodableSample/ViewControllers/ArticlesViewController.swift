//
//  ArticlesViewController..swift
//  NYTimesArticle
//
//  Created by Sajeev Raj on  4/3/19
//  Copyright © 2019 Sajeev. All rights reserved.
//

import UIKit

extension UIResponder {
    static var identifier: String {
        return "\(self)"
    }
}

protocol Dequeable {
    static func dequeue(tableView: UITableView, indexPath: IndexPath) -> Self
}

extension Dequeable where Self: UITableViewCell {
    static func dequeue(tableView: UITableView, indexPath: IndexPath) -> Self {
        return tableView.dequeueReusableCell(withIdentifier: Self.identifier, for: indexPath) as? Self ?? Self()
    }
}

extension UITableViewCell: Dequeable {}

class ArticlesViewController: UITableViewController {
    
    var articles = [Article]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    var activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // optimise navigation bar
        configureNavigationBar()
        
        // register the cells
        registerTableViewCell()
        
        // configure activity indicator view
        configureActivityIndicator()
        
        // fetch the data to be populated
        getArticlesList()
    }
    
    private func configureActivityIndicator() {
        activityIndicator           = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityIndicator.frame     = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center    = view.center
        activityIndicator.bringSubviewToFront(tableView)
        view.addSubview(activityIndicator)
    }
    
    private func configureNavigationBar() {
        title = "NY Times Most Popular"
        
        navigationController?.navigationBar.tintColor           = ThemeManager.navigationTintColor
        navigationController?.navigationBar.barTintColor        = ThemeManager.navigationColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.layer.shadowColor   = ThemeManager.navigationShadowColor.cgColor
        navigationController?.navigationBar.layer.shadowOffset  = CGSize(width: 0.0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius  = 4.0
        navigationController?.navigationBar.layer.shadowOpacity = 1.0
        navigationController?.navigationBar.layer.masksToBounds = false
    }
    
    private func registerTableViewCell() {
        tableView.register(UINib(nibName: ArticleTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ArticleTableViewCell.identifier)
    }

}

extension ArticlesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ArticleTableViewCell.dequeue(tableView: tableView, indexPath: indexPath)
        cell.article = articles[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let articleDetailViewController = storyboard?.instantiateViewController(withIdentifier: ArticleDetailViewController.identifier) as? ArticleDetailViewController else {
            return
        }
        articleDetailViewController.url = articles[indexPath.row].url
        navigationController?.pushViewController(articleDetailViewController, animated: true)
    }
}

extension ArticlesViewController {
    
    // call service for loading articles
    func getArticlesList() {
        activityIndicator.startAnimating()
        Article.getList { [weak self] (response: ServiceResponse<[Article]>) in
            guard let welf = self else { return }
            switch response {
            case .success(let results):
                print(results)
                welf.articles = results
            case .failure(let error):
                print(error)
            case .finally:
                print("Finally")
                DispatchQueue.main.async {
                    welf.activityIndicator.stopAnimating()
                }
            }
        }
    }
}

