import UIKit
import SafariServices

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 11/255, green: 15/255, blue: 25/255, alpha: 1.0)

        let titleLabel = UILabel()
        titleLabel.text = "Safari Auto Refresh and Page Monitor XL"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = UIColor(red: 0/255, green: 242/255, blue: 254/255, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let subtitleLabel = UILabel()
        subtitleLabel.text = "Safari Web Extension for iOS"
        subtitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        subtitleLabel.textColor = .lightGray
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        let instructionsView = UITextView()
        instructionsView.text = """
        How to enable Safari Auto Refresh and Page Monitor XL on iPhone:

        1. Open iOS Settings app.
        2. Tap 'Safari'.
        3. Tap 'Extensions'.
        4. Turn ON 'Safari Auto Refresh and Page Monitor XL'.
        5. Set Permission to 'Allow on All Websites'.

        Now open Safari and tap the 'aA' extension button in your address bar!
        """
        instructionsView.font = UIFont.systemFont(ofSize: 14)
        instructionsView.textColor = .white
        instructionsView.backgroundColor = UIColor(red: 22/255, green: 30/255, blue: 46/255, alpha: 1.0)
        instructionsView.layer.cornerRadius = 12
        instructionsView.isEditable = false
        instructionsView.translatesAutoresizingMaskIntoConstraints = false

        let openSettingsButton = UIButton(type: .system)
        openSettingsButton.setTitle("Open Safari Settings", for: .normal)
        openSettingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        openSettingsButton.setTitleColor(.black, for: .normal)
        openSettingsButton.backgroundColor = UIColor(red: 0/255, green: 242/255, blue: 254/255, alpha: 1.0)
        openSettingsButton.layer.cornerRadius = 10
        openSettingsButton.translatesAutoresizingMaskIntoConstraints = false
        openSettingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)

        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(instructionsView)
        view.addSubview(openSettingsButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            instructionsView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            instructionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instructionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            instructionsView.heightAnchor.constraint(equalToConstant: 220),

            openSettingsButton.topAnchor.constraint(equalTo: instructionsView.bottomAnchor, constant: 24),
            openSettingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            openSettingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            openSettingsButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    @objc private func openSettings() {
        SFSafariApplication.showPreferencesForExtension(withIdentifier: "com.krabople.SafariAutoRefreshXL.Extension") { error in
            if let error = error {
                print("Error opening preferences: \(error)")
            }
        }
    }
}
