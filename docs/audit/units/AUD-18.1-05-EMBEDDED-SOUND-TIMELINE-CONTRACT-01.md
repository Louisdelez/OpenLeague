# SYS-18.1-05 — sons intégrés et timelines natives

2026-11-02T01:05:48.135965+00:00

Audit statique fini avec trois bornes précises,sous réserve de sélection de la relecture indépendante. Aucun fonctionnement média,implémentation ou parent complet.

## Résolu
Les26DefineSound,37StartSound et115SoundStreamHead2 sont rapprochés de leurs octets,carrier/version,ID,frame déclarée,timeline et symboles. Quatre SWF portent ces sons,parmi les huit profils déjà qualifiés. Tous les sons possèdent au moins un événement ; aucun son ne reçoit de nom exporté direct. Les IDs restent locaux au carrier : ID21 de CLB et ID21 de LSI ne sont pas fusionnés.
Les26sons sont déclarés codec2/rate3 ; le seek MP3 signé est conservé séparément des octets de trames. Les37SoundInfo ont flags0 et font trois octets avec SoundId : champs de boucle,enveloppe,in/out absents,aucun zéro ou défaut runtime inventé. Aucun décodeur MP3 n’est exécuté.
Les36événements nommés sont reliés à leurs SymbolClass de clips. Le son microfeedback restant est sur sprite62/frame9 ; une instruction PlaceObject2 à offset85289 place ce clip à profondeur1/frame1 dans sprite77 PopupDriver. La source AS PopupDriver et sa constante LINKAGE sont identifiées ; aucun callback/timeline réellement exécuté.
Liaisons applicatives :12événements de badges par kudos.CeremonyBadge+param2,10par expressions LeagueTier/seeding/Master,6par chaînes exactes CelebrationDialogue/SummonerIconCeremonyDialogue,un par placement vers PopupDriver. Huit événements TierPromotionDialogue-* restent liés à un préfixe natif dont le producteur de variante n’est pas établi dans les sources ciblées. Les FQCN applicatifs et noms de symboles ne sont pas fusionnés.
Les115en-têtes portent codec0,samples0 et aucun SoundStreamBlock dans les huit profils. Ils ne sont pas115pistes audio. Les octets sont47×0e000000,53×0f000000 et15×26000000. Pour ces15en-têtes microfeedback,le nibble réservé vaut2 ; la [spécification Adobe v19](https://open-flash.github.io/mirrors/swf-spec-19.pdf) le décrit à zéro. C’est un écart de format de la source native admise,conservé sans réécriture ; son impact réel reste inconnu.

## Limites et reprise
- AIR-AUDIO-CLB-TIER-SYMBOL-VARIANT : Eight events use hyphenated TierPromotionDialogue-* symbols. Targeted TierPromotionDialog calls only the base linkage; exact variant producer is unresolved. Reprise : Inspect the specific skin/linkage resolver,asset loader/configuration and native caller selecting these eight names during the upcoming transition audit. Reuse these symbol IDs and exact constructor; do not infer matching from prefix.
- AIR-AUDIO-MF-RESERVED-STREAM-HEADER : Fifteen admitted native microfeedback SoundStreamHead2 records have reserved nibble2 (raw26000000),where Adobe v19 specifies zero. No SoundStreamBlock is present in these carriers. Reprise : Retain each offset and source identity. Qualify actual AIR tag-reader tolerance only in separately authorized native/runtime work; do not modify headers or infer audible corruption.
- AIR-AUDIO-EMBEDDED-RUNTIME-SEMANTICS : Static tag/frame/symbol links do not verify decoding,actual timeline entry/replay,volume,concurrency,codec latency or sounds heard. Conditional SOUNDINFO fields absent in all37native events are not runtime defaults. Reprise : Use each carrier+soundID,event offset and timeline state in a separately authorized runtime/implementation task. Preserve signed MP3 seek and distinguish event sound from streaming audio; no synthetic loops/envelopes or silent placeholders.

La consultation web du document primaire Adobe hébergé par un miroir vérifie l’interprétation du format. L’URL Adobe essayée une fois répond404 ; aucun téléchargement de document ou de source LoL n’a été réalisé. Cette consultation est distinguée de l’interdiction d’acquisition HTTP native du lot.
Les preuves précédentes restent conservées : sources externes manquantes,rôles inconnus,casse,contexte host FLV,volume et horloges. L’audit n’établit aucune écoute,continuité,latence effective,fuite ou corruption audible.

## Contrôles réellement exécutés
Lecture ciblée des178enregistrements et en-têtes de sprites,comparaison aux matrices qualifiées et hashes,liaisons carrier/ID/frames/symboles,75placements microfeedback examinés pour une question nouvelle,neuf classes AS et34fenêtres exactes. Les requêtes AS globales et frontend/Tauri précédentes sont réutilisées sans les relancer.
Sept refus locaux du lecteur binaire sont exercés en mémoire : en-têtes MP3/StartSound/stream tronqués,boucle optionnelle manquante,bits réservés d’événement,trailing byte et latence MP3 absente. Ils testent le vérificateur documentaire,pas un joueur ou un scénario du jeu. La séparation des IDs inter-SWF est aussi vérifiée.
Relecture indépendante séparée : identités sources,champs,liaisons,limites et sorties liées aux SHA. accepted-delivery.json sélectionne les preuves ; le statut normatif de SYS-18.1-05 reste a_faire.

## Écritures et suite
Ajouts uniquement : F:\OpenLeague-work\audit-units\AUD-18.1-05-EMBEDDED-SOUND-TIMELINE-CONTRACT-01 et ce rapport,plus préparations statiques E. Aucun goal,critère,registre,produit,Plan ou base modifié ; aucune installation,migration,relance,suppression,export média ou exécution AS.
Prochain lot : couverture des97fichiers natifs déjà repérés pour les transitions,leurs vrais appelants et dépendances précises. Ne pas relancer une recherche globale sans question nouvelle ; reprendre notamment la liaison des huit variantes CLB.
