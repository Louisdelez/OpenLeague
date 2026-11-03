# BindSysKeys — checkbox conditionnée par macOS

## 1. Portée et dimensions

AUD-17.5-01-OPTIONS-BIND-SYS-KEYS-01, goal SYS-01.2-02, parent SYS-17.5-01. Une identité XML36 : OPT-SRC-6ce93b95a2c80a4a. Le lot ChampSwap précédent est un progrès vérifié. Audit : association clôturable après relecture. Implémentation : consumer nommé non qualifié, entrées locales conservées. Vérification : documentaire uniquement, aucun cas produit/OS. Acceptation humaine : non demandée. Parent et goal restent ouverts.

## 2. Sources et configuration

FoundryOptionsKeybinds.xml:36, SHA2706bdaa0d68114b5c586c8c111b8e3666ab449d55076f3ea2c07c29b794191e : checkbox ini=[General]BindSysKeys, updateonclick=true, aucun selected explicite ni gate propre. Le groupe parent XML35 porte onlyshowif=macosx. Ni la case ni ses ancêtres n’imposent strategy=input. Locale en_GB:732 : Allow Re-Binding of System Key Combinations. Octets/offsets/index et sources sont épinglés.

Defaults/Game.cfg fourni ne contient pas la clé. Config/Game.cfg:7 et deploy/DATA/cfg/game.cfg:5 contiennent General/BindSysKeys=0. Ce sont deux valeurs de fichiers, pas une valeur effective de session ni un défaut historique Mac établi. L’option appartient à Game.cfg/General ; son emplacement dans le keygrid ne la transforme pas en entrée Input.ini/GameEvents.

## 3. Frontend, plateforme et consumers

Les21fenêtres checkbox déjà acquises sont réutilisées : split ini,ReadGameCfg avec fallback0,normalisation,journal/undo,regular par défaut et Update. updateonclick=true active le chemin live ; la source ViewCheckbox appelle applyLiveUpdate depuis onClick **et** receiveModelChange. Le nom updateonclick ne garantit donc pas « uniquement au clic ». Le nombre et l’ordre effectifs des invocations ne sont pas qualifiés. Payload live,modèle changé et journal regular ne prouvent ni application OS ni sauvegarde durable. Aucun callback int10/AutoAcquire ou comportement SmartCast n’est transféré.

Le host déjà audité construit windows comme terme de plateforme sur son chemin normal PE. ModelFactory teste les termes onlyshowif du vecteur reçu. Cette lecture ne constitue pas une exécution du menu ni un consumer Mac : la référence Mac/version/handler de cette option reste à identifier. La déclaration conditionnelle reste dans le périmètre ; elle n’est ni supprimée ni présentée comme disponible sur Windows. Les règles natives de combinaisons admissibles et permissions ne sont pas inventées.

La nouvelle recherche bornée sur1168sources Rust/launcher renvoie une seule ligne : shop_text_input.rs:52 lit SuperLeft/SuperRight. Ses gardes fenêtre/focus/session (20..41) et son filtrage local (46..69) évitent d’insérer certaines combinaisons comme texte. Cela n’établit pas la réaffectation de touches système. main.rs:648..663 crée la fenêtre primaire avec défauts Bevy hors titre/résolution ; aucun consumer de cette clé n’est qualifié dans ces points inspectés. Le comportement éventuel du framework/OS n’est pas globalement exclu. native_user_settings.rs:54..75 conserve un loader générique qui peut migrer : il est lu, jamais invoqué.

## 4. Attendu, observé et contrôles

Attendu : source/config/plateforme exacte,chemins frontend et consumer partiel classifiés sans intervention OS. Observé : checkbox conditionnelle,source live et regular distinctes,deux fichiers0 ;consumer Mac et valeur effective non qualifiés. La recherche de graphies de tâches correspondantes,conservée,ne trouve pas de match exact ;les tâches clavier/remap/reprise existantes sont aussi référencées, sans preuve d’absence de tout travail équivalent.

Exécutés : recherche nouvelle et reçu code0,identités XML/config/libellé,fenêtres déjà acquises et consumers réels,critères et cohérence. Non exécutés : jeu/Rust/native/AS/GUI/réseau,émulation,clavier/capture/raccourcis/permissions OS,loader,migration,ancienne analyse/lecteur/test. Aucun texte non canonique n’est déclaré systématiquement refusé depuis la seule conversion checkbox. Les codes et empreintes du producteur et du lecteur documentaires sont conservés.

## 5. Inconnues et reprise

- SYSKEY-MAC-PROVIDER : version/source/handler Mac et raccord GetGameCfg/GetGameCfgDefault/Update de cette clé non qualifiés. Reprise : référence Mac nommée ou contrat local explicite, puis inspection de ce consumer précis.
- SYSKEY-PLATFORM-ADMISSION : environnement réel,applicabilité et combinaisons/permissions inconnus. Reprise : vecteur/contexte qualifiés et politique de plateforme. Le poste Windows n’autorise pas à exclure silencieusement cette option ni à la transposer.
- SYSKEY-LIVE-DURABILITY : effet réel,count/order,Apply/Cancel/Reset,absence/invalide et Save/restart non exécutés. Reprise : consumer et scénario isolés autorisés ;un Update n’est pas un acquittement.

## 6. Actions restantes

HUD-OPTIONS-ENTRY-01 est réutilisé pour le parcours de menu. BIND-RESTART-01 et BIND-NATIVE-PROVIDER-01 restent des fondations adjacentes dans leur portée originale de raccourcis ;elles ne qualifient pas le fichier General/Game.cfg ni la capture Mac, et ne doivent pas rediriger cette valeur vers Input.ini.

Une fiche documentaire conditionnelle **HUD-OPTIONS-BIND-SYS-KEYS-MAC-01** couvre ce seul raccord vers un consumer Mac préalablement qualifié. Sources,dépendances,travail,critères,contrôles et preuves sont dans new_proposed_corrections[]. Fin : consumer et combinaisons admises nommés,valeur0/1 avec résultat observable,contexte non applicable sans capture forcée,live/Apply/Cancel/Save/relance séparés,refus ou politique explicite pour plateforme/provider/focus/session/combinaisons réservées. Pas d’interception globale arbitraire,ni de comportement Windows inventé. Autorisation produit/runtime distincte requise. Aucun registre,état ou critère existant modifié.

## 7. Livraison et suite

Rapport/preuve isolés sur F,relecture des sept rubriques et reçus réels. Corpus1168,25fichiers protégés,5registres et Git préexistants conservés. Goal/critères normatifs/Plan/UI/bases inchangés ;aucune installation/migration/redémarrage ou modification OS.

La source XML36 était la dernière feuille pending du snapshot192nœuds. Sa clôture documentaire doit être reliée aux deux livraisons ChampionOnly/ChampSwap pour établir un bilan actualisé des157feuilles ;aucun total de fonctionnalités terminées n’en découle. Restent les13conteneurs et la frontière d’include. Prochain lot : quickbindlayout XML8 et boutons globaux normal/rapide.
