# SYS-01.2-02 — Rammus : Spiked Shell et HUD, V1261

4 novembre 2026. Unité `AUD-SYS-01.2-02-RAMMUS-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé sur ce périmètre. Implémentation, vérification du gameplay et acceptation humaine restent distinctes.

## 1. Exigence et périmètre

`CH-Rammus-PASSIF-PRESENTATION-HUD`, `OLF-f819709d-f1c1-51ad-938c-3f889e047255` : relier icône, texte, rang applicable et conversion armure→AD aux consommateurs. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; inconnue `OLU-b17a8724-1e18-5035-87c3-f38b02421eda` ouverte. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE conservés. Phase D06, lot D06-CH-Rammus et prérequis consultés, sans satisfaction revendiquée. Parent PRESENTATION et goal ouverts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Primaire `reference_requirement_trace_sources/rammus-passive-spiked-shell-links-v617.json`, 2224846octets, SHA `91fb766ea78232b2f3e226b29cd380718aaf62cc37a46035af0da731cbfbaa3e`, UTC documentaire 2026-10-26T13:51:00.044410+00:00, sans attribution à une heure d’exécution.

HUD : une définition/un catalogue. SOURCE : 40 relations/32 identités, six sites/trois fichiers. V617 : 31 sources/93 associations, 24 sites/48 liens/12 fichiers. Union : 14 fichiers/30 ancres. V617 réutilise 11 INIBIN, 11 Lua, sept preloads, un DDF et font.

L’identité SOURCE supplémentaire est `OLS-49fe6cdf-3fef-5ace-9788-df9e0d38b8b4` : DATA/Spells/Spiked Shell.inibin,44octets/SHAf8905104564fdfe583e638748a7eabb943fd406dce1ee03974a6541594922bd6,membre0.0.0.120. Sa preuve V547, `F:\OpenLeague\docs\reference_requirement_trace_sources\rammus-passive-conversion-links-v547.json`, SHA97c31a13ac3a0f92e44c59af87baa7f608d9630297895b87db4547166232490e, est réutilisée sans lecture D. Sélection du membre par observed.path, car ces lignes ne portent pas source_id ; sélection initiale vide conservée comme limite du sélecteur, pas comme absence de fichier (`supplement_membership_selection.json`).

Passive1LuaName/BuffName valent exactement « Spiked Shell » ; Lua SpikedShell.luaobj et preload spikedshell restent distincts. Spiked Shell.inibin lie game_buff_tooltip_Spiked_Shell, ligne2702 : f2% d’armure et bonus f1. Description4259 annonce 25% de l’armure convertie en AD. Les producteurs f1/f2 et la priorité des variantes restent ouverts. Passive1, description et six niveaux absents, sans zéro inventé. Persistance/non-dissipation ne prouvent pas le lifecycle.

11 Lua : six littéraux/cinq limites NEWTABLE ; CharScript natif vide56octets, communautaire vide. Six BuffData V617 résolus, plus celui du passif réutilisé de V547. DDF12lignes : seul DefensiveBallCurl/f1 armor×0,1 non vide. Ce renvoi du W à10% ne donne pas la conversion du passif à25%. Cinq candidats absents ne prouvent aucune absence globale ou corruption.

16 références communautaires comparatives : W armure/RM50/10 au rang1 contre40/40 natifs ; E durée1,25–3,25s contre1,25–2,25s, sans réduction d’armure dans ce fichier ; Q délègue un buff ; R ObjAIBase ne qualifie pas les structures. Aucun serveur original prouvé.

Deux DDS nécessaires,8448octets/un contenu,4224octets chacun,64×64 DXT5,mip brut0 : Characters/Rammus/Info membre0.0.0.40 ; Spells/Icons2D membre0.0.0.25. SHA commun0b0b6123410c2242c9f1ad3a301518e69fd395382271941086b4d149cae2b15c,MD5 2b708cc858e406e7b9e502bdcc58b071. Taille/MD5 concordent au manifeste lol_game_client0.0.1.7 ; sélection E avant deux lectures SOURCE. Lookup/pixels/variante ouverts.

Font miroir inchangé, témoin Ahri réutilisé. Mana courant/PARType absent ; source_sha256 communautaire 6966octets/SHAbc5ff42afb3ebda477dcf7f8cccdd7b52c407ecb140c142c70940305b21809d2, distinct de l’INIBIN natif2287octets/SHA25707d0ab00629c680286fa4798f0f9ebaeebce642ec76466f1745e6b05d59d5 (`resource_provenance.json`).

## 3. Consommateurs actuels

30 ancres exactes,16 entrées communes et28 fichiers code/configuration vérifiés. Aucun hit Rammus/SpikedShell/Armordillo dans ces Rust, sans absence globale revendiquée. Progression.rs:40–45 décompose AD en base/croissance/objet/autel/ajustement ; appel90–91 sans armure, calcul d’armure séparé100–104. Aucun producteur de conversion identifié dans cette route. Attaques/lifesteal/dégâts consomment l’AD courant ; HUD Mana/MPStat/PV et module Ezreal ne qualifient pas bonus f1, pourcentage f2, icône/texte du passif.

## 4. Attendu et observé

Attendu : conversion et affichage sourcés, recalcul après variation d’armure. V617 : trois cas base/Tissu1029+15armure/Épée1036+10AD. AD55,880001/55,880001/65,880005 ; armure31,384001/46,384003/31,384001. Neuf mêlées sortantes, neuf physiques entrants, trois QAnnie,81 refus,six trajets aboutis sans reprise. Neuf échantillons statistiques dont deux cycles achat/vente/rachat, six transactions publiques : vente restaure les valeurs initiales.

Calculs f32 recontrôlés : Tissu ne donne aucun AD et ne change pas les coups sortants≈46,87133PV ; Épée monte ces coups à≈55,25919. Tissu réduit les impacts entrants≈38,36845→34,43682PV ; Q ordinaire≈60,56018PV inchangé. Concordance raw×100/(100+résistance),tolérance0,002. Aucun bonus de conversion observé. Totaux illustratifs AD+25%armure63,726/67,476/73,726 non adoptés comme ordre serveur.

Échec ancien du collecteur Python1 : addition double comparée exactement à Rust f32 ; BUILD/RUN0 et relecture f32 qualifiée conservés, sans modification moteur/recompilation/rejeu. V547 visait Garen ; ici Annie. Ses neuf coups ne sont pas ajoutés aux totaux V617.

PV cible/Q sans paires brutes adjacentes ; dégâts dérivés hérités. Refus : flags sans snapshots bruts. PV source/healing_checked false ne qualifient pas soin/régénération ; aucune garde NPC universelle. Niveau1,trois profils ; aucun sort Rammus accepté, W non exercé.

Historique18fichiers/11212931octets,18pins concordants,doublons de reçus omis avant lecture. Binaire6127104octets/SHA83c31c91abe6dff8153e3770001756a25012833b4955ae46d17f12f7e9499bf3,inerte. Contrôles61/61,cohérence séparée51/51,même agent. Amorçage courant : référence erronée au précédent lot, script/erreur conservés, scope/contrat préparés réutilisés ; retour outil retranscrit, aucun faux journal brut. Aucun nouveau build/jeu/VM/REA/rendu/audio/GPU/réseau ni revue indépendante/humaine.

## 5. Écarts et inconnues

Conversion absente du chemin inspecté ; producteurs f1/f2, priorité des noms, armure négative, croissance,W/défenses temporaires,multiplicateurs/ordre/caps/arrondis,mort/respawn,lookup/provenance Mana et transport ouverts. QWER distincts. Limites V564 et deux échecs Nami conservés.

## 6. Corrections et reprise

Réutiliser `CH-Rammus-PASSIF-PRESENTATION-HUD` et SOURCE/NETWORK/SIMULATION. `COR-RAMMUS-SPIKED-SHELL-POLICY-01` : qualifier armure admissible, ordre, arrondis/caps, f1/f2 et résolution des noms. Fin : contrat4.20 sourcé, sans renvoi W10% substitué.

`COR-RAMMUS-SPIKED-SHELL-STATS-HUD-01` : intégrer conversion au calcul effectif d’AD et affichage. Fin : base/objet/croissance,W,armure négative,achat/vente/recalcul,autels/réductions/mort/respawn,attaques/critique et transport vérifiés. Reprendre sur preuve nouvelle,mapping/callsite,dérive ou autorisation d’implémenter ; aucun correctif fonctionnel ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_rammus_passive_hud_20261104` ; evidence_review/coherence_review, DDS/histoire, supplément V547, resource_provenance.json, phase_package_prerequisites.json et journaux. Captures avant assertions,hook7/7 réutilisé ; limites Python/contexte/inventaire final/TOCTOU déclarées.

Rapport et ajouts CURRENT/HANDOFF uniquement ; sauvegardes et sept protégés vérifiés avant/après publication. Une unité d’audit bornée close ; zéro tâche/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif ; goal/Plan/UI/bases/registres/produit inchangés.
