//
//  ViewController.swift
//  TrendingMovies
//
//  Created by EDA BARUTÇU on 10.01.2022.
//

import UIKit
import Alamofire

class TrendingMoviesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let TrendingMoviesURL = "https://api.themoviedb.org/3/trending/movie/week?api_key=6702a110e5d04249321d8bde3181b806"
    private var movies: [MovieEntity.Movie] = [MovieEntity.Movie]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var pageNumber: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        let nib =  UINib(nibName: MovieCell.identifier, bundle: Bundle(for: MovieCell.self))
        tableView.register(nib, forCellReuseIdentifier: MovieCell.identifier)
        getTrendingMovies()
    }
    
    private func getTrendingMovies(_ pageNumber: Int? = nil) {
        var params: [String: Any] = [:]
        if let page = pageNumber {
            params["page"] = page
        }
        
        AF.request(TrendingMoviesURL, method: .get, parameters: params).responseJSON {  (response) in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let moviesJSON = try JSONDecoder().decode(MovieEntity.self, from: data)
                        self.movies += moviesJSON.movies
                    } catch {
                        print(error)
                    }
                }
            case .failure:
                print("fail!")
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        if deltaOffset >= 10, deltaOffset < 200 {
            pageNumber += 1
            getTrendingMovies(pageNumber)
        }
    }
}



extension TrendingMoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        cell.movie = movies[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = storyboard.instantiateViewController(withIdentifier: "details") as? ModelDetailsViewController {
            vc.movieId = movies[indexPath.row].id
            print(movies[indexPath.row].id)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

