//
//  TagListView.swift
//  TagListViewDemo
//
//  Created by Dongyuan Liu on 2015-05-09.
//  Copyright (c) 2015 Ela. All rights reserved.
//

import UIKit

@objc public protocol TagListViewDelegate {
    @objc optional func tagPressed(_ title: String, tagView: TagView, sender: TagListView) -> Void
    @objc optional func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) -> Void
    @objc optional func tagListView(_ tagListView: TagListView, didSelectTagAt index: Int) -> Void
    @objc optional func tagListView(_ tagListView: TagListView, willSelectTagAt index: Int) -> Int
    @objc optional func tagListView(_ tagListView: TagListView, didDeselectTagAt index: Int) -> Void
    @objc optional func tagListView(_ tagListView: TagListView, willDeselectTagAt index: Int) -> Int
    @objc optional func tagListView(_ tagListView: TagListView, willBeginEditingTagAt index: Int)
    @objc optional func tagListView(_ tagListView: TagListView, didEndEditingTagAt index: Int)
    @objc optional func tagListView(_ tagListView: TagListView, targetForMoveFromTagAt sourceIndex: Int,
                            toProposed proposedDestinationIndex: Int) -> Int
}

@objc public protocol TagListViewDatasource {
    @objc optional func tagListView(_ tagListView: TagListView, canEditTagAt index: Int) -> Bool
    @objc optional func tagListView(_ tagListView: TagListView, canMoveTagAt index: Int) -> Bool
    @objc optional func tagListView(_ tagListView: TagListView, moveTagAt sourceIndex: Int, to destinationIndex: Int)
}

@IBDesignable
open class TagListView: UIView {
    
    @IBInspectable open dynamic var textColor: UIColor = UIColor.white {
        didSet {
            for tagView in tagViews {
                tagView.textColor = textColor
            }
        }
    }
    
    @IBInspectable open dynamic var selectedTextColor: UIColor = UIColor.white {
        didSet {
            for tagView in tagViews {
                tagView.selectedTextColor = selectedTextColor
            }
        }
    }
    
    @IBInspectable open dynamic var tagBackgroundColor: UIColor = UIColor.gray {
        didSet {
            for tagView in tagViews {
                tagView.tagBackgroundColor = tagBackgroundColor
            }
        }
    }
    
    @IBInspectable open dynamic var tagHighlightedBackgroundColor: UIColor? {
        didSet {
            for tagView in tagViews {
                tagView.highlightedBackgroundColor = tagHighlightedBackgroundColor
            }
        }
    }
    
    @IBInspectable open dynamic var tagSelectedBackgroundColor: UIColor? {
        didSet {
            for tagView in tagViews {
                tagView.selectedBackgroundColor = tagSelectedBackgroundColor
            }
        }
    }
    
    @IBInspectable open dynamic var cornerRadius: CGFloat = 0 {
        didSet {
            for tagView in tagViews {
                tagView.cornerRadius = cornerRadius
            }
        }
    }
    @IBInspectable open dynamic var borderWidth: CGFloat = 0 {
        didSet {
            for tagView in tagViews {
                tagView.borderWidth = borderWidth
            }
        }
    }
    
    @IBInspectable open dynamic var borderColor: UIColor? {
        didSet {
            for tagView in tagViews {
                tagView.borderColor = borderColor
            }
        }
    }
    
    @IBInspectable open dynamic var selectedBorderColor: UIColor? {
        didSet {
            for tagView in tagViews {
                tagView.selectedBorderColor = selectedBorderColor
            }
        }
    }
    
    @IBInspectable open dynamic var paddingY: CGFloat = 2 {
        didSet {
            for tagView in tagViews {
                tagView.paddingY = paddingY
            }
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var paddingX: CGFloat = 5 {
        didSet {
            for tagView in tagViews {
                tagView.paddingX = paddingX
            }
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var marginY: CGFloat = 2 {
        didSet {
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var marginX: CGFloat = 5 {
        didSet {
            rearrangeViews()
        }
    }
    
    @objc public enum Alignment: Int {
        case left
        case center
        case right
    }
    @IBInspectable open var alignment: Alignment = .left {
        didSet {
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var shadowColor: UIColor = UIColor.white {
        didSet {
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var shadowRadius: CGFloat = 0 {
        didSet {
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var shadowOffset: CGSize = CGSize.zero {
        didSet {
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var shadowOpacity: Float = 0 {
        didSet {
            rearrangeViews()
        }
    }
    
    @IBInspectable open dynamic var enableRemoveButton: Bool = false {
        didSet {
            for tagView in tagViews {
                tagView.enableRemoveButton = enableRemoveButton
            }
            rearrangeViews()
        }
    }
    
    @IBInspectable open dynamic var removeButtonIconSize: CGFloat = 12 {
        didSet {
            for tagView in tagViews {
                tagView.removeButtonIconSize = removeButtonIconSize
            }
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var removeIconLineWidth: CGFloat = 1 {
        didSet {
            for tagView in tagViews {
                tagView.removeIconLineWidth = removeIconLineWidth
            }
            rearrangeViews()
        }
    }
    
    @IBInspectable open dynamic var removeIconLineColor: UIColor = UIColor.white.withAlphaComponent(0.54) {
        didSet {
            for tagView in tagViews {
                tagView.removeIconLineColor = removeIconLineColor
            }
            rearrangeViews()
        }
    }
    
    open dynamic var textFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            for tagView in tagViews {
                tagView.textFont = textFont
            }
            rearrangeViews()
        }
    }
    
    @IBOutlet open weak var delegate: TagListViewDelegate?
    @IBOutlet open weak var datasource: TagListViewDatasource?
    
    open private(set) var tagViews: [TagView] = []
    private(set) var tagBackgroundViews: [UIView] = []
    private(set) var rowViews: [UIView] = []
    private(set) var tagViewHeight: CGFloat = 0
    private(set) var rows = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    // MARK: - Interface Builder
    
    open override func prepareForInterfaceBuilder() {
        addTag("Welcome")
        addTag("to")
        selectTag(at: tagViews.index(of: addTag("TagListView"))!)
    }
    
    // MARK: - Layout
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        rearrangeViews()
    }
    
    private func rearrangeViews() {
        let views = tagViews as [UIView] + tagBackgroundViews + rowViews
        for view in views {
            view.removeFromSuperview()
        }
        rowViews.removeAll(keepingCapacity: true)
        
        var currentRow = 0
        var currentRowView: UIView!
        var currentRowTagCount = 0
        var currentRowWidth: CGFloat = 0
        for (index, tagView) in tagViews.enumerated() {
            tagView.frame.size = tagView.intrinsicContentSize
            tagViewHeight = tagView.frame.height
            
            if currentRowTagCount == 0 || currentRowWidth + tagView.frame.width > frame.width {
                currentRow += 1
                currentRowWidth = 0
                currentRowTagCount = 0
                currentRowView = UIView()
                currentRowView.frame.origin.y = CGFloat(currentRow - 1) * (tagViewHeight + marginY)
                
                rowViews.append(currentRowView)
                addSubview(currentRowView)
            }
            
            let tagBackgroundView = tagBackgroundViews[index]
            tagBackgroundView.frame.origin = CGPoint(x: currentRowWidth, y: 0)
            tagBackgroundView.frame.size = tagView.bounds.size
            tagBackgroundView.layer.shadowColor = shadowColor.cgColor
            tagBackgroundView.layer.shadowPath = UIBezierPath(roundedRect: tagBackgroundView.bounds, cornerRadius: cornerRadius).cgPath
            tagBackgroundView.layer.shadowOffset = shadowOffset
            tagBackgroundView.layer.shadowOpacity = shadowOpacity
            tagBackgroundView.layer.shadowRadius = shadowRadius
            tagBackgroundView.addSubview(tagView)
            currentRowView.addSubview(tagBackgroundView)
            
            currentRowTagCount += 1
            currentRowWidth += tagView.frame.width + marginX
            
            switch alignment {
            case .left:
                currentRowView.frame.origin.x = 0
            case .center:
                currentRowView.frame.origin.x = (frame.width - (currentRowWidth - marginX)) / 2
            case .right:
                currentRowView.frame.origin.x = frame.width - (currentRowWidth - marginX)
            }
            currentRowView.frame.size.width = currentRowWidth
            currentRowView.frame.size.height = max(tagViewHeight, currentRowView.frame.height)
        }
        rows = currentRow
        
        invalidateIntrinsicContentSize()
    }
    
    // MARK: - Manage tags
    
    override open var intrinsicContentSize: CGSize {
        var height = CGFloat(rows) * (tagViewHeight + marginY)
        if rows > 0 {
            height -= marginY
        }
        return CGSize(width: frame.width, height: height)
    }
    
    private func createNewTagView(_ title: String) -> TagView {
        let tagView = TagView(title: title)
        
        tagView.textColor = textColor
        tagView.selectedTextColor = selectedTextColor
        tagView.tagBackgroundColor = tagBackgroundColor
        tagView.highlightedBackgroundColor = tagHighlightedBackgroundColor
        tagView.selectedBackgroundColor = tagSelectedBackgroundColor
        tagView.cornerRadius = cornerRadius
        tagView.borderWidth = borderWidth
        tagView.borderColor = borderColor
        tagView.selectedBorderColor = selectedBorderColor
        tagView.paddingX = paddingX
        tagView.paddingY = paddingY
        tagView.textFont = textFont
        tagView.removeIconLineWidth = removeIconLineWidth
        tagView.removeButtonIconSize = removeButtonIconSize
        tagView.enableRemoveButton = enableRemoveButton
        tagView.removeIconLineColor = removeIconLineColor
        tagView.addTarget(self, action: #selector(tagPressed(_:)), for: .touchUpInside)
        tagView.removeButton.addTarget(self, action: #selector(removeButtonPressed(_:)), for: .touchUpInside)
        
        /*
         These seems to interfere with the longPress for reordering.
         Why have the longPress executed by the tagView?
         It is supposed to be a function that works on all tagViews, i.e.
         We could add a longPress gesture if isEditable = false,
         but that evades the logic of isEditable.
         However it does not break things.
         Maybe I should make isEditable optional. If nil it is the past. If true or false the future.
        if !allowReordering {
            // On long press, deselect all tags except this one
            tagView.onLongPress = { [unowned self] this in
                for tag in self.tagViews {
                    tag.isSelected = (tag == this)
                }
            }
        }
        */
        
        return tagView
    }
    
    @discardableResult
    open func addTag(_ title: String) -> TagView {
        return addTagView(createNewTagView(title))
    }
    
    @discardableResult
    open func addTags(_ titles: [String]) -> [TagView] {
        var tagViews: [TagView] = []
        for title in titles {
            tagViews.append(createNewTagView(title))
        }
        return addTagViews(tagViews)
    }
    
    @discardableResult
    open func addTagViews(_ tagViews: [TagView]) -> [TagView] {
        for tagView in tagViews {
            self.tagViews.append(tagView)
            tagBackgroundViews.append(UIView(frame: tagView.bounds))
        }
        rearrangeViews()
        return tagViews
    }
    
    @discardableResult
    open func insertTag(_ title: String, at index: Int) -> TagView {
        return insertTagView(createNewTagView(title), at: index)
    }
    
    @discardableResult
    open func addTagView(_ tagView: TagView) -> TagView {
        tagViews.append(tagView)
        tagBackgroundViews.append(UIView(frame: tagView.bounds))
        rearrangeViews()
        
        return tagView
    }
    
    @discardableResult
    open func insertTagView(_ tagView: TagView, at index: Int) -> TagView {
        tagViews.insert(tagView, at: index)
        tagBackgroundViews.insert(UIView(frame: tagView.bounds), at: index)
        rearrangeViews()
        
        return tagView
    }
    
    open func setTitle(_ title: String, at index: Int) {
        tagViews[index].titleLabel?.text = title
    }
    
    // MARK: editable = true functions
    
    open var editAccessory = " X"
    
    open var isEditable = false {
        // isEditable allways implies allowReordering true
        didSet {
            if isEditable {
                for (index, tagView) in tagViews.enumerated() {
                    if datasource?.tagListView?(self, canEditTagAt: index) != nil && datasource!.tagListView!(self, canEditTagAt: index) {
                        if let title = tagView.titleLabel?.text {
                            setTitle(title + editAccessory, at:index)
                        }
                    }
                }
            } else {
                for (index, tagView) in tagViews.enumerated() {
                    if let title = tagView.titleLabel?.text {
                        let newTitle = title.replacingOccurrences(of: editAccessory, with: "")
                        setTitle(newTitle, at:index)
                    }
                }
            }
            allowReordering = isEditable
        }
    }
    
    open var editableAccessory : String? = nil
    
    open func removeTag(_ title: String) {
        // loop the array in reversed order to remove items during loop
        for index in stride(from: (tagViews.count - 1), through: 0, by: -1) {
            
            let tagView = tagViews[index]
            if tagView.currentTitle == title {
                removeTagView(tagView)
            }
        }
    }
    
    open func removeTag(at index: Int) {
        if datasource?.tagListView?(self, canEditTagAt: index) != nil &&
            datasource!.tagListView!(self, canEditTagAt: index) {
            if datasource?.tagListView?(self, canEditTagAt: index) != nil {
                delegate!.tagListView!(self, willBeginEditingTagAt: index)
            }
            removeTagView(tagViews[index])
            if datasource?.tagListView?(self, canEditTagAt: index) != nil {
                delegate!.tagListView!(self, didEndEditingTagAt: index)
            }
        }
    }
    

    open func removeTagView(_ tagView: TagView) {
        tagView.removeFromSuperview()
        if let index = tagViews.index(of: tagView) {
            tagViews.remove(at: index)
            tagBackgroundViews.remove(at: index)
        }
        rearrangeViews()
    }
    
    
    open func removeAllTags() {
        let views = tagViews as [UIView] + tagBackgroundViews
        for view in views {
            view.removeFromSuperview()
        }
        tagViews = []
        tagBackgroundViews = []
        rearrangeViews()
    }
    
    public var tagsCount: Int {
        get {
            return tagViews.count
        }
    }
    
    // MARK : Selection functions

    
    var allowsMultipleSelection: Bool = false
    
    func deselectTag(at index: Int) {
        tagViews[index].isSelected = false
    }
    
    func selectTag(at index: Int) {
        if !allowsMultipleSelection {
            deselectAllTags()
        }
        tagViews[index].isSelected = true
    }
    
    private func deselectAllTags() {
        for tagView in self.tagViews {
            tagView.isSelected = false
        }
    }
    
    open func selectedTags() -> [TagView] {
        return tagViews.filter() { $0.isSelected == true }
    }
    
    // Maybe this should be deprecated as it exposes to TagView
    open func deSelectTagIn(_ tagView: TagView) {
        if let validIndex = tagViews.index(of: tagView) {
            filterDeselectionAt(validIndex)
        }
    }
    
    private func filterDeselectionAt(_ index: Int) {
        // deselection only works when not in editMode
        if !isEditable {
            // has a deselection filter been defined
            if delegate?.tagListView?(self, willDeselectTagAt: index) != nil {
                // is it allowed to change the deselect state of this tag?
                if index == delegate?.tagListView?(self, willDeselectTagAt: index) {
                    // then select the tag
                    deselectTag(at: index)
                    delegate?.tagListView?(self, didDeselectTagAt: index)
                } else {
                    // no deselection allowed
                }
            } else {
                // always allow
                deselectTag(at: index)
                delegate?.tagListView?(self, didDeselectTagAt: index)
            }
        }
    }
    
    // Maybe this should be deprecated as it exposes to TagView
    open func selectTagIn(_ tagView: TagView) {
        if let validIndex = tagViews.index(of: tagView) {
            filterSelectionAt(validIndex)
        }
    }
    
    private func filterSelectionAt(_ index: Int) {
        if !isEditable {
            // has a selection filter been defined?
            if delegate?.tagListView?(self, willSelectTagAt: index) != nil {
                // is it allowed to change the select state of this tag?
                if index == delegate?.tagListView?(self, willSelectTagAt: index) {
                    // then select the tag
                    selectTag(at: index)
                    delegate?.tagListView?(self, didSelectTagAt: index)
                } else {
                    // no selection allowed
                }
            } else {
                selectTag(at: index)
                delegate?.tagListView?(self, didSelectTagAt: index)
            }
        }
    }

    // MARK: Index functions
    
    var indexForSelectedTag: Int? {
        get {
            for (index, tagView) in tagViews.enumerated() {
                if tagView.isSelected { return index }
            }
            return nil
        }
    }
    
    var indecesForSelectedTags: [Int] {
        get {
            var selectedIndeces: [Int] = []
            for (index, tagView) in tagViews.enumerated() {
                if tagView.isSelected {
                    selectedIndeces.append(index)
                }
            }
            return selectedIndeces
        }
    }
    
    func indecesWithTag(_ title: String) -> [Int] {
        var indeces: [Int] = []
        for (index, tagView) in tagViews.enumerated() {
            if tagView.titleLabel?.text == title {
                indeces.append(index)
            }
        }
        return indeces
    }
    // MARK: - Events
    
    // Maybe this should be deprecated as it exposes to TagView
    func tagPressed(_ sender: TagView!) {
        sender.onTap?(sender)
        if isEditable {
            if let currentIndex = self.tagViews.index(of: sender) {
                removeTag(at: currentIndex)
            }
        } else {
            if let currentIndex = self.tagViews.index(of: sender) {
                sender.isSelected ? filterDeselectionAt(currentIndex) : filterSelectionAt(currentIndex)
            }
        }
        delegate?.tagPressed?(sender.currentTitle ?? "", tagView: sender, sender: self)
    }
    
    func removeButtonPressed(_ closeButton: CloseButton!) {
        if let tagView = closeButton.tagView {
            delegate?.tagRemoveButtonPressed?(tagView.currentTitle ?? "", tagView: tagView, sender: self)
        }
    }
    
    // MARK: - Drag & Drop support
    
    open var allowReordering = false {
        didSet {
            if allowReordering {
                // if reordering is allowed setup the longPress gesture
                let longpress = UILongPressGestureRecognizer(target: self, action: #selector(TagListView.longPressGestureRecognized))
                self.addGestureRecognizer(longpress)
            }
        }
    }

    private func indexForTagViewAt(_ point: CGPoint) -> Int? {
        for (index, tagView) in tagViews.enumerated() {
            if tagView.frame.contains(self.convert(point, to: tagView)) {
                return index
            }
        }
        return nil
    }
    
    
    private var longPressViewSnapshot : UIView? = nil
    
    private var longPressInitialIndex : Int? = nil

    @objc private func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        
        func snapshotOfView(_ inputView: UIView) -> UIView {
            UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
            inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
            UIGraphicsEndImageContext()
            let cellSnapshot : UIView = UIImageView(image: image)
            cellSnapshot.layer.masksToBounds = false
            cellSnapshot.layer.cornerRadius = 0.0
            cellSnapshot.layer.shadowOffset = CGSize.init(width: -5.0, height: 0.0)
            cellSnapshot.layer.shadowRadius = 5.0
            cellSnapshot.layer.shadowOpacity = 0.4
            return cellSnapshot
        }
        
        
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let locationInView = longPress.location(in: self)
        // get the index of the tag where the longPress took place
        var index = indexForTagViewAt(longPress.location(in: self))
        
        func startReOrderingTagAt(_ sourceIndex: Int?) {
            
            let state = longPress.state
            switch state {
            case UIGestureRecognizerState.began:
                self.longPressInitialIndex = index
                if let sourceIndex = self.longPressInitialIndex {
                    if let canMoveTag = datasource?.tagListView?(self, canMoveTagAt: sourceIndex) {
                        // check if the user gives permission to move this tag
                        if canMoveTag {
                            // make only a snapshot if the tag is allowed to move
                            longPressViewSnapshot = snapshotOfView(tagViews[sourceIndex])
                            if longPressViewSnapshot != nil {
                                
                                longPressViewSnapshot!.isHidden = true
                                longPressViewSnapshot!.alpha = 0.0
                                addSubview(longPressViewSnapshot!)
                                
                                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                                    self.longPressViewSnapshot!.center = locationInView
                                    self.longPressViewSnapshot!.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                                    self.longPressViewSnapshot!.alpha = 0.9
                                    self.tagViews[sourceIndex].alpha = 0.3
                                }, completion: { (finished) -> Void in
                                    if finished {
                                        self.tagViews[sourceIndex].isHidden = true
                                        self.longPressViewSnapshot!.isHidden = false
                                    }
                                })
                            }
                        }
                    }
                }
            case UIGestureRecognizerState.changed:
                if longPressViewSnapshot != nil {
                    // move the snapshot to current press location
                    longPressViewSnapshot!.center = locationInView
                    if let validDestinationIndex = index,
                        let validSourceIndex = self.longPressInitialIndex {
                        if validDestinationIndex != validSourceIndex {
                            // ask the user if the destinationIndex is allowed
                            if let userDefinedDestinationIndex = delegate?.tagListView?(self, targetForMoveFromTagAt: validSourceIndex, toProposed: validDestinationIndex) {
                                // use the destinationIndex value proposed by the user
                                moveTagAt(validSourceIndex, to: userDefinedDestinationIndex)
                                self.longPressInitialIndex = userDefinedDestinationIndex
                            } else {
                                // the user does not want to interfere, so default is to use the initial proposed target index
                                moveTagAt(self.longPressInitialIndex!, to: validDestinationIndex)
                                self.longPressInitialIndex = validDestinationIndex
                            }
                        }
                    }
                }
            default:
                if longPressViewSnapshot != nil {
                    if let validIndex = self.longPressInitialIndex {
                        tagViews[validIndex].isHidden = false
                        tagViews[validIndex].alpha = 0.0
                        UIView.animate(withDuration: 0.25, animations: { () -> Void in
                            self.longPressViewSnapshot!.center = self.tagViews[validIndex].center
                            self.longPressViewSnapshot!.transform = CGAffineTransform.identity
                            self.longPressViewSnapshot!.alpha = 0.0
                            self.tagViews[validIndex].alpha = 1.0
                        }, completion: { (finished) -> Void in
                            if finished {
                                self.longPressInitialIndex = nil
                                self.longPressViewSnapshot!.removeFromSuperview()
                                self.longPressViewSnapshot = nil
                            }
                        })
                    } else {
                        UIView.animate(withDuration: 0.25, animations: { () -> Void in
                            // My.viewSnapshot!.center = self.tagViews[validIndex].center
                            self.longPressViewSnapshot!.transform = CGAffineTransform.identity
                            self.longPressViewSnapshot!.alpha = 0.0
                            // self.tagViews[validIndex].alpha = 1.0
                        }, completion: { (finished) -> Void in
                            if finished {
                                self.longPressInitialIndex = nil
                                self.longPressViewSnapshot!.removeFromSuperview()
                                self.longPressViewSnapshot = nil
                            }
                        })
                    }
                }
            }
        }
        
        func moveTagAt(_ fromIndex: Int, to toIndex: Int) {
            if fromIndex != toIndex {
                tagViews.insert(tagViews.remove(at: fromIndex), at: toIndex)
                // give the user the chance to move the data
                datasource?.tagListView?(self, moveTagAt: fromIndex, to: toIndex)
            }
        }
        
        startReOrderingTagAt(index)

    }

    
}
