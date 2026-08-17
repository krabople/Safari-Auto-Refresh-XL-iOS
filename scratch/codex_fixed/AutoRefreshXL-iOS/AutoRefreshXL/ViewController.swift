import UIKit
import SafariServices
import UserNotifications

class ViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 11/255, green: 15/255, blue: 25/255, alpha: 1.0)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 18
        mainStack.alignment = .fill
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])

        // 1. Header Card
        let headerCard = createCardView()
        let logoLabel = UILabel()
        logoLabel.text = "⚡ Auto Refresh XL"
        logoLabel.font = UIFont.systemFont(ofSize: 22, weight: .black)
        logoLabel.textColor = UIColor(red: 0/255, green: 242/255, blue: 254/255, alpha: 1.0)
        logoLabel.textAlignment = .center
        logoLabel.translatesAutoresizingMaskIntoConstraints = false

        let subLabel = UILabel()
        subLabel.text = "Safari Web Extension & Page Monitor for iOS"
        subLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        subLabel.textColor = UIColor(red: 148/255, green: 163/255, blue: 184/255, alpha: 1.0)
        subLabel.textAlignment = .center
        subLabel.numberOfLines = 0
        subLabel.translatesAutoresizingMaskIntoConstraints = false

        let statusBadge = UILabel()
        statusBadge.text = "  ✓ EXTENSION INSTALLED & READY  "
        statusBadge.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        statusBadge.textColor = UIColor(red: 34/255, green: 197/255, blue: 94/255, alpha: 1.0)
        statusBadge.backgroundColor = UIColor(red: 34/255, green: 197/255, blue: 94/255, alpha: 0.15)
        statusBadge.layer.cornerRadius = 10
        statusBadge.layer.masksToBounds = true
        statusBadge.textAlignment = .center
        statusBadge.translatesAutoresizingMaskIntoConstraints = false

        let headerStack = UIStackView(arrangedSubviews: [logoLabel, subLabel, statusBadge])
        headerStack.axis = .vertical
        headerStack.spacing = 8
        headerStack.alignment = .center
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        headerCard.addSubview(headerStack)

        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: headerCard.topAnchor, constant: 16),
            headerStack.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(equalTo: headerCard.trailingAnchor, constant: -16),
            headerStack.bottomAnchor.constraint(equalTo: headerCard.bottomAnchor, constant: -16),
            statusBadge.heightAnchor.constraint(equalToConstant: 24)
        ])
        mainStack.addArrangedSubview(headerCard)

        // 2. Button Action Stack (Settings & Notifications)
        let buttonStack = UIStackView()
        buttonStack.axis = .vertical
        buttonStack.spacing = 10
        buttonStack.alignment = .fill
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        let openSettingsBtn = UIButton(type: .system)
        openSettingsBtn.setTitle("⚙️ Open Safari Settings", for: .normal)
        openSettingsBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        openSettingsBtn.setTitleColor(.black, for: .normal)
        openSettingsBtn.backgroundColor = UIColor(red: 0/255, green: 242/255, blue: 254/255, alpha: 1.0)
        openSettingsBtn.layer.cornerRadius = 12
        openSettingsBtn.translatesAutoresizingMaskIntoConstraints = false
        openSettingsBtn.heightAnchor.constraint(equalToConstant: 46).isActive = true
        openSettingsBtn.addTarget(self, action: #selector(openSettingsTapped), for: .touchUpInside)

        let requestNotifyBtn = UIButton(type: .system)
        requestNotifyBtn.setTitle("🔔 Enable System Notifications", for: .normal)
        requestNotifyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        requestNotifyBtn.setTitleColor(.white, for: .normal)
        requestNotifyBtn.backgroundColor = UIColor(red: 22/255, green: 30/255, blue: 46/255, alpha: 1.0)
        requestNotifyBtn.layer.cornerRadius = 12
        requestNotifyBtn.layer.borderWidth = 1
        requestNotifyBtn.layer.borderColor = UIColor(red: 0/255, green: 242/255, blue: 254/255, alpha: 0.3).cgColor
        requestNotifyBtn.translatesAutoresizingMaskIntoConstraints = false
        requestNotifyBtn.heightAnchor.constraint(equalToConstant: 46).isActive = true
        requestNotifyBtn.addTarget(self, action: #selector(requestNotificationsTapped), for: .touchUpInside)

        buttonStack.addArrangedSubview(openSettingsBtn)
        buttonStack.addArrangedSubview(requestNotifyBtn)
        mainStack.addArrangedSubview(buttonStack)

        // 3. Step-by-Step Setup Guide Card
        let setupCard = createCardView()
        let setupTitle = createSectionTitle("📱 How to Enable in Safari")
        
        let stepsStack = UIStackView()
        stepsStack.axis = .vertical
        stepsStack.spacing = 12
        stepsStack.translatesAutoresizingMaskIntoConstraints = false
        
        let steps = [
            ("1", "Open iOS Settings App", "Tap 'Safari' in the main settings list."),
            ("2", "Navigate to Extensions", "Tap 'Extensions' under the General Safari settings."),
            ("3", "Turn ON Extension", "Select 'Safari Auto Refresh and Page Monitor XL' and toggle it ON."),
            ("4", "Grant Website Permissions", "Tap 'Permissions' ➔ 'All Websites' ➔ Select 'Allow'."),
            ("5", "Launch in Safari", "Open Safari, visit any page, tap the 'aA' icon in the URL bar, and select 'Auto Refresh XL'!")
        ]

        for (num, title, desc) in steps {
            stepsStack.addArrangedSubview(createStepRow(number: num, title: title, description: desc))
        }

        let setupContentStack = UIStackView(arrangedSubviews: [setupTitle, stepsStack])
        setupContentStack.axis = .vertical
        setupContentStack.spacing = 12
        setupContentStack.translatesAutoresizingMaskIntoConstraints = false
        setupCard.addSubview(setupContentStack)

        NSLayoutConstraint.activate([
            setupContentStack.topAnchor.constraint(equalTo: setupCard.topAnchor, constant: 16),
            setupContentStack.leadingAnchor.constraint(equalTo: setupCard.leadingAnchor, constant: 16),
            setupContentStack.trailingAnchor.constraint(equalTo: setupCard.trailingAnchor, constant: -16),
            setupContentStack.bottomAnchor.constraint(equalTo: setupCard.bottomAnchor, constant: -16)
        ])
        mainStack.addArrangedSubview(setupCard)

        // 4. Complete Feature Guide Card
        let guideCard = createCardView()
        let guideTitle = createSectionTitle("📖 Complete Feature Guide")
        
        let featuresStack = UIStackView()
        featuresStack.axis = .vertical
        featuresStack.spacing = 14
        featuresStack.translatesAutoresizingMaskIntoConstraints = false

        let features = [
            ("⏱️ Preset & Custom Timers", "Quickly choose preset chips (5s, 10s, 30s, 1m, 5m, 15m) or set precise custom Hours, Minutes, and Seconds countdowns."),
            ("🎲 Random Interval Range", "Set Min & Max seconds (e.g. 5s – 20s) to randomize refresh timing on every cycle. Helps bypass anti-bot and rate-limiting scripts."),
            ("🔄 Hard Refresh & Limits", "Enable 'Hard Refresh' to bypass browser cache and fetch fresh server data. Set a 'Refresh Limit' to automatically stop after N refreshes."),
            ("📌 On-Page Overlay Widget", "Shows a live floating countdown widget directly on top of webpage content so you can monitor progress while browsing."),
            ("👆 Touch Interaction Safety", "Enable 'Stop on Interaction' to automatically pause auto-refreshing if you tap, scroll, or type on the page."),
            ("🔍 Page Content Monitoring", "Scans the webpage content for target text (e.g. 'In Stock', 'Available'), Regular Expressions, or XPath selectors. Choose between 'Target Appears' or 'Target Disappears'."),
            ("🔔 Smart Alert Actions", "When target content is detected, automatically play sound alerts, send iOS notifications, highlight elements, auto-scroll to detected items, or focus the tab."),
            ("⚡ Auto-Start Domain Rules", "Add domain patterns to your Auto-Start list so auto-refreshing starts automatically whenever you navigate to matching sites.")
        ]

        for (featTitle, featDesc) in features {
            featuresStack.addArrangedSubview(createFeatureRow(title: featTitle, description: featDesc))
        }

        let guideContentStack = UIStackView(arrangedSubviews: [guideTitle, featuresStack])
        guideContentStack.axis = .vertical
        guideContentStack.spacing = 12
        guideContentStack.translatesAutoresizingMaskIntoConstraints = false
        guideCard.addSubview(guideContentStack)

        NSLayoutConstraint.activate([
            guideContentStack.topAnchor.constraint(equalTo: guideCard.topAnchor, constant: 16),
            guideContentStack.leadingAnchor.constraint(equalTo: guideCard.leadingAnchor, constant: 16),
            guideContentStack.trailingAnchor.constraint(equalTo: guideCard.trailingAnchor, constant: -16),
            guideContentStack.bottomAnchor.constraint(equalTo: guideCard.bottomAnchor, constant: -16)
        ])
        mainStack.addArrangedSubview(guideCard)
    }

    private func createCardView() -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor(red: 22/255, green: 30/255, blue: 46/255, alpha: 1.0)
        card.layer.cornerRadius = 14
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor(red: 0/255, green: 242/255, blue: 254/255, alpha: 0.15).cgColor
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }

    private func createSectionTitle(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor(red: 0/255, green: 242/255, blue: 254/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func createStepRow(number: String, title: String, description: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let numBadge = UILabel()
        numBadge.text = number
        numBadge.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        numBadge.textColor = .black
        numBadge.backgroundColor = UIColor(red: 0/255, green: 242/255, blue: 254/255, alpha: 1.0)
        numBadge.layer.cornerRadius = 11
        numBadge.layer.masksToBounds = true
        numBadge.textAlignment = .center
        numBadge.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let descLabel = UILabel()
        descLabel.text = description
        descLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        descLabel.textColor = UIColor(red: 148/255, green: 163/255, blue: 184/255, alpha: 1.0)
        descLabel.numberOfLines = 0
        descLabel.translatesAutoresizingMaskIntoConstraints = false

        let textStack = UIStackView(arrangedSubviews: [titleLabel, descLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(numBadge)
        container.addSubview(textStack)

        NSLayoutConstraint.activate([
            numBadge.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            numBadge.topAnchor.constraint(equalTo: container.topAnchor, constant: 2),
            numBadge.widthAnchor.constraint(equalToConstant: 22),
            numBadge.heightAnchor.constraint(equalToConstant: 22),

            textStack.leadingAnchor.constraint(equalTo: numBadge.trailingAnchor, constant: 10),
            textStack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            textStack.topAnchor.constraint(equalTo: container.topAnchor),
            textStack.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        return container
    }

    private func createFeatureRow(title: String, description: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        titleLabel.textColor = UIColor(red: 248/255, green: 250/255, blue: 252/255, alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let descLabel = UILabel()
        descLabel.text = description
        descLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        descLabel.textColor = UIColor(red: 148/255, green: 163/255, blue: 184/255, alpha: 1.0)
        descLabel.numberOfLines = 0
        descLabel.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [titleLabel, descLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        return container
    }

    @objc private func openSettingsTapped() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    @objc private func requestNotificationsTapped() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: granted ? "Notifications Allowed" : "Notifications Disabled",
                    message: granted ? "System notifications are enabled! You can manage alert styles, sounds, and banners in iOS Settings ➔ Safari Auto Refresh XL ➔ Notifications." : "Permission was not granted. Please enable Notifications in your iOS Settings app.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
}
