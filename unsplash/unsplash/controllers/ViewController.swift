//
//  ViewController.swift
//  unsplash
//
//  Created by macOS on 5/26/22.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
    
    //Main UI Components
    private var collectionView: UICollectionView?
    let searchBar = UISearchBar()
    
    // List of Results => Images [initialy empty]
    var result: [Result] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Init CollectionView and SearchBar
        initViews()
                
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.frame.size.width - 20, height: 50)
        collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 60, width: view.frame.size.width, height: view.frame.size.height - 65)
    }
    
    
    //Init CollectionView and SearchBar
    func initViews()  {
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.size.width * 0.5, height: view.frame.size.width * 0.5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        self.collectionView = collectionView
        view.addSubview(collectionView)
    }
    
    // Api Call For Unsplash server Using URLSession
    func fetchPhotos(query: String) {
        let urlString = "https://api.unsplash.com/search/photos?page=1&query=\(query)&client_id=dilNQcx1DQipwsL1Evso5RJ8pmDdjJHO59zAMDtHQ0A"
        guard let url = URL(string: urlString) else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let jsonResult = try JSONDecoder().decode(ApiResponse.self, from: data)
                
                print("dataStart==========================")
                print(jsonResult.results)
                print("==========================dataEnd")
                
                DispatchQueue.main.async {
                    self?.result = jsonResult.results
                    self?.collectionView?.reloadData()
                }
                
            }catch{
                print("ErrorStart==========================")
                print(error)
                print("==========================ErrorEnd")
            }
        }
        task.resume()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        result.count
    }
    
    // DequeueReusableCell Custom UICollectionViewCell => ImageCollectionViewCell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageURLString = result[indexPath.row].urls.small
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.configure(with: imageURLString)
        cell.backgroundColor = .systemBackground
        return cell
    }
    
    // Trigger Api request with textInputQuery of user Entry in SearchBarTextField
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        if let text = searchBar.text{
            result = []
            collectionView?.reloadData()
            fetchPhotos(query: text)
        }
    }
    
}

