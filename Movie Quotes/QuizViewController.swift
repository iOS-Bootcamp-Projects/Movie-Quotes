//
//  QuizViewController.swift
//  Movie Quotes
//
//  Created by Aamer Essa on 04/12/2022.
//

import UIKit
import CoreData 
class QuizViewController: UIViewController {

    
    @IBOutlet weak var showAnswerText: UILabel!
    @IBOutlet weak var movieImageContiner: UIView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var userAnswer: UITextField!
    @IBOutlet weak var errorMassage: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var question: UITextView!
    var goBack:movie?
    var movie = [Movie]()
    var selectedMovies = [Int64]()
    var pointer = 0
    var score = 0
    var questions = [Answer]()
    var selectedQuestion = [Answer]()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // connect to DB
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMassage.isHidden = true
        fetchQuestions()
        question.text = selectedQuestion[pointer].question!
        movieImage.isHidden = true
        movieImageContiner.isHidden = true
        
    }
    

    
    // MARK: - Navigation

    @IBAction func onClickBack(_ sender: Any) {
        let alert = UIAlertController(title: "Cancel the current game??", message: "You score will not be saved", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Re-Pick Movie", style: .destructive,handler: { handler in
            self.pointer = 0
            self.score = 0
            self.dismiss(animated: true)
            self.goBack?.goBack()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
   
    @IBAction func showAnswer(_ sender: Any) {
        let alert = UIAlertController(title: "Show Answer", message: "You will lose a point on your score", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Go Back", style: .cancel))
        alert.addAction(UIAlertAction(title: "Show Answer", style: .destructive,handler: { showAnswer in
            self.movieImageContiner.isHidden = false
            self.showAnswerText.isHidden = false
            self.movieImageContiner.backgroundColor = .red
            
            UIView.animate(withDuration: 0.5, delay: 0.0,usingSpringWithDamping: 0.5,initialSpringVelocity: 0.5,options: .curveEaseInOut) {
                self.showAnswerText.text = self.selectedQuestion[self.pointer].answer
                self.showAnswerText.transform = CGAffineTransform(translationX: -25, y: 0)
            }
            
                        self.pointer += 1
            if self.score > 0 {
                self.score -= 1
                self.scoreLabel.text = "Score: \(self.score)"
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+2.0 , execute: {self.showNextQuestion()})
        }))
        self.present(alert, animated: true)
    }
    
    
    func fetchQuestions (){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Answer")
        do{
            let resualt = try managedObjectContext.fetch(request)
            questions = resualt as! [Answer]
        } catch {
            print("\(error)")
        }
        for selectedMovie in selectedMovies {
            for Question in questions {
                if Question.movieID == selectedMovie {
                    selectedQuestion.append(Question)
                }
            }
        }
        for qq in selectedQuestion {
            print(qq.movieID)
            
        }
    } // end of fetchAllTa
    
    @IBAction func userAnswer(_ sender: UITextField) {
        print(selectedQuestion)
        if sender.text == selectedQuestion[self.pointer].answer! {
            movieImage.isHidden = false
            movieImageContiner.isHidden = false
            movieImageContiner.backgroundColor = .black
            showAnswerText.isHidden = true
            for Movie in movie {
                if Movie.name == sender.text {
                    movieImage.image = UIImage(named: Movie.img!)
                }
            }
            pointer += 1
            score += 1
            scoreLabel.text = "Score: \(score)"
            DispatchQueue.main.asyncAfter(deadline: .now()+2.0 , execute: {self.showNextQuestion()})
            
            
        } else if sender.text != "" {
            errorMassage.isHidden = false
        }
    }
    
    func showNextQuestion () {
        errorMassage.isHidden = true
        
        if pointer >= selectedQuestion.count {
            movieImageContiner.isHidden = false
            movieImageContiner.backgroundColor = .green
            movieImage.isHidden = true
            showAnswerText.isHidden = false
            showAnswerText.text = "Your Score is \(score) out of \(selectedQuestion.count)"
            selectedQuestion.removeAll()
            DispatchQueue.main.asyncAfter(deadline: .now()+2.0 , execute: {
                self.dismiss(animated: true)
                self.pointer = 0
                self.score = 0
                self.goBack?.goBack()
                
            })
            
        } else{
            movieImage.isHidden = true
            movieImageContiner.isHidden = true
            userAnswer.text = ""
            question.text = selectedQuestion[self.pointer].question
        }
        
        
    }
}
