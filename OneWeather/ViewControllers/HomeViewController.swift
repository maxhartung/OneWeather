import UIKit
import Combine

class HomeViewController: UIViewController, HomeViewModelDelegate {
    
    // MARK:- Views
    
    let currentTemp : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    let currentLocationName : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(red: 178/255, green: 100/255, blue: 77/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        return label
    }()
    
    // MARK:- Properties
    
    var viewModel : HomeViewModel!
    var cancellable : Set<AnyCancellable> = []
    
    // MARK:- LifeCycle
    
    init(viewModel : HomeViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.delegate = self
        viewModel.$weather.receive(on: DispatchQueue.main).compactMap({$0}).sink{ data in
            self.currentTemp.text = String(Int(data.current.temp.rounded())) + " °C"
        }.store(in: &cancellable)
        
        viewModel.$locationName.receive(on: DispatchQueue.main).sink { name in
            self.currentLocationName.text = name.uppercased()
        }.store(in: &cancellable)
    }
    
    //178,100,77
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK:- SetupUI
    
    func setupViews(){
        view.backgroundColor = .systemBackground
        view.addSubview(currentTemp)
        view.addSubview(currentLocationName)
    }
    
    func setupConstraints(){
        currentTemp.translatesAutoresizingMaskIntoConstraints = false
        currentLocationName.translatesAutoresizingMaskIntoConstraints = false
        currentTemp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150).isActive = true
        
        currentTemp.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        currentTemp.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        currentLocationName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        currentLocationName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true

        currentLocationName.topAnchor.constraint(equalTo: currentTemp.bottomAnchor, constant: 120).isActive = true
    }
    
    // MARK:- Handlers
    
    func showMessage(message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Information", message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self?.present(alert, animated: true, completion: nil)
        }
    }
}

