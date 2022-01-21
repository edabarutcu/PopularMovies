//
//  ModelDetailsViewController.swift
//  TrendingMovies
//
//  Created by EDA BARUTÇU on 10.01.2022.
//

import UIKit
import Alamofire

class ModelDetailsViewController: UIViewController {
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingConteinerView: UIView!
    
    private var ModelDetailsURL = ""
    
    public var movieId: Int? {
        didSet {
            ModelDetailsURL = "https://api.themoviedb.org/3/movie/\( movieId!))?api_key=6702a110e5d04249321d8bde3181b806&language=en-US"
        }
    }
    
    public var details: DetailEntity? {
        didSet {
            if let details = details {
                let posterURL = URL(string:"https://image.tmdb.org/t/p/w500" + (details.poster ?? ""))
                poster.kf.setImage(with: posterURL)
                ratingLabel.text = "\(details.rating)"
                titleLabel.text = details.title
                descriptionLabel.text = details.overview
                releaseDateLabel.text = details.releaseDate
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getModelDetails()
        ratingConteinerView.layer.cornerRadius = 12
        ratingConteinerView.layer.masksToBounds = true
    }
    
    
}

extension ModelDetailsViewController {
    func getModelDetails() {
        AF.request(ModelDetailsURL, method: .get, parameters: [:]).responseJSON { (response) in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let detailsJSON = try JSONDecoder().decode(DetailEntity.self, from: data)
                        self.details = detailsJSON
                    } catch {
                        print(error)
                    }
                    
                    
                }
            case .failure:
                print("Fail!")
                
                
            }
            
        }
    }
}
