//
//  TagsTableViewCell.swift
//  TagListViewDemo
//
//  Created by arnaud on 23/11/16.
//  Copyright © 2016 Ela. All rights reserved.
//

import UIKit
import TagListView

class TagsTableViewCell: UITableViewCell {
    
    var tagList: [String] = [] {
        didSet {
            setupTagListViewWithData()
        }
    }
    
    private func setupTagListViewWithData() {
        if tagListView != nil {
            tagListView.removeAllTags()
            tagListView.addTags(tagList)
            tagListView.editable = editMode
        }
    }

    var editMode = false {
        didSet {
            setupTagListViewWithData()
        }
    }
    
    @IBOutlet weak var tagListView: TagListView! {
        didSet {
            tagListView.textFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
            tagListView.alignment = .center
            tagListView.tagBackgroundColor = UIColor.green
            tagListView.cornerRadius = 10
            setupTagListViewWithData()
        }
    }
}
