//
//  ViewController.swift
//  MiniProject
//
//  Created by 유민아 on 2023/06/09.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    var selectedMovie: Movie?
    var popularMovies: [Movie] = []
    var actionMovies: [Movie] = []
    var fantasyMovies: [Movie] = []
    var adventureMovies: [Movie] = []
    var genrePack: [String] = ["Action", "Fantasy", "Adventure"]
    
    var sortMethod: Int = 0 // 0은 voteCount
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var popularMoviePack: UITableView!
    
    let apiKey = "d5093ab98d0da8cf7324a5aa283bf1ab"
    let apiURL = "https://api.themoviedb.org/3/movie"
    
    let topCView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()
    let actionCView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()
    let fantasyCView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()
    let adventureCView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
        
        movieCountList(num: 0)
        actionList()
        fantasyList()
        adventureList()
        
        popularMoviePack.delegate = self
        popularMoviePack.dataSource = self
        
        popularMoviePack.register(TopCell.self, forCellReuseIdentifier: "TopCell")
        popularMoviePack.register(ActionCell.self, forCellReuseIdentifier: "ActionCell")
        popularMoviePack.register(FantasyCell.self, forCellReuseIdentifier: "FantasyCell")
        popularMoviePack.register(AdventureCell.self, forCellReuseIdentifier: "AdventureCell")
        
        
        let topLayout = UICollectionViewFlowLayout()
        topLayout.scrollDirection = .horizontal
        topCView.collectionViewLayout = topLayout
        topCView.dataSource = self
        topCView.delegate = self
        topCView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "TopCell")
        topCView.backgroundColor = .clear
        
        topCView.frame = CGRect(x: 0, y: 60, width: view.bounds.width, height: 200)

        view.addSubview(topCView)


        let actionLayout = UICollectionViewFlowLayout()
        actionLayout.scrollDirection = .horizontal
        actionCView.collectionViewLayout = actionLayout
        actionCView.dataSource = self
        actionCView.delegate = self
        actionCView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ActionCell")
        actionCView.backgroundColor = .clear
        
        actionCView.frame = CGRect(x: 0, y: 60, width: view.bounds.width, height: 200)
        
        view.addSubview(actionCView)
        
        
        let fantasyLayout = UICollectionViewFlowLayout()
        fantasyLayout.scrollDirection = .horizontal
        fantasyCView.collectionViewLayout = fantasyLayout
        fantasyCView.dataSource = self
        fantasyCView.delegate = self
        fantasyCView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "FantasyCell")
        fantasyCView.backgroundColor = .clear
        
        fantasyCView.frame = CGRect(x: 0, y: 60, width: view.bounds.width, height: 200)
        
        view.addSubview(fantasyCView)
        
        let adventureLayout = UICollectionViewFlowLayout()
        adventureLayout.scrollDirection = .horizontal
        adventureCView.collectionViewLayout = adventureLayout
        adventureCView.dataSource = self
        adventureCView.delegate = self
        adventureCView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "AdventureCell")
        adventureCView.backgroundColor = .clear
            
        adventureCView.frame = CGRect(x: 0, y: 60, width: view.bounds.width, height: 200)
        
        view.addSubview(adventureCView)

        
        popularMoviePack.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopCell", for: indexPath) as! TopCell
            
            cell.titleLabel.text = "📈 TOP 20"
            
            cell.contentView.backgroundColor = UIColor(red: 36/255, green: 36/255, blue: 36/255, alpha: 1)
            
            cell.selectionStyle = .none
            
            cell.contentView.addSubview(topCView)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActionCell", for: indexPath) as! ActionCell
                        
            cell.titleLabel.text = "👊 액션 장르 TOP 20"
            
            cell.contentView.backgroundColor = UIColor(red: 36/255, green: 36/255, blue: 36/255, alpha: 1)
            
            cell.selectionStyle = .none
            
            cell.contentView.addSubview(actionCView)
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FantasyCell", for: indexPath) as! FantasyCell
                        
            cell.titleLabel.text = "✨ 판타지 장르 TOP 20"
            
            cell.contentView.backgroundColor = UIColor(red: 36/255, green: 36/255, blue: 36/255, alpha: 1)
            
            cell.selectionStyle = .none
            
            cell.contentView.addSubview(fantasyCView)
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdventureCell", for: indexPath) as! AdventureCell
                        
            cell.titleLabel.text = "🗺️ 어드벤처 장르 TOP 20"
            
            cell.contentView.backgroundColor = UIColor(red: 36/255, green: 36/255, blue: 36/255, alpha: 1)
            
            cell.selectionStyle = .none
            
            cell.contentView.addSubview(adventureCView)
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 {
            return 260
        }
        return UITableView.automaticDimension
    }
    
    //--------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topCView || collectionView == actionCView || collectionView == fantasyCView || collectionView == adventureCView {
            return 20
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewHeight: CGFloat = 200

        if collectionView == topCView ||
            collectionView == actionCView ||
            collectionView == fantasyCView ||
            collectionView == adventureCView {
            return CGSize(width: 125, height: collectionViewHeight)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == topCView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCell", for: indexPath)
            
            for subview in cell.contentView.subviews {
                if let label = subview as? UILabel {
                    label.removeFromSuperview()
                }
            }
            
            let popularMovieLabel = UILabel(frame: CGRect(x: 8, y: 155, width: 115, height: 27))
            popularMovieLabel.text = "\(indexPath.row + 1) \(popularMovies[indexPath.item].title)"
            
            popularMovieLabel.textColor = UIColor.white
            popularMovieLabel.font = UIFont.boldSystemFont(ofSize: 12)

            let movieImg = sameImg() // 모두 같은 이미지 쓰기 때문에 함수로 호출
                        
            cell.contentView.addSubview(popularMovieLabel)
            cell.contentView.addSubview(movieImg)
            
            return cell
        } else if collectionView == actionCView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActionCell", for: indexPath)
            
            for subview in cell.contentView.subviews {
                if let label = subview as? UILabel {
                    label.removeFromSuperview()
                }
            }
            
            let movieImg = sameImg()
            
            let actionMovieLabel = UILabel(frame: CGRect(x: 8, y: 155, width: 115, height: 27))
            actionMovieLabel.text = "\(indexPath.row + 1) \(actionMovies[indexPath.item].title)"

            actionMovieLabel.textColor = UIColor.white
            actionMovieLabel.font = UIFont.boldSystemFont(ofSize: 12)

                        
            cell.contentView.addSubview(actionMovieLabel)
            cell.contentView.addSubview(movieImg)
            
           return cell
        } else if collectionView == fantasyCView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FantasyCell", for: indexPath)
            
            for subview in cell.contentView.subviews {
                if let label = subview as? UILabel {
                    label.removeFromSuperview()
                }
            }
            
            let movieImg = sameImg()
            
            let fantasyMovieLabel = UILabel(frame: CGRect(x: 8, y: 155, width: 115, height: 27))
            fantasyMovieLabel.text = "\(indexPath.row + 1) \( fantasyMovies[indexPath.item].title)"

            fantasyMovieLabel.textColor = UIColor.white
            fantasyMovieLabel.font = UIFont.boldSystemFont(ofSize: 12)

                        
            cell.contentView.addSubview(fantasyMovieLabel)
            cell.contentView.addSubview(movieImg)
            
           return cell
        } else if collectionView == adventureCView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdventureCell", for: indexPath)
            
            for subview in cell.contentView.subviews {
                if let label = subview as? UILabel {
                    label.removeFromSuperview()
                }
            }
            
            let movieImg = sameImg()
            
            let adventureMovieLabel = UILabel(frame: CGRect(x: 8, y: 155, width: 115, height: 27))
            adventureMovieLabel.text = "\(indexPath.row + 1) \( adventureMovies[indexPath.item].title)"

            adventureMovieLabel.textColor = UIColor.white
            adventureMovieLabel.font = UIFont.boldSystemFont(ofSize: 12)

                        
            cell.contentView.addSubview(adventureMovieLabel)
            cell.contentView.addSubview(movieImg)
            
           return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == topCView {
            self.selectedMovie = popularMovies[indexPath.row]

        } else if collectionView == actionCView {
            self.selectedMovie = actionMovies[indexPath.row]

        } else if collectionView == fantasyCView {
            self.selectedMovie = fantasyMovies[indexPath.row]

        } else if collectionView == adventureCView {
            self.selectedMovie = adventureMovies[indexPath.row]

        }
        performSegue(withIdentifier: "DetailPageSegue", sender: collectionView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let collectionView = sender as? UICollectionView,
        let destinationVC = segue.destination as? DetailPageViewController,
        let indexPath = collectionView.indexPathsForSelectedItems?.first {
            
            if segue.identifier == "DetailPageSegue" {
                if collectionView == topCView {
                    self.selectedMovie = popularMovies[indexPath.row]
                } else if collectionView == actionCView {
                    self.selectedMovie = actionMovies[indexPath.row]
                } else if collectionView == fantasyCView {
                    self.selectedMovie = fantasyMovies[indexPath.row]
                } else if collectionView == adventureCView {
                    self.selectedMovie = adventureMovies[indexPath.row]
                }
                
                destinationVC.movie = selectedMovie
                print("## ", selectedMovie?.originalTitle ?? "++++++")
            }
        }
    }
    
    func sameImg() -> UIImageView {
        let imageFrame = CGRect(x: 0, y: 0, width: 125, height: 155)
        let movieImg = UIImageView(frame: imageFrame)
        movieImg.contentMode = .scaleAspectFit
        movieImg.layer.cornerRadius = 15
        movieImg.clipsToBounds = true
        movieImg.image = UIImage(named: "poster_sample.jpg")
        
        return movieImg
    }
    
    func movieCountList(num: Int) { // 평가 갯수 순으로 정렬
        guard let jsonData = loadJSONData() else {
            print("Failed to load JSON data.")
            return
        }
        
        do {
            let movies = try JSONDecoder().decode([Movie].self, from: jsonData)
            
            if num == 0 {
                let sortedMovies = movies.sorted { $0.voteCount > $1.voteCount }
                popularMovies = Array(sortedMovies.prefix(20))
            } else if num == 1 {
                let sortedMovies = movies.sorted { $0.voteAverage > $1.voteAverage }
                popularMovies = Array(sortedMovies.prefix(20))
            }
            print("😈", popularMovies)
            
        } catch {
            print("Failed to decode JSON data: \(error)")
        }
    }
    
    func actionList() {
        guard let jsonData = loadJSONData() else {
            print("Failed to load JSON data.")
            return
        }
        
        do {
            let movies = try JSONDecoder().decode([Movie].self, from: jsonData)
            
            actionMovies = movies.filter { movie in
                return movie.genres.contains { genre in
                    return genre.name == genrePack[0]
                }
            }
            
            let sortedMovies = actionMovies.sorted { $0.voteCount > $1.voteCount }
            actionMovies = Array(sortedMovies.prefix(20))
            
        } catch {
            print("Failed to decode JSON data: \(error)")
        }
    }
    
    func fantasyList() {
        guard let jsonData = loadJSONData() else {
            print("Failed to load JSON data.")
            return
        }
        
        do {
            let movies = try JSONDecoder().decode([Movie].self, from: jsonData)
            
            fantasyMovies = movies.filter { movie in
                return movie.genres.contains { genre in
                    return genre.name == genrePack[1]
                }
            }
            
            let sortedMovies = fantasyMovies.sorted { $0.voteCount > $1.voteCount }
            fantasyMovies = Array(sortedMovies.prefix(20))
            
        } catch {
            print("Failed to decode JSON data: \(error)")
        }
    }
    
    func adventureList() {
        guard let jsonData = loadJSONData() else {
            print("Failed to load JSON data.")
            return
        }
        
        do {
            let movies = try JSONDecoder().decode([Movie].self, from: jsonData)
            
            adventureMovies = movies.filter { movie in
                return movie.genres.contains { genre in
                    return genre.name == genrePack[2]
                }
            }
            
            let sortedMovies = adventureMovies.sorted { $0.voteCount > $1.voteCount }
            adventureMovies = Array(sortedMovies.prefix(20))
            
        } catch {
            print("Failed to decode JSON data: \(error)")
        }
    }
    
    @objc func segmentValueChanged(_ sender:UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            movieCountList(num: 0)
        case 1:
            movieCountList(num: 1)
        default:
            break
        }
        topCView.reloadData()
        popularMoviePack.reloadData()
    }
    
    func loadJSONData() -> Data? { // Movie
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
}

