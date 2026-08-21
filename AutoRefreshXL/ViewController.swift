import UIKit

private struct GuideSection { let title: String; let body: String }
private struct FeatureGuide { let icon: String; let title: String; let summary: String; let sections: [GuideSection] }

private enum AppTheme {
    static let background = UIColor(red: 7/255, green: 12/255, blue: 23/255, alpha: 1)
    static let card = UIColor(red: 18/255, green: 27/255, blue: 43/255, alpha: 1)
    static let cyan = UIColor(red: 0/255, green: 229/255, blue: 239/255, alpha: 1)
    static let blue = UIColor(red: 48/255, green: 145/255, blue: 238/255, alpha: 1)
    static let primary = UIColor(red: 241/255, green: 245/255, blue: 249/255, alpha: 1)
    static let secondary = UIColor(red: 163/255, green: 177/255, blue: 198/255, alpha: 1)
}

private final class AppLogoView: UIView {
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(AppTheme.card.cgColor); context.fillEllipse(in: rect.insetBy(dx: 1, dy: 1))
        context.setStrokeColor(AppTheme.cyan.cgColor); context.setLineWidth(max(5, rect.width * 0.13))
        context.strokeEllipse(in: rect.insetBy(dx: rect.width * 0.2, dy: rect.height * 0.2))
        context.setFillColor(AppTheme.blue.cgColor); context.fillEllipse(in: rect.insetBy(dx: rect.width * 0.39, dy: rect.height * 0.39))
    }
}

final class ViewController: UIViewController {
    private let contentStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Auto Refresh XL"
        view.backgroundColor = AppTheme.background
        configureNavigationBar()
        buildInterface()
    }

    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground(); appearance.backgroundColor = AppTheme.background
        appearance.titleTextAttributes = [.foregroundColor: AppTheme.primary]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = AppTheme.cyan
    }

    private func buildInterface() {
        let scroll = UIScrollView(); scroll.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical; contentStack.spacing = 16; contentStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll); scroll.addSubview(contentStack)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor), scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentStack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -28)
        ])
        contentStack.addArrangedSubview(welcomeCard())
        contentStack.addArrangedSubview(settingsButton())
        contentStack.addArrangedSubview(setupCard())
        let heading = label("Complete Feature Guide", 21, .bold, AppTheme.primary); heading.accessibilityTraits = .header
        contentStack.addArrangedSubview(heading)
        contentStack.addArrangedSubview(label("Tap a feature for detailed instructions, limitations, and useful tips.", 13, .regular, AppTheme.secondary))
        for (index, feature) in Self.features.enumerated() { contentStack.addArrangedSubview(featureButton(feature, index)) }
    }

    private func welcomeCard() -> UIView {
        let card = cardView(); let logo = AppLogoView(); logo.backgroundColor = .clear; logo.translatesAutoresizingMaskIntoConstraints = false
        let title = label("Safari Auto Refresh and\nPage Monitor XL", 20, .black, AppTheme.cyan); title.numberOfLines = 0
        let subtitle = label("Automatic refreshing, content monitoring, visible and audible alerts, and exact-page Auto-Start rules for Safari.", 13, .regular, AppTheme.secondary); subtitle.numberOfLines = 0
        let words = UIStackView(arrangedSubviews: [title, subtitle]); words.axis = .vertical; words.spacing = 7
        let row = UIStackView(arrangedSubviews: [logo, words]); row.axis = .horizontal; row.alignment = .center; row.spacing = 14; row.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(row)
        NSLayoutConstraint.activate([logo.widthAnchor.constraint(equalToConstant: 66), logo.heightAnchor.constraint(equalTo: logo.widthAnchor), row.topAnchor.constraint(equalTo: card.topAnchor, constant: 16), row.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16), row.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16), row.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)])
        return card
    }

    private func settingsButton() -> UIButton {
        var config = UIButton.Configuration.filled(); config.title = "Open Extension Settings Guide"; config.image = UIImage(systemName: "gearshape.fill")
        config.imagePadding = 8; config.baseBackgroundColor = AppTheme.cyan; config.baseForegroundColor = .black; config.cornerStyle = .medium
        let button = UIButton(configuration: config); button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(openSettingsGuide), for: .touchUpInside); return button
    }

    private func setupCard() -> UIView {
        let card = cardView(); let stack = UIStackView(); stack.axis = .vertical; stack.spacing = 12; stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(label("Set up the extension", 17, .bold, AppTheme.cyan))
        let steps = [
            ("1", "Allow the extension", "Settings → Apps → Safari → Extensions → Safari Auto Refresh and Page Monitor XL. Turn on Allow Extension."),
            ("2", "Allow website access", "On that screen, allow access to the websites you want to refresh. Allow for All Websites is the simplest setup."),
            ("3", "Open it in Safari", "Visit a webpage. Tap Safari’s Page Menu button beside the search field, then choose Auto Refresh XL from the extensions list."),
            ("4", "If it is missing", "Tap Page Menu → Manage Extensions and switch on Auto Refresh XL. Safari profiles may require separate enabling.")
        ]
        for step in steps { stack.addArrangedSubview(stepRow(step.0, step.1, step.2)) }
        card.addSubview(stack); NSLayoutConstraint.activate([stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 16), stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16), stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16), stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)])
        return card
    }

    private func stepRow(_ number: String, _ title: String, _ body: String) -> UIView {
        let badge = label(number, 12, .bold, .black); badge.textAlignment = .center; badge.backgroundColor = AppTheme.cyan; badge.layer.cornerRadius = 12; badge.clipsToBounds = true; badge.translatesAutoresizingMaskIntoConstraints = false
        let titleLabel = label(title, 14, .bold, AppTheme.primary); let bodyLabel = label(body, 12, .regular, AppTheme.secondary); bodyLabel.numberOfLines = 0
        let words = UIStackView(arrangedSubviews: [titleLabel, bodyLabel]); words.axis = .vertical; words.spacing = 3
        let row = UIStackView(arrangedSubviews: [badge, words]); row.axis = .horizontal; row.alignment = .top; row.spacing = 10
        NSLayoutConstraint.activate([badge.widthAnchor.constraint(equalToConstant: 24), badge.heightAnchor.constraint(equalToConstant: 24)]); return row
    }

    private func featureButton(_ feature: FeatureGuide, _ index: Int) -> UIButton {
        var config = UIButton.Configuration.plain(); config.title = feature.title; config.subtitle = feature.summary; config.image = UIImage(systemName: feature.icon)
        config.imagePadding = 13; config.baseForegroundColor = AppTheme.primary; config.titleAlignment = .leading
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 14, bottom: 14, trailing: 14)
        let button = UIButton(configuration: config); button.tag = index; button.contentHorizontalAlignment = .fill; button.backgroundColor = AppTheme.card
        button.layer.cornerRadius = 13; button.layer.borderWidth = 1; button.layer.borderColor = UIColor(red: 35/255, green: 60/255, blue: 82/255, alpha: 1).cgColor
        button.tintColor = AppTheme.cyan; button.addTarget(self, action: #selector(openFeature(_:)), for: .touchUpInside)
        button.accessibilityHint = "Opens the detailed feature guide"; return button
    }

    @objc private func openFeature(_ sender: UIButton) {
        guard Self.features.indices.contains(sender.tag) else { return }
        navigationController?.pushViewController(FeatureDetailViewController(feature: Self.features[sender.tag]), animated: true)
    }

    @objc private func openSettingsGuide() {
        let alert = UIAlertController(title: "Enable Auto Refresh XL", message: "Go to Settings → Apps → Safari → Extensions → Safari Auto Refresh and Page Monitor XL. Turn on Allow Extension and allow website access. Apple does not provide an App Store-safe link directly to an individual extension switch.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel)); alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }); present(alert, animated: true)
    }

    private func cardView() -> UIView { let view = UIView(); view.backgroundColor = AppTheme.card; view.layer.cornerRadius = 14; view.layer.borderWidth = 1; view.layer.borderColor = UIColor(red: 31/255, green: 57/255, blue: 78/255, alpha: 1).cgColor; return view }
    private func label(_ text: String, _ size: CGFloat, _ weight: UIFont.Weight, _ color: UIColor) -> UILabel { let result = UILabel(); result.text = text; result.font = .systemFont(ofSize: size, weight: weight); result.textColor = color; return result }

    private static let features: [FeatureGuide] = [
        FeatureGuide(icon: "timer", title: "Intervals and countdowns", summary: "Preset or custom refresh timing", sections: [
            GuideSection(title: "How it works", body: "Choose a preset or enter hours, minutes, and seconds. Press Start Refresh to begin the first countdown. Monitoring does not check immediately; its first cycle occurs only when this countdown reaches zero."),
            GuideSection(title: "What happens at zero", body: "The extension obtains fresh content for monitoring, performs a genuine visible Safari reload, and schedules the next countdown. Page loading time and iOS suspension can delay very short intervals."),
            GuideSection(title: "Tips", body: "Allow enough time for the site to load. Excessive refreshing may trigger captchas, rate limits, or a temporary website block.")]),
        FeatureGuide(icon: "shuffle", title: "Random interval range", summary: "A new delay for every cycle", sections: [
            GuideSection(title: "Using random mode", body: "Enter minimum and maximum seconds. Preset and custom fields are disabled because a fresh random delay is selected after every cycle."),
            GuideSection(title: "Limitations", body: "Random timing does not bypass website rules or anti-automation systems. Avoid extremely short ranges on complex pages.")]),
        FeatureGuide(icon: "arrow.clockwise", title: "Refresh options and limits", summary: "Hard refresh, limits, and interaction safety", sections: [
            GuideSection(title: "Hard Refresh", body: "Requests a reload that bypasses cached data where Safari supports it. Websites and service workers may still impose their own caching."),
            GuideSection(title: "Refresh Limit", body: "A positive number stops after that many cycles; zero is unlimited. The overlay shows the count."),
            GuideSection(title: "Stop on interaction", body: "Stops when you interact with the monitored webpage. Overlay controls are excluded so they remain usable.")]),
        FeatureGuide(icon: "rectangle.inset.filled", title: "On-page overlay", summary: "Countdown, monitored term, and controls", sections: [
            GuideSection(title: "What it shows", body: "The draggable overlay shows countdown, refresh count, fixed or random mode, monitored term, Stop Refresh, and the sound toggle when monitoring uses sound."),
            GuideSection(title: "Moving and hiding", body: "Drag its header. Closing the widget hides it; use Stop Refresh to end the process."),
            GuideSection(title: "Compatibility", body: "It cannot appear on Safari internal pages, Settings, some document viewers, or websites without extension access.")]),
        FeatureGuide(icon: "text.magnifyingglass", title: "Content monitoring", summary: "Text, regex, and XPath matching", sections: [
            GuideSection(title: "Plain Text", body: "Case-insensitive text matching. Entering text into an empty field turns monitoring on; clearing it turns monitoring off. You can manually switch it off while keeping the text."),
            GuideSection(title: "Regular Expression", body: "Uses a case-insensitive JavaScript regular expression. Invalid expressions cannot match, so test complex expressions carefully."),
            GuideSection(title: "XPath", body: "Finds an element using its page structure. XPath rules may break when a site redesigns its markup."),
            GuideSection(title: "Appears or disappears", body: "Appears triggers when a match exists; Disappears triggers when it does not. Checks start after the first countdown."),
            GuideSection(title: "Dynamic sites", body: "Fresh server HTML is checked. Very late JavaScript content, inaccessible frames, images, and canvas text may not be detectable.")]),
        FeatureGuide(icon: "speaker.wave.3.fill", title: "Sound alerts", summary: "Safari-safe audible target alerts", sections: [
            GuideSection(title: "Enabling sound", body: "Safari requires a webpage tap before it can play sound. Tap Enable Alert Sound on the overlay; the confirmation sound verifies it and the control changes to Disable Alert Sound."),
            GuideSection(title: "Other tabs", body: "Alerts are routed to the tab you are viewing. If that webpage has not received a tap, Safari may block audio and the banner offers an Enable Sound button."),
            GuideSection(title: "Limitations", body: "Reloading replaces a page’s audio context. Device volume, Safari media policy, and iOS resource suspension still apply. These are webpage sounds, not push notifications.")]),
        FeatureGuide(icon: "bell.badge.fill", title: "On-screen target alerts", summary: "Visible alerts across Safari tabs", sections: [
            GuideSection(title: "Cross-tab alerts", body: "The banner appears on the ordinary Safari webpage currently being viewed. View Monitored Tab returns to the source tab when needed."),
            GuideSection(title: "Limitations", body: "Safari cannot inject the banner into internal browser pages, Settings, some viewers, or pages without permission. It is not a Lock Screen push notification.")]),
        FeatureGuide(icon: "highlighter", title: "Highlight and auto-scroll", summary: "Find a detected result after reload", sections: [
            GuideSection(title: "Highlighting", body: "Plain-text and regex matches use the yellow pulsing highlight. The extension reapplies it to the newly reloaded page so navigation does not remove it."),
            GuideSection(title: "Auto-scroll", body: "Safari smoothly centres the detected match. The extension retries briefly for pages that render after the initial document."),
            GuideSection(title: "Limitations", body: "Hidden or replaced server text, inaccessible frames, closed shadow content, images, canvas, and late components may not be highlightable.")]),
        FeatureGuide(icon: "bolt.fill", title: "Auto-Start rules", summary: "Start on saved exact pages", sections: [
            GuideSection(title: "Adding", body: "On the desired page, choose Auto-Start Current Page. New rules save the entire URL, including path and query string, and match that exact address."),
            GuideSection(title: "Editing", body: "Advanced Options opens inside the extension. Edit changes URL and default interval; Delete permanently removes the rule. Older wildcard rules remain supported."),
            GuideSection(title: "Tips", body: "Redirects and changing query parameters can produce a different final address. Edit the rule to the exact address Safari displays.")]),
        FeatureGuide(icon: "checkmark.shield.fill", title: "Permissions and troubleshooting", summary: "Website access, profiles, and common fixes", sections: [
            GuideSection(title: "Enable in Settings", body: "Settings → Apps → Safari → Extensions → Safari Auto Refresh and Page Monitor XL. Turn on Allow Extension and grant the required website access."),
            GuideSection(title: "Enable in Safari", body: "Tap Page Menu beside the search field, then Manage Extensions. Switch on Auto Refresh XL and select it from Page Menu to open its controls."),
            GuideSection(title: "If controls are missing", body: "Use a normal http or https page, grant website permission, reload once, and reopen the extension. Safari internal pages cannot be controlled."),
            GuideSection(title: "Saved entries", body: "Form values are saved per tab. Closing the extension with Safari’s blue checkmark should not discard an unfinished setup.")])
    ]
}

private final class FeatureDetailViewController: UIViewController {
    private let feature: FeatureGuide
    init(feature: FeatureGuide) { self.feature = feature; super.init(nibName: nil, bundle: nil) }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad(); title = feature.title; view.backgroundColor = AppTheme.background
        let scroll = UIScrollView(); let stack = UIStackView(); scroll.translatesAutoresizingMaskIntoConstraints = false; stack.translatesAutoresizingMaskIntoConstraints = false; stack.axis = .vertical; stack.spacing = 14
        view.addSubview(scroll); scroll.addSubview(stack)
        NSLayoutConstraint.activate([scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor), scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor), scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor), stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 18), stack.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: 16), stack.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -16), stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -28)])
        let symbol = UIImageView(image: UIImage(systemName: feature.icon)); symbol.tintColor = AppTheme.cyan; symbol.contentMode = .scaleAspectFit; symbol.heightAnchor.constraint(equalToConstant: 58).isActive = true; stack.addArrangedSubview(symbol)
        let summary = makeLabel(feature.summary, 16, .semibold, AppTheme.secondary); summary.textAlignment = .center; stack.addArrangedSubview(summary)
        for section in feature.sections {
            let card = UIView(); card.backgroundColor = AppTheme.card; card.layer.cornerRadius = 13; card.layer.borderWidth = 1; card.layer.borderColor = UIColor(red: 31/255, green: 57/255, blue: 78/255, alpha: 1).cgColor
            let heading = makeLabel(section.title, 16, .bold, AppTheme.cyan); heading.accessibilityTraits = .header
            let body = makeLabel(section.body, 14, .regular, AppTheme.primary); body.numberOfLines = 0
            let words = UIStackView(arrangedSubviews: [heading, body]); words.axis = .vertical; words.spacing = 8; words.translatesAutoresizingMaskIntoConstraints = false; card.addSubview(words)
            NSLayoutConstraint.activate([words.topAnchor.constraint(equalTo: card.topAnchor, constant: 15), words.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 15), words.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -15), words.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -15)]); stack.addArrangedSubview(card)
        }
    }
    private func makeLabel(_ text: String, _ size: CGFloat, _ weight: UIFont.Weight, _ color: UIColor) -> UILabel { let value = UILabel(); value.text = text; value.font = .systemFont(ofSize: size, weight: weight); value.textColor = color; return value }
}
