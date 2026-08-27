import UIKit

private let appTranslations: [String: [String: String]] = [
    "de": [
        "A new delay for every cycle": "Neue Verzögerung bei jedem Durchlauf",
        "A positive number stops after that many cycles; zero is unlimited. The overlay shows the count.": "Eine positive Zahl stoppt nach so vielen Zyklen; Null ist unbegrenzt. Das Overlay zeigt die Anzahl an.",
        "Adding": "Hinzufügen",
        "Advanced Options opens inside the extension. Edit changes URL and default interval; Delete permanently removes the rule. Older wildcard rules remain supported.": "Erweiterte Optionen werden in der Erweiterung geöffnet. Bearbeiten Sie die Änderungs-URL und das Standardintervall. Durch Löschen wird die Regel dauerhaft entfernt. Ältere Wildcard-Regeln werden weiterhin unterstützt.",
        "Allow enough time for the site to load. Refreshing very frequently can increase battery usage and mobile data use, and may trigger captchas, rate limits, or a temporary website block.": "Warten Sie ausreichend Zeit, bis die Website geladen ist. Eine sehr häufige Aktualisierung kann den Akkuverbrauch und die Nutzung mobiler Daten erhöhen und Captchas, Ratenbegrenzungen oder eine vorübergehende Website-Sperre auslösen.",
        "Allow the extension": "Erweiterung erlauben",
        "Allow website access": "Website-Zugriff erlauben",
        "Appears or disappears": "Erscheint oder verschwindet",
        "Appears triggers when a match exists; Disappears triggers when it does not. Checks start after the first countdown.": "Erscheint als Auslöser, wenn eine Übereinstimmung vorliegt; Verschwindet wird ausgelöst, wenn dies nicht der Fall ist. Die Kontrollen beginnen nach dem ersten Countdown.",
        "Auto Refresh XL Settings": "Auto Refresh XL Einstellungen",
        "Auto-Start rules": "Auto-Start-Regeln",
        "Auto-refresh and page monitoring can continue while you browse other tabs within Safari. They will not operate reliably after Safari is closed, moved into the background, or you switch to another app.": "Die automatische Aktualisierung und Seitenüberwachung können fortgesetzt werden, während Sie andere Registerkarten in Safari durchsuchen. Sie funktionieren nicht zuverlässig, nachdem Safari geschlossen, in den Hintergrund verschoben oder zu einer anderen App gewechselt wird.",
        "Auto-scroll": "Automatisches Scrollen",
        "Automatic refreshing, content monitoring, visible and audible alerts, and exact-page Auto-Start rules for Safari.": "Automatische Aktualisierung, Inhaltsüberwachung, sichtbare und akustische Warnungen und seitengenaue Autostart-Regeln für Safari.",
        "Case-insensitive text matching. Entering text into an empty field turns monitoring on; clearing it turns monitoring off. You can manually switch it off while keeping the text.": "Textvergleich ohne Berücksichtigung der Groß- und Kleinschreibung. Durch die Eingabe von Text in ein leeres Feld wird die Überwachung aktiviert. Durch Löschen wird die Überwachung ausgeschaltet. Sie können es manuell ausschalten, während der Text erhalten bleibt.",
        "Choose a preset or enter hours, minutes, and seconds. Press Start Refresh to begin the first countdown. Monitoring does not check immediately; its first cycle occurs only when this countdown reaches zero.": "Wählen Sie eine Voreinstellung oder geben Sie Stunden, Minuten und Sekunden ein. Drücken Sie „Aktualisierung starten“, um den ersten Countdown zu starten. Die Überwachung prüft nicht sofort; sein erster Zyklus findet erst statt, wenn dieser Countdown Null erreicht.",
        "Compatibility": "Kompatibilität",
        "Complete Feature Guide": "Vollständige Funktionsübersicht",
        "Contact Support": "Support kontaktieren",
        "Content monitoring": "Inhaltsüberwachung",
        "Countdown, monitored term, and controls": "Countdown, überwachter Begriff und Steuerung",
        "Creates an email to krabople@gmail.com": "Erstellt eine E-Mail an krabople@gmail.com",
        "Cross-tab alerts": "Kreuztabellenwarnungen",
        "Drag its header. Its position is retained across refreshes in the same tab. Closing the widget hides it until the next page load; use Stop Refresh to end the process.": "Ziehen Sie die Kopfzeile. Seine Position bleibt bei Aktualisierungen auf derselben Registerkarte erhalten. Wenn Sie das Widget schließen, wird es ausgeblendet, bis die nächste Seite geladen wird. Verwenden Sie Stop Refresh, um den Vorgang zu beenden.",
        "Dynamic sites": "Dynamische Websites",
        "Editing": "Bearbeiten",
        "Email Support": "E-Mail-Support",
        "Enable in Safari": "Aktivieren Sie in Safari",
        "Enable in Settings": "In den Einstellungen aktivieren",
        "Enabling sound": "Ton aktivieren",
        "Enter minimum and maximum seconds. Preset and custom fields are disabled because a fresh random delay is selected after every cycle.": "Geben Sie minimale und maximale Sekunden ein. Voreingestellte und benutzerdefinierte Felder sind deaktiviert, da nach jedem Zyklus eine neue zufällige Verzögerung ausgewählt wird.",
        "Find a detected result after reload": "Erkanntes Ergebnis nach dem Neuladen finden",
        "Finds an element using its page structure. XPath rules may break when a site redesigns its markup.": "Findet ein Element anhand seiner Seitenstruktur. XPath-Regeln können fehlschlagen, wenn eine Website ihr Markup neu gestaltet.",
        "Form values are saved per tab. Closing the extension with Safari’s blue checkmark should not discard an unfinished setup.": "Formularwerte werden pro Registerkarte gespeichert. Das Schließen der Erweiterung mit dem blauen Häkchen von Safari sollte kein unvollendetes Setup verwerfen.",
        "Hard Refresh": "Harte Aktualisierung",
        "Hard refresh, limits, and interaction safety": "Vollständige Aktualisierung, Limits und Interaktionsschutz",
        "Hidden or replaced server text, inaccessible frames, closed shadow content, images, canvas, and late components may not be highlightable.": "Versteckter oder ersetzter Servertext, unzugängliche Rahmen, geschlossene Schatteninhalte, Bilder, Leinwand und späte Komponenten können möglicherweise nicht hervorgehoben werden.",
        "Highlight and auto-scroll": "Hervorheben und automatisch scrollen",
        "Highlighting": "Hervorhebung",
        "How it works": "Wie es funktioniert",
        "If it is missing": "Falls sie nicht angezeigt wird",
        "Intervals and countdowns": "Intervalle und Countdowns",
        "It cannot appear on Safari internal pages, Settings, some document viewers, or websites without extension access.": "Es kann nicht auf internen Seiten von Safari, in den Einstellungen, in einigen Dokumentbetrachtern oder auf Websites ohne Erweiterungszugriff angezeigt werden.",
        "Limitations": "Einschränkungen",
        "Moving and hiding": "Bewegen und verstecken",
        "OK": "OK",
        "On that screen, allow access to the websites you want to refresh. Allow for All Websites is the simplest setup.": "Erlauben Sie auf diesem Bildschirm den Zugriff auf die Websites, die Sie aktualisieren möchten. „Für alle Websites zulassen“ ist die einfachste Einrichtung.",
        "On the desired page, choose Auto-Start Current Page. New rules save the entire URL, including path and query string, and match that exact address.": "Wählen Sie auf der gewünschten Seite die Option „Aktuelle Seite automatisch starten“ aus. Neue Regeln speichern die gesamte URL, einschließlich Pfad und Abfragezeichenfolge, und stimmen genau mit dieser Adresse überein.",
        "On-page overlay": "Widget auf der Webseite",
        "On-screen target alerts": "Sichtbare Zielalarme",
        "Open it in Safari": "In Safari öffnen",
        "Opens the detailed feature guide": "Öffnet die ausführliche Funktionsanleitung",
        "Other tabs": "Andere Registerkarten",
        "Permissions and troubleshooting": "Berechtigungen und Fehlerbehebung",
        "Plain Text": "Klartext",
        "Plain-text and regex matches use the yellow pulsing highlight. The extension reapplies it to the newly reloaded page so navigation does not remove it.": "Nur-Text- und regex-Übereinstimmungen verwenden die gelbe pulsierende Hervorhebung. Die Erweiterung wendet es erneut auf die neu geladene Seite an, sodass es durch die Navigation nicht entfernt wird.",
        "Please email krabople@gmail.com from your preferred email app.": "Bitte sende über deine bevorzugte E-Mail-App eine Nachricht an krabople@gmail.com.",
        "Preset or custom refresh timing": "Vorgegebene oder eigene Aktualisierungszeiten",
        "Random interval range": "Zufälliger Intervallbereich",
        "Random timing can reduce repetitive request patterns and may avoid bot detection on some websites, but it does not always bypass website rules or anti-automation systems. Avoid extremely short ranges on complex pages.": "Zufälliges Timing kann sich wiederholende Anforderungsmuster reduzieren und die Bot-Erkennung auf einigen Websites verhindern, aber Website-Regeln oder Anti-Automatisierungssysteme werden dadurch nicht immer umgangen. Vermeiden Sie extrem kurze Bereiche auf komplexen Seiten.",
        "Redirects and changing query parameters can produce a different final address. Edit the rule to the exact address Safari displays.": "Weiterleitungen und sich ändernde Abfrageparameter können zu einer anderen endgültigen Adresse führen. Bearbeiten Sie die Regel auf die genaue Adresse, die Safari anzeigt.",
        "Refresh Limit": "Aktualisierungslimit",
        "Refresh options and limits": "Aktualisierungsoptionen und Limits",
        "Regular Expression": "Regulärer Ausdruck",
        "Requests a reload that bypasses cached data where Safari supports it. Websites and service workers may still impose their own caching.": "Fordert ein Neuladen an, das zwischengespeicherte Daten umgeht, sofern Safari dies unterstützt. Websites und Servicemitarbeiter können weiterhin ihr eigenes Caching vorschreiben.",
        "Safari Auto Refresh and\nPage Monitor XL": "Auto Refresh XL für Safari",
        "Safari cannot inject the banner into internal browser pages, Settings, some viewers, or pages without permission. It is not a Lock Screen push notification.": "Safari kann das Banner ohne Erlaubnis nicht in interne Browserseiten, Einstellungen, einige Viewer oder Seiten einfügen. Es handelt sich nicht um eine Push-Benachrichtigung für den Sperrbildschirm.",
        "Safari must remain open on screen": "Safari muss auf dem Bildschirm geöffnet bleiben",
        "Safari smoothly centres the detected match. The extension retries briefly for pages that render after the initial document.": "Safari zentriert die erkannte Übereinstimmung reibungslos. Die Erweiterung versucht für Seiten, die nach dem ursprünglichen Dokument gerendert werden, kurz einen erneuten Versuch.",
        "Safari-safe audible target alerts": "Zuverlässige akustische Safari-Alarme",
        "Saved entries": "Gespeicherte Einträge",
        "Set up the extension": "Erweiterung einrichten",
        "Settings → Apps → Safari → Extensions → Safari Auto Refresh and Page Monitor XL. Turn on Allow Extension and grant the required website access.": "Einstellungen → Apps → Safari → Erweiterungen → Auto Refresh XL. Aktivieren Sie „Erweiterung zulassen“ und gewähren Sie den erforderlichen Website-Zugriff.",
        "Settings → Apps → Safari → Extensions → Safari Auto Refresh and Page Monitor XL. Turn on Allow Extension.": "Einstellungen → Apps → Safari → Erweiterungen → Auto Refresh XL. Aktivieren Sie „Erweiterung zulassen“.",
        "Sound alerts": "Akustische Alarme",
        "Start on saved exact pages": "Auf gespeicherten genauen Seiten starten",
        "Stop on interaction": "Stoppen Sie die Interaktion",
        "Stops refreshing when you interact with the monitored webpage. Use this when you want a tap, click, key press, or other page interaction to end the active refresh session.": "Die Aktualisierung stoppt, wenn Sie mit der überwachten Webseite interagieren. Verwenden Sie dies, wenn Sie möchten, dass die aktive Aktualisierungssitzung durch Tippen, Klicken, Tastendruck oder eine andere Seiteninteraktion beendet wird.",
        "Tap Page Menu beside the search field, then Manage Extensions. Switch on Auto Refresh XL and select it from Page Menu to open its controls.": "Tippen Sie neben dem Suchfeld auf Seitenmenü und dann auf Erweiterungen verwalten. Schalten Sie Auto Refresh XL ein und wählen Sie es im Seitenmenü aus, um seine Steuerelemente zu öffnen.",
        "Tap Page Menu → Manage Extensions and switch on Auto Refresh XL. Safari profiles may require separate enabling.": "Tippen Sie auf Seitenmenü → Erweiterungen verwalten und schalten Sie Auto Refresh XL ein. Safari-Profile erfordern möglicherweise eine separate Aktivierung.",
        "Tap a feature for detailed instructions, limitations, and useful tips.": "Tippe auf eine Funktion, um Anleitungen, Einschränkungen und Tipps anzuzeigen.",
        "Text, regex, and XPath matching": "Text-, Regex- und XPath-Vergleich",
        "The Ring/Silent switch, device volume, Focus modes, and iOS resource suspension can affect alerts. Webpage audio remains available as a fallback when native sound cannot be started.": "Der Klingel-/Stummschalter, die Gerätelautstärke, die Fokusmodi und die iOS-Ressourcenunterbrechung können sich auf Warnungen auswirken. Webseiten-Audio bleibt als Ersatz verfügbar, wenn der native Sound nicht gestartet werden kann.",
        "The banner appears on the ordinary Safari webpage currently being viewed. View Monitored Tab returns to the source tab when needed.": "Das Banner erscheint auf der normalen Safari-Webseite, die gerade angezeigt wird. Die Registerkarte „Überwacht anzeigen“ kehrt bei Bedarf zur Registerkarte „Quelle“ zurück.",
        "The draggable overlay shows countdown, refresh count, fixed or random mode, monitored term, Stop Refresh, and the sound toggle when monitoring uses sound.": "Das verschiebbare Overlay zeigt Countdown, Aktualisierungsanzahl, festen oder zufälligen Modus, überwachten Zeitraum, Aktualisierung stoppen und die Tonumschaltung, wenn die Überwachung Ton verwendet.",
        "The extension obtains fresh content for monitoring, performs a genuine visible Safari reload, and schedules the next countdown. Page loading time and iOS suspension can delay very short intervals.": "Die Erweiterung ruft neue Inhalte zur Überwachung ab, führt einen echten, sichtbaren Neuladevorgang durch und plant den nächsten Countdown. Die Seitenladezeit und die iOS-Unterbrechung können sehr kurze Zeiträume verzögern.",
        "The iOS extension plays the primary alert sound natively, while the visible alert is routed to the ordinary Safari webpage you are viewing.": "Die iOS-Erweiterung spielt den primären Alarmton nativ ab, während der sichtbare Alarm an die normale Safari-Webseite weitergeleitet wird, die Sie gerade ansehen.",
        "The rendered page is checked immediately after refresh and watched for later changes. Inaccessible frames, images, canvas text, and closed components may not be detectable.": "Die gerenderte Seite wird sofort nach der Aktualisierung überprüft und auf spätere Änderungen überwacht. Unzugängliche Rahmen, Bilder, Leinwandtext und geschlossene Komponenten sind möglicherweise nicht erkennbar.",
        "Tips": "Tipps",
        "Use the overlay button to enable or disable alert sound. The preference remains selected when the monitored page refreshes.": "Verwenden Sie die Overlay-Taste, um den Alarmton zu aktivieren oder zu deaktivieren. Die Einstellung bleibt ausgewählt, wenn die überwachte Seite aktualisiert wird.",
        "Uses a case-insensitive JavaScript regular expression. Invalid expressions cannot match, so test complex expressions carefully.": "Verwendet einen regulären JavaScript-Ausdruck, bei dem die Groß-/Kleinschreibung nicht berücksichtigt wird. Ungültige Ausdrücke können nicht übereinstimmen. Testen Sie daher komplexe Ausdrücke sorgfältig.",
        "Using random mode": "Verwenden des Zufallsmodus",
        "Visible alerts across Safari tabs": "Sichtbare Alarme in Safari-Tabs",
        "Visit a webpage. Tap Safari’s Page Menu button beside the search field, then choose Auto Refresh XL from the extensions list.": "Besuchen Sie eine Webseite. Tippen Sie auf die Seitenmenü-Schaltfläche von Safari neben dem Suchfeld und wählen Sie dann Auto Refresh XL aus der Erweiterungsliste aus.",
        "Website access, profiles, and common fixes": "Website-Zugriff, Profile und häufige Lösungen",
        "What happens at zero": "Was passiert bei Null?",
        "What it shows": "Was es zeigt",
        "XPath": "XPath"
    ],
    "fr": [
        "A new delay for every cycle": "Un nouveau délai à chaque cycle",
        "A positive number stops after that many cycles; zero is unlimited. The overlay shows the count.": "Un nombre positif s’arrête après autant de cycles ; zéro est illimité. La superposition montre le décompte.",
        "Adding": "Ajout",
        "Advanced Options opens inside the extension. Edit changes URL and default interval; Delete permanently removes the rule. Older wildcard rules remain supported.": "Les options avancées s'ouvrent dans l'extension. Modifier l'URL des modifications et l'intervalle par défaut ; Supprimer supprime définitivement la règle. Les anciennes règles génériques restent prises en charge.",
        "Allow enough time for the site to load. Refreshing very frequently can increase battery usage and mobile data use, and may trigger captchas, rate limits, or a temporary website block.": "Prévoyez suffisamment de temps pour que le site se charge. L'actualisation très fréquente peut augmenter l'utilisation de la batterie et des données mobiles, et peut déclencher des captchas, des limites de débit ou un blocage temporaire du site Web.",
        "Allow the extension": "Autoriser l’extension",
        "Allow website access": "Autoriser l’accès aux sites web",
        "Appears or disappears": "Apparaît ou disparaît",
        "Appears triggers when a match exists; Disappears triggers when it does not. Checks start after the first countdown.": "Apparaît comme déclencheur lorsqu'une correspondance existe ; Disparaît les déclencheurs quand ce n'est pas le cas. Les contrôles commencent après le premier compte à rebours.",
        "Auto Refresh XL Settings": "Réglages d’Auto Refresh XL",
        "Auto-Start rules": "Règles de démarrage auto",
        "Auto-refresh and page monitoring can continue while you browse other tabs within Safari. They will not operate reliably after Safari is closed, moved into the background, or you switch to another app.": "L'actualisation automatique et la surveillance des pages peuvent continuer pendant que vous parcourez d'autres onglets dans Safari. Ils ne fonctionneront pas de manière fiable une fois que Safari sera fermé, déplacé en arrière-plan ou lorsque vous passerez à une autre application.",
        "Auto-scroll": "Défilement automatique",
        "Automatic refreshing, content monitoring, visible and audible alerts, and exact-page Auto-Start rules for Safari.": "Actualisation automatique, surveillance du contenu, alertes visibles et sonores et règles de démarrage automatique par page exacte pour Safari.",
        "Case-insensitive text matching. Entering text into an empty field turns monitoring on; clearing it turns monitoring off. You can manually switch it off while keeping the text.": "Correspondance de texte insensible à la casse. La saisie de texte dans un champ vide active la surveillance ; sa suppression désactive la surveillance. Vous pouvez le désactiver manuellement tout en conservant le texte.",
        "Choose a preset or enter hours, minutes, and seconds. Press Start Refresh to begin the first countdown. Monitoring does not check immediately; its first cycle occurs only when this countdown reaches zero.": "Choisissez un préréglage ou entrez les heures, les minutes et les secondes. Appuyez sur Démarrer l'actualisation pour lancer le premier compte à rebours. La surveillance ne vérifie pas immédiatement ; son premier cycle n'a lieu que lorsque ce compte à rebours atteint zéro.",
        "Compatibility": "Compatibilité",
        "Complete Feature Guide": "Guide complet des fonctionnalités",
        "Contact Support": "Contacter l’assistance",
        "Content monitoring": "Surveillance du contenu",
        "Countdown, monitored term, and controls": "Compte à rebours, terme surveillé et commandes",
        "Creates an email to krabople@gmail.com": "Crée un e-mail à krabople@gmail.com",
        "Cross-tab alerts": "Alertes croisées",
        "Drag its header. Its position is retained across refreshes in the same tab. Closing the widget hides it until the next page load; use Stop Refresh to end the process.": "Faites glisser son en-tête. Sa position est conservée lors des actualisations dans le même onglet. La fermeture du widget le masque jusqu'au prochain chargement de la page ; utilisez Stop Refresh pour terminer le processus.",
        "Dynamic sites": "Sites dynamiques",
        "Editing": "Édition",
        "Email Support": "Assistance par e-mail",
        "Enable in Safari": "Activer dans Safari",
        "Enable in Settings": "Activer dans les paramètres",
        "Enabling sound": "Activation du son",
        "Enter minimum and maximum seconds. Preset and custom fields are disabled because a fresh random delay is selected after every cycle.": "Entrez les secondes minimales et maximales. Les champs prédéfinis et personnalisés sont désactivés car un nouveau délai aléatoire est sélectionné après chaque cycle.",
        "Find a detected result after reload": "Retrouver un résultat après l’actualisation",
        "Finds an element using its page structure. XPath rules may break when a site redesigns its markup.": "Recherche un élément en utilisant sa structure de page. Les règles XPath peuvent être rompues lorsqu'un site repense son balisage.",
        "Form values are saved per tab. Closing the extension with Safari’s blue checkmark should not discard an unfinished setup.": "Les valeurs du formulaire sont enregistrées par onglet. La fermeture de l'extension avec la coche bleue de Safari ne devrait pas supprimer une configuration inachevée.",
        "Hard Refresh": "Actualisation difficile",
        "Hard refresh, limits, and interaction safety": "Actualisation forcée, limites et sécurité",
        "Hidden or replaced server text, inaccessible frames, closed shadow content, images, canvas, and late components may not be highlightable.": "Le texte du serveur masqué ou remplacé, les cadres inaccessibles, le contenu masqué fermé, les images, le canevas et les composants tardifs peuvent ne pas être mis en surbrillance.",
        "Highlight and auto-scroll": "Surlignage et défilement automatique",
        "Highlighting": "Mise en évidence",
        "How it works": "Comment ça marche",
        "If it is missing": "Si elle n’apparaît pas",
        "Intervals and countdowns": "Intervalles et comptes à rebours",
        "It cannot appear on Safari internal pages, Settings, some document viewers, or websites without extension access.": "Il ne peut pas apparaître sur les pages internes de Safari, dans les paramètres, dans certaines visionneuses de documents ou sur les sites Web sans accès à l'extension.",
        "Limitations": "Limites",
        "Moving and hiding": "Se déplacer et se cacher",
        "OK": "OK",
        "On that screen, allow access to the websites you want to refresh. Allow for All Websites is the simplest setup.": "Sur cet écran, autorisez l'accès aux sites Web que vous souhaitez actualiser. Autoriser tous les sites Web est la configuration la plus simple.",
        "On the desired page, choose Auto-Start Current Page. New rules save the entire URL, including path and query string, and match that exact address.": "Sur la page souhaitée, choisissez Démarrage automatique de la page actuelle. Les nouvelles règles enregistrent l'intégralité de l'URL, y compris le chemin et la chaîne de requête, et correspondent à cette adresse exacte.",
        "On-page overlay": "Widget superposé",
        "On-screen target alerts": "Alertes visibles",
        "Open it in Safari": "Ouvrir dans Safari",
        "Opens the detailed feature guide": "Ouvre le guide détaillé des fonctionnalités",
        "Other tabs": "Autres onglets",
        "Permissions and troubleshooting": "Autorisations et dépannage",
        "Plain Text": "Texte brut",
        "Plain-text and regex matches use the yellow pulsing highlight. The extension reapplies it to the newly reloaded page so navigation does not remove it.": "Les correspondances en texte brut et regex utilisent la surbrillance jaune clignotante. L'extension le réapplique à la page nouvellement rechargée afin que la navigation ne la supprime pas.",
        "Please email krabople@gmail.com from your preferred email app.": "Envoyez un e-mail à krabople@gmail.com depuis votre application préférée.",
        "Preset or custom refresh timing": "Fréquence prédéfinie ou personnalisée",
        "Random interval range": "Plage d’intervalle aléatoire",
        "Random timing can reduce repetitive request patterns and may avoid bot detection on some websites, but it does not always bypass website rules or anti-automation systems. Avoid extremely short ranges on complex pages.": "Un timing aléatoire peut réduire les modèles de requêtes répétitives et éviter la détection de robots sur certains sites Web, mais il ne contourne pas toujours les règles des sites Web ou les systèmes anti-automatisation. Évitez les plages extrêmement courtes sur les pages complexes.",
        "Redirects and changing query parameters can produce a different final address. Edit the rule to the exact address Safari displays.": "Les redirections et la modification des paramètres de requête peuvent produire une adresse finale différente. Modifiez la règle à l'adresse exacte affichée par Safari.",
        "Refresh Limit": "Limite d'actualisation",
        "Refresh options and limits": "Options et limites d’actualisation",
        "Regular Expression": "Expression régulière",
        "Requests a reload that bypasses cached data where Safari supports it. Websites and service workers may still impose their own caching.": "Demande un rechargement qui contourne les données mises en cache là où Safari le prend en charge. Les sites Web et les prestataires de services peuvent toujours imposer leur propre mise en cache.",
        "Safari Auto Refresh and\nPage Monitor XL": "Auto Refresh XL pour Safari",
        "Safari cannot inject the banner into internal browser pages, Settings, some viewers, or pages without permission. It is not a Lock Screen push notification.": "Safari ne peut pas injecter la bannière dans les pages internes du navigateur, les paramètres, certaines visionneuses ou les pages sans autorisation. Il ne s'agit pas d'une notification push de l'écran de verrouillage.",
        "Safari must remain open on screen": "Safari doit rester ouvert à l'écran",
        "Safari smoothly centres the detected match. The extension retries briefly for pages that render after the initial document.": "Safari centre en douceur la correspondance détectée. L'extension réessaye brièvement pour les pages qui s'affichent après le document initial.",
        "Safari-safe audible target alerts": "Alertes sonores fiables dans Safari",
        "Saved entries": "Entrées enregistrées",
        "Set up the extension": "Configurer l’extension",
        "Settings → Apps → Safari → Extensions → Safari Auto Refresh and Page Monitor XL. Turn on Allow Extension and grant the required website access.": "Paramètres → Applications → Safari → Extensions → Auto Refresh XL. Activez Autoriser l'extension et accordez l'accès au site Web requis.",
        "Settings → Apps → Safari → Extensions → Safari Auto Refresh and Page Monitor XL. Turn on Allow Extension.": "Paramètres → Applications → Safari → Extensions → Auto Refresh XL. Activez Autoriser l'extension.",
        "Sound alerts": "Alertes sonores",
        "Start on saved exact pages": "Démarrer sur des pages exactes enregistrées",
        "Stop on interaction": "Arrêtez-vous sur l'interaction",
        "Stops refreshing when you interact with the monitored webpage. Use this when you want a tap, click, key press, or other page interaction to end the active refresh session.": "Arrête de s'actualiser lorsque vous interagissez avec la page Web surveillée. Utilisez-le lorsque vous souhaitez qu'un appui, un clic, une pression sur une touche ou toute autre interaction de page mette fin à la session d'actualisation active.",
        "Tap Page Menu beside the search field, then Manage Extensions. Switch on Auto Refresh XL and select it from Page Menu to open its controls.": "Appuyez sur Menu de la page à côté du champ de recherche, puis sur Gérer les extensions. Allumez Auto Refresh XL et sélectionnez-le dans le menu Page pour ouvrir ses commandes.",
        "Tap Page Menu → Manage Extensions and switch on Auto Refresh XL. Safari profiles may require separate enabling.": "Appuyez sur Menu de la page → Gérer les extensions et activez Auto Refresh XL. Les profils Safari peuvent nécessiter une activation distincte.",
        "Tap a feature for detailed instructions, limitations, and useful tips.": "Touchez une fonctionnalité pour afficher les instructions, limites et conseils.",
        "Text, regex, and XPath matching": "Correspondance texte, expression et XPath",
        "The Ring/Silent switch, device volume, Focus modes, and iOS resource suspension can affect alerts. Webpage audio remains available as a fallback when native sound cannot be started.": "Le commutateur Sonnerie/Silence, le volume de l'appareil, les modes de mise au point et la suspension des ressources iOS peuvent affecter les alertes. L’audio de la page Web reste disponible comme solution de secours lorsque le son natif ne peut pas être démarré.",
        "The banner appears on the ordinary Safari webpage currently being viewed. View Monitored Tab returns to the source tab when needed.": "La bannière apparaît sur la page Web ordinaire de Safari en cours de consultation. Afficher l'onglet surveillé revient à l'onglet source lorsque cela est nécessaire.",
        "The draggable overlay shows countdown, refresh count, fixed or random mode, monitored term, Stop Refresh, and the sound toggle when monitoring uses sound.": "La superposition déplaçable affiche le compte à rebours, le nombre d'actualisations, le mode fixe ou aléatoire, le terme surveillé, l'arrêt de l'actualisation et la bascule sonore lorsque la surveillance utilise le son.",
        "The extension obtains fresh content for monitoring, performs a genuine visible Safari reload, and schedules the next countdown. Page loading time and iOS suspension can delay very short intervals.": "L'extension obtient du nouveau contenu à surveiller, effectue un véritable rechargement Safari visible et planifie le prochain compte à rebours. Le temps de chargement des pages et la suspension de iOS peuvent retarder des intervalles très courts.",
        "The iOS extension plays the primary alert sound natively, while the visible alert is routed to the ordinary Safari webpage you are viewing.": "L'extension iOS joue le son d'alerte principal de manière native, tandis que l'alerte visible est acheminée vers la page Web Safari ordinaire que vous consultez.",
        "The rendered page is checked immediately after refresh and watched for later changes. Inaccessible frames, images, canvas text, and closed components may not be detectable.": "La page rendue est vérifiée immédiatement après l'actualisation et surveillée pour les modifications ultérieures. Les cadres, images, textes de canevas et composants fermés inaccessibles peuvent ne pas être détectables.",
        "Tips": "Conseils",
        "Use the overlay button to enable or disable alert sound. The preference remains selected when the monitored page refreshes.": "Utilisez le bouton de superposition pour activer ou désactiver le son d'alerte. La préférence reste sélectionnée lors de l'actualisation de la page surveillée.",
        "Uses a case-insensitive JavaScript regular expression. Invalid expressions cannot match, so test complex expressions carefully.": "Utilise une expression régulière JavaScript qui ne respecte pas la casse. Les expressions non valides ne peuvent pas correspondre, testez donc soigneusement les expressions complexes.",
        "Using random mode": "Utiliser le mode aléatoire",
        "Visible alerts across Safari tabs": "Alertes visibles dans les onglets Safari",
        "Visit a webpage. Tap Safari’s Page Menu button beside the search field, then choose Auto Refresh XL from the extensions list.": "Visitez une page Web. Appuyez sur le bouton Menu de la page de Safari à côté du champ de recherche, puis choisissez Auto Refresh XL dans la liste des extensions.",
        "Website access, profiles, and common fixes": "Accès aux sites, profils et solutions courantes",
        "What happens at zero": "Que se passe-t-il à zéro",
        "What it shows": "Ce que ça montre",
        "XPath": "XPath"
    ],
    "es": [
        "A new delay for every cycle": "Un nuevo retraso en cada ciclo",
        "A positive number stops after that many cycles; zero is unlimited. The overlay shows the count.": "Un número positivo se detiene después de tantos ciclos; el cero es ilimitado. La superposición muestra el recuento.",
        "Adding": "Añadiendo",
        "Advanced Options opens inside the extension. Edit changes URL and default interval; Delete permanently removes the rule. Older wildcard rules remain supported.": "Opciones avanzadas se abre dentro de la extensión. Editar cambios URL e intervalo predeterminado; Eliminar elimina permanentemente la regla. Se siguen admitiendo reglas de comodines más antiguas.",
        "Allow enough time for the site to load. Refreshing very frequently can increase battery usage and mobile data use, and may trigger captchas, rate limits, or a temporary website block.": "Espere suficiente tiempo para que se cargue el sitio. Actualizar con mucha frecuencia puede aumentar el uso de la batería y de los datos móviles, y puede activar captchas, límites de velocidad o un bloqueo temporal del sitio web.",
        "Allow the extension": "Permitir la extensión",
        "Allow website access": "Permitir acceso a sitios web",
        "Appears or disappears": "Aparece o desaparece",
        "Appears triggers when a match exists; Disappears triggers when it does not. Checks start after the first countdown.": "Aparecen activadores cuando existe una coincidencia; Desaparece el disparador cuando no lo hace. Los controles comienzan después de la primera cuenta atrás.",
        "Auto Refresh XL Settings": "Ajustes de Auto Refresh XL",
        "Auto-Start rules": "Reglas de inicio automático",
        "Auto-refresh and page monitoring can continue while you browse other tabs within Safari. They will not operate reliably after Safari is closed, moved into the background, or you switch to another app.": "La actualización automática y el monitoreo de la página pueden continuar mientras navega por otras pestañas dentro de Safari. No funcionarán de manera confiable después de cerrar Safari, moverlo a un segundo plano o cambiar a otra aplicación.",
        "Auto-scroll": "Desplazamiento automático",
        "Automatic refreshing, content monitoring, visible and audible alerts, and exact-page Auto-Start rules for Safari.": "Actualización automática, monitoreo de contenido, alertas visibles y audibles y reglas de inicio automático de página exacta para Safari.",
        "Case-insensitive text matching. Entering text into an empty field turns monitoring on; clearing it turns monitoring off. You can manually switch it off while keeping the text.": "Coincidencia de texto que no distingue entre mayúsculas y minúsculas. Al ingresar texto en un campo vacío se activa la supervisión; al borrarlo se desactiva la monitorización. Puede desactivarlo manualmente mientras conserva el texto.",
        "Choose a preset or enter hours, minutes, and seconds. Press Start Refresh to begin the first countdown. Monitoring does not check immediately; its first cycle occurs only when this countdown reaches zero.": "Elija un ajuste preestablecido o ingrese horas, minutos y segundos. Presione Iniciar actualización para comenzar la primera cuenta regresiva. El seguimiento no comprueba inmediatamente; su primer ciclo ocurre sólo cuando esta cuenta regresiva llega a cero.",
        "Compatibility": "Compatibilidad",
        "Complete Feature Guide": "Guía completa de funciones",
        "Contact Support": "Contactar con soporte",
        "Content monitoring": "Monitorización de contenido",
        "Countdown, monitored term, and controls": "Cuenta atrás, término vigilado y controles",
        "Creates an email to krabople@gmail.com": "Crea un correo electrónico a krabople@gmail.com",
        "Cross-tab alerts": "Alertas cruzadas",
        "Drag its header. Its position is retained across refreshes in the same tab. Closing the widget hides it until the next page load; use Stop Refresh to end the process.": "Arrastra su encabezado. Su posición se conserva tras las actualizaciones en la misma pestaña. Cerrar el widget lo oculta hasta que se carga la siguiente página; utilice Detener actualización para finalizar el proceso.",
        "Dynamic sites": "Sitios dinámicos",
        "Editing": "Edición",
        "Email Support": "Soporte por correo",
        "Enable in Safari": "Habilitar en Safari",
        "Enable in Settings": "Habilitar en Configuración",
        "Enabling sound": "Habilitando sonido",
        "Enter minimum and maximum seconds. Preset and custom fields are disabled because a fresh random delay is selected after every cycle.": "Introduzca segundos mínimos y máximos. Los campos preestablecidos y personalizados están deshabilitados porque se selecciona un nuevo retraso aleatorio después de cada ciclo.",
        "Find a detected result after reload": "Encuentra el resultado después de recargar",
        "Finds an element using its page structure. XPath rules may break when a site redesigns its markup.": "Encuentra un elemento utilizando su estructura de página. Las reglas de XPath pueden infringirse cuando un sitio rediseña su marcado.",
        "Form values are saved per tab. Closing the extension with Safari’s blue checkmark should not discard an unfinished setup.": "Los valores del formulario se guardan por pestaña. Cerrar la extensión con la marca de verificación azul de Safari no debería descartar una configuración sin terminar.",
        "Hard Refresh": "Actualización completa",
        "Hard refresh, limits, and interaction safety": "Recarga completa, límites y seguridad",
        "Hidden or replaced server text, inaccessible frames, closed shadow content, images, canvas, and late components may not be highlightable.": "Es posible que el texto del servidor oculto o reemplazado, los marcos inaccesibles, el contenido de sombras cerradas, las imágenes, el lienzo y los componentes tardíos no se puedan resaltar.",
        "Highlight and auto-scroll": "Resaltado y desplazamiento automático",
        "Highlighting": "Destacando",
        "How it works": "como funciona",
        "If it is missing": "Si no aparece",
        "Intervals and countdowns": "Intervalos y cuentas atrás",
        "It cannot appear on Safari internal pages, Settings, some document viewers, or websites without extension access.": "No puede aparecer en las páginas internas de Safari, en la Configuración, en algunos visores de documentos o en sitios web sin acceso a extensiones.",
        "Limitations": "Limitaciones",
        "Moving and hiding": "Moverse y esconderse",
        "OK": "Aceptar",
        "On that screen, allow access to the websites you want to refresh. Allow for All Websites is the simplest setup.": "En esa pantalla, permita el acceso a los sitios web que desea actualizar. Permitir todos los sitios web es la configuración más sencilla.",
        "On the desired page, choose Auto-Start Current Page. New rules save the entire URL, including path and query string, and match that exact address.": "En la página deseada, elija Iniciar automáticamente la página actual. Las nuevas reglas guardan la URL completa, incluida la ruta y la cadena de consulta, y coinciden con esa dirección exacta.",
        "On-page overlay": "Widget superpuesto",
        "On-screen target alerts": "Alertas visibles",
        "Open it in Safari": "Abrir en Safari",
        "Opens the detailed feature guide": "Abre la guía detallada de funciones.",
        "Other tabs": "Otras pestañas",
        "Permissions and troubleshooting": "Permisos y solución de problemas",
        "Plain Text": "Texto sin formato",
        "Plain-text and regex matches use the yellow pulsing highlight. The extension reapplies it to the newly reloaded page so navigation does not remove it.": "Las coincidencias de texto sin formato y regex utilizan el resaltado intermitente en amarillo. La extensión lo vuelve a aplicar a la página recién recargada para que la navegación no la elimine.",
        "Please email krabople@gmail.com from your preferred email app.": "Envía un correo a krabople@gmail.com desde tu aplicación preferida.",
        "Preset or custom refresh timing": "Frecuencia predefinida o personalizada",
        "Random interval range": "Intervalo aleatorio",
        "Random timing can reduce repetitive request patterns and may avoid bot detection on some websites, but it does not always bypass website rules or anti-automation systems. Avoid extremely short ranges on complex pages.": "La sincronización aleatoria puede reducir los patrones de solicitudes repetitivas y puede evitar la detección de bots en algunos sitios web, pero no siempre elude las reglas del sitio web o los sistemas antiautomatización. Evite rangos extremadamente cortos en páginas complejas.",
        "Redirects and changing query parameters can produce a different final address. Edit the rule to the exact address Safari displays.": "Las redirecciones y el cambio de parámetros de consulta pueden producir una dirección final diferente. Edite la regla a la dirección exacta que muestra Safari.",
        "Refresh Limit": "Límite de actualización",
        "Refresh options and limits": "Opciones y límites de recarga",
        "Regular Expression": "Expresión regular",
        "Requests a reload that bypasses cached data where Safari supports it. Websites and service workers may still impose their own caching.": "Solicita una recarga que omite los datos almacenados en caché donde Safari los admite. Los sitios web y los trabajadores de servicios aún pueden imponer su propio almacenamiento en caché.",
        "Safari Auto Refresh and\nPage Monitor XL": "Auto Refresh XL para Safari",
        "Safari cannot inject the banner into internal browser pages, Settings, some viewers, or pages without permission. It is not a Lock Screen push notification.": "Safari no puede insertar el banner en las páginas internas del navegador, en la Configuración, en algunos visores o en páginas sin permiso. No es una notificación push en la pantalla de bloqueo.",
        "Safari must remain open on screen": "Safari debe permanecer abierto en pantalla",
        "Safari smoothly centres the detected match. The extension retries briefly for pages that render after the initial document.": "Safari centra suavemente la coincidencia detectada. La extensión vuelve a intentar brevemente las páginas que se muestran después del documento inicial.",
        "Safari-safe audible target alerts": "Alertas sonoras fiables en Safari",
        "Saved entries": "Entradas guardadas",
        "Set up the extension": "Configurar la extensión",
        "Settings → Apps → Safari → Extensions → Safari Auto Refresh and Page Monitor XL. Turn on Allow Extension and grant the required website access.": "Configuración → Aplicaciones → Safari → Extensiones → Auto Refresh XL. Active Permitir extensión y otorgue el acceso al sitio web requerido.",
        "Settings → Apps → Safari → Extensions → Safari Auto Refresh and Page Monitor XL. Turn on Allow Extension.": "Configuración → Aplicaciones → Safari → Extensiones → Auto Refresh XL. Active Permitir extensión.",
        "Sound alerts": "Alertas sonoras",
        "Start on saved exact pages": "Iniciar en páginas exactas guardadas",
        "Stop on interaction": "Detener la interacción",
        "Stops refreshing when you interact with the monitored webpage. Use this when you want a tap, click, key press, or other page interaction to end the active refresh session.": "Deja de actualizarse cuando interactúa con la página web monitoreada. Úselo cuando desee tocar, hacer clic, presionar una tecla u otra interacción con la página para finalizar la sesión de actualización activa.",
        "Tap Page Menu beside the search field, then Manage Extensions. Switch on Auto Refresh XL and select it from Page Menu to open its controls.": "Toque Menú de página junto al campo de búsqueda y luego Administrar extensiones. Encienda Auto Refresh XL y selecciónelo en el menú de página para abrir sus controles.",
        "Tap Page Menu → Manage Extensions and switch on Auto Refresh XL. Safari profiles may require separate enabling.": "Toque Menú de página → Administrar extensiones y active Auto Refresh XL. Los perfiles Safari pueden requerir una habilitación por separado.",
        "Tap a feature for detailed instructions, limitations, and useful tips.": "Toca una función para ver instrucciones, limitaciones y consejos.",
        "Text, regex, and XPath matching": "Coincidencia de texto, regex y XPath",
        "The Ring/Silent switch, device volume, Focus modes, and iOS resource suspension can affect alerts. Webpage audio remains available as a fallback when native sound cannot be started.": "El interruptor de timbre/silencio, el volumen del dispositivo, los modos de enfoque y la suspensión de recursos iOS pueden afectar las alertas. El audio de la página web permanece disponible como alternativa cuando no se puede iniciar el sonido nativo.",
        "The banner appears on the ordinary Safari webpage currently being viewed. View Monitored Tab returns to the source tab when needed.": "El banner aparece en la página web normal de Safari que se está viendo actualmente. Ver pestaña supervisada vuelve a la pestaña de origen cuando es necesario.",
        "The draggable overlay shows countdown, refresh count, fixed or random mode, monitored term, Stop Refresh, and the sound toggle when monitoring uses sound.": "La superposición que se puede arrastrar muestra la cuenta regresiva, el recuento de actualización, el modo fijo o aleatorio, el término monitoreado, Detener actualización y el cambio de sonido cuando el monitoreo usa sonido.",
        "The extension obtains fresh content for monitoring, performs a genuine visible Safari reload, and schedules the next countdown. Page loading time and iOS suspension can delay very short intervals.": "La extensión obtiene contenido nuevo para monitorear, realiza una recarga genuina y visible de Safari y programa la siguiente cuenta regresiva. El tiempo de carga de la página y la suspensión de iOS pueden retrasar intervalos muy cortos.",
        "The iOS extension plays the primary alert sound natively, while the visible alert is routed to the ordinary Safari webpage you are viewing.": "La extensión iOS reproduce el sonido de alerta principal de forma nativa, mientras que la alerta visible se dirige a la página web normal de Safari que está viendo.",
        "The rendered page is checked immediately after refresh and watched for later changes. Inaccessible frames, images, canvas text, and closed components may not be detectable.": "La página renderizada se verifica inmediatamente después de la actualización y se observa para detectar cambios posteriores. Es posible que no se puedan detectar marcos, imágenes, texto del lienzo y componentes cerrados inaccesibles.",
        "Tips": "Consejos",
        "Use the overlay button to enable or disable alert sound. The preference remains selected when the monitored page refreshes.": "Utilice el botón superpuesto para habilitar o deshabilitar el sonido de alerta. La preferencia permanece seleccionada cuando se actualiza la página monitoreada.",
        "Uses a case-insensitive JavaScript regular expression. Invalid expressions cannot match, so test complex expressions carefully.": "Utiliza una expresión regular JavaScript que no distingue entre mayúsculas y minúsculas. Las expresiones no válidas no pueden coincidir, así que pruebe las expresiones complejas con cuidado.",
        "Using random mode": "Usando el modo aleatorio",
        "Visible alerts across Safari tabs": "Alertas visibles entre pestañas de Safari",
        "Visit a webpage. Tap Safari’s Page Menu button beside the search field, then choose Auto Refresh XL from the extensions list.": "Visita una página web. Toca el botón Menú de página de Safari junto al campo de búsqueda y elige Auto Refresh XL en la lista de extensiones.",
        "Website access, profiles, and common fixes": "Acceso web, perfiles y soluciones habituales",
        "What happens at zero": "¿Qué pasa en cero?",
        "What it shows": "lo que muestra",
        "XPath": "XPath"
    ],
    "it": [
        "A new delay for every cycle": "Un nuovo ritardo per ogni ciclo",
        "A positive number stops after that many cycles; zero is unlimited. The overlay shows the count.": "Un numero positivo si ferma dopo tanti cicli; zero è illimitato. La sovrapposizione mostra il conteggio.",
        "Adding": "Aggiunta",
        "Advanced Options opens inside the extension. Edit changes URL and default interval; Delete permanently removes the rule. Older wildcard rules remain supported.": "Le Opzioni avanzate si aprono all'interno dell'estensione. Modifica modifiche URL e intervallo predefinito; Elimina rimuove definitivamente la regola. Le regole dei caratteri jolly precedenti rimangono supportate.",
        "Allow enough time for the site to load. Refreshing very frequently can increase battery usage and mobile data use, and may trigger captchas, rate limits, or a temporary website block.": "Concedere tempo sufficiente per il caricamento del sito. L'aggiornamento molto frequente può aumentare l'utilizzo della batteria e dei dati mobili e può attivare captcha, limiti di velocità o un blocco temporaneo del sito Web.",
        "Allow the extension": "Consenti l’estensione",
        "Allow website access": "Consenti l’accesso ai siti web",
        "Appears or disappears": "Appare o scompare",
        "Appears triggers when a match exists; Disappears triggers when it does not. Checks start after the first countdown.": "Appare trigger quando esiste una corrispondenza; I trigger scompaiono quando non lo fa. I controlli iniziano dopo il primo conto alla rovescia.",
        "Auto Refresh XL Settings": "Impostazioni Auto Refresh XL",
        "Auto-Start rules": "Regole di avvio automatico",
        "Auto-refresh and page monitoring can continue while you browse other tabs within Safari. They will not operate reliably after Safari is closed, moved into the background, or you switch to another app.": "L'aggiornamento automatico e il monitoraggio della pagina possono continuare mentre esplori altre schede all'interno di Safari. Non funzioneranno in modo affidabile dopo la chiusura di Safari, lo spostamento in background o il passaggio a un'altra app.",
        "Auto-scroll": "Scorrimento automatico",
        "Automatic refreshing, content monitoring, visible and audible alerts, and exact-page Auto-Start rules for Safari.": "Aggiornamento automatico, monitoraggio dei contenuti, avvisi visivi e acustici e regole di avvio automatico della pagina esatta per Safari.",
        "Case-insensitive text matching. Entering text into an empty field turns monitoring on; clearing it turns monitoring off. You can manually switch it off while keeping the text.": "Corrispondenza del testo senza distinzione tra maiuscole e minuscole. L'immissione di testo in un campo vuoto attiva il monitoraggio; cancellandolo si disattiva il monitoraggio. Puoi disattivarlo manualmente mantenendo il testo.",
        "Choose a preset or enter hours, minutes, and seconds. Press Start Refresh to begin the first countdown. Monitoring does not check immediately; its first cycle occurs only when this countdown reaches zero.": "Scegli una preimpostazione o inserisci ore, minuti e secondi. Premere Avvia aggiornamento per iniziare il primo conto alla rovescia. Il monitoraggio non effettua controlli immediati; il suo primo ciclo avviene solo quando questo conto alla rovescia raggiunge lo zero.",
        "Compatibility": "Compatibilità",
        "Complete Feature Guide": "Guida completa alle funzioni",
        "Contact Support": "Contatta l’assistenza",
        "Content monitoring": "Monitoraggio dei contenuti",
        "Countdown, monitored term, and controls": "Conto alla rovescia, termine monitorato e controlli",
        "Creates an email to krabople@gmail.com": "Crea un'e-mail a krabople@gmail.com",
        "Cross-tab alerts": "Avvisi a campi incrociati",
        "Drag its header. Its position is retained across refreshes in the same tab. Closing the widget hides it until the next page load; use Stop Refresh to end the process.": "Trascina la sua intestazione. La sua posizione viene mantenuta durante gli aggiornamenti nella stessa scheda. Chiudendo il widget lo si nasconde fino al caricamento della pagina successiva; utilizzare Interrompi aggiornamento per terminare il processo.",
        "Dynamic sites": "Siti dinamici",
        "Editing": "Modifica",
        "Email Support": "Assistenza e-mail",
        "Enable in Safari": "Abilita in Safari",
        "Enable in Settings": "Abilita nelle Impostazioni",
        "Enabling sound": "Abilitazione del suono",
        "Enter minimum and maximum seconds. Preset and custom fields are disabled because a fresh random delay is selected after every cycle.": "Immettere i secondi minimi e massimi. I campi preimpostati e personalizzati sono disabilitati perché dopo ogni ciclo viene selezionato un nuovo ritardo casuale.",
        "Find a detected result after reload": "Trova un risultato rilevato dopo il ricaricamento",
        "Finds an element using its page structure. XPath rules may break when a site redesigns its markup.": "Trova un elemento utilizzando la sua struttura di pagina. Le regole XPath potrebbero non essere valide quando un sito ridisegna il proprio markup.",
        "Form values are saved per tab. Closing the extension with Safari’s blue checkmark should not discard an unfinished setup.": "I valori del modulo vengono salvati per scheda. La chiusura dell'estensione con il segno di spunta blu di Safari non dovrebbe eliminare una configurazione incompleta.",
        "Hard Refresh": "Aggiornamento difficile",
        "Hard refresh, limits, and interaction safety": "Aggiornamento difficile, limiti e sicurezza dell'interazione",
        "Hidden or replaced server text, inaccessible frames, closed shadow content, images, canvas, and late components may not be highlightable.": "Il testo del server nascosto o sostituito, i frame inaccessibili, i contenuti shadow chiusi, le immagini, le tele e i componenti tardivi potrebbero non essere evidenziabili.",
        "Highlight and auto-scroll": "Evidenziazione e scorrimento automatico",
        "Highlighting": "Evidenziando",
        "How it works": "Come funziona",
        "If it is missing": "Se non è visibile",
        "Intervals and countdowns": "Intervalli e conto alla rovescia",
        "It cannot appear on Safari internal pages, Settings, some document viewers, or websites without extension access.": "Non può essere visualizzato nelle pagine interne di Safari, nelle Impostazioni, in alcuni visualizzatori di documenti o nei siti Web senza accesso all'estensione.",
        "Limitations": "Limitazioni",
        "Moving and hiding": "Muoversi e nascondersi",
        "OK": "OK",
        "On that screen, allow access to the websites you want to refresh. Allow for All Websites is the simplest setup.": "In quella schermata, consenti l'accesso ai siti Web che desideri aggiornare. Consenti tutti i siti Web è la configurazione più semplice.",
        "On the desired page, choose Auto-Start Current Page. New rules save the entire URL, including path and query string, and match that exact address.": "Nella pagina desiderata, seleziona Avvia automaticamente la pagina corrente. Le nuove regole salvano l'intero URL, incluso il percorso e la stringa di query, e corrispondono a quell'indirizzo esatto.",
        "On-page overlay": "Widget sulla pagina",
        "On-screen target alerts": "Avvisi sullo schermo",
        "Open it in Safari": "Apri in Safari",
        "Opens the detailed feature guide": "Apre la guida dettagliata alle funzionalità",
        "Other tabs": "Altre schede",
        "Permissions and troubleshooting": "Autorizzazioni e risoluzione dei problemi",
        "Plain Text": "Testo semplice",
        "Plain-text and regex matches use the yellow pulsing highlight. The extension reapplies it to the newly reloaded page so navigation does not remove it.": "Le corrispondenze di testo normale e regex utilizzano l'evidenziazione gialla pulsante. L'estensione lo riapplica alla pagina appena ricaricata in modo che la navigazione non lo rimuova.",
        "Please email krabople@gmail.com from your preferred email app.": "Invia un’e-mail a krabople@gmail.com dalla tua app preferita.",
        "Preset or custom refresh timing": "Tempi predefiniti o personalizzati",
        "Random interval range": "Intervallo casuale",
        "Random timing can reduce repetitive request patterns and may avoid bot detection on some websites, but it does not always bypass website rules or anti-automation systems. Avoid extremely short ranges on complex pages.": "La tempistica casuale può ridurre i modelli di richiesta ripetitivi e può evitare il rilevamento dei bot su alcuni siti Web, ma non sempre aggira le regole del sito Web o i sistemi anti-automazione. Evitare intervalli estremamente brevi su pagine complesse.",
        "Redirects and changing query parameters can produce a different final address. Edit the rule to the exact address Safari displays.": "I reindirizzamenti e la modifica dei parametri di query possono produrre un indirizzo finale diverso. Modifica la regola con l'indirizzo esatto visualizzato da Safari.",
        "Refresh Limit": "Aggiorna limite",
        "Refresh options and limits": "Opzioni e limiti di aggiornamento",
        "Regular Expression": "Espressione regolare",
        "Requests a reload that bypasses cached data where Safari supports it. Websites and service workers may still impose their own caching.": "Richiede un ricaricamento che ignori i dati memorizzati nella cache laddove Safari lo supporta. I siti Web e gli addetti ai servizi possono comunque imporre la propria memorizzazione nella cache.",
        "Safari Auto Refresh and\nPage Monitor XL": "Auto Refresh XL per Safari",
        "Safari cannot inject the banner into internal browser pages, Settings, some viewers, or pages without permission. It is not a Lock Screen push notification.": "Safari non può inserire il banner nelle pagine interne del browser, nelle Impostazioni, in alcuni visualizzatori o nelle pagine senza autorizzazione. Non è una notifica push sulla schermata di blocco.",
        "Safari must remain open on screen": "Safari deve rimanere aperto sullo schermo",
        "Safari smoothly centres the detected match. The extension retries briefly for pages that render after the initial document.": "Safari centra uniformemente la corrispondenza rilevata. L'estensione riprova brevemente per le pagine visualizzate dopo il documento iniziale.",
        "Safari-safe audible target alerts": "Avvisi acustici di destinazione Safari sicuri",
        "Saved entries": "Voci salvate",
        "Set up the extension": "Configura l’estensione",
        "Settings → Apps → Safari → Extensions → Safari Auto Refresh and Page Monitor XL. Turn on Allow Extension and grant the required website access.": "Impostazioni → App → Safari → Estensioni → Auto Refresh XL. Attiva Consenti estensione e concedi l'accesso al sito Web richiesto.",
        "Settings → Apps → Safari → Extensions → Safari Auto Refresh and Page Monitor XL. Turn on Allow Extension.": "Impostazioni → App → Safari → Estensioni → Auto Refresh XL. Attiva Consenti estensione.",
        "Sound alerts": "Avvisi sonori",
        "Start on saved exact pages": "Inizia dalle pagine esatte salvate",
        "Stop on interaction": "Fermati all'interazione",
        "Stops refreshing when you interact with the monitored webpage. Use this when you want a tap, click, key press, or other page interaction to end the active refresh session.": "Interrompe l'aggiornamento quando interagisci con la pagina Web monitorata. Utilizzalo quando desideri che un tocco, un clic, la pressione di un tasto o un'altra interazione con la pagina terminino la sessione di aggiornamento attiva.",
        "Tap Page Menu beside the search field, then Manage Extensions. Switch on Auto Refresh XL and select it from Page Menu to open its controls.": "Tocca Menu Pagina accanto al campo di ricerca, quindi Gestisci estensioni. Accendi Auto Refresh XL e selezionalo dal menu Pagina per aprirne i controlli.",
        "Tap Page Menu → Manage Extensions and switch on Auto Refresh XL. Safari profiles may require separate enabling.": "Tocca Menu Pagina → Gestisci estensioni e attiva Auto Refresh XL. I profili Safari potrebbero richiedere un'abilitazione separata.",
        "Tap a feature for detailed instructions, limitations, and useful tips.": "Tocca una funzione per istruzioni, limitazioni e suggerimenti.",
        "Text, regex, and XPath matching": "Corrispondenza di testo, regex e XPath",
        "The Ring/Silent switch, device volume, Focus modes, and iOS resource suspension can affect alerts. Webpage audio remains available as a fallback when native sound cannot be started.": "L'interruttore Suoneria/Silenzioso, il volume del dispositivo, le modalità Focus e la sospensione delle risorse iOS possono influire sugli avvisi. L'audio della pagina Web rimane disponibile come fallback quando non è possibile avviare l'audio nativo.",
        "The banner appears on the ordinary Safari webpage currently being viewed. View Monitored Tab returns to the source tab when needed.": "Il banner appare sulla normale pagina web Safari attualmente visualizzata. Visualizza scheda monitorata ritorna alla scheda di origine quando necessario.",
        "The draggable overlay shows countdown, refresh count, fixed or random mode, monitored term, Stop Refresh, and the sound toggle when monitoring uses sound.": "La sovrapposizione trascinabile mostra il conto alla rovescia, il conteggio degli aggiornamenti, la modalità fissa o casuale, il termine monitorato, Interrompi aggiornamento e l'attivazione/disattivazione dell'audio quando il monitoraggio utilizza l'audio.",
        "The extension obtains fresh content for monitoring, performs a genuine visible Safari reload, and schedules the next countdown. Page loading time and iOS suspension can delay very short intervals.": "L'estensione ottiene nuovi contenuti per il monitoraggio, esegue un vero e proprio ricaricamento visibile Safari e pianifica il conto alla rovescia successivo. Il tempo di caricamento della pagina e la sospensione iOS possono ritardare intervalli molto brevi.",
        "The iOS extension plays the primary alert sound natively, while the visible alert is routed to the ordinary Safari webpage you are viewing.": "L'estensione iOS riproduce il suono di avviso principale in modo nativo, mentre l'avviso visibile viene instradato alla normale pagina Web Safari che stai visualizzando.",
        "The rendered page is checked immediately after refresh and watched for later changes. Inaccessible frames, images, canvas text, and closed components may not be detectable.": "La pagina renderizzata viene controllata immediatamente dopo l'aggiornamento e monitorata per eventuali modifiche successive. Cornici, immagini, testo su tela e componenti chiusi inaccessibili potrebbero non essere rilevabili.",
        "Tips": "Suggerimenti",
        "Use the overlay button to enable or disable alert sound. The preference remains selected when the monitored page refreshes.": "Utilizzare il pulsante in sovrapposizione per abilitare o disabilitare il suono di avviso. La preferenza rimane selezionata quando la pagina monitorata viene aggiornata.",
        "Uses a case-insensitive JavaScript regular expression. Invalid expressions cannot match, so test complex expressions carefully.": "Utilizza un'espressione regolare JavaScript senza distinzione tra maiuscole e minuscole. Le espressioni non valide non possono corrispondere, quindi testa attentamente le espressioni complesse.",
        "Using random mode": "Utilizzando la modalità casuale",
        "Visible alerts across Safari tabs": "Avvisi visibili nelle schede Safari",
        "Visit a webpage. Tap Safari’s Page Menu button beside the search field, then choose Auto Refresh XL from the extensions list.": "Visita una pagina web. Tocca il pulsante Menu Pagina di Safari accanto al campo di ricerca, quindi scegli Auto Refresh XL dall'elenco delle estensioni.",
        "Website access, profiles, and common fixes": "Accesso al sito Web, profili e soluzioni comuni",
        "What happens at zero": "Cosa succede a zero",
        "What it shows": "Cosa mostra",
        "XPath": "XPath"
    ],
    "pt": [
        "A new delay for every cycle": "Um novo atraso para cada ciclo",
        "A positive number stops after that many cycles; zero is unlimited. The overlay shows the count.": "Um número positivo para após tantos ciclos; zero é ilimitado. A sobreposição mostra a contagem.",
        "Adding": "Adicionando",
        "Advanced Options opens inside the extension. Edit changes URL and default interval; Delete permanently removes the rule. Older wildcard rules remain supported.": "Opções avançadas são abertas dentro da extensão. Editar alterações de URL e intervalo padrão; Excluir remove permanentemente a regra. As regras curinga mais antigas permanecem suportadas.",
        "Allow enough time for the site to load. Refreshing very frequently can increase battery usage and mobile data use, and may trigger captchas, rate limits, or a temporary website block.": "Aguarde tempo suficiente para o site carregar. Atualizar com muita frequência pode aumentar o uso da bateria e dos dados móveis, além de acionar captchas, limites de taxa ou bloqueio temporário do site.",
        "Allow the extension": "Permitir a extensão",
        "Allow website access": "Permitir acesso a sites",
        "Appears or disappears": "Aparece ou desaparece",
        "Appears triggers when a match exists; Disappears triggers when it does not. Checks start after the first countdown.": "Aparece gatilhos quando existe uma correspondência; Desaparece os gatilhos quando isso não acontece. As verificações começam após a primeira contagem regressiva.",
        "Auto Refresh XL Settings": "Definições do Auto Refresh XL",
        "Auto-Start rules": "Regras de início automático",
        "Auto-refresh and page monitoring can continue while you browse other tabs within Safari. They will not operate reliably after Safari is closed, moved into the background, or you switch to another app.": "A atualização automática e o monitoramento de página podem continuar enquanto você navega em outras guias do Safari. Eles não funcionarão de maneira confiável depois que o Safari for fechado, movido para segundo plano ou você mudar para outro aplicativo.",
        "Auto-scroll": "Rolagem automática",
        "Automatic refreshing, content monitoring, visible and audible alerts, and exact-page Auto-Start rules for Safari.": "Atualização automática, monitoramento de conteúdo, alertas visíveis e sonoros e regras de início automático de página exata para Safari.",
        "Case-insensitive text matching. Entering text into an empty field turns monitoring on; clearing it turns monitoring off. You can manually switch it off while keeping the text.": "Correspondência de texto sem distinção entre maiúsculas e minúsculas. Inserir texto em um campo vazio ativa o monitoramento; limpá-lo desativa o monitoramento. Você pode desligá-lo manualmente enquanto mantém o texto.",
        "Choose a preset or enter hours, minutes, and seconds. Press Start Refresh to begin the first countdown. Monitoring does not check immediately; its first cycle occurs only when this countdown reaches zero.": "Escolha uma predefinição ou insira horas, minutos e segundos. Pressione Iniciar atualização para iniciar a primeira contagem regressiva. O monitoramento não verifica imediatamente; seu primeiro ciclo ocorre somente quando essa contagem regressiva chega a zero.",
        "Compatibility": "Compatibilidade",
        "Complete Feature Guide": "Guia completo de funcionalidades",
        "Contact Support": "Contactar o suporte",
        "Content monitoring": "Monitorização de conteúdo",
        "Countdown, monitored term, and controls": "Contagem regressiva, prazo monitorado e controles",
        "Creates an email to krabople@gmail.com": "Cria um e-mail para krabople@gmail.com",
        "Cross-tab alerts": "Alertas de tabela cruzada",
        "Drag its header. Its position is retained across refreshes in the same tab. Closing the widget hides it until the next page load; use Stop Refresh to end the process.": "Arraste seu cabeçalho. Sua posição é mantida durante as atualizações na mesma guia. Fechar o widget o oculta até o próximo carregamento da página; use Stop Refresh para encerrar o processo.",
        "Dynamic sites": "Sites dinâmicos",
        "Editing": "Edição",
        "Email Support": "Suporte por e-mail",
        "Enable in Safari": "Habilitar em Safari",
        "Enable in Settings": "Ativar nas configurações",
        "Enabling sound": "Habilitando som",
        "Enter minimum and maximum seconds. Preset and custom fields are disabled because a fresh random delay is selected after every cycle.": "Insira segundos mínimo e máximo. Os campos predefinidos e personalizados são desativados porque um novo atraso aleatório é selecionado após cada ciclo.",
        "Find a detected result after reload": "Encontre um resultado detectado após recarregar",
        "Finds an element using its page structure. XPath rules may break when a site redesigns its markup.": "Encontra um elemento usando sua estrutura de página. As regras XPath podem ser quebradas quando um site redesenha sua marcação.",
        "Form values are saved per tab. Closing the extension with Safari’s blue checkmark should not discard an unfinished setup.": "Os valores do formulário são salvos por guia. Fechar a extensão com a marca de seleção azul de Safari não deve descartar uma configuração inacabada.",
        "Hard Refresh": "Atualização difícil",
        "Hard refresh, limits, and interaction safety": "Atualização completa, limites e segurança de interação",
        "Hidden or replaced server text, inaccessible frames, closed shadow content, images, canvas, and late components may not be highlightable.": "Texto de servidor oculto ou substituído, quadros inacessíveis, conteúdo de sombra fechada, imagens, telas e componentes atrasados podem não ser destacáveis.",
        "Highlight and auto-scroll": "Realce e deslocação automática",
        "Highlighting": "Destaque",
        "How it works": "Como funciona",
        "If it is missing": "Se não aparecer",
        "Intervals and countdowns": "Intervalos e contagens decrescentes",
        "It cannot appear on Safari internal pages, Settings, some document viewers, or websites without extension access.": "Ele não pode aparecer nas páginas internas do Safari, configurações, alguns visualizadores de documentos ou sites sem acesso à extensão.",
        "Limitations": "Limitações",
        "Moving and hiding": "Movendo-se e escondendo-se",
        "OK": "OK",
        "On that screen, allow access to the websites you want to refresh. Allow for All Websites is the simplest setup.": "Nessa tela, permita o acesso aos sites que deseja atualizar. Permitir todos os sites é a configuração mais simples.",
        "On the desired page, choose Auto-Start Current Page. New rules save the entire URL, including path and query string, and match that exact address.": "Na página desejada, escolha Iniciar automaticamente a página atual. As novas regras salvam o URL inteiro, incluindo o caminho e a string de consulta, e correspondem ao endereço exato.",
        "On-page overlay": "Widget sobre a página",
        "On-screen target alerts": "Alertas no ecrã",
        "Open it in Safari": "Abrir no Safari",
        "Opens the detailed feature guide": "Abre o guia detalhado de recursos",
        "Other tabs": "Outras guias",
        "Permissions and troubleshooting": "Permissões e resolução de problemas",
        "Plain Text": "Texto Simples",
        "Plain-text and regex matches use the yellow pulsing highlight. The extension reapplies it to the newly reloaded page so navigation does not remove it.": "As correspondências de texto simples e regex usam o destaque amarelo pulsante. A extensão reaplica-o à página recém-recarregada para que a navegação não a remova.",
        "Please email krabople@gmail.com from your preferred email app.": "Envie um e-mail para krabople@gmail.com através da sua aplicação preferida.",
        "Preset or custom refresh timing": "Tempo de atualização predefinido ou personalizado",
        "Random interval range": "Intervalo aleatório",
        "Random timing can reduce repetitive request patterns and may avoid bot detection on some websites, but it does not always bypass website rules or anti-automation systems. Avoid extremely short ranges on complex pages.": "O tempo aleatório pode reduzir padrões de solicitação repetitivos e evitar a detecção de bots em alguns sites, mas nem sempre ignora as regras do site ou os sistemas antiautomação. Evite intervalos extremamente curtos em páginas complexas.",
        "Redirects and changing query parameters can produce a different final address. Edit the rule to the exact address Safari displays.": "Redirecionamentos e alterações de parâmetros de consulta podem produzir um endereço final diferente. Edite a regra para o endereço exato que Safari exibe.",
        "Refresh Limit": "Limite de atualização",
        "Refresh options and limits": "Opções e limites de atualização",
        "Regular Expression": "Expressão regular",
        "Requests a reload that bypasses cached data where Safari supports it. Websites and service workers may still impose their own caching.": "Solicita uma recarga que ignora os dados armazenados em cache onde Safari os suporta. Sites e prestadores de serviços ainda podem impor seu próprio cache.",
        "Safari Auto Refresh and\nPage Monitor XL": "Auto Refresh XL para Safari",
        "Safari cannot inject the banner into internal browser pages, Settings, some viewers, or pages without permission. It is not a Lock Screen push notification.": "Safari não pode injetar o banner em páginas internas do navegador, configurações, alguns visualizadores ou páginas sem permissão. Não é uma notificação push da tela de bloqueio.",
        "Safari must remain open on screen": "Safari deve permanecer aberto na tela",
        "Safari smoothly centres the detected match. The extension retries briefly for pages that render after the initial document.": "Safari centraliza suavemente a correspondência detectada. A extensão faz novas tentativas brevemente para páginas renderizadas após o documento inicial.",
        "Safari-safe audible target alerts": "Alertas de alvo sonoros seguros para Safari",
        "Saved entries": "Entradas salvas",
        "Set up the extension": "Configurar a extensão",
        "Settings → Apps → Safari → Extensions → Safari Auto Refresh and Page Monitor XL. Turn on Allow Extension and grant the required website access.": "Configurações → Aplicativos → Safari → Extensões → Auto Refresh XL. Ative Permitir extensão e conceda o acesso necessário ao site.",
        "Settings → Apps → Safari → Extensions → Safari Auto Refresh and Page Monitor XL. Turn on Allow Extension.": "Configurações → Aplicativos → Safari → Extensões → Auto Refresh XL. Ative Permitir extensão.",
        "Sound alerts": "Alertas sonoros",
        "Start on saved exact pages": "Comece nas páginas exatas salvas",
        "Stop on interaction": "Pare na interação",
        "Stops refreshing when you interact with the monitored webpage. Use this when you want a tap, click, key press, or other page interaction to end the active refresh session.": "Para de atualizar quando você interage com a página da Web monitorada. Use isto quando desejar que um toque, clique, pressionamento de tecla ou outra interação de página encerre a sessão de atualização ativa.",
        "Tap Page Menu beside the search field, then Manage Extensions. Switch on Auto Refresh XL and select it from Page Menu to open its controls.": "Toque no Menu da página ao lado do campo de pesquisa e depois em Gerenciar extensões. Ligue Auto Refresh XL e selecione-o no Menu da Página para abrir seus controles.",
        "Tap Page Menu → Manage Extensions and switch on Auto Refresh XL. Safari profiles may require separate enabling.": "Toque em Menu da página → Gerenciar extensões e ative Auto Refresh XL. Os perfis Safari podem exigir ativação separada.",
        "Tap a feature for detailed instructions, limitations, and useful tips.": "Toque numa funcionalidade para ver instruções, limitações e sugestões.",
        "Text, regex, and XPath matching": "Correspondência de texto, regex e XPath",
        "The Ring/Silent switch, device volume, Focus modes, and iOS resource suspension can affect alerts. Webpage audio remains available as a fallback when native sound cannot be started.": "A opção Toque/Silencioso, o volume do dispositivo, os modos de foco e a suspensão de recursos iOS podem afetar os alertas. O áudio da página da Web permanece disponível como alternativa quando o som nativo não pode ser iniciado.",
        "The banner appears on the ordinary Safari webpage currently being viewed. View Monitored Tab returns to the source tab when needed.": "O banner aparece na página Safari comum que está sendo visualizada no momento. Exibir guia monitorada retorna à guia de origem quando necessário.",
        "The draggable overlay shows countdown, refresh count, fixed or random mode, monitored term, Stop Refresh, and the sound toggle when monitoring uses sound.": "A sobreposição arrastável mostra contagem regressiva, contagem de atualização, modo fixo ou aleatório, termo monitorado, Parar atualização e alternância de som quando o monitoramento usa som.",
        "The extension obtains fresh content for monitoring, performs a genuine visible Safari reload, and schedules the next countdown. Page loading time and iOS suspension can delay very short intervals.": "A extensão obtém conteúdo novo para monitoramento, executa uma recarga Safari genuína e visível e agenda a próxima contagem regressiva. O tempo de carregamento da página e a suspensão do iOS podem atrasar intervalos muito curtos.",
        "The iOS extension plays the primary alert sound natively, while the visible alert is routed to the ordinary Safari webpage you are viewing.": "A extensão iOS reproduz o som de alerta principal nativamente, enquanto o alerta visível é roteado para a página da Web Safari comum que você está visualizando.",
        "The rendered page is checked immediately after refresh and watched for later changes. Inaccessible frames, images, canvas text, and closed components may not be detectable.": "A página renderizada é verificada imediatamente após a atualização e monitorada para alterações posteriores. Quadros, imagens, texto de tela e componentes fechados inacessíveis podem não ser detectáveis.",
        "Tips": "Dicas",
        "Use the overlay button to enable or disable alert sound. The preference remains selected when the monitored page refreshes.": "Use o botão de sobreposição para ativar ou desativar o som de alerta. A preferência permanece selecionada quando a página monitorada é atualizada.",
        "Uses a case-insensitive JavaScript regular expression. Invalid expressions cannot match, so test complex expressions carefully.": "Usa uma expressão regular JavaScript que não diferencia maiúsculas de minúsculas. Expressões inválidas não podem corresponder, portanto teste expressões complexas com cuidado.",
        "Using random mode": "Usando o modo aleatório",
        "Visible alerts across Safari tabs": "Alertas visíveis nas guias Safari",
        "Visit a webpage. Tap Safari’s Page Menu button beside the search field, then choose Auto Refresh XL from the extensions list.": "Visite uma página da web. Toque no botão do menu da página de Safari ao lado do campo de pesquisa e escolha Auto Refresh XL na lista de extensões.",
        "Website access, profiles, and common fixes": "Acesso ao site, perfis e soluções comuns",
        "What happens at zero": "O que acontece em zero",
        "What it shows": "O que isso mostra",
        "XPath": "XPath"
    ],
    "nl": [
        "A new delay for every cycle": "Een nieuwe vertraging voor elke cyclus",
        "A positive number stops after that many cycles; zero is unlimited. The overlay shows the count.": "Een positief getal stopt na zoveel cycli; nul is onbeperkt. De overlay toont de telling.",
        "Adding": "Toevoegen",
        "Advanced Options opens inside the extension. Edit changes URL and default interval; Delete permanently removes the rule. Older wildcard rules remain supported.": "Geavanceerde opties worden geopend in de extensie. Wijzigingen URL en standaardinterval bewerken; Verwijderen verwijdert de regel permanent. Oudere wildcardregels blijven ondersteund.",
        "Allow enough time for the site to load. Refreshing very frequently can increase battery usage and mobile data use, and may trigger captchas, rate limits, or a temporary website block.": "Geef de site voldoende tijd om te laden. Zeer regelmatig vernieuwen kan het batterijgebruik en het gebruik van mobiele data verhogen, en captcha's, snelheidslimieten of een tijdelijke websiteblokkering veroorzaken.",
        "Allow the extension": "De extensie toestaan",
        "Allow website access": "Websitetoegang toestaan",
        "Appears or disappears": "Verschijnt of verdwijnt",
        "Appears triggers when a match exists; Disappears triggers when it does not. Checks start after the first countdown.": "Verschijnt triggers wanneer er een match bestaat; Verdwijnt triggers wanneer dit niet het geval is. De controles starten na de eerste aftelling.",
        "Auto Refresh XL Settings": "Instellingen van Auto Refresh XL",
        "Auto-Start rules": "Regels voor automatisch starten",
        "Auto-refresh and page monitoring can continue while you browse other tabs within Safari. They will not operate reliably after Safari is closed, moved into the background, or you switch to another app.": "Automatisch vernieuwen en paginamonitoring kunnen doorgaan terwijl u door andere tabbladen binnen Safari bladert. Ze werken niet meer betrouwbaar nadat Safari is gesloten, naar de achtergrond is verplaatst of u naar een andere app overschakelt.",
        "Auto-scroll": "Automatisch scrollen",
        "Automatic refreshing, content monitoring, visible and audible alerts, and exact-page Auto-Start rules for Safari.": "Automatisch vernieuwen, inhoudsmonitoring, zichtbare en hoorbare waarschuwingen en Auto-Start-regels op exacte pagina's voor Safari.",
        "Case-insensitive text matching. Entering text into an empty field turns monitoring on; clearing it turns monitoring off. You can manually switch it off while keeping the text.": "Hoofdletterongevoelige tekstmatching. Als u tekst in een leeg veld invoert, wordt de monitoring ingeschakeld; Als u dit wist, wordt de monitoring uitgeschakeld. Je kunt het handmatig uitschakelen terwijl je de tekst behoudt.",
        "Choose a preset or enter hours, minutes, and seconds. Press Start Refresh to begin the first countdown. Monitoring does not check immediately; its first cycle occurs only when this countdown reaches zero.": "Kies een voorinstelling of voer uren, minuten en seconden in. Druk op Start Refresh om het eerste aftellen te starten. Monitoring controleert niet onmiddellijk; de eerste cyclus vindt alleen plaats wanneer deze aftelling nul bereikt.",
        "Compatibility": "Compatibiliteit",
        "Complete Feature Guide": "Volledige functiegids",
        "Contact Support": "Contact opnemen",
        "Content monitoring": "Inhoud controleren",
        "Countdown, monitored term, and controls": "Aftellen, bewaakte termijn en controles",
        "Creates an email to krabople@gmail.com": "Creëert een e-mail naar krabople@gmail.com",
        "Cross-tab alerts": "Kruistabelwaarschuwingen",
        "Drag its header. Its position is retained across refreshes in the same tab. Closing the widget hides it until the next page load; use Stop Refresh to end the process.": "Sleep de kop ervan. De positie blijft behouden bij vernieuwingen op hetzelfde tabblad. Als u de widget sluit, wordt deze verborgen totdat de volgende pagina wordt geladen; gebruik Stop Refresh om het proces te beëindigen.",
        "Dynamic sites": "Dynamische sites",
        "Editing": "Bewerken",
        "Email Support": "E-mailondersteuning",
        "Enable in Safari": "Schakel in Safari in",
        "Enable in Settings": "Schakel in Instellingen in",
        "Enabling sound": "Geluid inschakelen",
        "Enter minimum and maximum seconds. Preset and custom fields are disabled because a fresh random delay is selected after every cycle.": "Voer minimale en maximale seconden in. Vooraf ingestelde en aangepaste velden zijn uitgeschakeld omdat na elke cyclus een nieuwe willekeurige vertraging wordt geselecteerd.",
        "Find a detected result after reload": "Zoek een gedetecteerd resultaat na het herladen",
        "Finds an element using its page structure. XPath rules may break when a site redesigns its markup.": "Zoekt een element met behulp van de paginastructuur. XPath-regels kunnen overtreden worden wanneer een site de opmaak opnieuw ontwerpt.",
        "Form values are saved per tab. Closing the extension with Safari’s blue checkmark should not discard an unfinished setup.": "Formulierwaarden worden per tabblad opgeslagen. Het sluiten van de extensie met het blauwe vinkje van Safari mag een onvoltooide installatie niet weggooien.",
        "Hard Refresh": "Hard vernieuwen",
        "Hard refresh, limits, and interaction safety": "Harde vernieuwing, limieten en interactieveiligheid",
        "Hidden or replaced server text, inaccessible frames, closed shadow content, images, canvas, and late components may not be highlightable.": "Verborgen of vervangen servertekst, ontoegankelijke frames, gesloten schaduwinhoud, afbeeldingen, canvas en late componenten kunnen mogelijk niet worden gemarkeerd.",
        "Highlight and auto-scroll": "Markeren en automatisch scrollen",
        "Highlighting": "Markering",
        "How it works": "Hoe het werkt",
        "If it is missing": "Als de extensie ontbreekt",
        "Intervals and countdowns": "Intervallen en aftellen",
        "It cannot appear on Safari internal pages, Settings, some document viewers, or websites without extension access.": "Het kan niet verschijnen op interne Safari-pagina's, instellingen, sommige documentviewers of websites zonder extensietoegang.",
        "Limitations": "Beperkingen",
        "Moving and hiding": "Bewegen en verstoppen",
        "OK": "OK",
        "On that screen, allow access to the websites you want to refresh. Allow for All Websites is the simplest setup.": "Geef op dat scherm toegang tot de websites die u wilt vernieuwen. Toestaan ​​voor alle websites is de eenvoudigste configuratie.",
        "On the desired page, choose Auto-Start Current Page. New rules save the entire URL, including path and query string, and match that exact address.": "Kies op de gewenste pagina de optie Huidige pagina automatisch starten. Nieuwe regels slaan de volledige URL op, inclusief pad en queryreeks, en komen overeen met dat exacte adres.",
        "On-page overlay": "Widget op de pagina",
        "On-screen target alerts": "Meldingen op het scherm",
        "Open it in Safari": "Openen in Safari",
        "Opens the detailed feature guide": "Opent de gedetailleerde functiegids",
        "Other tabs": "Andere tabbladen",
        "Permissions and troubleshooting": "Toestemming en probleemoplossing",
        "Plain Text": "Platte tekst",
        "Plain-text and regex matches use the yellow pulsing highlight. The extension reapplies it to the newly reloaded page so navigation does not remove it.": "Platte tekst en regex-overeenkomsten gebruiken de gele pulserende markering. De extensie past deze opnieuw toe op de nieuw geladen pagina, zodat de navigatie deze niet verwijdert.",
        "Please email krabople@gmail.com from your preferred email app.": "Stuur vanuit je favoriete e-mailapp een bericht naar krabople@gmail.com.",
        "Preset or custom refresh timing": "Vooraf ingestelde of aangepaste vernieuwingstijdstip",
        "Random interval range": "Willekeurig interval",
        "Random timing can reduce repetitive request patterns and may avoid bot detection on some websites, but it does not always bypass website rules or anti-automation systems. Avoid extremely short ranges on complex pages.": "Willekeurige timing kan repetitieve verzoekpatronen verminderen en kan botdetectie op sommige websites voorkomen, maar omzeilt niet altijd websiteregels of antiautomatiseringssystemen. Vermijd extreem korte afstanden op complexe pagina's.",
        "Redirects and changing query parameters can produce a different final address. Edit the rule to the exact address Safari displays.": "Omleidingen en het wijzigen van queryparameters kunnen een ander eindadres opleveren. Bewerk de regel naar het exacte adres dat Safari weergeeft.",
        "Refresh Limit": "Vernieuwingslimiet",
        "Refresh options and limits": "Verversingsopties en limieten",
        "Regular Expression": "Reguliere expressie",
        "Requests a reload that bypasses cached data where Safari supports it. Websites and service workers may still impose their own caching.": "Vraagt om opnieuw laden waarbij gegevens in de cache worden omzeild waar Safari dit ondersteunt. Websites en servicemedewerkers kunnen nog steeds hun eigen caching opleggen.",
        "Safari Auto Refresh and\nPage Monitor XL": "Auto Refresh XL voor Safari",
        "Safari cannot inject the banner into internal browser pages, Settings, some viewers, or pages without permission. It is not a Lock Screen push notification.": "Safari kan de banner niet zonder toestemming in interne browserpagina's, instellingen, sommige kijkers of pagina's injecteren. Het is geen pushmelding op het vergrendelscherm.",
        "Safari must remain open on screen": "Safari moet geopend blijven op het scherm",
        "Safari smoothly centres the detected match. The extension retries briefly for pages that render after the initial document.": "Safari centreert de gedetecteerde overeenkomst soepel. De extensie probeert het kort opnieuw voor pagina's die na het oorspronkelijke document worden weergegeven.",
        "Safari-safe audible target alerts": "Safari-veilige hoorbare doelwaarschuwingen",
        "Saved entries": "Opgeslagen vermeldingen",
        "Set up the extension": "De extensie instellen",
        "Settings → Apps → Safari → Extensions → Safari Auto Refresh and Page Monitor XL. Turn on Allow Extension and grant the required website access.": "Instellingen → Apps → Safari → Extensies → Auto Refresh XL. Schakel Extensie toestaan ​​in en verleen de vereiste websitetoegang.",
        "Settings → Apps → Safari → Extensions → Safari Auto Refresh and Page Monitor XL. Turn on Allow Extension.": "Instellingen → Apps → Safari → Extensies → Auto Refresh XL. Schakel Extensie toestaan ​​in.",
        "Sound alerts": "Geluidsmeldingen",
        "Start on saved exact pages": "Begin op opgeslagen exacte pagina's",
        "Stop on interaction": "Stop met interactie",
        "Stops refreshing when you interact with the monitored webpage. Use this when you want a tap, click, key press, or other page interaction to end the active refresh session.": "Stopt met vernieuwen wanneer u interactie heeft met de bewaakte webpagina. Gebruik dit wanneer u wilt dat een tik, klik, toetsaanslag of andere pagina-interactie de actieve vernieuwingssessie beëindigt.",
        "Tap Page Menu beside the search field, then Manage Extensions. Switch on Auto Refresh XL and select it from Page Menu to open its controls.": "Tik op Paginamenu naast het zoekveld en vervolgens op Extensies beheren. Schakel Auto Refresh XL in en selecteer het in het Paginamenu om de bedieningselementen te openen.",
        "Tap Page Menu → Manage Extensions and switch on Auto Refresh XL. Safari profiles may require separate enabling.": "Tik op Paginamenu → Extensies beheren en schakel Auto Refresh XL in. Voor Safari-profielen is mogelijk afzonderlijke activering vereist.",
        "Tap a feature for detailed instructions, limitations, and useful tips.": "Tik op een functie voor instructies, beperkingen en tips.",
        "Text, regex, and XPath matching": "Tekst-, regex- en XPath-matching",
        "The Ring/Silent switch, device volume, Focus modes, and iOS resource suspension can affect alerts. Webpage audio remains available as a fallback when native sound cannot be started.": "De Ring/Silent-schakelaar, het apparaatvolume, de focusmodi en de opschorting van iOS-bronnen kunnen waarschuwingen beïnvloeden. Webpagina-audio blijft beschikbaar als fallback wanneer het native geluid niet kan worden gestart.",
        "The banner appears on the ordinary Safari webpage currently being viewed. View Monitored Tab returns to the source tab when needed.": "De banner verschijnt op de gewone Safari-webpagina die momenteel wordt bekeken. Bekijk het bewaakte tabblad keert indien nodig terug naar het brontabblad.",
        "The draggable overlay shows countdown, refresh count, fixed or random mode, monitored term, Stop Refresh, and the sound toggle when monitoring uses sound.": "De versleepbare overlay toont het aftellen, het aantal vernieuwingen, de vaste of willekeurige modus, de gecontroleerde term, het vernieuwen van de stop en de geluidsschakelaar wanneer de monitoring geluid gebruikt.",
        "The extension obtains fresh content for monitoring, performs a genuine visible Safari reload, and schedules the next countdown. Page loading time and iOS suspension can delay very short intervals.": "De extensie verkrijgt nieuwe inhoud voor monitoring, voert een echt zichtbare Safari-herlaadbeurt uit en plant het volgende aftellen. De laadtijd van de pagina en de opschorting van iOS kunnen zeer korte intervallen vertragen.",
        "The iOS extension plays the primary alert sound natively, while the visible alert is routed to the ordinary Safari webpage you are viewing.": "De iOS-extensie speelt het primaire waarschuwingsgeluid native af, terwijl de zichtbare waarschuwing wordt doorgestuurd naar de gewone Safari-webpagina die u bekijkt.",
        "The rendered page is checked immediately after refresh and watched for later changes. Inaccessible frames, images, canvas text, and closed components may not be detectable.": "De weergegeven pagina wordt onmiddellijk na het vernieuwen gecontroleerd en gecontroleerd op latere wijzigingen. Ontoegankelijke frames, afbeeldingen, canvastekst en gesloten componenten zijn mogelijk niet detecteerbaar.",
        "Tips": "Tips",
        "Use the overlay button to enable or disable alert sound. The preference remains selected when the monitored page refreshes.": "Gebruik de overlayknop om het waarschuwingsgeluid in of uit te schakelen. De voorkeur blijft geselecteerd wanneer de bewaakte pagina wordt vernieuwd.",
        "Uses a case-insensitive JavaScript regular expression. Invalid expressions cannot match, so test complex expressions carefully.": "Gebruikt een hoofdletterongevoelige reguliere expressie JavaScript. Ongeldige expressies kunnen niet overeenkomen, dus test complexe expressies zorgvuldig.",
        "Using random mode": "Willekeurige modus gebruiken",
        "Visible alerts across Safari tabs": "Zichtbare waarschuwingen op Safari-tabbladen",
        "Visit a webpage. Tap Safari’s Page Menu button beside the search field, then choose Auto Refresh XL from the extensions list.": "Bezoek een webpagina. Tik op de paginamenuknop van Safari naast het zoekveld en kies vervolgens Auto Refresh XL in de lijst met extensies.",
        "Website access, profiles, and common fixes": "Websitetoegang, profielen en veelvoorkomende oplossingen",
        "What happens at zero": "Wat gebeurt er bij nul",
        "What it shows": "Wat het laat zien",
        "XPath": "XPath"
    ],
    "ja": [
        "A new delay for every cycle": "サイクルごとに新しい待ち時間",
        "A positive number stops after that many cycles; zero is unlimited. The overlay shows the count.": "正の数は、その回数のサイクル後に停止します。ゼロは無制限です。オーバーレイにはカウントが表示されます。",
        "Adding": "追加",
        "Advanced Options opens inside the extension. Edit changes URL and default interval; Delete permanently removes the rule. Older wildcard rules remain supported.": "拡張機能内で詳細オプションが開きます。編集すると、URL とデフォルトの間隔が変更されます。削除はルールを完全に削除します。古いワイルドカード ルールは引き続きサポートされます。",
        "Allow enough time for the site to load. Refreshing very frequently can increase battery usage and mobile data use, and may trigger captchas, rate limits, or a temporary website block.": "サイトが読み込まれるまで十分な時間をとってください。非常に頻繁に更新すると、バッテリーの使用量とモバイル データの使用量が増加する可能性があり、キャプチャ、レート制限、または一時的な Web サイトのブロックがトリガーされる可能性があります。",
        "Allow the extension": "拡張機能を許可",
        "Allow website access": "Webサイトへのアクセスを許可",
        "Appears or disappears": "現れたり消えたり",
        "Appears triggers when a match exists; Disappears triggers when it does not. Checks start after the first countdown.": "一致するものが存在する場合にトリガーが表示されます。トリガーが消えない場合は消えます。最初のカウントダウン後にチェックが開始されます。",
        "Auto Refresh XL Settings": "Auto Refresh XLの設定",
        "Auto-Start rules": "自動開始ルール",
        "Auto-refresh and page monitoring can continue while you browse other tabs within Safari. They will not operate reliably after Safari is closed, moved into the background, or you switch to another app.": "自動更新とページ監視は、Safari 内の他のタブを参照している間も継続できます。 Safari を閉じたり、バックグラウンドに移動したり、別のアプリに切り替えたりすると、これらは確実に動作しなくなります。",
        "Auto-scroll": "自動スクロール",
        "Automatic refreshing, content monitoring, visible and audible alerts, and exact-page Auto-Start rules for Safari.": "Safari の自動更新、コンテンツ監視、表示および可聴のアラート、正確なページの自動開始ルール。",
        "Case-insensitive text matching. Entering text into an empty field turns monitoring on; clearing it turns monitoring off. You can manually switch it off while keeping the text.": "大文字と小文字を区別しないテキスト一致。空のフィールドにテキストを入力すると、監視がオンになります。これをクリアすると監視がオフになります。テキストを保持したまま手動でオフにすることもできます。",
        "Choose a preset or enter hours, minutes, and seconds. Press Start Refresh to begin the first countdown. Monitoring does not check immediately; its first cycle occurs only when this countdown reaches zero.": "プリセットを選択するか、時、分、秒を入力します。 [更新の開始] を押して、最初のカウントダウンを開始します。モニタリングはすぐにはチェックしません。最初のサイクルは、このカウントダウンがゼロに達したときにのみ発生します。",
        "Compatibility": "互換性",
        "Complete Feature Guide": "機能ガイド",
        "Contact Support": "サポートに連絡",
        "Content monitoring": "コンテンツ監視",
        "Countdown, monitored term, and controls": "カウントダウン、監視期間、およびコントロール",
        "Creates an email to krabople@gmail.com": "krabople@gmail.com 宛に電子メールを作成します",
        "Cross-tab alerts": "クロス集計アラート",
        "Drag its header. Its position is retained across refreshes in the same tab. Closing the widget hides it until the next page load; use Stop Refresh to end the process.": "ヘッダーをドラッグします。その位置は、同じタブ内で更新されても保持されます。ウィジェットを閉じると、次のページが読み込まれるまでウィジェットが非表示になります。プロセスを終了するには、Stop Refresh を使用します。",
        "Dynamic sites": "動的サイト",
        "Editing": "編集",
        "Email Support": "メールサポート",
        "Enable in Safari": "Safari で有効にする",
        "Enable in Settings": "設定で有効にする",
        "Enabling sound": "サウンドを有効にする",
        "Enter minimum and maximum seconds. Preset and custom fields are disabled because a fresh random delay is selected after every cycle.": "最小秒と最大秒を入力します。サイクルごとに新しいランダム遅延が選択されるため、プリセット フィールドとカスタム フィールドは無効になります。",
        "Find a detected result after reload": "リロード後に検出結果を検索する",
        "Finds an element using its page structure. XPath rules may break when a site redesigns its markup.": "ページ構造を使用して要素を検索します。サイトがマークアップを再設計すると、XPath ルールが壊れる可能性があります。",
        "Form values are saved per tab. Closing the extension with Safari’s blue checkmark should not discard an unfinished setup.": "フォームの値はタブごとに保存されます。 Safari の青いチェックマークを付けて拡張機能を閉じても、未完了のセットアップは破棄されません。",
        "Hard Refresh": "ハードリフレッシュ",
        "Hard refresh, limits, and interaction safety": "ハードリフレッシュ、制限、およびインタラクションの安全性",
        "Hidden or replaced server text, inaccessible frames, closed shadow content, images, canvas, and late components may not be highlightable.": "非表示または置換されたサーバー テキスト、アクセスできないフレーム、閉じたシャドウ コンテンツ、画像、キャンバス、および遅延コンポーネントは強調表示できない場合があります。",
        "Highlight and auto-scroll": "強調表示と自動スクロール",
        "Highlighting": "ハイライト表示",
        "How it works": "仕組み",
        "If it is missing": "表示されない場合",
        "Intervals and countdowns": "間隔とカウントダウン",
        "It cannot appear on Safari internal pages, Settings, some document viewers, or websites without extension access.": "拡張機能にアクセスしないと、Safari 内部ページ、設定、一部のドキュメント ビューア、または Web サイトに表示できません。",
        "Limitations": "制限事項",
        "Moving and hiding": "移動して隠れる",
        "OK": "OK",
        "On that screen, allow access to the websites you want to refresh. Allow for All Websites is the simplest setup.": "その画面で、更新したい Web サイトへのアクセスを許可します。 「すべての Web サイトを許可」は最も簡単な設定です。",
        "On the desired page, choose Auto-Start Current Page. New rules save the entire URL, including path and query string, and match that exact address.": "目的のページで、「現在のページを自動開始」を選択します。新しいルールは、パスとクエリ文字列を含む URL 全体を保存し、その正確なアドレスと一致します。",
        "On-page overlay": "ページ上のウィジェット",
        "On-screen target alerts": "画面上の通知",
        "Open it in Safari": "Safariで開く",
        "Opens the detailed feature guide": "詳細な機能ガイドを開きます",
        "Other tabs": "その他のタブ",
        "Permissions and troubleshooting": "権限とトラブルシューティング",
        "Plain Text": "プレーンテキスト",
        "Plain-text and regex matches use the yellow pulsing highlight. The extension reapplies it to the newly reloaded page so navigation does not remove it.": "プレーンテキストと regex の一致では、黄色の点滅ハイライトが使用されます。拡張機能は、ナビゲーションによって削除されないように、新しくリロードされたページにそれを再適用します。",
        "Please email krabople@gmail.com from your preferred email app.": "お使いのメールアプリからkrabople@gmail.comにご連絡ください。",
        "Preset or custom refresh timing": "プリセットまたはカスタムの更新時間",
        "Random interval range": "ランダム間隔",
        "Random timing can reduce repetitive request patterns and may avoid bot detection on some websites, but it does not always bypass website rules or anti-automation systems. Avoid extremely short ranges on complex pages.": "ランダムなタイミングにより、反復的なリクエスト パターンが減り、一部の Web サイトでのボット検出が回避される可能性がありますが、Web サイトのルールや自動化対策システムを常にバイパスできるわけではありません。複雑なページでは、極端に短い範囲を避けてください。",
        "Redirects and changing query parameters can produce a different final address. Edit the rule to the exact address Safari displays.": "リダイレクトやクエリ パラメータの変更により、異なる最終アドレスが生成される可能性があります。 Safari が表示する正確なアドレスにルールを編集します。",
        "Refresh Limit": "リフレッシュ制限",
        "Refresh options and limits": "更新オプションと上限",
        "Regular Expression": "正規表現",
        "Requests a reload that bypasses cached data where Safari supports it. Websites and service workers may still impose their own caching.": "Safari がサポートする場合、キャッシュされたデータをバイパスするリロードを要求します。 Web サイトとサービスワーカーは依然として独自のキャッシュを課す可能性があります。",
        "Safari Auto Refresh and\nPage Monitor XL": "Safari向けAuto Refresh XL",
        "Safari cannot inject the banner into internal browser pages, Settings, some viewers, or pages without permission. It is not a Lock Screen push notification.": "Safari は、許可なく内部ブラウザ ページ、設定、一部のビューア、またはページにバナーを挿入することはできません。ロック画面のプッシュ通知ではありません。",
        "Safari must remain open on screen": "Safari は画面上で開いたままにする必要があります",
        "Safari smoothly centres the detected match. The extension retries briefly for pages that render after the initial document.": "Safari は、検出された一致をスムーズに中央に配置します。拡張機能は、最初のドキュメントの後にレンダリングされるページに対して短時間再試行します。",
        "Safari-safe audible target alerts": "Safari-safe 可聴目標警報",
        "Saved entries": "保存されたエントリ",
        "Set up the extension": "拡張機能を設定",
        "Settings → Apps → Safari → Extensions → Safari Auto Refresh and Page Monitor XL. Turn on Allow Extension and grant the required website access.": "設定→アプリ→Safari→拡張機能→Auto Refresh XL。 [拡張機能を許可] をオンにして、必要な Web サイトへのアクセスを許可します。",
        "Settings → Apps → Safari → Extensions → Safari Auto Refresh and Page Monitor XL. Turn on Allow Extension.": "設定→アプリ→Safari→拡張機能→Auto Refresh XL。 「拡張機能を許可」をオンにします。",
        "Sound alerts": "サウンド通知",
        "Start on saved exact pages": "保存した正確なページから開始する",
        "Stop on interaction": "インタラクション時に停止",
        "Stops refreshing when you interact with the monitored webpage. Use this when you want a tap, click, key press, or other page interaction to end the active refresh session.": "監視対象の Web ページを操作すると、更新が停止します。タップ、クリック、キーの押下、またはその他のページ操作によってアクティブな更新セッションを終了する場合は、これを使用します。",
        "Tap Page Menu beside the search field, then Manage Extensions. Switch on Auto Refresh XL and select it from Page Menu to open its controls.": "検索フィールドの横にある「ページメニュー」をタップし、「拡張機能の管理」をタップします。 Auto Refresh XL をオンにし、ページ メニューから選択してコントロールを開きます。",
        "Tap Page Menu → Manage Extensions and switch on Auto Refresh XL. Safari profiles may require separate enabling.": "「ページメニュー」→「拡張機能の管理」をタップし、Auto Refresh XLをオンにします。 Safari プロファイルは個別に有効にする必要がある場合があります。",
        "Tap a feature for detailed instructions, limitations, and useful tips.": "機能をタップすると、詳しい手順、制限事項、ヒントが表示されます。",
        "Text, regex, and XPath matching": "テキスト、regex、および XPath の一致",
        "The Ring/Silent switch, device volume, Focus modes, and iOS resource suspension can affect alerts. Webpage audio remains available as a fallback when native sound cannot be started.": "リング/サイレント スイッチ、デバイスの音量、フォーカス モード、および iOS リソースの一時停止は、アラートに影響を与える可能性があります。 Web ページの音声は、ネイティブ サウンドを開始できない場合でもフォールバックとして利用できます。",
        "The banner appears on the ordinary Safari webpage currently being viewed. View Monitored Tab returns to the source tab when needed.": "バナーは、現在表示されている通常の Safari Web ページに表示されます。 [監視対象タブの表示] は、必要に応じてソース タブに戻ります。",
        "The draggable overlay shows countdown, refresh count, fixed or random mode, monitored term, Stop Refresh, and the sound toggle when monitoring uses sound.": "ドラッグ可能なオーバーレイには、カウントダウン、リフレッシュ回数、固定モードまたはランダムモード、監視期間、リフレッシュの停止、および監視でサウンドが使用されている場合のサウンドの切り替えが表示されます。",
        "The extension obtains fresh content for monitoring, performs a genuine visible Safari reload, and schedules the next countdown. Page loading time and iOS suspension can delay very short intervals.": "この拡張機能は、監視用に新しいコンテンツを取得し、本物の表示可能な Safari リロードを実行し、次のカウントダウンをスケジュールします。ページの読み込み時間と iOS の一時停止により、非常に短い間隔で遅延が発生する可能性があります。",
        "The iOS extension plays the primary alert sound natively, while the visible alert is routed to the ordinary Safari webpage you are viewing.": "iOS 拡張機能は、プライマリ アラート サウンドをネイティブに再生しますが、表示されるアラートは、表示している通常の Safari Web ページにルーティングされます。",
        "The rendered page is checked immediately after refresh and watched for later changes. Inaccessible frames, images, canvas text, and closed components may not be detectable.": "レンダリングされたページは更新直後にチェックされ、その後の変更が監視されます。アクセスできないフレーム、画像、キャンバス テキスト、閉じたコンポーネントは検出できない場合があります。",
        "Tips": "ヒント",
        "Use the overlay button to enable or disable alert sound. The preference remains selected when the monitored page refreshes.": "オーバーレイ ボタンを使用して、警告音を有効または無効にします。監視対象のページが更新されても、設定は選択されたままになります。",
        "Uses a case-insensitive JavaScript regular expression. Invalid expressions cannot match, so test complex expressions carefully.": "大文字と小文字を区別しない JavaScript 正規表現を使用します。無効な式は一致しないため、複雑な式を慎重にテストしてください。",
        "Using random mode": "ランダムモードの使用",
        "Visible alerts across Safari tabs": "Safari タブ全体でアラートを表示",
        "Visit a webpage. Tap Safari’s Page Menu button beside the search field, then choose Auto Refresh XL from the extensions list.": "Web ページにアクセスします。検索フィールドの横にあるSafariのページメニューボタンをタップし、拡張機能リストからAuto Refresh XLを選択します。",
        "Website access, profiles, and common fixes": "Web サイトへのアクセス、プロファイル、および一般的な修正",
        "What happens at zero": "ゼロで何が起こるか",
        "What it shows": "それが示すもの",
        "XPath": "XPath"
    ],
    "ko": [
        "A new delay for every cycle": "모든 사이클에 대한 새로운 지연",
        "A positive number stops after that many cycles; zero is unlimited. The overlay shows the count.": "양수는 많은 사이클 후에 중지됩니다. 0은 무제한입니다. 오버레이에 개수가 표시됩니다.",
        "Adding": "추가",
        "Advanced Options opens inside the extension. Edit changes URL and default interval; Delete permanently removes the rule. Older wildcard rules remain supported.": "고급 옵션은 확장 프로그램 내부에서 열립니다. 변경 URL 및 기본 간격을 편집합니다. 삭제하면 규칙이 영구적으로 제거됩니다. 이전 와일드카드 규칙은 계속 지원됩니다.",
        "Allow enough time for the site to load. Refreshing very frequently can increase battery usage and mobile data use, and may trigger captchas, rate limits, or a temporary website block.": "사이트가 로드될 때까지 충분한 시간을 허용하십시오. 너무 자주 새로 고치면 배터리 사용량과 모바일 데이터 사용량이 늘어나고 보안 문자, 속도 제한 또는 임시 웹사이트 차단이 발생할 수 있습니다.",
        "Allow the extension": "확장 프로그램 허용",
        "Allow website access": "웹사이트 접근 허용",
        "Appears or disappears": "나타나거나 사라짐",
        "Appears triggers when a match exists; Disappears triggers when it does not. Checks start after the first countdown.": "일치하는 항목이 있을 때 트리거가 나타납니다. 사라지는 경우 트리거가 사라집니다. 첫 번째 카운트다운 후 점검이 시작됩니다.",
        "Auto Refresh XL Settings": "Auto Refresh XL 설정",
        "Auto-Start rules": "자동 시작 규칙",
        "Auto-refresh and page monitoring can continue while you browse other tabs within Safari. They will not operate reliably after Safari is closed, moved into the background, or you switch to another app.": "Safari 내에서 다른 탭을 탐색하는 동안 자동 새로 고침 및 페이지 모니터링을 계속할 수 있습니다. Safari를 닫거나, 백그라운드로 이동하거나, 다른 앱으로 전환한 후에는 안정적으로 작동하지 않습니다.",
        "Auto-scroll": "자동 스크롤",
        "Automatic refreshing, content monitoring, visible and audible alerts, and exact-page Auto-Start rules for Safari.": "Safari에 대한 자동 새로 고침, 콘텐츠 모니터링, 시각적 및 청각적 경고, 정확한 페이지 자동 시작 규칙.",
        "Case-insensitive text matching. Entering text into an empty field turns monitoring on; clearing it turns monitoring off. You can manually switch it off while keeping the text.": "대소문자를 구분하지 않는 텍스트 일치. 빈 필드에 텍스트를 입력하면 모니터링이 켜집니다. 이를 지우면 모니터링이 꺼집니다. 텍스트를 유지하면서 수동으로 끌 수 있습니다.",
        "Choose a preset or enter hours, minutes, and seconds. Press Start Refresh to begin the first countdown. Monitoring does not check immediately; its first cycle occurs only when this countdown reaches zero.": "사전 설정을 선택하거나 시간, 분, 초를 입력하세요. 첫 번째 카운트다운을 시작하려면 새로 고침 시작을 누르세요. 모니터링은 즉시 확인하지 않습니다. 첫 번째 주기는 이 카운트다운이 0에 도달할 때만 발생합니다.",
        "Compatibility": "호환성",
        "Complete Feature Guide": "전체 기능 안내",
        "Contact Support": "지원 문의",
        "Content monitoring": "콘텐츠 모니터링",
        "Countdown, monitored term, and controls": "카운트다운, 모니터링되는 용어 및 제어",
        "Creates an email to krabople@gmail.com": "krabople@gmail.com으로 이메일을 작성합니다.",
        "Cross-tab alerts": "크로스탭 경고",
        "Drag its header. Its position is retained across refreshes in the same tab. Closing the widget hides it until the next page load; use Stop Refresh to end the process.": "헤더를 드래그하세요. 해당 위치는 동일한 탭에서 새로 고쳐도 유지됩니다. 위젯을 닫으면 다음 페이지가 로드될 때까지 숨겨집니다. 프로세스를 종료하려면 새로 고침 중지를 사용하십시오.",
        "Dynamic sites": "동적 사이트",
        "Editing": "편집",
        "Email Support": "이메일 지원",
        "Enable in Safari": "Safari에서 활성화",
        "Enable in Settings": "설정에서 활성화",
        "Enabling sound": "사운드 활성화",
        "Enter minimum and maximum seconds. Preset and custom fields are disabled because a fresh random delay is selected after every cycle.": "최소 및 최대 초를 입력합니다. 매 사이클마다 새로운 무작위 지연이 선택되므로 사전 설정 및 사용자 정의 필드가 비활성화됩니다.",
        "Find a detected result after reload": "새로고침 후 감지된 결과 찾기",
        "Finds an element using its page structure. XPath rules may break when a site redesigns its markup.": "페이지 구조를 사용하여 요소를 찾습니다. 사이트가 마크업을 다시 디자인하면 XPath 규칙이 깨질 수 있습니다.",
        "Form values are saved per tab. Closing the extension with Safari’s blue checkmark should not discard an unfinished setup.": "양식 값은 탭별로 저장됩니다. Safari의 파란색 확인 표시로 확장 프로그램을 닫으면 완료되지 않은 설정이 삭제되어서는 안 됩니다.",
        "Hard Refresh": "강제 새로고침",
        "Hard refresh, limits, and interaction safety": "강제 새로고침, 한도, 상호작용 안전",
        "Hidden or replaced server text, inaccessible frames, closed shadow content, images, canvas, and late components may not be highlightable.": "숨겨지거나 대체된 서버 텍스트, 액세스할 수 없는 프레임, 닫힌 그림자 콘텐츠, 이미지, 캔버스 및 최신 구성 요소는 강조 표시할 수 없습니다.",
        "Highlight and auto-scroll": "강조 표시 및 자동 스크롤",
        "Highlighting": "강조",
        "How it works": "작동 원리",
        "If it is missing": "표시되지 않는 경우",
        "Intervals and countdowns": "간격 및 카운트다운",
        "It cannot appear on Safari internal pages, Settings, some document viewers, or websites without extension access.": "확장 액세스 권한이 없으면 Safari 내부 페이지, 설정, 일부 문서 뷰어 또는 웹사이트에 표시될 수 없습니다.",
        "Limitations": "제한 사항",
        "Moving and hiding": "이동 및 숨기기",
        "OK": "확인",
        "On that screen, allow access to the websites you want to refresh. Allow for All Websites is the simplest setup.": "해당 화면에서 새로 고치려는 웹사이트에 대한 액세스를 허용하세요. 모든 웹 사이트 허용은 가장 간단한 설정입니다.",
        "On the desired page, choose Auto-Start Current Page. New rules save the entire URL, including path and query string, and match that exact address.": "원하는 페이지에서 현재 페이지 자동 시작을 선택합니다. 새로운 규칙은 경로 및 쿼리 문자열을 포함한 전체 URL을 저장하고 정확한 주소와 일치시킵니다.",
        "On-page overlay": "페이지 오버레이",
        "On-screen target alerts": "화면 알림",
        "Open it in Safari": "Safari에서 열기",
        "Opens the detailed feature guide": "세부 기능 가이드 열기",
        "Other tabs": "기타 탭",
        "Permissions and troubleshooting": "권한 및 문제 해결",
        "Plain Text": "일반 텍스트",
        "Plain-text and regex matches use the yellow pulsing highlight. The extension reapplies it to the newly reloaded page so navigation does not remove it.": "일반 텍스트 및 regex 일치는 노란색 펄스 강조 표시를 사용합니다. 확장 프로그램은 새로 다시 로드된 페이지에 이를 다시 적용하므로 탐색 시 이를 제거하지 않습니다.",
        "Please email krabople@gmail.com from your preferred email app.": "원하는 이메일 앱에서 krabople@gmail.com으로 문의해 주세요.",
        "Preset or custom refresh timing": "사전 설정 또는 사용자 정의 새로 고침 타이밍",
        "Random interval range": "무작위 간격",
        "Random timing can reduce repetitive request patterns and may avoid bot detection on some websites, but it does not always bypass website rules or anti-automation systems. Avoid extremely short ranges on complex pages.": "무작위 타이밍은 반복적인 요청 패턴을 줄이고 일부 웹사이트에서 봇 감지를 방지할 수 있지만 웹사이트 규칙이나 자동화 방지 시스템을 항상 우회하는 것은 아닙니다. 복잡한 페이지에서는 매우 짧은 범위를 사용하지 마세요.",
        "Redirects and changing query parameters can produce a different final address. Edit the rule to the exact address Safari displays.": "리디렉션 및 쿼리 매개변수 변경으로 인해 최종 주소가 달라질 수 있습니다. Safari가 표시하는 정확한 주소로 규칙을 편집합니다.",
        "Refresh Limit": "새로고침 한도",
        "Refresh options and limits": "새로고침 옵션 및 제한",
        "Regular Expression": "정규식",
        "Requests a reload that bypasses cached data where Safari supports it. Websites and service workers may still impose their own caching.": "Safari가 지원하는 캐시된 데이터를 우회하는 다시 로드를 요청합니다. 웹사이트와 서비스 워커는 여전히 자체 캐싱을 적용할 수 있습니다.",
        "Safari Auto Refresh and\nPage Monitor XL": "Safari용 Auto Refresh XL",
        "Safari cannot inject the banner into internal browser pages, Settings, some viewers, or pages without permission. It is not a Lock Screen push notification.": "Safari는 허가 없이 내부 브라우저 페이지, 설정, 일부 뷰어 또는 페이지에 배너를 삽입할 수 없습니다. 잠금화면 푸시 알림이 아닙니다.",
        "Safari must remain open on screen": "Safari는 화면에 계속 열려 있어야 합니다.",
        "Safari smoothly centres the detected match. The extension retries briefly for pages that render after the initial document.": "Safari는 감지된 일치 항목을 원활하게 중앙에 배치합니다. 확장 프로그램은 초기 문서 이후에 렌더링되는 페이지에 대해 잠시 재시도합니다.",
        "Safari-safe audible target alerts": "Safari-안전한 가청 표적 경고",
        "Saved entries": "저장된 항목",
        "Set up the extension": "확장 프로그램 설정",
        "Settings → Apps → Safari → Extensions → Safari Auto Refresh and Page Monitor XL. Turn on Allow Extension and grant the required website access.": "설정 → 앱 → Safari → 확장 프로그램 → Auto Refresh XL. 확장 허용을 켜고 필요한 웹사이트 액세스 권한을 부여하세요.",
        "Settings → Apps → Safari → Extensions → Safari Auto Refresh and Page Monitor XL. Turn on Allow Extension.": "설정 → 앱 → Safari → 확장 프로그램 → Auto Refresh XL. 확장 허용을 켭니다.",
        "Sound alerts": "소리 알림",
        "Start on saved exact pages": "저장된 정확한 페이지에서 시작",
        "Stop on interaction": "상호작용 중지",
        "Stops refreshing when you interact with the monitored webpage. Use this when you want a tap, click, key press, or other page interaction to end the active refresh session.": "모니터링되는 웹페이지와 상호작용할 때 새로 고침이 중지됩니다. 탭, 클릭, 키 누르기 또는 기타 페이지 상호 작용을 통해 활성 새로 고침 세션을 종료하려면 이 옵션을 사용하세요.",
        "Tap Page Menu beside the search field, then Manage Extensions. Switch on Auto Refresh XL and select it from Page Menu to open its controls.": "검색 필드 옆에 있는 페이지 메뉴를 탭한 다음 확장 프로그램 관리를 탭하세요. Auto Refresh XL를 켜고 페이지 메뉴에서 선택하여 컨트롤을 엽니다.",
        "Tap Page Menu → Manage Extensions and switch on Auto Refresh XL. Safari profiles may require separate enabling.": "페이지 메뉴 → 확장 관리를 누르고 Auto Refresh XL를 켭니다. Safari 프로필은 별도의 활성화가 필요할 수 있습니다.",
        "Tap a feature for detailed instructions, limitations, and useful tips.": "기능을 탭하면 자세한 안내, 제한 사항 및 팁을 볼 수 있습니다.",
        "Text, regex, and XPath matching": "텍스트, regex 및 XPath 일치",
        "The Ring/Silent switch, device volume, Focus modes, and iOS resource suspension can affect alerts. Webpage audio remains available as a fallback when native sound cannot be started.": "벨소리/무음 스위치, 장치 볼륨, 집중 모드 및 iOS 리소스 일시 중단은 경고에 영향을 미칠 수 있습니다. 기본 사운드를 시작할 수 없는 경우 웹페이지 오디오를 대체 수단으로 계속 사용할 수 있습니다.",
        "The banner appears on the ordinary Safari webpage currently being viewed. View Monitored Tab returns to the source tab when needed.": "배너는 현재 보고 있는 일반 Safari 웹페이지에 나타납니다. 모니터링된 탭 보기는 필요한 경우 소스 탭으로 돌아갑니다.",
        "The draggable overlay shows countdown, refresh count, fixed or random mode, monitored term, Stop Refresh, and the sound toggle when monitoring uses sound.": "드래그 가능한 오버레이에는 카운트다운, 새로 고침 횟수, 고정 또는 무작위 모드, 모니터링되는 용어, 새로 고침 중지 및 모니터링이 사운드를 사용할 때 사운드 토글이 표시됩니다.",
        "The extension obtains fresh content for monitoring, performs a genuine visible Safari reload, and schedules the next countdown. Page loading time and iOS suspension can delay very short intervals.": "확장 프로그램은 모니터링을 위한 새로운 콘텐츠를 얻고, 실제로 보이는 Safari 다시 로드를 수행하고, 다음 카운트다운을 예약합니다. 페이지 로딩 시간 및 iOS 일시중단으로 인해 매우 짧은 간격이 지연될 수 있습니다.",
        "The iOS extension plays the primary alert sound natively, while the visible alert is routed to the ordinary Safari webpage you are viewing.": "iOS 확장은 기본적으로 기본 경고음을 재생하는 반면, 시각적 경고는 보고 있는 일반 Safari 웹 페이지로 라우팅됩니다.",
        "The rendered page is checked immediately after refresh and watched for later changes. Inaccessible frames, images, canvas text, and closed components may not be detectable.": "새로 고침 후 즉시 렌더링된 페이지를 확인하고 이후 변경 사항을 감시합니다. 액세스할 수 없는 프레임, 이미지, 캔버스 텍스트 및 닫힌 구성 요소는 감지되지 않을 수 있습니다.",
        "Tips": "팁",
        "Use the overlay button to enable or disable alert sound. The preference remains selected when the monitored page refreshes.": "오버레이 버튼을 사용하여 경고음을 활성화하거나 비활성화합니다. 모니터링되는 페이지가 새로 고쳐질 때 기본 설정은 선택된 상태로 유지됩니다.",
        "Uses a case-insensitive JavaScript regular expression. Invalid expressions cannot match, so test complex expressions carefully.": "대소문자를 구분하지 않는 JavaScript 정규식을 사용합니다. 잘못된 표현식은 일치할 수 없으므로 복잡한 표현식을 주의 깊게 테스트하세요.",
        "Using random mode": "무작위 모드 사용",
        "Visible alerts across Safari tabs": "Safari 탭 전체에 표시되는 경고",
        "Visit a webpage. Tap Safari’s Page Menu button beside the search field, then choose Auto Refresh XL from the extensions list.": "웹페이지를 방문하세요. 검색 필드 옆에 있는 Safari의 페이지 메뉴 버튼을 누른 다음 확장 목록에서 Auto Refresh XL를 선택하세요.",
        "Website access, profiles, and common fixes": "웹 사이트 액세스, 프로필 및 일반적인 수정 사항",
        "What happens at zero": "0에서 무슨 일이 일어나는가",
        "What it shows": "그것이 보여주는 것",
        "XPath": "XPath"
    ],
    "zh-Hans": [
        "A new delay for every cycle": "每个周期都有一个新的延迟",
        "A positive number stops after that many cycles; zero is unlimited. The overlay shows the count.": "正数在多个周期后停止；零是无限的。叠加层显示计数。",
        "Adding": "添加",
        "Advanced Options opens inside the extension. Edit changes URL and default interval; Delete permanently removes the rule. Older wildcard rules remain supported.": "高级选项在扩展内打开。编辑更改 URL 和默认间隔；删除会永久删除该规则。旧的通配符规则仍然受支持。",
        "Allow enough time for the site to load. Refreshing very frequently can increase battery usage and mobile data use, and may trigger captchas, rate limits, or a temporary website block.": "留出足够的时间让网站加载。频繁刷新会增加电池使用量和移动数据使用量，并可能触发验证码、速率限制或临时网站屏蔽。",
        "Allow the extension": "允许扩展",
        "Allow website access": "允许访问网站",
        "Appears or disappears": "出现或消失",
        "Appears triggers when a match exists; Disappears triggers when it does not. Checks start after the first countdown.": "当存在匹配时出现触发器；当触发器不存在时，触发器就会消失。检查在第一次倒计时后开始。",
        "Auto Refresh XL Settings": "Auto Refresh XL 设置",
        "Auto-Start rules": "自动启动规则",
        "Auto-refresh and page monitoring can continue while you browse other tabs within Safari. They will not operate reliably after Safari is closed, moved into the background, or you switch to another app.": "当您浏览 Safari 中的其他选项卡时，自动刷新和页面监控可以继续。 Safari 关闭、移至后台或切换到另一个应用程序后，它们将无法可靠运行。",
        "Auto-scroll": "自动滚动",
        "Automatic refreshing, content monitoring, visible and audible alerts, and exact-page Auto-Start rules for Safari.": "Safari 的自动刷新、内容监控、视觉和听觉警报以及精确页面自动启动规则。",
        "Case-insensitive text matching. Entering text into an empty field turns monitoring on; clearing it turns monitoring off. You can manually switch it off while keeping the text.": "不区分大小写的文本匹配。在空白字段中输入文本即可开启监控；清除它会关闭监控。您可以在保留文本的同时手动将其关闭。",
        "Choose a preset or enter hours, minutes, and seconds. Press Start Refresh to begin the first countdown. Monitoring does not check immediately; its first cycle occurs only when this countdown reaches zero.": "选择预设或输入小时、分钟和秒。按“开始刷新”开始第一次倒计时。监控不立即检查；仅当倒计时达到零时，才会发生第一个周期。",
        "Compatibility": "兼容性",
        "Complete Feature Guide": "完整功能指南",
        "Contact Support": "联系支持",
        "Content monitoring": "内容监控",
        "Countdown, monitored term, and controls": "倒计时、监控项和控件",
        "Creates an email to krabople@gmail.com": "创建电子邮件至 krabople@gmail.com",
        "Cross-tab alerts": "交叉表警报",
        "Drag its header. Its position is retained across refreshes in the same tab. Closing the widget hides it until the next page load; use Stop Refresh to end the process.": "拖动其标题。其位置在同一选项卡中刷新时保留。关闭小部件会将其隐藏起来，直到加载下一个页面；使用停止刷新来结束该过程。",
        "Dynamic sites": "动态站点",
        "Editing": "编辑",
        "Email Support": "电子邮件支持",
        "Enable in Safari": "在Safari中启用",
        "Enable in Settings": "在设置中启用",
        "Enabling sound": "启用声音",
        "Enter minimum and maximum seconds. Preset and custom fields are disabled because a fresh random delay is selected after every cycle.": "输入最小和最大秒数。预设和自定义字段被禁用，因为每个周期后都会选择新的随机延迟。",
        "Find a detected result after reload": "重新加载后查找检测结果",
        "Finds an element using its page structure. XPath rules may break when a site redesigns its markup.": "使用页面结构查找元素。当站点重新设计其标记时，XPath 规则可能会被破坏。",
        "Form values are saved per tab. Closing the extension with Safari’s blue checkmark should not discard an unfinished setup.": "表单值按选项卡保存。使用 Safari 的蓝色复选标记关闭扩展不应丢弃未完成的设置。",
        "Hard Refresh": "硬刷新",
        "Hard refresh, limits, and interaction safety": "硬刷新、限制和交互安全",
        "Hidden or replaced server text, inaccessible frames, closed shadow content, images, canvas, and late components may not be highlightable.": "隐藏或替换的服务器文本、无法访问的框架、封闭的阴影内容、图像、画布和后期组件可能无法突出显示。",
        "Highlight and auto-scroll": "高亮和自动滚动",
        "Highlighting": "突出显示",
        "How it works": "它是如何运作的",
        "If it is missing": "如果未显示",
        "Intervals and countdowns": "间隔和倒计时",
        "It cannot appear on Safari internal pages, Settings, some document viewers, or websites without extension access.": "它不能出现在 Safari 内部页面、设置、某些文档查看器或没有扩展程序访问权限的网站上。",
        "Limitations": "局限性",
        "Moving and hiding": "移动和隐藏",
        "OK": "好",
        "On that screen, allow access to the websites you want to refresh. Allow for All Websites is the simplest setup.": "在该屏幕上，允许访问您要刷新的网站。允许所有网站是最简单的设置。",
        "On the desired page, choose Auto-Start Current Page. New rules save the entire URL, including path and query string, and match that exact address.": "在所需页面上，选择“自动启动当前页面”。新规则保存整个 URL，包括路径和查询字符串，并匹配该确切地址。",
        "On-page overlay": "页面悬浮组件",
        "On-screen target alerts": "屏幕提醒",
        "Open it in Safari": "在 Safari 中打开",
        "Opens the detailed feature guide": "打开详细的功能指南",
        "Other tabs": "其他选项卡",
        "Permissions and troubleshooting": "权限和故障排除",
        "Plain Text": "纯文本",
        "Plain-text and regex matches use the yellow pulsing highlight. The extension reapplies it to the newly reloaded page so navigation does not remove it.": "纯文本和 regex 匹配使用黄色脉冲突出显示。该扩展程序会将其重新应用到新重新加载的页面，因此导航不会将其删除。",
        "Please email krabople@gmail.com from your preferred email app.": "请使用您常用的邮件应用发送邮件至 krabople@gmail.com。",
        "Preset or custom refresh timing": "预设或自定义刷新时间",
        "Random interval range": "随机间隔范围",
        "Random timing can reduce repetitive request patterns and may avoid bot detection on some websites, but it does not always bypass website rules or anti-automation systems. Avoid extremely short ranges on complex pages.": "随机计时可以减少重复请求模式，并可能避免某些网站上的机器人检测，但它并不总是绕过网站规则或反自动化系统。避免复杂页面上的范围极短。",
        "Redirects and changing query parameters can produce a different final address. Edit the rule to the exact address Safari displays.": "重定向和更改查询参数可能会产生不同的最终地址。将规则编辑为 Safari 显示的确切地址。",
        "Refresh Limit": "刷新限制",
        "Refresh options and limits": "刷新选项和限制",
        "Regular Expression": "正则表达式",
        "Requests a reload that bypasses cached data where Safari supports it. Websites and service workers may still impose their own caching.": "请求重新加载，绕过 Safari 支持的缓存数据。网站和服务工作人员仍可能强加自己的缓存。",
        "Safari Auto Refresh and\nPage Monitor XL": "Safari 自动刷新 XL",
        "Safari cannot inject the banner into internal browser pages, Settings, some viewers, or pages without permission. It is not a Lock Screen push notification.": "Safari 无法将横幅注入内部浏览器页面、设置、某些查看器或未经许可的页面。这不是锁屏推送通知。",
        "Safari must remain open on screen": "Safari 必须在屏幕上保持打开状态",
        "Safari smoothly centres the detected match. The extension retries briefly for pages that render after the initial document.": "Safari 平滑地居​​中检测到的匹配。扩展程序会短暂重试在初始文档之后呈现的页面。",
        "Safari-safe audible target alerts": "Safari-安全目标声音警报",
        "Saved entries": "已保存的条目",
        "Set up the extension": "设置扩展",
        "Settings → Apps → Safari → Extensions → Safari Auto Refresh and Page Monitor XL. Turn on Allow Extension and grant the required website access.": "设置 → 应用程序 → Safari → 扩展 → Auto Refresh XL。打开允许扩展并授予所需的网站访问权限。",
        "Settings → Apps → Safari → Extensions → Safari Auto Refresh and Page Monitor XL. Turn on Allow Extension.": "设置 → 应用程序 → Safari → 扩展 → Auto Refresh XL。打开允许扩展。",
        "Sound alerts": "声音提醒",
        "Start on saved exact pages": "从保存的确切页面开始",
        "Stop on interaction": "停止互动",
        "Stops refreshing when you interact with the monitored webpage. Use this when you want a tap, click, key press, or other page interaction to end the active refresh session.": "当您与受监控的网页交互时停止刷新。当您希望通过点击、单击、按键或其他页面交互来结束活动刷新会话时，请使用此选项。",
        "Tap Page Menu beside the search field, then Manage Extensions. Switch on Auto Refresh XL and select it from Page Menu to open its controls.": "点击搜索字段旁边的页面菜单，然后点击管理扩展。打开 Auto Refresh XL 并从页面菜单中选择它以打开其控件。",
        "Tap Page Menu → Manage Extensions and switch on Auto Refresh XL. Safari profiles may require separate enabling.": "点击页面菜单 → 管理扩展并打开 Auto Refresh XL。 Safari 配置文件可能需要单独启用。",
        "Tap a feature for detailed instructions, limitations, and useful tips.": "轻点某项功能以查看详细说明、限制和实用提示。",
        "Text, regex, and XPath matching": "文本、regex 和 XPath 匹配",
        "The Ring/Silent switch, device volume, Focus modes, and iOS resource suspension can affect alerts. Webpage audio remains available as a fallback when native sound cannot be started.": "响铃/静音开关、设备音量、焦点模式和 iOS 资源暂停可能会影响警报。当本机声音无法启动时，网页音频仍然可以作为后备。",
        "The banner appears on the ordinary Safari webpage currently being viewed. View Monitored Tab returns to the source tab when needed.": "该横幅出现在当前正在查看的普通 Safari 网页上。需要时，“查看受监控”选项卡会返回到“源”选项卡。",
        "The draggable overlay shows countdown, refresh count, fixed or random mode, monitored term, Stop Refresh, and the sound toggle when monitoring uses sound.": "可拖动的叠加显示倒计时、刷新计数、固定或随机模式、监控项、停止刷新以及监控使用声音时的声音切换。",
        "The extension obtains fresh content for monitoring, performs a genuine visible Safari reload, and schedules the next countdown. Page loading time and iOS suspension can delay very short intervals.": "该扩展获取新内容进行监控，执行真正可见的 Safari 重新加载，并安排下一个倒计时。页面加载时间和 iOS 暂停可能会延迟很短的时间间隔。",
        "The iOS extension plays the primary alert sound natively, while the visible alert is routed to the ordinary Safari webpage you are viewing.": "iOS 扩展本机播放主要警报声音，而可见警报则路由到您正在查看的普通 Safari 网页。",
        "The rendered page is checked immediately after refresh and watched for later changes. Inaccessible frames, images, canvas text, and closed components may not be detectable.": "刷新后立即检查呈现的页面并观察稍后的更改。无法访问的框架、图像、画布文本和封闭组件可能无法检测到。",
        "Tips": "温馨提示",
        "Use the overlay button to enable or disable alert sound. The preference remains selected when the monitored page refreshes.": "使用覆盖按钮启用或禁用警报声音。当受监控的页面刷新时，首选项保持选中状态。",
        "Uses a case-insensitive JavaScript regular expression. Invalid expressions cannot match, so test complex expressions carefully.": "使用不区分大小写的 JavaScript 正则表达式。无效的表达式无法匹配，因此请仔细测试复杂的表达式。",
        "Using random mode": "使用随机模式",
        "Visible alerts across Safari tabs": "Safari 选项卡上的可见警报",
        "Visit a webpage. Tap Safari’s Page Menu button beside the search field, then choose Auto Refresh XL from the extensions list.": "访问一个网页。点击搜索字段旁边的 Safari 的页面菜单按钮，然后从扩展列表中选择 Auto Refresh XL。",
        "Website access, profiles, and common fixes": "网站访问、配置文件和常见修复",
        "What happens at zero": "零时会发生什么",
        "What it shows": "它显示了什么",
        "XPath": "XPath"
    ],
    "zh-Hant": [
        "A new delay for every cycle": "每個週期都有一個新的延遲",
        "A positive number stops after that many cycles; zero is unlimited. The overlay shows the count.": "正數在多個週期後停止；零是無限的。疊加層顯示計數。",
        "Adding": "添加",
        "Advanced Options opens inside the extension. Edit changes URL and default interval; Delete permanently removes the rule. Older wildcard rules remain supported.": "進階選項在擴充內打開。編輯更改 URL 和預設間隔；刪除會永久刪除該規則。舊的通配符規則仍然受支援。",
        "Allow enough time for the site to load. Refreshing very frequently can increase battery usage and mobile data use, and may trigger captchas, rate limits, or a temporary website block.": "留出足夠的時間讓網站載入。頻繁刷新會增加電池使用量和行動數據使用量，並可能觸發驗證碼、速率限製或臨時網站屏蔽。",
        "Allow the extension": "允許擴充功能",
        "Allow website access": "允許取用網站",
        "Appears or disappears": "出現或消失",
        "Appears triggers when a match exists; Disappears triggers when it does not. Checks start after the first countdown.": "當存在匹配時出現觸發器；當觸發器不存在時，觸發器就會消失。檢查在第一次倒數後開始。",
        "Auto Refresh XL Settings": "Auto Refresh XL 設定",
        "Auto-Start rules": "自動啟動規則",
        "Auto-refresh and page monitoring can continue while you browse other tabs within Safari. They will not operate reliably after Safari is closed, moved into the background, or you switch to another app.": "當您瀏覽 Safari 中的其他標籤時，自動刷新和頁面監控可以繼續。 Safari 關閉、移至背景或切換到另一個應用程式後，它們將無法可靠地運作。",
        "Auto-scroll": "自動捲動",
        "Automatic refreshing, content monitoring, visible and audible alerts, and exact-page Auto-Start rules for Safari.": "Safari 的自動刷新、內容監控、視覺和聽覺警報以及精確頁面自動啟動規則。",
        "Case-insensitive text matching. Entering text into an empty field turns monitoring on; clearing it turns monitoring off. You can manually switch it off while keeping the text.": "不區分大小寫的文字匹配。在空白欄位中輸入文字即可開啟監控；清除它會關閉監控。您可以在保留文字的同時手動將其關閉。",
        "Choose a preset or enter hours, minutes, and seconds. Press Start Refresh to begin the first countdown. Monitoring does not check immediately; its first cycle occurs only when this countdown reaches zero.": "選擇預設或輸入小時、分鐘和秒。按下「開始刷新」開始第一次倒數。監控不立即檢查；僅當倒數達到零時，才會發生第一個週期。",
        "Compatibility": "相容性",
        "Complete Feature Guide": "完整功能指南",
        "Contact Support": "聯絡支援",
        "Content monitoring": "內容監控",
        "Countdown, monitored term, and controls": "倒數計時、監控項和控件",
        "Creates an email to krabople@gmail.com": "建立電子郵件至 krabople@gmail.com",
        "Cross-tab alerts": "交叉表警報",
        "Drag its header. Its position is retained across refreshes in the same tab. Closing the widget hides it until the next page load; use Stop Refresh to end the process.": "拖曳其標題。其位置在同一選項卡中刷新時保留。關閉小部件會將其隱藏起來，直到加載下一個頁面；使用停止刷新來結束該過程。",
        "Dynamic sites": "動態站點",
        "Editing": "編輯",
        "Email Support": "電子郵件支援",
        "Enable in Safari": "在Safari中啟用",
        "Enable in Settings": "在設定中啟用",
        "Enabling sound": "啟用聲音",
        "Enter minimum and maximum seconds. Preset and custom fields are disabled because a fresh random delay is selected after every cycle.": "輸入最小和最大秒數。預設和自訂欄位被停用，因為每個週期後都會選擇新的隨機延遲。",
        "Find a detected result after reload": "重新載入後尋找檢測結果",
        "Finds an element using its page structure. XPath rules may break when a site redesigns its markup.": "使用頁面結構尋找元素。當網站重新設計其標記時，XPath 規則可能會被破壞。",
        "Form values are saved per tab. Closing the extension with Safari’s blue checkmark should not discard an unfinished setup.": "表單值按選項卡保存。使用 Safari 的藍色複選標記關閉擴充功能不應丟棄未完成的設定。",
        "Hard Refresh": "硬刷新",
        "Hard refresh, limits, and interaction safety": "硬刷新、限制和互動安全",
        "Hidden or replaced server text, inaccessible frames, closed shadow content, images, canvas, and late components may not be highlightable.": "隱藏或替換的伺服器文字、無法存取的框架、封閉的陰影內容、圖像、畫布和後期元件可能無法突出顯示。",
        "Highlight and auto-scroll": "醒目提示和自動捲動",
        "Highlighting": "突出顯示",
        "How it works": "它是如何運作的",
        "If it is missing": "如果沒有顯示",
        "Intervals and countdowns": "間隔和倒數",
        "It cannot appear on Safari internal pages, Settings, some document viewers, or websites without extension access.": "它不能出現在 Safari 內部頁面、設定、某些文件檢視器或沒有擴充功能存取權限的網站上。",
        "Limitations": "限制",
        "Moving and hiding": "移動和隱藏",
        "OK": "好",
        "On that screen, allow access to the websites you want to refresh. Allow for All Websites is the simplest setup.": "在該畫面上，允許訪問您要刷新的網站。允許所有網站是最簡單的設定。",
        "On the desired page, choose Auto-Start Current Page. New rules save the entire URL, including path and query string, and match that exact address.": "在所需頁面上，選擇「自動啟動目前頁面」。新規則保存整個 URL，包括路徑和查詢字串，並匹配該確切地址。",
        "On-page overlay": "頁面浮動小工具",
        "On-screen target alerts": "畫面提醒",
        "Open it in Safari": "在 Safari 中開啟",
        "Opens the detailed feature guide": "開啟詳細的功能指南",
        "Other tabs": "其他選項卡",
        "Permissions and troubleshooting": "權限和疑難排解",
        "Plain Text": "純文字",
        "Plain-text and regex matches use the yellow pulsing highlight. The extension reapplies it to the newly reloaded page so navigation does not remove it.": "純文字和 regex 匹配使用黃色脈衝突出顯示。該擴充功能會將其重新套用到新重新載入的頁面，因此導航不會將其刪除。",
        "Please email krabople@gmail.com from your preferred email app.": "請使用偏好的郵件 App 傳送郵件至 krabople@gmail.com。",
        "Preset or custom refresh timing": "預設或自訂刷新時間",
        "Random interval range": "隨機間隔範圍",
        "Random timing can reduce repetitive request patterns and may avoid bot detection on some websites, but it does not always bypass website rules or anti-automation systems. Avoid extremely short ranges on complex pages.": "隨機計時可以減少重複請求模式，並可能避免某些網站上的機器人檢測，但它並不總是繞過網站規則或反自動化系統。避免複雜頁面上的範圍極短。",
        "Redirects and changing query parameters can produce a different final address. Edit the rule to the exact address Safari displays.": "重定向和更改查詢參數可能會產生不同的最終位址。將規則編輯為 Safari 顯示的確切位址。",
        "Refresh Limit": "刷新限制",
        "Refresh options and limits": "重新整理選項和限制",
        "Regular Expression": "正規表示式",
        "Requests a reload that bypasses cached data where Safari supports it. Websites and service workers may still impose their own caching.": "請求重新加載，繞過 Safari 支援的快取資料。網站和服務工作人員仍可能強加自己的快取。",
        "Safari Auto Refresh and\nPage Monitor XL": "Safari 自動重新整理 XL",
        "Safari cannot inject the banner into internal browser pages, Settings, some viewers, or pages without permission. It is not a Lock Screen push notification.": "Safari 無法將橫幅注入內部瀏覽器頁面、設定、某些檢視器或未經許可的頁面。這不是鎖定螢幕推播通知。",
        "Safari must remain open on screen": "Safari 必須在螢幕上保持開啟狀態",
        "Safari smoothly centres the detected match. The extension retries briefly for pages that render after the initial document.": "Safari 平滑地居​​中偵測到的匹配。擴充功能會短暫重試在初始文件之後呈現的頁面。",
        "Safari-safe audible target alerts": "Safari-安全目標聲音警報",
        "Saved entries": "已儲存的條目",
        "Set up the extension": "設定擴充功能",
        "Settings → Apps → Safari → Extensions → Safari Auto Refresh and Page Monitor XL. Turn on Allow Extension and grant the required website access.": "設定 → 應用程式 → Safari → 擴充 → Auto Refresh XL。開啟允許擴展並授予所需的網站存取權限。",
        "Settings → Apps → Safari → Extensions → Safari Auto Refresh and Page Monitor XL. Turn on Allow Extension.": "設定 → 應用程式 → Safari → 擴充 → Auto Refresh XL。打開允許擴展。",
        "Sound alerts": "聲音提醒",
        "Start on saved exact pages": "從已儲存的確切頁面開始",
        "Stop on interaction": "停止互動",
        "Stops refreshing when you interact with the monitored webpage. Use this when you want a tap, click, key press, or other page interaction to end the active refresh session.": "當您與受監控的網頁互動時停止刷新。當您希望透過點擊、點擊、按鍵或其他頁面互動來結束活動刷新會話時，請使用此選項。",
        "Tap Page Menu beside the search field, then Manage Extensions. Switch on Auto Refresh XL and select it from Page Menu to open its controls.": "點選搜尋欄位旁的頁面選單，然後點選管理擴充。開啟 Auto Refresh XL 並從頁面選單中選擇它以開啟其控制項。",
        "Tap Page Menu → Manage Extensions and switch on Auto Refresh XL. Safari profiles may require separate enabling.": "點選頁面選單 → 管理擴充功能並開啟 Auto Refresh XL。 Safari 設定檔可能需要單獨啟用。",
        "Tap a feature for detailed instructions, limitations, and useful tips.": "點按功能以查看詳細說明、限制和實用提示。",
        "Text, regex, and XPath matching": "文字、regex 和 XPath 匹配",
        "The Ring/Silent switch, device volume, Focus modes, and iOS resource suspension can affect alerts. Webpage audio remains available as a fallback when native sound cannot be started.": "響鈴/靜音開關、裝置音量、焦點模式和 iOS 資源暫停可能會影響警報。當本機聲音無法啟動時，網頁音訊仍可作為後備。",
        "The banner appears on the ordinary Safari webpage currently being viewed. View Monitored Tab returns to the source tab when needed.": "該橫幅出現在目前正在查看的普通 Safari 網頁上。需要時，「查看受監控」標籤會回到「來源」標籤。",
        "The draggable overlay shows countdown, refresh count, fixed or random mode, monitored term, Stop Refresh, and the sound toggle when monitoring uses sound.": "可拖曳的疊加顯示倒數計時、刷新計數、固定或隨機模式、監控項目、停止刷新以及監控使用聲音時的聲音切換。",
        "The extension obtains fresh content for monitoring, performs a genuine visible Safari reload, and schedules the next countdown. Page loading time and iOS suspension can delay very short intervals.": "該擴充功能獲取新內容進行監控，執行真正可見的 Safari 重新加載，並安排下一個倒數計時。頁面載入時間和 iOS 暫停可能會延遲很短的時間間隔。",
        "The iOS extension plays the primary alert sound natively, while the visible alert is routed to the ordinary Safari webpage you are viewing.": "iOS 擴充本機播放主要警報聲音，而可見警報則路由至您正在查看的普通 Safari 網頁。",
        "The rendered page is checked immediately after refresh and watched for later changes. Inaccessible frames, images, canvas text, and closed components may not be detectable.": "刷新後立即檢查呈現的頁面並觀察稍後的變更。無法存取的框架、圖像、畫布文字和封閉組件可能無法偵測。",
        "Tips": "溫馨提示",
        "Use the overlay button to enable or disable alert sound. The preference remains selected when the monitored page refreshes.": "使用覆蓋按鈕啟用或停用警報聲音。當受監控的頁面刷新時，首選項會保持選取狀態。",
        "Uses a case-insensitive JavaScript regular expression. Invalid expressions cannot match, so test complex expressions carefully.": "使用不區分大小寫的 JavaScript 正規表示式。無效的表達式無法匹配，因此請仔細測試複雜的表達式。",
        "Using random mode": "使用隨機模式",
        "Visible alerts across Safari tabs": "Safari 選項卡上的可見警報",
        "Visit a webpage. Tap Safari’s Page Menu button beside the search field, then choose Auto Refresh XL from the extensions list.": "造訪一個網頁。點擊搜尋欄位旁的 Safari 的頁面選單按鈕，然後從擴充列表中選擇 Auto Refresh XL。",
        "Website access, profiles, and common fixes": "網站存取、設定檔和常見修復",
        "What happens at zero": "零時會發生什麼",
        "What it shows": "它顯示了什麼",
        "XPath": "XPath"
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
