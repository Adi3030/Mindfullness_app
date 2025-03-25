//
//  SignupViewController.swift
//  Mindfullness
//
//  Created by aditya sharma on 24/03/25.
//

import UIKit
import GoogleSignIn

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
    @IBOutlet weak var continueWithGoogleLabel: UILabel!
    @IBOutlet weak var continueWithEmail_Phone: UILabel!
    @IBOutlet weak var haveAnAccountLabel: UILabel!
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var continueAsGuest: UILabel!
    
    
    // UI Congiguration
    let leftLanguageLabel = UILabel()
    let languageLabel = UILabel()
    
    
    var timer: Timer?
    var currentIndex = 0
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        makeElementsTouchable()
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: "126198419082-5m0oc4afaeitq5u2digot3ctc9cetarm.apps.googleusercontent.com")
        // Listen for language change notification
        updateLanguageText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguageText), name: Notification.Name("LanguageChanged"), object: nil)
    }
    
    @objc func updateLanguageText() {
        continueWithGoogleLabel.text = LanguageManager.shared.localizedString(forKey: "continue_google")
        continueWithEmail_Phone.text = LanguageManager.shared.localizedString(forKey: "continue_email")
        languageLabel.text = LanguageManager.shared.localizedString(forKey: "language")
        leftLanguageLabel.text = LanguageManager.shared.localizedString(forKey: "ofLanguage")
        signInLabel.text = LanguageManager.shared.localizedString(forKey: "sign_in")
        haveAnAccountLabel.text = LanguageManager.shared.localizedString(forKey: "have_account")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
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
        leftLanguageLabel.text = "Language"
        leftLanguageLabel.textColor = Color.appForgroundColor
        leftLanguageLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        let leftBarButtonItem = UIBarButtonItem(customView: leftLanguageLabel)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        // Create the label
        
        languageLabel.text = "English" // Default language text
        languageLabel.textColor = Color.appForgroundColor
        languageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        
        
        // Create the select Language button
        let bellButton = UIButton(type: .system)
        bellButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
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
    
    func makeElementsTouchable() {
        // Enable user interaction for stack views
        gogleStackView.isUserInteractionEnabled = true
        phoneStackView.isUserInteractionEnabled = true
        continueAsGuest.isUserInteractionEnabled = true
        signInLabel.isUserInteractionEnabled = true

        
        
        // Add tap gesture recognizers
        let googleTap = UITapGestureRecognizer(target: self, action: #selector(googleStackTapped))
        let phoneTap = UITapGestureRecognizer(target: self, action: #selector(phoneStackTapped))
        let guestTap = UITapGestureRecognizer(target: self, action: #selector(guestTapped))
        let loginTap = UITapGestureRecognizer(target: self, action: #selector(signInTapped))

        
        gogleStackView.addGestureRecognizer(googleTap)
        phoneStackView.addGestureRecognizer(phoneTap)
        continueAsGuest.addGestureRecognizer(guestTap)
        signInLabel.addGestureRecognizer(loginTap)

    }
    // Action for bell button tap
    @objc func bellButtonTapped() {
        let halfScreenVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectLanguageTableViewController")
        // Set modal presentation style
        halfScreenVC.modalPresentationStyle = .pageSheet
        if let sheet = halfScreenVC.sheetPresentationController {
            sheet.detents = [.medium()] // Presents half-screen
            sheet.prefersGrabberVisible = true // Optional: Add grabber at the top
        }
        self.present(halfScreenVC, animated: true, completion: nil)
    }
    
    @objc func googleStackTapped() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first,
           let rootViewController = window.rootViewController {
            // Use rootViewController here
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
                guard let user = signInResult?.user, error == nil else { return }
                print("Signed in as \(user.profile?.name ?? "Unknown")")
            }
        }
    }
    
    @objc func phoneStackTapped() {
        print("Phone Stack View tapped!")
        // Add your action here (e.g., open dialer)
    }
    
    @objc func signInTapped() {
        print("Sign In Label View tapped!")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func guestTapped() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GuestViewController") as! GuestViewController
        self.navigationController?.pushViewController(vc, animated: true)
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

}
extension UIViewController {
    func applyGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds // Full screen gradient
        
        // Define light colors (adjust as needed)
        gradientLayer.colors = [
            UIColor.white.cgColor,  // Start with white
            UIColor.systemYellow.withAlphaComponent(0.2).cgColor,
            UIColor.systemOrange.withAlphaComponent(0.2).cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1) // Top center
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0) // Bottom center
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addGradientBorder(to imageView: UIImageView) {
        let gradient = CAGradientLayer()
        gradient.frame = imageView.bounds
        gradient.colors = [UIColor.red.cgColor, UIColor.orange.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)

        let shape = CAShapeLayer()
        shape.lineWidth = 5
        shape.path = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: imageView.layer.cornerRadius).cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.black.cgColor
        gradient.mask = shape

        imageView.layer.addSublayer(gradient)
    }

}
