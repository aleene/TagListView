//
//  ViewController.swift
//  TagListViewDemo
//
//  Created by Dongyuan Liu on 2015-05-09.
//  Copyright (c) 2015 Ela. All rights reserved.
//
import UIKit

class ViewController: UIViewController, TagListViewDelegate, TagListViewDatasource {
    
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
    @IBOutlet weak var scrollViewTagListView: TagListView!

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
        
        // setup biggerTagListView
        
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
        
        // This is an example of a TagListView, wich allows reordering
        // The data is found in biggestTagListViewTags
        // the data is reordered as the tags move around
        // However the last one is fixed: it can not be moved or replaced
        
        biggestTagListView.delegate = self
        biggestTagListView.datasource = self
        biggestTagListView.textFont = UIFont.systemFont(ofSize: 24)
        // it is also possible to add all tags in one go
        biggestTagListView.addTags(biggestTagListViewTags)
        biggestTagListView.alignment = .right
        // set to editable to allow reordering
        biggestTagListView.isEditable = true

        // This is an example of a TagListView inside a UIScrollView
        // You should fix the height of the UIScrollView
        // It only uses the default settings of a TagListView.
        
        scrollViewTagListView.delegate = self
        scrollViewTagListView.addTags(["This","is","a","TagListView","within","a","scrollView.","If", "the","data","do","not","fit","the","view","you","should","be","able","to","scroll","around.","This","is","a","TagListView","within","a","scrollView.","If", "the","data","do","not","fit","the","view","you","should","be","able","to","scroll","around.","This","is","a","TagListView","within","a","scrollView.","If", "the","data","do","not","fit","the","view","you","should","be","able","to","scroll","around.","This","is","a","TagListView","within","a","scrollView.","If", "the","data","do","not","fit","the","view","you","should","be","able","to","scroll","around."])
        multipleSelectionIsAllowed = false
    }
    
    private var biggestTagListViewTags = ["These","tags", "can", "be", "reordered", "by", "drag&drop", "NOT this one"]

    // MARK: TagListViewDatasource Functions

    func tagListView(_ tagListView: TagListView, canMoveTagAt index: Int) -> Bool {
        if tagListView == biggestTagListView {
            return index == biggestTagListView.tagsCount - 1 ? false : true
        } else {
            return true
        }

    }
    
    func tagListView(_ tagListView: TagListView, moveTagAt sourceIndex: Int, to destinationIndex: Int) {
        if tagListView == biggestTagListView {
            biggestTagListViewTags.insert(biggestTagListViewTags.remove(at: sourceIndex), at: destinationIndex)
            print(biggestTagListViewTags)
        }
    }

    // MARK: TagListViewDelegate Functions
    
    func tagListView(_ tagListView: TagListView, targetForMoveFromTagAt sourceIndex: Int,
                     toProposed proposedDestinationIndex: Int) -> Int {
        if tagListView == biggestTagListView {
            return proposedDestinationIndex == biggestTagListView.tagsCount - 1 ? biggestTagListView.tagsCount - 2 : proposedDestinationIndex
        } else {
            return proposedDestinationIndex
        }
    }

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
