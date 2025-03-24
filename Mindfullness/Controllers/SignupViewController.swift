//
//  SignupViewController.swift
//  Mindfullness
//
//  Created by aditya sharma on 24/03/25.
//

import UIKit

class SignUpViewControllerCollectionViewCell: UICollectionViewCell {
    
    override class func awakeFromNib() {
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
    }
}

class SignupViewController: UIViewController {
    
    @IBOutlet var superContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var gogleStackView: UIStackView!
    @IBOutlet weak var phoneStackView: UIStackView!
    
    
    var timer: Timer?
    var currentIndex = 0
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    func setupUI() {
        
        // configure delegates of collection View
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = false
        
        // setUp Buttons UI
        styleStackViews()
        
        // comment for test second

        // set up BG color
        applyGradientBackground()
        
        // page control congiguration UI
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.backgroundColor = .clear

        
        // Set up the navigation button
        // Create the left-most label
        let leftLanguageLabel = UILabel()
        leftLanguageLabel.text = "Language"
        leftLanguageLabel.textColor = Color.appForgroundColor
        leftLanguageLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        let leftBarButtonItem = UIBarButtonItem(customView: leftLanguageLabel)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        // Create the label
        let languageLabel = UILabel()
        languageLabel.text = "English" // Default language text
        languageLabel.textColor = Color.appForgroundColor
        languageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        
        
        // Create the bell button
        let bellButton = UIButton(type: .system)
        bellButton.setImage(UIImage(systemName: "bell"), for: .normal)
        bellButton.tintColor = Color.appForgroundColor
        bellButton.addTarget(self, action: #selector(bellButtonTapped), for: .touchUpInside)
        
        // Create a horizontal stack view for label and button
        let stackView = UIStackView(arrangedSubviews: [languageLabel, bellButton])
        stackView.axis = .horizontal
        stackView.spacing = 4 // Adjust spacing to keep them close
        stackView.alignment = .center
        
        // Create a container view for stackView
        let containerView = UIView()
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        // Convert container view into a UIBarButtonItem
        let rightBarButtonItem = UIBarButtonItem(customView: containerView)
        
        // Set it as the right navigation item
        navigationItem.rightBarButtonItem = rightBarButtonItem
        startAutoScroll()
    }
    
    // Action for bell button tap
    @objc func bellButtonTapped() {
        print("Bell button tapped!")
    }
    
}
extension SignupViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 320) // Custom size per item
      }
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          return 0 // Space between rows
      }
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
          return 0 // Space between items
      }
}
extension SignupViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SignUpViewControllerCollectionViewCell", for: indexPath) as! SignUpViewControllerCollectionViewCell
        
        return cell
    }
    // Returns a supplementary view (e.g., headers and footers). (Optional)
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        return nil
//    }
    
    
}
extension SignupViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    func startAutoScroll() {
        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(scrollToNextItem), userInfo: nil, repeats: true)
    }
    @objc func scrollToNextItem() {
        let nextIndex = (currentIndex + 1) % 3
        let indexPath = IndexPath(item: nextIndex, section: 0)

        UIViewPropertyAnimator(duration: 8.0, curve: .easeInOut) { // Slower transition
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }.startAnimation()

        currentIndex = nextIndex
        pageControl.currentPage = currentIndex
    }
    func styleStackViews() {
        let stackViews = [gogleStackView, phoneStackView] // Array of stack views
        for stackView in stackViews {
            stackView?.layer.borderWidth = 1
            stackView?.layer.borderColor = Color.appForgroundColor.cgColor
            stackView?.layer.cornerRadius = 25 // Adjust as needed
            stackView?.clipsToBounds = true
        }
    }
    func applyGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds // Full screen gradient
        
        // Define light colors (adjust as needed)
        gradientLayer.colors = [
            UIColor.white.cgColor,  // Start with white
            UIColor.systemYellow.withAlphaComponent(0.2).cgColor, // Light yellow
            UIColor.systemOrange.withAlphaComponent(0.2).cgColor  // Light orange
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1) // Top center
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0) // Bottom center
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
