//
//  ViewController.swift
//  TagListViewDemo
//
//  Created by Dongyuan Liu on 2015-05-09.
//  Copyright (c) 2015 Ela. All rights reserved.
//
import UIKit

class ViewController: UIViewController, TagListViewDelegate {
    
    @IBOutlet weak var tagListView: TagListView! {
        didSet {
            tagListView.allowsMultipleSelection = multipleSelectionIsAllowed
        }
    }

    @IBOutlet weak var biggerTagListView: TagListView! {
        didSet {
            biggerTagListView.allowsMultipleSelection = multipleSelectionIsAllowed
        }
    }

    @IBOutlet weak var biggestTagListView: TagListView! {
        didSet {
            if multipleSelectionSwitch != nil {
                multipleSelectionSwitch.setOn(multipleSelectionIsAllowed, animated: true)
            }
        }
    }

    @IBAction func multipleSelectionSwitch(_ sender: UISwitch) {
        multipleSelectionIsAllowed = !multipleSelectionIsAllowed
    }
    
    @IBOutlet weak var multipleSelectionSwitch: UISwitch! {
        didSet {
            multipleSelectionSwitch.setOn(multipleSelectionIsAllowed, animated: true)
        }
    }

    private var multipleSelectionIsAllowed = false {
        didSet {
            tagListView.allowsMultipleSelection = multipleSelectionIsAllowed
            biggerTagListView.allowsMultipleSelection = multipleSelectionIsAllowed
            biggestTagListView.allowsMultipleSelection = multipleSelectionIsAllowed
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagListView.delegate = self
        tagListView.addTag("TagListView")
        tagListView.addTag("TEAChart")
        tagListView.addTag("To Be Removed")
        tagListView.addTag("To Be Removed")
        tagListView.addTag("Quark Shell")
        tagListView.removeTag("To Be Removed")
        tagListView.addTag("On tap will be removed").onTap = { [weak self] tagView in
            self?.tagListView.removeTagView(tagView)
        }
        
        let tagView = tagListView.addTag("gray")
        tagView.tagBackgroundColor = UIColor.gray
        tagView.onTap = { tagView in
            print("Don’t tap me!")
        }
        
        tagListView.insertTag("This should be the third tag", at: 2)
        
        biggerTagListView.delegate = self
        biggerTagListView.textFont = UIFont.systemFont(ofSize: 15)
        biggerTagListView.shadowRadius = 2
        biggerTagListView.shadowOpacity = 0.4
        biggerTagListView.shadowColor = UIColor.black
        biggerTagListView.shadowOffset = CGSize(width: 1, height: 1)
        biggerTagListView.addTag("Inboard")
        biggerTagListView.addTag("Pomotodo")
        biggerTagListView.addTag("Halo Word")
        biggerTagListView.alignment = .center
        
        biggestTagListView.delegate = self
        biggestTagListView.textFont = UIFont.systemFont(ofSize: 24)
        // it is also possible to add all tags in one go
        biggestTagListView.addTags(["all", "your", "tag", "are", "belong", "to", "us"])
        biggestTagListView.alignment = .right
        
        multipleSelectionIsAllowed = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        if sender.allowsMultipleSelection {
            let indeces = sender.indecesForSelectedTags
            if !indeces.isEmpty {
                for index in indeces {
                    if sender.tagViews[index] == tagView {
                        print("This tag is selected and has index:", index)
                    }
                }
                print(sender.selectedTags().count, "have been selected")
            }
        } else {
            if let index = sender.indexForSelectedTag {
                print("This tag is selected and has index:", index)
                print(sender.selectedTags().count, "tags have been selected")
            }
        }
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }
    
    @IBAction func updateTitleDemo(_ sender: UIButton) {
        biggerTagListView.setTitle("New title", at: 1)
    }
    
    @IBAction func unwindToViewController(_ segue:UIStoryboardSegue) {
    }
    
}
