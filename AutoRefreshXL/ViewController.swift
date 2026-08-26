import UIKit

private let appTranslations: [String: [String: String]] = [
    "de": [
        "Complete Feature Guide":"Vollständige Funktionsübersicht", "Tap a feature for detailed instructions, limitations, and useful tips.":"Tippe auf eine Funktion, um Anleitungen, Einschränkungen und Tipps anzuzeigen.", "Auto Refresh XL Settings":"Auto Refresh XL Einstellungen", "Contact Support":"Support kontaktieren", "Set up the extension":"Erweiterung einrichten", "Allow the extension":"Erweiterung erlauben", "Allow website access":"Website-Zugriff erlauben", "Open it in Safari":"In Safari öffnen", "If it is missing":"Falls sie nicht angezeigt wird", "Intervals and countdowns":"Intervalle und Countdowns", "Preset or custom refresh timing":"Vorgegebene oder eigene Aktualisierungszeiten", "Random interval range":"Zufälliger Intervallbereich", "A new delay for every cycle":"Neue Verzögerung bei jedem Durchlauf", "Refresh options and limits":"Aktualisierungsoptionen und Limits", "Hard refresh, limits, and interaction safety":"Vollständige Aktualisierung, Limits und Interaktionsschutz", "On-page overlay":"Widget auf der Webseite", "Countdown, monitored term, and controls":"Countdown, überwachter Begriff und Steuerung", "Content monitoring":"Inhaltsüberwachung", "Text, regex, and XPath matching":"Text-, Regex- und XPath-Vergleich", "Sound alerts":"Akustische Alarme", "Safari-safe audible target alerts":"Zuverlässige akustische Safari-Alarme", "On-screen target alerts":"Sichtbare Zielalarme", "Visible alerts across Safari tabs":"Sichtbare Alarme in Safari-Tabs", "Highlight and auto-scroll":"Hervorheben und automatisch scrollen", "Find a detected result after reload":"Erkanntes Ergebnis nach dem Neuladen finden", "Auto-Start rules":"Auto-Start-Regeln", "Start on saved exact pages":"Auf gespeicherten genauen Seiten starten", "Permissions and troubleshooting":"Berechtigungen und Fehlerbehebung", "Website access, profiles, and common fixes":"Website-Zugriff, Profile und häufige Lösungen", "Email Support":"E-Mail-Support", "Please email krabople@gmail.com from your preferred email app.":"Bitte sende über deine bevorzugte E-Mail-App eine Nachricht an krabople@gmail.com.", "OK":"OK"
    ],
    "fr": [
        "Complete Feature Guide":"Guide complet des fonctionnalités", "Tap a feature for detailed instructions, limitations, and useful tips.":"Touchez une fonctionnalité pour afficher les instructions, limites et conseils.", "Auto Refresh XL Settings":"Réglages d’Auto Refresh XL", "Contact Support":"Contacter l’assistance", "Set up the extension":"Configurer l’extension", "Allow the extension":"Autoriser l’extension", "Allow website access":"Autoriser l’accès aux sites web", "Open it in Safari":"Ouvrir dans Safari", "If it is missing":"Si elle n’apparaît pas", "Intervals and countdowns":"Intervalles et comptes à rebours", "Preset or custom refresh timing":"Fréquence prédéfinie ou personnalisée", "Random interval range":"Plage d’intervalle aléatoire", "A new delay for every cycle":"Un nouveau délai à chaque cycle", "Refresh options and limits":"Options et limites d’actualisation", "Hard refresh, limits, and interaction safety":"Actualisation forcée, limites et sécurité", "On-page overlay":"Widget superposé", "Countdown, monitored term, and controls":"Compte à rebours, terme surveillé et commandes", "Content monitoring":"Surveillance du contenu", "Text, regex, and XPath matching":"Correspondance texte, expression et XPath", "Sound alerts":"Alertes sonores", "Safari-safe audible target alerts":"Alertes sonores fiables dans Safari", "On-screen target alerts":"Alertes visibles", "Visible alerts across Safari tabs":"Alertes visibles dans les onglets Safari", "Highlight and auto-scroll":"Surlignage et défilement automatique", "Find a detected result after reload":"Retrouver un résultat après l’actualisation", "Auto-Start rules":"Règles de démarrage auto", "Start on saved exact pages":"Démarrer sur des pages exactes enregistrées", "Permissions and troubleshooting":"Autorisations et dépannage", "Website access, profiles, and common fixes":"Accès aux sites, profils et solutions courantes", "Email Support":"Assistance par e-mail", "Please email krabople@gmail.com from your preferred email app.":"Envoyez un e-mail à krabople@gmail.com depuis votre application préférée.", "OK":"OK"
    ],
    "es": [
        "Complete Feature Guide":"Guía completa de funciones", "Tap a feature for detailed instructions, limitations, and useful tips.":"Toca una función para ver instrucciones, limitaciones y consejos.", "Auto Refresh XL Settings":"Ajustes de Auto Refresh XL", "Contact Support":"Contactar con soporte", "Set up the extension":"Configurar la extensión", "Allow the extension":"Permitir la extensión", "Allow website access":"Permitir acceso a sitios web", "Open it in Safari":"Abrir en Safari", "If it is missing":"Si no aparece", "Intervals and countdowns":"Intervalos y cuentas atrás", "Preset or custom refresh timing":"Frecuencia predefinida o personalizada", "Random interval range":"Intervalo aleatorio", "A new delay for every cycle":"Un nuevo retraso en cada ciclo", "Refresh options and limits":"Opciones y límites de recarga", "Hard refresh, limits, and interaction safety":"Recarga completa, límites y seguridad", "On-page overlay":"Widget superpuesto", "Countdown, monitored term, and controls":"Cuenta atrás, término vigilado y controles", "Content monitoring":"Monitorización de contenido", "Text, regex, and XPath matching":"Coincidencia de texto, regex y XPath", "Sound alerts":"Alertas sonoras", "Safari-safe audible target alerts":"Alertas sonoras fiables en Safari", "On-screen target alerts":"Alertas visibles", "Visible alerts across Safari tabs":"Alertas visibles entre pestañas de Safari", "Highlight and auto-scroll":"Resaltado y desplazamiento automático", "Find a detected result after reload":"Encuentra el resultado después de recargar", "Auto-Start rules":"Reglas de inicio automático", "Start on saved exact pages":"Iniciar en páginas exactas guardadas", "Permissions and troubleshooting":"Permisos y solución de problemas", "Website access, profiles, and common fixes":"Acceso web, perfiles y soluciones habituales", "Email Support":"Soporte por correo", "Please email krabople@gmail.com from your preferred email app.":"Envía un correo a krabople@gmail.com desde tu aplicación preferida.", "OK":"Aceptar"
    ],
    "it": [
        "Complete Feature Guide":"Guida completa alle funzioni", "Tap a feature for detailed instructions, limitations, and useful tips.":"Tocca una funzione per istruzioni, limitazioni e suggerimenti.", "Auto Refresh XL Settings":"Impostazioni Auto Refresh XL", "Contact Support":"Contatta l’assistenza", "Set up the extension":"Configura l’estensione", "Allow the extension":"Consenti l’estensione", "Allow website access":"Consenti l’accesso ai siti web", "Open it in Safari":"Apri in Safari", "If it is missing":"Se non è visibile", "Intervals and countdowns":"Intervalli e conto alla rovescia", "Preset or custom refresh timing":"Tempi predefiniti o personalizzati", "Random interval range":"Intervallo casuale", "A new delay for every cycle":"Un nuovo ritardo per ogni ciclo", "Refresh options and limits":"Opzioni e limiti di aggiornamento", "On-page overlay":"Widget sulla pagina", "Content monitoring":"Monitoraggio dei contenuti", "Sound alerts":"Avvisi sonori", "On-screen target alerts":"Avvisi sullo schermo", "Highlight and auto-scroll":"Evidenziazione e scorrimento automatico", "Auto-Start rules":"Regole di avvio automatico", "Permissions and troubleshooting":"Autorizzazioni e risoluzione dei problemi", "Email Support":"Assistenza e-mail", "Please email krabople@gmail.com from your preferred email app.":"Invia un’e-mail a krabople@gmail.com dalla tua app preferita.", "OK":"OK"
    ],
    "pt": [
        "Complete Feature Guide":"Guia completo de funcionalidades", "Tap a feature for detailed instructions, limitations, and useful tips.":"Toque numa funcionalidade para ver instruções, limitações e sugestões.", "Auto Refresh XL Settings":"Definições do Auto Refresh XL", "Contact Support":"Contactar o suporte", "Set up the extension":"Configurar a extensão", "Allow the extension":"Permitir a extensão", "Allow website access":"Permitir acesso a sites", "Open it in Safari":"Abrir no Safari", "If it is missing":"Se não aparecer", "Intervals and countdowns":"Intervalos e contagens decrescentes", "Random interval range":"Intervalo aleatório", "Refresh options and limits":"Opções e limites de atualização", "On-page overlay":"Widget sobre a página", "Content monitoring":"Monitorização de conteúdo", "Sound alerts":"Alertas sonoros", "On-screen target alerts":"Alertas no ecrã", "Highlight and auto-scroll":"Realce e deslocação automática", "Auto-Start rules":"Regras de início automático", "Permissions and troubleshooting":"Permissões e resolução de problemas", "Email Support":"Suporte por e-mail", "Please email krabople@gmail.com from your preferred email app.":"Envie um e-mail para krabople@gmail.com através da sua aplicação preferida.", "OK":"OK"
    ],
    "nl": [
        "Complete Feature Guide":"Volledige functiegids", "Tap a feature for detailed instructions, limitations, and useful tips.":"Tik op een functie voor instructies, beperkingen en tips.", "Auto Refresh XL Settings":"Instellingen van Auto Refresh XL", "Contact Support":"Contact opnemen", "Set up the extension":"De extensie instellen", "Allow the extension":"De extensie toestaan", "Allow website access":"Websitetoegang toestaan", "Open it in Safari":"Openen in Safari", "If it is missing":"Als de extensie ontbreekt", "Intervals and countdowns":"Intervallen en aftellen", "Random interval range":"Willekeurig interval", "Refresh options and limits":"Verversingsopties en limieten", "On-page overlay":"Widget op de pagina", "Content monitoring":"Inhoud controleren", "Sound alerts":"Geluidsmeldingen", "On-screen target alerts":"Meldingen op het scherm", "Highlight and auto-scroll":"Markeren en automatisch scrollen", "Auto-Start rules":"Regels voor automatisch starten", "Permissions and troubleshooting":"Toestemming en probleemoplossing", "Email Support":"E-mailondersteuning", "Please email krabople@gmail.com from your preferred email app.":"Stuur vanuit je favoriete e-mailapp een bericht naar krabople@gmail.com.", "OK":"OK"
    ],
    "ja": [
        "Complete Feature Guide":"機能ガイド", "Tap a feature for detailed instructions, limitations, and useful tips.":"機能をタップすると、詳しい手順、制限事項、ヒントが表示されます。", "Auto Refresh XL Settings":"Auto Refresh XLの設定", "Contact Support":"サポートに連絡", "Set up the extension":"拡張機能を設定", "Allow the extension":"拡張機能を許可", "Allow website access":"Webサイトへのアクセスを許可", "Open it in Safari":"Safariで開く", "If it is missing":"表示されない場合", "Intervals and countdowns":"間隔とカウントダウン", "Preset or custom refresh timing":"プリセットまたはカスタムの更新時間", "Random interval range":"ランダム間隔", "A new delay for every cycle":"サイクルごとに新しい待ち時間", "Refresh options and limits":"更新オプションと上限", "On-page overlay":"ページ上のウィジェット", "Content monitoring":"コンテンツ監視", "Sound alerts":"サウンド通知", "On-screen target alerts":"画面上の通知", "Highlight and auto-scroll":"強調表示と自動スクロール", "Auto-Start rules":"自動開始ルール", "Permissions and troubleshooting":"権限とトラブルシューティング", "Email Support":"メールサポート", "Please email krabople@gmail.com from your preferred email app.":"お使いのメールアプリからkrabople@gmail.comにご連絡ください。", "OK":"OK"
    ],
    "ko": [
        "Complete Feature Guide":"전체 기능 안내", "Tap a feature for detailed instructions, limitations, and useful tips.":"기능을 탭하면 자세한 안내, 제한 사항 및 팁을 볼 수 있습니다.", "Auto Refresh XL Settings":"Auto Refresh XL 설정", "Contact Support":"지원 문의", "Set up the extension":"확장 프로그램 설정", "Allow the extension":"확장 프로그램 허용", "Allow website access":"웹사이트 접근 허용", "Open it in Safari":"Safari에서 열기", "If it is missing":"표시되지 않는 경우", "Intervals and countdowns":"간격 및 카운트다운", "Random interval range":"무작위 간격", "Refresh options and limits":"새로고침 옵션 및 제한", "On-page overlay":"페이지 오버레이", "Content monitoring":"콘텐츠 모니터링", "Sound alerts":"소리 알림", "On-screen target alerts":"화면 알림", "Highlight and auto-scroll":"강조 표시 및 자동 스크롤", "Auto-Start rules":"자동 시작 규칙", "Permissions and troubleshooting":"권한 및 문제 해결", "Email Support":"이메일 지원", "Please email krabople@gmail.com from your preferred email app.":"원하는 이메일 앱에서 krabople@gmail.com으로 문의해 주세요.", "OK":"확인"
    ],
    "zh-Hans": [
        "Complete Feature Guide":"完整功能指南", "Tap a feature for detailed instructions, limitations, and useful tips.":"轻点某项功能以查看详细说明、限制和实用提示。", "Auto Refresh XL Settings":"Auto Refresh XL 设置", "Contact Support":"联系支持", "Set up the extension":"设置扩展", "Allow the extension":"允许扩展", "Allow website access":"允许访问网站", "Open it in Safari":"在 Safari 中打开", "If it is missing":"如果未显示", "Intervals and countdowns":"间隔和倒计时", "Random interval range":"随机间隔范围", "Refresh options and limits":"刷新选项和限制", "On-page overlay":"页面悬浮组件", "Content monitoring":"内容监控", "Sound alerts":"声音提醒", "On-screen target alerts":"屏幕提醒", "Highlight and auto-scroll":"高亮和自动滚动", "Auto-Start rules":"自动启动规则", "Permissions and troubleshooting":"权限和故障排除", "Email Support":"电子邮件支持", "Please email krabople@gmail.com from your preferred email app.":"请使用您常用的邮件应用发送邮件至 krabople@gmail.com。", "OK":"好"
    ],
    "zh-Hant": [
        "Complete Feature Guide":"完整功能指南", "Tap a feature for detailed instructions, limitations, and useful tips.":"點按功能以查看詳細說明、限制和實用提示。", "Auto Refresh XL Settings":"Auto Refresh XL 設定", "Contact Support":"聯絡支援", "Set up the extension":"設定擴充功能", "Allow the extension":"允許擴充功能", "Allow website access":"允許取用網站", "Open it in Safari":"在 Safari 中開啟", "If it is missing":"如果沒有顯示", "Intervals and countdowns":"間隔和倒數", "Random interval range":"隨機間隔範圍", "Refresh options and limits":"重新整理選項和限制", "On-page overlay":"頁面浮動小工具", "Content monitoring":"內容監控", "Sound alerts":"聲音提醒", "On-screen target alerts":"畫面提醒", "Highlight and auto-scroll":"醒目提示和自動捲動", "Auto-Start rules":"自動啟動規則", "Permissions and troubleshooting":"權限和疑難排解", "Email Support":"電子郵件支援", "Please email krabople@gmail.com from your preferred email app.":"請使用偏好的郵件 App 傳送郵件至 krabople@gmail.com。", "OK":"好"
    ]
]

private func L(_ source: String) -> String {
    let preferred = Locale.preferredLanguages.first ?? "en"
    let code: String
    if preferred.hasPrefix("zh-Hant") { code = "zh-Hant" }
    else if preferred.hasPrefix("zh-Hans") || preferred.hasPrefix("zh-CN") { code = "zh-Hans" }
    else { code = String(preferred.prefix(2)) }
    return appTranslations[code]?[source] ?? source
}

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

        let title = UILabel(); title.text = L(feature.title); title.textColor = AppTheme.primary
        title.font = .systemFont(ofSize: 15, weight: .bold); title.numberOfLines = 0; title.textAlignment = .left
        let summary = UILabel(); summary.text = L(feature.summary); summary.textColor = AppTheme.secondary
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
        accessibilityLabel = "\(L(feature.title)). \(L(feature.summary))"
        accessibilityHint = L("Opens the detailed feature guide")
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
        var config = UIButton.Configuration.filled(); config.title = L("Auto Refresh XL Settings"); config.image = UIImage(systemName: "gearshape.fill")
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
        config.title = L("Contact Support")
        config.image = UIImage(systemName: "envelope.fill")
        config.imagePadding = 8
        config.baseForegroundColor = AppTheme.cyan
        config.baseBackgroundColor = AppTheme.cyan
        config.cornerStyle = .medium
        let button = UIButton(configuration: config)
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addTarget(self, action: #selector(contactSupport), for: .touchUpInside)
        button.accessibilityHint = L("Creates an email to krabople@gmail.com")
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
            let alert = UIAlertController(title: L("Email Support"), message: L("Please email krabople@gmail.com from your preferred email app."), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: L("OK"), style: .default))
            present(alert, animated: true)
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    private func cardView() -> UIView { let view = UIView(); view.backgroundColor = AppTheme.card; view.layer.cornerRadius = 14; view.layer.borderWidth = 1; view.layer.borderColor = UIColor(red: 31/255, green: 57/255, blue: 78/255, alpha: 1).cgColor; return view }
    private func label(_ text: String, _ size: CGFloat, _ weight: UIFont.Weight, _ color: UIColor) -> UILabel { let result = UILabel(); result.text = L(text); result.font = .systemFont(ofSize: size, weight: weight); result.textColor = color; return result }

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
        super.viewDidLoad(); title = L(feature.title); view.backgroundColor = AppTheme.background
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
    private func makeLabel(_ text: String, _ size: CGFloat, _ weight: UIFont.Weight, _ color: UIColor) -> UILabel { let value = UILabel(); value.text = L(text); value.font = .systemFont(ofSize: size, weight: weight); value.textColor = color; return value }
}
