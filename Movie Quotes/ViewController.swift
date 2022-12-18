//
//  ViewController.swift
//  Movie Quotes
//
//  Created by Aamer Essa on 04/12/2022.
//

import UIKit
import CoreData

protocol movie {
    func goBack()
}
class ViewController: UIViewController,movie {
    

    @IBOutlet weak var movieCollections: UICollectionView!
    var movie = [Movie]()
   
    var selectedMovie = [Int64]()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // connect to DB
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieCollections.reloadData() 
        movieCollections.delegate = self
        movieCollections.dataSource = self
        print("Work")
         
        //createMovieList()
        fetchAllMovie()
       // creteQui()
      
        let lefttSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        lefttSwipe.direction = .left
        view.addGestureRecognizer(lefttSwipe)
        
        for Movie in movie {
            print(Movie.name!)
            print(Movie.id)
            
        }
     

    }
    func goBack() {
        movieCollections.reloadData()
        selectedMovie.removeAll()
        print("SS")
        
    }
    
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer)
    {
        if sender.direction == .left
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let quizView = storyboard.instantiateViewController(withIdentifier: "QuizView") as! QuizViewController
            quizView.selectedMovies = selectedMovie
            quizView.movie = movie
            quizView.goBack = self
            quizView.modalPresentationStyle = .fullScreen
            present(quizView, animated: true)
        }}
    func fetchAllMovie (){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
       
        do{
            let resualt = try managedObjectContext.fetch(request)
          
              movie = resualt as! [Movie]
           
        } catch {
            print("\(error)")
        }

    } // end of fetchAllTa


}

extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = movieCollections.dequeueReusableCell(withReuseIdentifier: "Item", for: indexPath) as! CollectionViewCell
        cell.moveName.text = movie[indexPath.row].name!
        cell.moveImage.image = UIImage(named:movie[indexPath.row].img!)
        cell.layer.cornerRadius = 20
        cell.layer.borderWidth = 0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.isUserInteractionEnabled = true
        return cell
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width/2)-4, height: (view.frame.size.height/5)-4)
       }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        cell?.layer.borderColor = UIColor.blue.cgColor
        cell?.layer.borderWidth = 1
        cell?.layer.cornerRadius = 20
        cell?.isUserInteractionEnabled = false
       
            selectedMovie.append(movie[indexPath.row].id)
        
                
        print(selectedMovie)
    }
    
}

