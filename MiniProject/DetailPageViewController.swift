//
//  DetailPageViewController.swift
//  MiniProject
//
//  Created by 유민아 on 2023/06/13.
//

import UIKit

class DetailPageViewController: UIViewController {
    var movie: Movie?
    var movieInfo: MovieInfo?
    var seperate: String = " | "
    var movieId: Int = 0
    var imdbId: String = ""
    var sMovieId: Int = 0

    let apiKey = "d5093ab98d0da8cf7324a5aa283bf1ab"
    let apiUrl = "https://api.themoviedb.org/3/movie"
    let imdbUrl = "https://www.imdb.com/title/"

    @IBOutlet weak var titleLabel: UILabel! // 제목
    @IBOutlet weak var overviewLabel: UILabel! // 개요
    @IBOutlet weak var manyInfoLabel: UILabel!// 평점, 개봉년도, 러닝타임 등..
    @IBOutlet weak var castLabel: UILabel! // 배우
    @IBOutlet weak var directorLabel: UILabel! // 감독
    @IBOutlet weak var movieImg: UIImageView!
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = movie {
            // 클릭한 영화의 아이디, 제목
            print("영화 제목: \(movie.originalTitle)")
            print("영화 아이디: \(movie.id)")
            
            movieId = movie.id
            imdbId = movie.imdbID
            
            fetchMovieCredits()
            DispatchQueue.main.async {
                self.viewDetailMovie()
            }
        } else {
            print("영화에 대한 정보가 없습니다.")
        }
    }

    func fetchMovieCredits() { // 출연진에 관한 데이터 가져오기
        let urlString = "\(apiUrl)/\(movieId)/credits?api_key=\(apiKey)&language=en-US"
        let session: URLSession = URLSession(configuration: .default)
        guard let url = URL(string: urlString) else { return }
        
        print("test ", movieId)
        print(urlString)
        
        let dataTask = session.dataTask(with: url) { [weak self] (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
                
            do {
                let movieInfo = try JSONDecoder().decode(MovieInfo.self, from: data)
                self?.movieInfo = movieInfo

                if let crew = movieInfo.crew.first {
                    print("First crew member: \(crew.name)")
                } else {
                    print("No crew members found.")
                }
                    
                DispatchQueue.main.async {
                    self?.viewDetailMovie()
                }
                
            } catch (let err) {
                print("**", err.localizedDescription)
                print("Decoding error:", err)
            }
        }
        dataTask.resume()
    }
    
    func viewDetailMovie() {
        if let imagePath = Bundle.main.path(forResource: "poster_sample", ofType: "jpg") {
            let imageURL = URL(fileURLWithPath: imagePath)
            if let image = UIImage(contentsOfFile: imageURL.path) {
                movieImg.image = image
            } else {
                print("이미지를 로드할 수 없습니다.")
            }
        }
        
        titleLabel.text = movie?.title
        
        var releaseDate = movie!.releaseDate
        var releaseYear = releaseDate.components(separatedBy: "-").first
        
        manyInfoLabel?.text = "⭐️ \(movie!.voteAverage)\(seperate)\(releaseYear ?? "nil")\(seperate)\(Int(movie!.runtime))분"
        
        if let directors = movieInfo?.crew.filter({ $0.department == "Directing" }) {
            let directorNames = directors.map { $0.name }
            directorLabel.text = "감독       \(directorNames.joined(separator: ", "))"
            let attributedText = NSMutableAttributedString(string: directorLabel.text ?? "")
            attributedText.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: directorLabel.font.pointSize)], range: NSRange(location: 0, length: 2))
            directorLabel.attributedText = attributedText
        } else {
            print("감독에 대한 정보가 없습니다")
        }

        let leadActors = movieInfo?.cast.map { $0.name }
        if let leadActors = leadActors {
            castLabel.text = "배우      \(leadActors.joined(separator: ", "))"
        } else {
            print("배우에 대한 정보가 없습니다")
        }
        
        overviewLabel.text = movie?.overview
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReviewSegue" {
            if let reviewVC = segue.destination as? ReviewViewController {
                reviewVC.movieId = imdbId
            }
        }
    }
}
