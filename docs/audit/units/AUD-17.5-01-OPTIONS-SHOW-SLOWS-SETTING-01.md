# AUD-17.5-01-OPTIONS-SHOW-SLOWS-SETTING-01 — ShowSlows

## R1 — Portée et décision

Un checkbox ligne101 OPT-SRC-0583d050f5a16ebc, son filtre natif et le trajet actuel ralentissement→affichage. Parent SYS-17.5-01 et goal SYS-01.2-02 ouverts. Producteur seul non clôturant, relecture séparée attendue. Audit borné distinct du rendu fonctionnel non exécuté et de l’acceptation humaine non demandée.

## R2 — Sources et provenance

PE4.20 `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`, SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ; XML/factory/index et export AS épinglés. Deux default Game.cfg51=0 ; user fourni81=1 ; deploy override sans clé exacte. F:/OpenLeague/Config/Game.cfg absent à ce chemin seulement. Aucun fichier sélectionné au runtime. en_GB787 : Show Slows in Loss of Control UI. Ne pas appeler1 un défaut historique : il appartient au fichier utilisateur fourni.

LossOfControlEnabled/relecture422, checkbox19fragments+3constantes et Save réutilisés sans réexport/anciens tests ou lecteurs. Ressources LossOfControl25+36définitions, archives, listes et réparation BaseOffset17bytes/8024 avec2warnings conservées par référence aux champs exacts et empreintes de l’audit précédent, sans reparsing/archive scan ou reconstruction. Cet acquis n’implique pas activation/dessin.

## R3 — Contrat et consommateurs réels

**Menu.** [LossOfControl]ShowSlows, savecfg explicite, différent du regular de LossOfControlEnabled. Aucun updateonclick sur contrôle/ancêtres : sentinel chaîne null et makeValueToBool ne demandent pas de live. Init canonique0/1, GFXfallback0, NEGATEVIEW, guards CLIK et journal/Save réutilisés. Mutation config/notification n’est ni acquittement de rendu ni durabilité. Valeurs invalides du getter natif non qualifiées par analogie avec un autre callback.

**Natif statique.** Trois lectures directes ShowSlows/LossOfControl via8B1910.5A9B04 et7D86A8 passent0/0 ; à7C33C2, la sortie du decEBX/jne non pris donne EBX0 aux deux push. Sources conditionnelles, pas exécution du provider.

À5A9B72, un candidat local5C et AL vrai permettent EBX←[1086808],ESI9 ; sinon fallback, autres candidats antérieurs conservés. À7C33BF, boucle cinq entrées de stride18 : BL faux et indexEDX2 sautent au pas suivant3425 ; BL vrai garde la comparaison/sélection normale. À7D86BC, résultat ensuite copié au local de pile1FE, publication finale non qualifiée. Ni5E transféré, ni appartenance d’équipe ou enum native inventés. L’identité complète candidat2/ESI9, priorité/label/time et renderer final restent ouverts. Aucun appel6F5930 dans ces fenêtres : ne pas lui emprunter un contrat de parsing cfg qu’il ne prouve pas.

**Courant.** Slow contient tag/fraction/expires_at, API serveur avec preflight/commit/expiry ; garde finite,0<fraction<=1,durée/tag, cible morte/inconnue et politique NPC explicitement locale. Le tick appelle advance_slows. Champion movement consomme strongest avec zone/soft-cap existant ; NPC conserve son budget linéaire et strongest timed/zone. Exhaust est un vrai producteur contrôlé par cible/range/visibilité. Cet inventaire n’audite pas toutes les valeurs/sorts/immunités ou formules natives.

Le snapshot clone les corps player/NPC, avec Slow et filtre de destinataire sur les corps visibles. Le type ne fournit pas à lui seul la métadonnée d’affichage native, priorité/icône/label ou autorisation fine de chaque champ. Le réglage de présentation ne doit ni supprimer un slow, changer sa durée ou annuler le mouvement. Les icônes de sorts utilisent déjà des états de stun ; ce n’est pas l’affichage du slow.

Startup/provider/repair et sélecteurs18Text/3cadres/QWER-D/F repris inchangés du lot précédent. Aucun raccord nommé ShowSlows ou slow-HUD dans les1168fichiers bornés ; cette recherche est complétée par les vrais producteurs/mouvements et sélecteurs de rendu. Gameplay, ressources, conversions et UI existants conservés, pas déclarés globalement absents.

## R4 — Attendu et observé

Sept cas consignés : défaut/user, Save différé, conditionnative, filtre2, gameplay existant, limites du rendu et refus/application restant à vérifier. Trois fenêtres natives et32instructions attendues nouvelles.19fragments AS/3constantes, corpus/source, registres/fichiers protégés et Git relus. Contrôles documentaires Python seulement ; aucun ancien test/lecteur/native parse, x86/AS/Rust/jeu/GUI/input/réseau/loader productif, installation, migration ou restart exécuté. Les gardes et tests présents ne sont pas rapportés comme nouvellement exercés.

## R5 — Manques et reprise

- SLOWS-NATIVE-CATEGORY : mappingcandidat2/ESI9, label/durée/priorité et rendu aval inconnus. Reprise sur source/type→display nommée ou trace discriminante ; contrat local explicite autorisé possible, pas de nouvelle recherche des mêmes clés.
- SLOWS-CURRENT-DISPLAY : ralentissement réel présent, métadonnées et UI de contrôle encore incomplètes. Réutiliser BUFF-LOSS-CONTROL-01 et BUFF-CATALOGUE-PUBLIC-01 pour un effet supporté/autorisé, pas reconstruire tous les slows.
- SLOWS-SETTING-BRIDGE : filtre savecfg et interaction avec activation globale non raccordés. Reprise produit autorisée après qualification du consommateur ; présentation seulement, autres candidats/visibilité/session/recovery préservés.
- SLOWS-SAVE-RELOAD : défaut0/user1 effectivement sélectionnés, Save/ack/cancel/default/reload/refus UI non exécutés. Build/assets/provider/cycle contrôlé nommés requis ; ne pas transformer une lecture cfg en rendu ou persistance.

Impacts et conditions discriminantes détaillés dans la preuve ; ces manques restent ouverts après le seul audit documentaire limité.

## R6 — Corrections et suite

HUD-OPTIONS-ENTRY-01, BUFF-LOSS-CONTROL-01, BUFF-CATALOGUE-PUBLIC-01 et HUD-LOSS-CONTROL-SETTING-01 réutilisées sans changer leurs définitions. Proposition HUD-SHOW-SLOWS-SETTING-01 limitée à ce filtre, dépend du catalogue/consommateur existant et ne duplique ni renderer ni mécanisme de ralentissement. Critères : un effet nommé exclu0/inclus1 selon priorité qualifiée, autres contrôles et gameplay inchangés, défaut0/user1 et savecfg/no-live, cycle et rendu réellement vérifiés. Aucun registre modifié, proposition non appliquée.

Prochain lot : EnableHUDAnimations ligne102, updateonclick=true, stratégie effective et vrai consommateur HUD à qualifier. Ne pas l’assimiler à toutes les animations de champions/effets. Ce lot suivant n’est pas exécuté ici.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-SHOW-SLOWS-SETTING-01\show-slows-setting-proof.json` SHA256 `4b3e04f24aa58b1fb58527cc86453725c54535feee0f72299915bfb2d72413de` ; producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-SHOW-SLOWS-SETTING-01\verify_show_slows_setting.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-SHOW-SLOWS-SETTING-01\audit-unit.json`. Relecture séparée attendue dans delivery-readback.json et INDEPENDENT-REVIEW.md. Seul le périmètre documentaire pourra être clos ; fonctionnalité/parent/goal ouverts. Nouveaux documents isolés seulement ; goal/critères, code/assets, suivi/interface/bases, registres et anciennes preuves inchangés.
