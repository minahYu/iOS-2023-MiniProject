//
//  SearchResultViewController.swift
//  MiniProject
//
//  Created by 유민아 on 2023/06/11.
//

import UIKit

class SearchResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var searchResults: [Movie] = []
    var searchResultsActor: [MovieInfo] = []
    var searchText: String?
    var selectedMovie: Movie?
    var movieInfo: MovieInfo?
    
    let apiKey = "d5093ab98d0da8cf7324a5aa283bf1ab"
    let apiUrl = "https://api.themoviedb.org/3/movie"
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getId()
        
        if let searchText = searchText {
            performSearch(with: searchText)
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray
        ]
        searchTextField.attributedPlaceholder = NSAttributedString(string: "영화명이나 배우명을 검색해보세요", attributes: attributes)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) { // 검색버튼 클릭
        if let searchText = searchTextField.text, !searchText.isEmpty {
            performSearch(with: searchText)
        } else {
            let alertController = UIAlertController(title: "경고", message: "검색어를 입력해주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        
        let movie = searchResults[indexPath.row]
        
        if let imagePath = Bundle.main.path(forResource: "poster_sample", ofType: "jpg") {
            let imageURL = URL(fileURLWithPath: imagePath)
            if let image = UIImage(contentsOfFile: imageURL.path) {
                cell.imageView?.image = image
            } else {
                print("이미지를 로드할 수 없습니다.")
            }
        }
        
        cell.textLabel?.text = "(\(movie.id)) \(movie.originalTitle)"
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.text = String(movie.id)
        
        let overviewSentences = movie.overview.split(separator: ".")
        if let firstSentence = overviewSentences.first {
            cell.detailTextLabel?.text = "\(firstSentence)"
        } else {
            cell.detailTextLabel?.text = "overview가 없습니다"
        }
        
        cell.detailTextLabel?.textColor = UIColor.white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = searchResults[indexPath.row]
        self.selectedMovie = selectedMovie

        performSegue(withIdentifier: "DetailPageSegue", sender: nil)
    }

    
    func performSearch(with searchText: String) {
        guard let jsonData = loadJSONData() else {
            print("Failed to load JSON data.")
            return
        }
        
        do {
            let movies = try JSONDecoder().decode([Movie].self, from: jsonData)
            
            searchResults = movies.filter { $0.originalTitle.lowercased().contains(searchText.lowercased()) }
            
            searchResults.sort(by: { $0.voteAverage > $1.voteAverage })
            
            if searchResults.isEmpty {
                tableView.backgroundView = createNoResultView()
            } else {
                tableView.backgroundView = nil
            }
            
            tableView.reloadData()
        } catch {
            print("Failed to decode JSON data: \(error)")
        }
    }
    
    func createNoResultView() -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height))
        label.text = "검색 결과가 없습니다."
        label.textColor = UIColor.white
        label.textAlignment = .center
        containerView.addSubview(label)
        
        return containerView
    }
    
    func loadJSONData() -> Data? {
        if let path = Bundle.main.path(forResource: "top_movies", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                return data
            } catch {
                print("Failed to load JSON data: \(error)")
            }
        }
        return nil
    }
    
    func getId() { // top_movies.json에 있는 영화들의 id 가져오기
        guard let jsonData = loadJSONData() else {
            print("Failed to load JSON data.")
            return
        }
        
        do {
            let movies = try JSONDecoder().decode([Movie].self, from: jsonData)
            
            let movieIds: [Int] = movies.map { $0.id }
            
            for movieId in movieIds {
                fetchMovieCredits(movieId: movieId)
            }
        } catch (let err) {
            print(err.localizedDescription)
        }
    }
    
    func fetchMovieCredits(movieId: Int) { // 출연진에 관한 데이터 가져오기
        let urlString = "\(apiUrl)/\(movieId)/credits?api_key=\(apiKey)&language=en-US"
        let session: URLSession = URLSession(configuration: .default)
        guard let url = URL(string: urlString) else { return }
        
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
                
            } catch (let err) {
                print("**", err.localizedDescription)
                print("Decoding error:", err)
            }
        }
        dataTask.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailPageSegue",
            let destinationVC = segue.destination as? DetailPageViewController {
            self.selectedMovie = searchResults[tableView.indexPathForSelectedRow!.row]
            destinationVC.movie = selectedMovie
            
            //print("## ", selectedMovie?.originalTitle ?? "++++++")
        }
    }


}

