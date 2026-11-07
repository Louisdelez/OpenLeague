# SYS-01.2-02 — Viktor : Hex Core, augmentations et consommateurs VFX, V1421

6 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-VIKTOR-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé ;fonctionnalité et acceptation ouvertes.

## 1. Exigence et périmètre

`CH-Viktor-PASSIF-PRESENTATION-VFX`, `OLF-fd8fe8e8-6081-5a59-94ac-60daf688ba72` :relier prototype,stades,marqueurs d’augmentation et dépendances aux consommateurs actuels. Contrat VFX,prérequis de phase/lot,consommateurs et inconnues préservés dans initial_scope.json. V650/HUD antérieurs conservés. Attribution,AP,choix,HUD et QWER restent des travaux distincts.

## 2. Sources et provenance

PUBLIC4.20.0.315,EUW/en_GB ;build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus. Catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/viktor-passive-glorious-evolution-links-v650.json`,3389014 octets,SHA `e988dc9ab138315e193830e064147043d52c70184ec591841917e9be4570b08c`. UTC documentaire2026-10-27T01:27:12.553185+00:00. Acquisitions retenues dans E ;aucun accès renouvelé D ou F/OpenLeague-work.

37primaires :17INIBIN,15Lua,quatre preloads,font,sans DDF. 48autres identités restent du contexte. 35vues Lua héritées,27initialisations littérales,huit limites,119globals,zéro prototype enfant,lecture antérieure complète. CharScript et quatre scripts d’objets56octets vides ;cela ne démontre pas l’absence globale d’effet.

Définition1424octets,SHA `b054dbaa0d56dfa53c5687c8d7b0ce67c07c7eb6b3deec7cd2080d3b56299a89` :ViktorBlah/Viktor_Passive.dds. APPerLev388 déclare ViktorStormTimer/ViktorChaosStormGuide.dds,persistance/non-dissipation ;aucun producteur AP qualifié. Sept marqueurs Q/W/E,QW/QE/WE,QWE portent respectivement les icônes3196/3197/3198 et des métadonnées persistantes ;ni choix ni lifecycle établis. Trois AutoBuff/quatre champs concernent Slow/Stun de W,non une recette du passif. Atmas/Disintegrate restent des contextes étrangers.

Ordre3200/3196/3197/3198 :AP par niveau3/4/5/6,AP fixe0/20/40/60,mana0/150/300/500,prix incrémentaux0/1000/1000/1000. Chaîne de recette,RequiredChampion=Viktor,MaxStack=1,CanBeSold=0 ;prototype caché/SpecialRecipe=1. Descriptions6826/6823/6824/6825 et14liaisons font héritées ;f1 et ordre/producteur AP inconnus. Font4480/4304 du passif conservée,miroir vérifié sans reparcours sémantique.

Quatre preloads :Char1674,3196=99,3197=97,3198=96,soit1966octets. Identités/rôles seulement ;contenu brut et références typées non reconstitués,aucun callback déduit.

Cinq DDS relus uniquement dans E,2176octets chacun,64×64/DXT1,mips brut0,cinq contenus distincts :passif et quatre icônes d’objet. Membership hérité core0.0.1.7,membres0.0.0.251. Déclarations d’icônes réutilisées depuis native_item_audit.json après garde d’identité ;correction existante du chemin Items/Icons2D conservée. Guide manque dans le manifeste sélectionné,ViktorBlah manque dans70286noms de ce manifeste ;non-absence universelle,aucun alias inventé. Identité StatsJSON courante distincte de l’INIBIN natif ;origine supplémentaire non inventée.

## 3. Consommateurs réels

Onze entrées actuelles :huit Rust,deux Python,un JSON ;30ancres et10suppléments HUD. Sept sources/frontières,32contextes,14mécanismes VFX partagés et deux animations ordinaires concordants.

lib.rs569 initialise six slots vides. shop.rs46 expose le catalogue ;quote_with_counts86 refuse l’objet absent ;Purchase.consumed est Vec<usize>,push(slot)141 consomme des indices. progression.rs87 multiplie items.ability_power par le bonus d’autel. Ces mécanismes ne produisent pas l’AP par niveau du HexCore.

native_hud_inventory17/23 lit le snapshot puis le catalogue ;80/82 charge le JSON par ID,104 refuse l’image absente. shop_ui57/368/427/431/434 filtre le catalogue,sélectionne et affiche description/recette/vente génériques. Les quatre objets manquent du catalogue,de l’admission Map10 et du manifeste HUD ;cela n’établit pas leur interdiction historique. Aucun producteur nommé dans huit préfixes Rust de production,conclusion bornée. Owner/projection/animations/HUD génériques restent disponibles,sans qualifier le passif.

## 4. Attendu, observé et contrôles

Attendu :source précise,consommateur ou lacune bornée,refus et reprise. Observé :ressources/consommateurs reliés,chaîne spécifique non établie. **31/31 contrôles documentaires qualifiés,54/54 de cohérence séparée du même agent** ;HUD173/173 et95/95 hérités.

Deux cas archivés niveaux1/18 relus :inventaire vide à l’entrée,avant et après ;AP0 contre texte prototype3/54 ;90ticks par cas,un apport XP diagnostique,sans injection directe. Ce ne sont pas180frames brutes ni une progression naturelle.

Douze commandes témoins relues :buy1029→upgrade1031→swap0to5→sell1031→buy1052→sell1052 ;or525/75/75/600/165/470,coût450,slot consommé0,AP20→0 sur1052. Témoins ordinaires,aucune évolution HexCore. 70refus publics portent des flags sans70paires brutes ;huit devis refusés ne sont pas des achats. Annie rencontre l’objet absent avant toute restriction de champion.

Ancien diagnostic BUILD0/RUN101 :assertion attendait ID1029 au lieu d’indice0. Deux lignes33/34 seulement corrigées,source ancienne et nouvelle conservées ;code du jeu inchangé,reçu corrigé hérité,sans rejeu. Binaire6034944octets,SHA `ba4d8b7fed82f2904e13959a584a7c1d1998aaf83a52a7d0c3106e364558e3a4`,identité inerte ;trois anciens journaux et1158entrées non rouverts.

Deux échecs actuels conservés :rôle documentary refusé avant démarrage du producteur,puis30/31 car comparaison exigeait des chaînes pour les recettes3196/3197 déjà entières. Qualification d’un seul prédicat par IDs entiers,30autres contrôles et valeurs sources inchangés. Deux erreurs de consultation root(stats optionnel/encodage) conservées. Six productions réussies ;aucun nouveau build,jeu,décodage natif,REA,GPU ou réseau.

## 5. Écarts et inconnues

Attribution,admission,AP/f1,choix,sorts modifiés,horloges/mort,audiences,lookup/provider/variante,attache et pixels restent ouverts. **Le rendu du HexCore et des augmentations reste non qualifié.** Ni icône ni marqueur persistant n’établit la création d’un effet. Aucune revue indépendante/humaine ou qualification de l’inventaire secondaire complet.

## 6. Corrections et reprise

corrections_and_restart.json :quatre clauses POLICY/STATE/NETWORK/VFX,avec préconditions,fins et reprises. PROTO-GRANT,HEXCORE-CATALOG,LEVEL-AP,AUGMENT-CHOICE,GUIDE-ICON et HUD existants conservés ;premier cas possible sans exiger tout le kit.

Réutiliser les acquis inchangés ;rechercher seulement une preuve/capture/callsite nouveau répondant à une question précise. Implémentation sous autorisation distincte. next_lot.json vise Vladimir :chercher ses audits avant toute acquisition. Aucun gain chiffré de vitesse annoncé.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_viktor_passive_vfx_20261106` :evidence_review_corrected.json fait autorité,original30/31 conservé,cohérence,fenêtres,diagnostics relus,corrections,journaux. Publication limitée au rapport et aux ajouts CURRENT/HANDOFF,sauvegardes exactes,sept registres protégés.

Une unité de liaison close ;zéro tâche VFX,fonctionnalité,inconnue,acceptation ou goal clos. Goal/Plan/UI/bases/registres/produit inchangés ;SYS-01.2-02 actif.
