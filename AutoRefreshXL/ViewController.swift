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

private final class FeatureRowControl: UIControl {
    init(feature: FeatureGuide) {
        super.init(frame: .zero)
        backgroundColor = AppTheme.card
        layer.cornerRadius = 13
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 35/255, green: 60/255, blue: 82/255, alpha: 1).cgColor

        let iconBackground = UIView()
        iconBackground.backgroundColor = AppTheme.cyan.withAlphaComponent(0.14)
        iconBackground.layer.cornerRadius = 20
        iconBackground.translatesAutoresizingMaskIntoConstraints = false
        let icon = UIImageView(image: UIImage(systemName: feature.icon))
        icon.tintColor = AppTheme.cyan
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        iconBackground.addSubview(icon)

        let title = UILabel(); title.text = feature.title; title.textColor = AppTheme.primary
        title.font = .systemFont(ofSize: 15, weight: .bold); title.numberOfLines = 0; title.textAlignment = .left
        let summary = UILabel(); summary.text = feature.summary; summary.textColor = AppTheme.secondary
        summary.font = .systemFont(ofSize: 12); summary.numberOfLines = 0; summary.textAlignment = .left
        let words = UIStackView(arrangedSubviews: [title, summary]); words.axis = .vertical; words.spacing = 4
        let chevron = UIImageView(image: UIImage(systemName: "chevron.right")); chevron.tintColor = AppTheme.secondary; chevron.contentMode = .scaleAspectFit
        chevron.translatesAutoresizingMaskIntoConstraints = false
        let row = UIStackView(arrangedSubviews: [iconBackground, words, chevron])
        row.axis = .horizontal; row.alignment = .center; row.spacing = 12; row.isUserInteractionEnabled = false
        row.translatesAutoresizingMaskIntoConstraints = false; addSubview(row)
        NSLayoutConstraint.activate([
            iconBackground.widthAnchor.constraint(equalToConstant: 40), iconBackground.heightAnchor.constraint(equalToConstant: 40),
            icon.centerXAnchor.constraint(equalTo: iconBackground.centerXAnchor), icon.centerYAnchor.constraint(equalTo: iconBackground.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 22), icon.heightAnchor.constraint(equalToConstant: 22),
            chevron.widthAnchor.constraint(equalToConstant: 9),
            row.topAnchor.constraint(equalTo: topAnchor, constant: 13), row.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13),
            row.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -13), row.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -13)
        ])
        accessibilityLabel = "\(feature.title). \(feature.summary)"
        accessibilityHint = "Opens the detailed feature guide"
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override var isHighlighted: Bool { didSet { alpha = isHighlighted ? 0.68 : 1 } }
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
        contentStack.addArrangedSubview(foregroundNoticeCard())
        contentStack.addArrangedSubview(setupCard())
        let heading = label("Complete Feature Guide", 21, .bold, AppTheme.primary); heading.accessibilityTraits = .header
        contentStack.addArrangedSubview(heading)
        contentStack.addArrangedSubview(label("Tap a feature for detailed instructions, limitations, and useful tips.", 13, .regular, AppTheme.secondary))
        for (index, feature) in Self.features.enumerated() { contentStack.addArrangedSubview(featureButton(feature, index)) }
        contentStack.addArrangedSubview(settingsButton())
        contentStack.addArrangedSubview(supportButton())
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
        var config = UIButton.Configuration.filled(); config.title = "Auto Refresh XL Settings"; config.image = UIImage(systemName: "gearshape.fill")
        config.imagePadding = 8; config.baseBackgroundColor = AppTheme.cyan; config.baseForegroundColor = .black; config.cornerStyle = .medium
        let button = UIButton(configuration: config); button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(openSettingsGuide), for: .touchUpInside); return button
    }

    private func foregroundNoticeCard() -> UIView {
        let card = cardView()
        card.layer.borderColor = UIColor(red: 245/255, green: 158/255, blue: 11/255, alpha: 0.65).cgColor
        let icon = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
        icon.tintColor = UIColor(red: 251/255, green: 191/255, blue: 36/255, alpha: 1)
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        let title = label("Safari must remain open on screen", 15, .bold, UIColor(red: 251/255, green: 191/255, blue: 36/255, alpha: 1))
        let body = label("Auto-refresh and page monitoring can continue while you browse other tabs within Safari. They will not operate reliably after Safari is closed, moved into the background, or you switch to another app.", 13, .regular, AppTheme.primary)
        body.numberOfLines = 0
        let words = UIStackView(arrangedSubviews: [title, body]); words.axis = .vertical; words.spacing = 6
        let row = UIStackView(arrangedSubviews: [icon, words]); row.axis = .horizontal; row.alignment = .top; row.spacing = 12; row.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(row)
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 25), icon.heightAnchor.constraint(equalToConstant: 25),
            row.topAnchor.constraint(equalTo: card.topAnchor, constant: 15), row.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 15),
            row.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -15), row.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -15)
        ])
        return card
    }

    private func supportButton() -> UIButton {
        var config = UIButton.Configuration.tinted()
        config.title = "Contact Support"
        config.image = UIImage(systemName: "envelope.fill")
        config.imagePadding = 8
        config.baseForegroundColor = AppTheme.cyan
        config.baseBackgroundColor = AppTheme.cyan
        config.cornerStyle = .medium
        let button = UIButton(configuration: config)
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addTarget(self, action: #selector(contactSupport), for: .touchUpInside)
        button.accessibilityHint = "Creates an email to krabople@gmail.com"
        return button
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

    private func featureButton(_ feature: FeatureGuide, _ index: Int) -> FeatureRowControl {
        let control = FeatureRowControl(feature: feature); control.tag = index
        control.addTarget(self, action: #selector(openFeature(_:)), for: .touchUpInside)
        return control
    }

    @objc private func openFeature(_ sender: UIControl) {
        guard Self.features.indices.contains(sender.tag) else { return }
        navigationController?.pushViewController(FeatureDetailViewController(feature: Self.features[sender.tag]), animated: true)
    }

    @objc private func openSettingsGuide() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @objc private func contactSupport() {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = "krabople@gmail.com"
        components.queryItems = [URLQueryItem(name: "subject", value: "Auto Refresh XL Support")]
        guard let url = components.url, UIApplication.shared.canOpenURL(url) else {
            let alert = UIAlertController(title: "Email Support", message: "Please email krabople@gmail.com from your preferred email app.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    private func cardView() -> UIView { let view = UIView(); view.backgroundColor = AppTheme.card; view.layer.cornerRadius = 14; view.layer.borderWidth = 1; view.layer.borderColor = UIColor(red: 31/255, green: 57/255, blue: 78/255, alpha: 1).cgColor; return view }
    private func label(_ text: String, _ size: CGFloat, _ weight: UIFont.Weight, _ color: UIColor) -> UILabel { let result = UILabel(); result.text = text; result.font = .systemFont(ofSize: size, weight: weight); result.textColor = color; return result }

    private static let features: [FeatureGuide] = [
        FeatureGuide(icon: "timer", title: "Intervals and countdowns", summary: "Preset or custom refresh timing", sections: [
            GuideSection(title: "How it works", body: "Choose a preset or enter hours, minutes, and seconds. Press Start Refresh to begin the first countdown. Monitoring does not check immediately; its first cycle occurs only when this countdown reaches zero."),
            GuideSection(title: "What happens at zero", body: "The extension obtains fresh content for monitoring, performs a genuine visible Safari reload, and schedules the next countdown. Page loading time and iOS suspension can delay very short intervals."),
            GuideSection(title: "Tips", body: "Allow enough time for the site to load. Refreshing very frequently can increase battery usage and mobile data use, and may trigger captchas, rate limits, or a temporary website block.")]),
        FeatureGuide(icon: "shuffle", title: "Random interval range", summary: "A new delay for every cycle", sections: [
            GuideSection(title: "Using random mode", body: "Enter minimum and maximum seconds. Preset and custom fields are disabled because a fresh random delay is selected after every cycle."),
            GuideSection(title: "Limitations", body: "Random timing can reduce repetitive request patterns and may avoid bot detection on some websites, but it does not always bypass website rules or anti-automation systems. Avoid extremely short ranges on complex pages.")]),
        FeatureGuide(icon: "arrow.clockwise", title: "Refresh options and limits", summary: "Hard refresh, limits, and interaction safety", sections: [
            GuideSection(title: "Hard Refresh", body: "Requests a reload that bypasses cached data where Safari supports it. Websites and service workers may still impose their own caching."),
            GuideSection(title: "Refresh Limit", body: "A positive number stops after that many cycles; zero is unlimited. The overlay shows the count."),
            GuideSection(title: "Stop on interaction", body: "Stops refreshing when you interact with the monitored webpage. Use this when you want a tap, click, key press, or other page interaction to end the active refresh session.")]),
        FeatureGuide(icon: "rectangle.inset.filled", title: "On-page overlay", summary: "Countdown, monitored term, and controls", sections: [
            GuideSection(title: "What it shows", body: "The draggable overlay shows countdown, refresh count, fixed or random mode, monitored term, Stop Refresh, and the sound toggle when monitoring uses sound."),
            GuideSection(title: "Moving and hiding", body: "Drag its header. Its position is retained across refreshes in the same tab. Closing the widget hides it until the next page load; use Stop Refresh to end the process."),
            GuideSection(title: "Compatibility", body: "It cannot appear on Safari internal pages, Settings, some document viewers, or websites without extension access.")]),
        FeatureGuide(icon: "text.magnifyingglass", title: "Content monitoring", summary: "Text, regex, and XPath matching", sections: [
            GuideSection(title: "Plain Text", body: "Case-insensitive text matching. Entering text into an empty field turns monitoring on; clearing it turns monitoring off. You can manually switch it off while keeping the text."),
            GuideSection(title: "Regular Expression", body: "Uses a case-insensitive JavaScript regular expression. Invalid expressions cannot match, so test complex expressions carefully."),
            GuideSection(title: "XPath", body: "Finds an element using its page structure. XPath rules may break when a site redesigns its markup."),
            GuideSection(title: "Appears or disappears", body: "Appears triggers when a match exists; Disappears triggers when it does not. Checks start after the first countdown."),
            GuideSection(title: "Dynamic sites", body: "The rendered page is checked immediately after refresh and watched for later changes. Inaccessible frames, images, canvas text, and closed components may not be detectable.")]),
        FeatureGuide(icon: "speaker.wave.3.fill", title: "Sound alerts", summary: "Safari-safe audible target alerts", sections: [
            GuideSection(title: "Enabling sound", body: "Use the overlay button to enable or disable alert sound. The preference remains selected when the monitored page refreshes."),
            GuideSection(title: "Other tabs", body: "The iOS extension plays the primary alert sound natively, while the visible alert is routed to the ordinary Safari webpage you are viewing."),
            GuideSection(title: "Limitations", body: "The Ring/Silent switch, device volume, Focus modes, and iOS resource suspension can affect alerts. Webpage audio remains available as a fallback when native sound cannot be started.")]),
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
