//
//  ItemViewController.swift
//  wishter
//
//  Created by Wilhelm Michaelsen on 5/23/17.
//  Copyright © 2017 Wilhelm Michaelsen. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CustomItemHeaderDelegate {

    @IBOutlet weak var myCollectionView: UICollectionView!
    
    /* itemData = ["price":..., "title":...] */
    var itemData: NSDictionary?
    var itemImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.myCollectionView.delegate = self
        self.myCollectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: UICollectionViewDelegate/DataSource
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "itemID", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView: CustomItemHeader = myCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "itemHeader", for: indexPath) as! CustomItemHeader
        
        headerView.delegate = self
        headerView.itemLabel.text = self.itemData?["title"] as? String
        headerView.itemImageView.image = self.itemImage
        
        return headerView
    }
    
    //MARK: CustomItemHeaderDelegate
    func buyTapped(_ sender: Any) {
         if let link = self.itemData?["url"] {
             UIApplication.shared.openURL(NSURL(string: "https://\(link)") as! URL)
         } else {
             print("link is nil (ProfileViewController.swift)")
         }
    }

}
