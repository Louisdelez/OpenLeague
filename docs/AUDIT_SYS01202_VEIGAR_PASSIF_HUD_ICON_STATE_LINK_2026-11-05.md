# SYS-01.2-02 — Veigar : Equilibrium et HUD, V1291

5 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-VEIGAR-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé pour ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et périmètre

`CH-Veigar-PASSIF-PRESENTATION-HUD`, `OLF-5518a75f-1e1f-5676-b10d-ce6260a84176` : relier icônes, textes, mana manquant et régénération aux consommateurs actuels/HUD. Contrat a_faire, implémentation/acceptation false ; dépendance NETWORK et inconnue `OLU-210efa30-c84c-59ca-b9cf-0645cb2f29dd` ouverte. Six contrats et prérequis D06/D06-CH-Veigar consultés sans satisfaction revendiquée. SOURCE/SIMULATION et parent PRESENTATION restent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/veigar-passive-missing-mana-regeneration-links-v554.json`, 515593 octets/SHA `83eb85a79adb12b7e339c749395b12aeba41653db781a27ef1a266c3fcf176d0`, UTC documentaire 2026-10-25T20:10:40.575178+00:00.

HUD enregistré : deux identités natives/un catalogue. SOURCE : dix relations/cinq identités/six sites ; V554 : quatre fichiers natifs et17 frontières. Union23 ancres/dix fichiers. Les quatre directs V554 restent définition, font, INIBIN/Lua VeigarEquilibrium ; aucun preload qualifié. Lua349 entièrement parsé, zéro callback enfant, métadonnées non exécutées.

Définition Passive1=1, Passive1LuaName et BuffName=VeigarEquilibrium. Font2866/4301 : régénération augmentée de1% par1% de mana manquant ; nom4477. Ancien texte Mundo/dégâts sous40%PV, descriptions+40/60/80%regen et niveaux1/9/17 conservés sans adoption. Flags PersistsThroughDeath/NonDispellable ne prouvent pas le lifecycle serveur.

**Chemins CharScript clarifiés** : V554 constatait l’absence dans `Veigar/Scripts`. La cinquième identité enregistrée est `Veigar/CharScriptVeigar.luaobj`, à la racine :56 octets,SHA `7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0`, membre254 au manifeste enregistré. Registre/extrait existant réutilisé, aucun stat/lecture native fraîche. Pas d’absence globale ni de cinquième fichier nouvellement exécuté.

Définition Veigar_Entropy.dds et buff VeigarEntropy.dds : deux noms conservés. Deux chemins propre/shared,4224 octets chacun,64×64 DXT5,mip brut1,membres237/25 du projet RADS0.0.1.7. Même contenu SHA `40d8b895c603a868fd08d47aac1b02e914c0d069c3fcc2e8d9030c1d1afd054b` ; tailles/MD5 concordants.8448 octets lus SOURCE après sélection E. Identité des octets ne détermine ni priorité d’alias,provider,variante ou pixels.

Six archives1749364 octets sélectionnées avant lecture F/OpenLeague-work. Ancien wrapper et vérification analytique conservés ; aucun binaire ou1158 dépendances copié/rejoué. resource_provenance.json distingue StatsJSON communautaire et INIBIN natif.

## 3. Consommateurs actuels

23 ancres,30 fichiers code/configuration,16 entrées communes et18 identités V554 comparables inchangées. regeneration utilise base,croissance et objets, sans terme Veigar/mana manquant dans le chemin choisi. shop augmente les plafonds en conservant les pools absolus selon une reconstruction communautaire explicitement commentée. Fontaine et régénération demeurent des mécanismes distincts.

PV/Mana ont des chemins HUD génériques. Maxima ne prend pas Veigar en charge ; recherche Veigar/Equilibrium vide dans les sources Rust choisies. Absence bornée, sans conclusion mondiale. Aucun widget/statut passif spécifique qualifié ; loader/catalogue ne démontre pas l’affichage.

## 4. Attendu, observé et contrôles

Quatre cas publics L1 au spawn : Veigar plein,Veigar+Sapphire1027,Veigar+Sapphire+Charme1004,Annie+Sapphire. Achats400/180or et plafond+200mana vérifiés ; pools conservés selon la politique courante. Aucune injection de mana,or,XP,niveau,position ou effet ; aucun sort fonctionnel exécuté.

**116 paires de mana brutes avant fontaine recalculées en float32**, dont87 non écrêtées. Veigar+Sapphire démarre342.3999939/542.4000244,soit36.87316% manquant ; après29ticks343.5602417, taux1.2mana/s. Avec Charme :343.8496399, taux1.5. Résidus exactement nuls face au calcul base/objet ; aucun supplément Equilibrium observé dans ces deux cas. Le cas plein ne pourrait pas le valider ; Annie contrôle la régénération commune.

Quatre pulsations au tick30 recalculées séparément : plafond×15%,puis régénération ordinaire selon le moteur courant. Veigar atteint424.9602661 ou425.2596436 ; le saut n’est pas Equilibrium. Cette constante de fontaine demeure une reconstruction communautaire.32 refus flags, dont12 Learn/Cast/CastAt Veigar ; toutes les paires de snapshots complètes ne sont pas archivées.

BUILD/RUN hérités0, RUN brut égal OBS. Erreur historique binary64/f32 reproduite analytiquement :542.3999938964844 contre542.4000244140625 ; ancienne correction des deux comparaisons réutilisée sans recompilation/réexécution. Multiplicateur illustratif1+fraction manquante non adopté comme algorithme natif.

Binaire inerte6025216 octets/SHA `c98bd9d0ec2a06ba6757bb3bf6b0a59741af04fa9f5b85af46433814017de0b5`, identité non fraîchement rehashée.137/137 contrôles,112/112 cohérence séparée du même agent. Toutes productions actuelles journalisées0 ; aucune nouvelle exécution jeu/build/VM/REA/GPU/réseau ni acceptation indépendante/humaine.

## 5. Écarts et inconnues

Formule float32 native,ordre base/objets,ajustement de pools natif,autres niveaux,déficits extrêmes,coûts de sorts,mort/réapparition et lifecycle restent ouverts. Transport de la valeur/statut,HUD,tooltip,pixels,animation et audio non qualifiés. Fontaine,Charme et réserve pleine ne prouvent pas Equilibrium.

## 6. Corrections et reprise

`COR-VEIGAR-EQUILIBRIUM-POLICY-01` : qualifier formule,base concernée,ordre des modificateurs,plafonds et lifecycle. Fin : contrat historique sourcé ou reconstruction explicitement séparée ; illustration non promue en règle native.

`COR-VEIGAR-EQUILIBRIUM-REGENERATION-01` : consommer le mana manquant dans le vrai chemin de régénération selon ce contrat. Fin : L1/L18,plein/faible/vidé,achats/coûts de sorts,mort/refus vérifiés ; fontaine,Charme et autres ressources préservés.

`COR-VEIGAR-EQUILIBRIUM-HUD-BINDINGS-01` : relier icône/nom/texte et état autoritaire. Fin : deux noms/provider/priorité explicités,transport,transitions,tooltip et pixels observés ; aucun affichage dynamique inventé.

`COR-SYS01202-VEIGAR-CHARSCRIPT-PATH-SCOPE-01` : ambiguïté documentaire résolue par la distinction racine/Scripts. Aucune correction binaire justifiée par cette seule différence. Reprendre sur source/callsite nouveau,dérive ou autorisation fonctionnelle.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_veigar_passive_hud_20261105` : evidence_review,coherence_review,archives,DDS,CharScript_path_resolution,resource_provenance.json,prérequis et journaux. Hook7/7 réutilisé ; limites Python/contexte/TOCTOU conservées.

Rapport et ajouts CURRENT/HANDOFF uniquement ; sauvegardes exactes et sept protégés contrôlés à publication. Une unité documentaire close ; zéro tâche/fonctionnalité/inconnue/acceptation close. Goal/Plan/UI/bases/registres/produit inchangés ; SYS-01.2-02 actif.
