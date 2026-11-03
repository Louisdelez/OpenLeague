# AUD-17.5-01-OPTIONS-ENVIRONMENT-QUALITY-01 — EnvironmentQuality

Date : 2026-10-31T07:48:19.275208+00:00. Parent SYS-17.5-01 / OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46 / OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd. Goal SYS-01.2-02 inchangé.

## R1 — Portée et fin

Un seul réglage :[Performance]EnvironmentQuality,du XML Options aux lecteurs et usages du code actuel. Identité,niveaux,preset,repli,chargement,usage des ressources et limites de modification/persistance sont reliés. Aucun audit de toute la vidéo. Le producteur livre les preuves ;la clôture documentaire appartient à la relecture indépendante.

Audit : source/consommateurs inspectés. Implémentation : lecteurs et effets présents,cycle Options/persistance non établi. Vérification : statique/documentaire,preuves d'exécution antérieures réutilisées à leur date. Acceptation humaine : non demandée. Fonctionnalité,parent et goal non terminés.

## R2 — Sources et provenance

Nœud `OPT-SRC-761ea55571f86c15` de FoundryOptionsMenu.xml ligne33,hash 4859ef32283b8f22b69c202299ce5240e199cd7cde9f709fa67360d0270470de. Ses cinq enfants option lignes34–38 portent les valeurs textuelles0..4 et leurs labels. graphicslookup=0,1,1,2,3,3,4 ;parent graphicsslider ligne23,strategy=savecfg. Routes ModelDropdown/ViewDropdown/GraphicsLookup et ModelGraphicsSlider reliées aux scripts réels de l'export306 existant,aucun nouvel export.

Contrat natif réutilisé :ID16,Performance/EnvironmentQuality,défaut entier3,dispatch0x837630,getter0x835080. Anciennes126 lectures et9 defaults ;suffixe qualité0x8376dd..0x837724 (980cas,avant rebuild) ;suffixe fog0x8376cc..0x837729 (1408cas,callbacks limités). Le PE est identifié par SHA402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Ces cas ne sont pas rejoués et ne prouvent pas le menu entier.

Les Game.cfg par défaut original et actuel sont identiques :SHA02c41cb9a5068f8bc993435557fd7b159bddbcda1f022605d284d9ea51d72b0e. GraphicsSlider=3 ligne213 et EnvironmentQuality=3 ligne216. Le mapping XML au preset3 donne2. Ce sont trois faits de source :pas une preuve que le menu visible sélectionne2,ni d'une écriture indue. L'ordre d'initialisation/synchronisation et le fournisseur effectif restent à qualifier.

## R3 — Consommateurs réels

AS statique :ModelDropdown.init et restoreDefaults lisent CFG avec repli textuel"0",distinct du défaut entier natif3. setValue ignore une chaîne absente des valeurs ;setSelectedIndex ne change la valeur que dans les bornes mais émet CHANGE même sinon. ViewDropdown.onChange appelle le modèle puis USER_CHANGE ;ce handler n'écrit pas directement l'INI. Le parent déclare savecfg et applyInheritance copie la stratégie absente dans l'objet enfant ;son ini direct fournit Performance/EnvironmentQuality. Les contrats de journal,Save,Cancel et Defaults sont réutilisés et gardent leur limite d'ack/atomicité.

ModelGraphicsSlider applique son index aux GraphicsLookup des enfants ;le mode CUSTOM recherche un index qui corresponde à tous les enfants,donc EnvironmentQuality seul ne suffit pas à reconstituer le preset. UnifBaseModel crée les enfants avant le retour d'Interactive.init ;ModelApplication reset le serializer après cette création et OnSyncOptionValues peut sérialiser après synchronisation. Ces méthodes empêchent de conclure sur le résultat initial à partir des seuls defaults.

Code courant :main.rs607 charge via native_user_settings::load_using ;load_text_files fusionne user/default ;environment utilise Performance/EnvironmentQuality,read_integer_value et IntegerOptions ;main.rs612 lit ID16 et applique Quality avant insertion de la ressource ligne803. Ce chargeur peut créer un dossier et renommer Game.cfg lignes61/66 :il n'est pas exécuté.

Quality.apply borne0..4 et incrémente une révision avec bouclage seulement en cas de changement. map_fog::setup,au Startup,construit draw_modes et selector7_names à partir de quality.value. Le bind utilise ces valeurs pour les matériaux. native_high_fog::advance,au Update,lit la qualité à chaque passage pour les uniformes fog/clouds ;projected_terrain::collect,au PostUpdate,copie la qualité pour sélectionner les receveurs. selector7_depth::synchronize lit les noms du catalogue et entretient les phases de profondeur. Aucune mise à jour complète de ce catalogue sur changement de Quality n'est établie par ces consommateurs ;fog dynamique seul ne prouve pas un rebuild complet.

Recherche groupée des alias et usages :64 lignes candidates dans10 fichiers du corpus1168,identités et appartenance vérifiées. Les tests/commentaires restent des candidats ;les fragments de production ci-dessus fondent les rôles réels. Aucun graphe exhaustif d'appels indirects revendiqué.

## R4 — Vérifications,attendu et observé

- XML exact,nœud unique,cinq choix,mapping sept entrées,parent/strategy et absence de datasource direct :concordants.
- 25 méthodes AS et16 fragments courants identifiés par fichier/hash/lignes ;gardes des chaînes/index/replis et routes de chargement/scheduling contrôlées dans les sources. Aucun AS/Rust exécuté.
- Comptage documentaire des87 enregistrements de matériaux selon les prédicats inspectés :qualité0→4 modes blended/0 noms selector7 ;qualités1..4→10/6. Ce calcul ne rend pas une image et ne remplace pas un test du module.
- Trois captures du5octobre restent identifiées (ancien client e7a98a4e…,qualités3/1/4,logs et PNG concordants). Pas de nouvelle inspection visuelle,de nouveau lancement ou de qualification du binaire actuel. Les anciennes sources main.rs/native_user_settings.rs et le lecteur graphique ont évolué :les anciens244/255 tests ne deviennent pas des tests de leur état courant.
- V715 conserve la preuve plus récente du parser/cache générique et de15 cas du vrai module texte. Le réglage testé était x3d_platform ;aucune qualification EnvironmentQuality spécifique ou composition complète n'en est déduite. Les identités courantes de ses consommateurs sont vérifiées.
- Contrôles de gel :corpus1168,25 fichiers protégés,5 registres et Git avant/après. Aucun Goal,critère,Plan/UI,base,produit,asset ou ancienne preuve modifié.
- Non exécutés :chargeur productif,test Rust,client original,x86,AS,GUI,input,GPU,réseau,installation,migration,rebuild ou écriture de configuration.

## R5 — Écarts et reprise

- **ENV-Q-OPTIONS-CYCLE** :An actual current Options widget→journal→apply/cancel/reset→persistence path for this one setting is not established by inspected consumers. Impact :Read/effect code cannot close the Options functionality. Reprise :Product/UI work separately authorized plus selected source/runtime contract;reuse HUD-OPTIONS-ENTRY-01,Save/Cancel/Defaults and this widget identity;observe normal,invalid,apply,cancel,reset,reopen/restart.
- **ENV-Q-INIT-SYNC** :Effective native init/SyncOptionValues/provider sequence resolving the source preset/default mismatch and missing-key fallbacks. Impact :No initial selected value,unintended write or historical UI bug claimed. Reprise :New isolated native/AS observation authorized for this exact menu/context,or an explicitly versioned reconstruction policy;do not alter default data on the basis of two literals.
- **ENV-Q-DERIVED-STATE** :A change at runtime is not shown to rebuild catalog.draw_modes/selector7_names and retire derived materials/depth children coherently. Impact :Per-frame fog/profile propagation is not complete dynamic environment switching. Reprise :Reuse startup/per-frame source fragments;qualify0→3→0 with changed derived caches,existing/new materials,depth-child removal,projection and fog updates plus cancel rollback;no new broad source research needed.
- **ENV-Q-LOCALE-PROVIDER** :Complete native selected provider/overlays and localized user-file integration for this setting. Impact :Generic x3d_platform15-case proof does not determine this setting’s effective historical/current file selection. Reprise :Reuse V715 generic parser/cache evidence;require EnvironmentQuality-specific input/provider selection or explicit local policy. Current load_using requests user/default,not localized discovery.
- **ENV-Q-RENDER-FIDELITY** :Full native callbacks/rebuild987600/LOD/pass order and current-vs-original framebuffer equivalence. Impact :Source-linked effects and old diagnostic captures do not prove visual fidelity or full game completion. Reprise :Use native getter/quality/profile/material contracts and exact new renderer lead;separate native execution,source integration and GPU/render comparisons.

Les deux includes internes manquants conservent leurs recherches et conditions de reprise dans le recensement précédent ;aucune recherche de ces fichiers relancée. Ils empêchent une couverture globale du menu mais n'empêchent pas l'identification de ce dropdown présent.

## R6 — Corrections réutilisées

HUD-OPTIONS-ENTRY-01 est conservée,proposée/non appliquée. Son objectif ouvrir/modifier/appliquer/annuler/fermer reçoit ici les entrées précises du réglage ;les IDs d'écart ci-dessus sont documentaires,pas de nouvelles tâches ou critères normatifs. Le contrat de reprise doit préserver lecteurs et usages existants,les deux replis distincts,et qualifier init/sync et caches dérivés avant d'accepter apply/cancel/reset/persistance. Aucun doublon de correction. HUD-QUIT-DIALOG-LIFECYCLE-01 est conservée hors de cette portée.

Prochain sous-audit indépendant :AUD-17.5-01-OPTIONS-KEYBIND-CAST1-01,première capacité et variantes normale/rapide,avec son entrée réelle et ses limites de rebind/focus. Les questions natives sans entrée nouvelle sont arrêtées à leurs conditions de reprise ;pas de réexport ni d'analyse native répétée.

## R7 — Livraison et relecture

Preuve neuve :`F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-ENVIRONMENT-QUALITY-01\environment-quality-proof.json` (SHA01218925680afbba767ab82f7ad3b3f51a9bd13c89f72df5a81099807fb0ebdb).

Script neuf :`F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-ENVIRONMENT-QUALITY-01\verify_environment_quality.py` ;fiche :`F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-ENVIRONMENT-QUALITY-01\audit-unit.json`. Relecture séparée :`F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-ENVIRONMENT-QUALITY-01\verify_delivery.py` →`F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-ENVIRONMENT-QUALITY-01\delivery-readback.json` et `INDEPENDENT-REVIEW.md`.

Les identités complètes,fragments,attendu/observé,versions divergentes et limites sont dans la preuve. Seuls ces nouveaux artefacts documentaires et ce rapport sont écrits. SYS-17.5-01,SYS-01.2-02 et toutes les cases antérieures restent ouverts/inchangés ;aucun pourcentage du jeu n'est calculé.
