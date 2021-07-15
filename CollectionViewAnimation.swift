//
//  BottomView.swift
//  newNoCrop
//
//  Created by Mehedi on 6/20/21.
//

import UIKit

class BottomView: UIView {
    
    var currentSelectedIndex = -1
    @IBOutlet var containerView: UIView!
    
    @IBOutlet weak var videoView: VideoView!
    @IBOutlet var bottomViewBottomConstraintsArray: [NSLayoutConstraint]!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    deinit {
        print("BottomView Deinit")
    }
}

extension BottomView {
    
    fileprivate func commonInit() {
        Bundle.main.loadNibNamed("BottomView", owner: self, options: nil)
        self.containerView.frame = self.bounds
        self.containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(self.containerView)
       // self.setupCollectionView()
    }
}

//MARK: CollectioView Delegate, DataSource, FlowlayOut
extension BottomView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: Setup CollectionView
    fileprivate func setupCollectionView() {
        self.registerCollectionViewCell()
        self.setCollectionViewFlowLayout()
        self.setCollectionViewDelegate()
    }
    
    //MARK: Registration nib file and Set Delegate, Datasource
    fileprivate func registerCollectionViewCell(){
        let menuNib = UINib(nibName: "CollectionViewCell", bundle: nil)
        self.collectionView.register(menuNib, forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    //MARK: Set Collection View Flow Layout
    fileprivate func setCollectionViewFlowLayout(){
        if let layoutMenu = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layoutMenu.scrollDirection = .horizontal
            layoutMenu.minimumLineSpacing = 15
            layoutMenu.minimumInteritemSpacing = 15
        }
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    //ReloadSingle Cell
    fileprivate func reloadSingleCell(){
        
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = self.collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.5, animations: {
            //self.collectionView.reloadItems(at: [indexPath])
            cell?.reloadInputViews()
            cell?.layoutIfNeeded()
        })
    }
    
    //MARK: Set Collection View Delegate
    fileprivate func setCollectionViewDelegate(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.containerView.layer.cornerRadius = cell.containerView.bounds.height * 0.5
        cell.containerView.clipsToBounds = true
        cell.containerView.backgroundColor = UIColor.red
        cell.collectionViewCellDelegate = self
        cell.containerView.layer.cornerRadius = cell.containerView.bounds.height * 0.5
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentSelectedIndex = indexPath.item
       self.collectionView.reloadItems(at: [indexPath])
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        let cell = self.collectionView.cellForItem(at: indexPath) as? CollectionViewCell
        cell?.topCellView.isHidden = true
        
        cell?.transform = CGAffineTransform(scaleX: 0.1, y: 1)
        cell?.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.18, animations: {
            cell?.transform = CGAffineTransform(scaleX: 0.2, y: 1)
        }, completion: {_ in
            UIView.animate(withDuration: 0.16, animations: {
                cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1)
            }, completion: {_ in
                UIView.animate(withDuration: 0.5, animations: {
                    cell?.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: {_ in
                    
                })
            })
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = self.collectionView.cellForItem(at: indexPath) as? CollectionViewCell
        cell?.topCellView.isHidden = false
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = collectionView.bounds.height
        let height: CGFloat = collectionView.bounds.height
        if indexPath.item == self.currentSelectedIndex {
            width = 300
        }
        return CGSize(width: width, height: height)
    }
    
}

extension BottomView: CollectionViewCellDelegate {
    func tappedOnCellCancelButton() {
        let indexPath = IndexPath(item: self.currentSelectedIndex, section: 0)
        let cell = self.collectionView.cellForItem(at: indexPath) as? CollectionViewCell
        cell?.topCellView.isHidden = false
        self.currentSelectedIndex = -1
        self.collectionView.reloadData()
    }
    
    
}
