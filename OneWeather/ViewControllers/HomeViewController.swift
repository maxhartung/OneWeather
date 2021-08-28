import UIKit
import Combine

class HomeViewController: UIViewController {
    
    // MARK:- Views
    
    let currentTemp : UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    // MARK:- Properties
    
    var viewModel : HomeViewModel!
    var cancellable : Set<AnyCancellable> = []
    
    // MARK:- LifeCycle
    
    init(viewModel : HomeViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.$weather.receive(on: DispatchQueue.main).compactMap({$0}).sink{ data in
            self.currentTemp.text = String(data!.current.temp)
        }.store(in: &cancellable)
    }
    
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
    }
    
    func setupConstraints(){
        currentTemp.translatesAutoresizingMaskIntoConstraints = false
        currentTemp.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        currentTemp.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }
}

