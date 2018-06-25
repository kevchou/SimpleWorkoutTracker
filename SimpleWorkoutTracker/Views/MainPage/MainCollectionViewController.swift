//
//  MainCollectionViewController.swift
//  SimpleWorkoutTracker
//
//  Created by Kevin Chou on 2018-06-13.
//  Copyright © 2018 Kevin Chou. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MainCollectionViewController: UICollectionViewController, UIViewControllerTransitioningDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    
    
    

    // MARK: UICollectionViewDelegate

    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
 
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch(indexPath.row) {
        case 0:
            performSegue(withIdentifier: "NewWorkoutSegue", sender: self)
            
        case 1:
            let pvc = UIViewController()
            pvc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(pvc, animated: true, completion: nil)
            
        default:
            return
        }
    }
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    fileprivate let itemsPerRow: CGFloat = 2
}



// MARK: DataSource
extension MainCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCellIdentifier", for: indexPath) as! MainPageCollectionViewCell
        
        // Configure the cell
        cell.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        if indexPath.row == 0 {
            cell.textLabel.text = "New Workout"
        }
        
        return cell
    }
}


// MARK: - Size of collectionview cells
extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout
                    collectionViewLayout: UICollectionViewLayout,
                 sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
             layout collectionViewLayout: UICollectionViewLayout,
               insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
        return sectionInsets
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
        
    }

    // MARK: - Navigation
    @IBAction func unwindToMainPageSegue(segue: UIStoryboardSegue) {

    }

}



