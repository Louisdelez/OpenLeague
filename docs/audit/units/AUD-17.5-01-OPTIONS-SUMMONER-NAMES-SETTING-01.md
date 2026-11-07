# AUD-17.5-01-OPTIONS-SUMMONER-NAMES-SETTING-01 — Show Summoner Names

## R1 — Portée et décision

Parent SYS-17.5-01 ; goal SYS-01.2-02 ouverts. Lot limité au checkbox ligne99 OPT-SRC-60d3f89aecba1c6e, source nommée native et trajet actuel identité→DTO→affichage. Le producteur seul ne clôt pas : relecture distincte attendue. Aucun résultat fonctionnel, pourcentage global ou acceptation humaine.

## R2 — Sources et provenance

Référence LoL4.20 PE `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`, SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ; XML/factory, en_GB ligne788, index et export antérieur épinglés dans la preuve. Quatre Game.cfg fournis identifiés : deux defaults ligne144=1, user fourni27=1, override deploy29=1. Ils ne prouvent ni sélection au runtime ni date historique de préférence utilisateur. Candidat F:/OpenLeague/Config/Game.cfg absent à ce chemin exact seulement. Catégories evtShowSummonerNames lignes355/374 : déclarations, pas binding/hotkey exécuté.

Lot DrawHealthBars, checkbox19fragments+3constantes, bool natif et Save réutilisés sans relancer leurs exports/tests/lecteurs. Audit scoreboard réutilisé pour le roster et SCORE-HOST-COLUMNS-01. Identités complètes, tailles, offsets et sources de chaque fragment dans la preuve.

## R3 — Contrat et consommateurs réels

**Menu.** ini=[HUD]ShowSummonerNames, savecfg explicite, aucun updateonclick sur contrôle/ancêtres. Le sentinel getAttrib est la chaîne null, qui ne satisfait pas makeValueToBool. Les appels applyLiveUpdate de sync/clic ne demandent donc pas de live sur cette déclaration fournie. Canonical0/1, vue Boolean(Number), NEGATEVIEW et guards CLIK réutilisés. ReadGameCfg fallback0 reste distinct des fichiers fournis1 ; Save requiert configuration/notification, sans acquittement de rendu/persistance déduit.

**Natif statique.**8345B9 associe le nom complet à837D10.83656D initialise le slot47 depuis HUD/ShowSummonerNames via8B1910 avec argument1. Le callback convertit via6F5930 et appelle835440(slot47,bool), chemin distinct du cachedbyte5D DrawHealthBars.835440 met à jour une map indexée, saute le travail si la valeur existante est identique ; insertion/changement passe par836FF0 avant8373D0.

836FF0 construit une clé entre crochets via sélecteurs section/clé, obtient une destination par686670 au contexte receiver+80 puis copie la chaîne fournie par564C20. La sémantique finale de ces destinations, le fournisseur et le renderer natif ne sont pas qualifiés. Dans le dispatch suivant, slot47→index46→octet15 à8378AE→pointeur837837 à83787C→retour direct. Ce retour ne prouve aucune absence d’effet natif : le helper de changement a déjà été appelé. Bool ASCII/locale réutilisé avec ses limites, aucune hypothèse byte5E ou contexte de mode inventée.

**Courant.** ChampionDefinition.name est le libellé du catalogue de champions. Champion complet, RosterEntry, JoinRequest deny_unknown_fields et publication snapshot ne fournissent pas de nom d’invocateur. Roster contient id/champion/team/score ; snapshot_for filtre les corps players/units par visibilité. Le rendu health::update installé après caméra avant UI Prepare dessine des Nodes/fills colorés, sans texte ou réglage nommé. La table de fin imprime p.champion. Unit.name et spawn_unit concernent des unités NPC ; la chaîne private display name est une fixture, pas une identité autoritaire.

Des helpers existent déjà : audio_announcer_actor_name et audio_announcer_name_provider exigent un backend raw_name/converted_name/cache et gèrent stockage/conversion/diagnostics. Ils ne sont pas un fournisseur live de noms de joueurs ni une nameplate. Leur SSO16 n’est pas une longueur maximale de nom ; leurs fallbacks génériques ne doivent pas devenir une identité inventée. Aucun composant existant effacé ou déclaré globalement absent.

## R4 — Attendu, observé et contrôles

Sept cas consignés avec attendu/observé : défaut, Save différé, slot, avant/après dispatch, provenance des données, helpers présents, visibilité/refus. Sept fenêtres natives nouvelles,26 instructions attendues, trois fenêtres bool réutilisées par identité et table47 relues. Recherche regex bornée à1168 fichiers : aucune occurrence du réglage/nameplate, seul display-name est la fixture ligne27 ; cette recherche est complétée par les types, publishers et rendus réels inspectés.

Source de gardes/valeurs ≠ événements physiques/refus réellement exercés. Aucun x86/AS/Rust/jeu/GUI/input/réseau, loader productif, installation, migration, export ou ancien test/lecteur exécuté. Corpus, cinq registres,25fichiers protégés et Git vérifiés avant/après ;76modifications suivies antérieures conservées. Les succès sont ceux de la vérification documentaire Python, pas des fonctionnalités du jeu.

## R5 — Manques, impact et reprise

- SSN-NATIVE-FINAL : identité/propriétaire/renderer natif et application ultime ouverts. Une lecture de nameplate/provider nommée ou trace discriminante permettra de reprendre, sans requalifier la route47 intacte.
- SSN-AUTHORITATIVE-DATA : source de vrai nom et lien player/session→DTO non établis. Reprendre sur un fournisseur approuvé ; aucun remplacement par champion/NPC/fixture, conserver les helpers.
- SSN-CURRENT-NAMEPLATE : absence de texte et de raccord dans le chemin health inspecté. Travail produit séparément autorisé, contrat natif/local qualifié, réutilisation caméra/visibilité ; le roster ne doit pas exposer de position cachée.
- SSN-APPLIED-SAVE :0/1 appliqués, noms absents/encodage, owner/session/recovery, cancel/default/Save/reload non exécutés. Reprendre avec build/assets/provider identifiés et cycle contrôlé autorisé, sans preview non déclaré.

Chaque manque et condition de reprise détaillés dans la preuve ; ils restent ouverts après clôture documentaire limitée.

## R6 — Corrections et suite

HUD-OPTIONS-ENTRY-01 et SCORE-HOST-COLUMNS-01 conservées textuellement. Une proposition distincte HUD-SUMMONER-NAMES-SETTING-01 décrit source autoritaire/DTO/nameplate, audience et sauvegarde ; critères et prérequis précis dans la preuve. Ni nouveau service de comptes, ni reconstruction scoreboard, ni réécriture des helpers. Proposition documentaire non appliquée, aucun registre modifié.

Prochain lot : LossOfControlEnabled ligne100 OPT-SRC-6af238fd7f18fde4. Examiner la stratégie effective et le consommateur réel, en réutilisant les contrats communs ; ce lot n’est pas exécuté ici.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-SUMMONER-NAMES-SETTING-01\summoner-names-setting-proof.json`, SHA256 `df39863b124fbf47e930dea181b3bdeb6d549f75a72fe3e4deb9c4f1da821715` ; producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-SUMMONER-NAMES-SETTING-01\verify_summoner_names_setting_v2.py`, fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-SUMMONER-NAMES-SETTING-01\audit-unit.json`. Relecture prévue : delivery-readback.json et INDEPENDENT-REVIEW.md dans le même dossier. Le premier producteur a échoué avant toute émission de preuve/rapport (mot-clé setting doublé) ; script et producer-failure.json conservés, correction dans un nouveau v2. Seule la relecture peut clôturer le lot documentaire borné ; parent, fonctionnalité et goal restent ouverts. Nouveaux fichiers isolés uniquement ; code/assets, goal/critères, suivi/interface/bases, registres et preuves antérieures inchangés.
