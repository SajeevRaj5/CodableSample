//
//  ArticleTableViewCell.swift
//  NYTimesArticle
//
//  Created by Sajeev Raj on  4/3/19
//  Copyright © 2019 Sajeev. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    var article: Article? {
        didSet {
            configureView()
        }
    }

    @IBOutlet weak var detailLabel: UILabel?
    @IBOutlet weak var authorNameLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var profileImageView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
        
        setUpViewProperties()
    }
    
    private func setUpViewProperties() {
        profileImageView?.layer.cornerRadius = (profileImageView?.bounds.width ?? 0)/2
    }
    
    private func configureView() {
        detailLabel?.text = article?.title
        authorNameLabel?.text = article?.author
        dateLabel?.text = article?.publishedDate
    }
}
