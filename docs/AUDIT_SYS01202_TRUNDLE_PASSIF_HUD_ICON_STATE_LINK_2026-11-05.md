# SYS-01.2-02 — Trundle : King's Tribute et HUD, V1284

5 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-TRUNDLE-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé pour ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et périmètre

`CH-Trundle-PASSIF-PRESENTATION-HUD`, `OLF-37dfc9b7-29bb-5f00-92f2-f998c7ec92f7` : relier icône, texte et état du passif aux consommateurs actuels. Contrat a_faire, implémentation/acceptation false ; dépendance NETWORK, inconnue `OLU-2a858835-d495-5f19-968b-97a3b8f2c0c4` ouverte. Six contrats et prérequis D06/D06-CH-Trundle consultés, sans satisfaction revendiquée. SOURCE/SIMULATION-CONTRAT/SIMULATION V533/V534/V535/V641 déjà partiels : aucune association équivalente recréée.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Primaire `reference_requirement_trace_sources/trundle-existing-routes-refinement-v641.json`, 646015 octets, SHA `cbc568fa69ef5cdabade0939efa39d1801a50835931087b3d7c5673c561fd2b9`, UTC documentaire 2026-10-26T21:37:13.002506+00:00.

HUD enregistré : définition/CharScript, un catalogue. SOURCE : cinq identités natives/huit sites ; union avec V641 :17 ancres/sept fichiers. Reçu d’inspection V641,465109 octets/SHA `9e500954f9b96790ce307a96e3126ba0368d6b628ad1a006cd154a23279bb6e3`, sélectionné sur E avant unique lecture F/OpenLeague-work ; aucune relecture des cinq payloads natifs : deux INIBIN, deux Lua, font.

Définition : alias TrundleDiseaseOverseer, nom game_character_passiveName_Trundle, icône Trundle_Passive.dds. Passive1Desc/PARType absents ; champs de niveaux1/4/7 conservés comme métadonnées, sans conversion en table de soin. CharScript racine vide56 octets ; Overseer382 octets sans fonction enfant, BuffTextureName=Trundle_W.dds, persistance/non-dissipation déclarées. Ces littéraux ne prouvent pas les callbacks serveur.

Font miroir d’identité native vérifiée :2796 donne King's Tribute, soin de f2 % des PV maximum de l’ennemi mort à proximité ;4291 description qualitative ;4467 nom. **Producteur natif f2 inconnu.** Rayon local1000 et table communautaire2/3/4/5/6 % aux niveaux1/5/9/12/15 non promus en valeurs natives.

Deux DDS propres HUD/Icons2D :Trundle_Passive et Trundle_W, chacun2176 octets,64×64 DXT1, compteur brut de mips0, membre0.0.0.161 du projet0.0.1.7. SHA respectifs `afc957622e845311939379f9d8057dbeababfe17ab503bd608a9dcb157c3e84e` et `354fe3b6c9466731b09ba844825705739eafb359cff12d674d33ec0add4f2c90`. Taille/MD5 concordants ; deux stat/lectures SOURCE après sélection E,4352 octets, aucun DDS étranger/particule lu. Provider et pixels restent ouverts.

resource_provenance.json distingue le hash du porteur Mana courant de l’INIBIN natif ; la provenance communautaire finale de ce hash n’est pas requalifiée ici.

## 3. Consommateurs actuels

17 ancres,27 fichiers code/configuration et16 entrées communes vérifiés. Quatre identités Trundle/damage/world/annie_r inchangées depuis V641.

damage.rs:135 et world.rs:401 appellent le récepteur trundle_passive.rs:27 après mort par dégâts. Celui-ci filtre victime/bénéficiaires, calcule maximum victime × ratio du niveau et appelle heal. healing.rs conserve Ignite, amplification W et plafond des PV. La politique native et les expirations hors dégâts restent distinctes.

lib.rs:776 clone le joueur dans Snapshot ; client/main.rs:1331 reçoit le snapshot ; native_hud_bars.rs:10 lit health/max_health, puis actualise HPBar. **Chemin statique générique des PV établi**, sans observation nouvelle du soin jusqu’aux pixels.

native_hud_ranks.rs:7 prend déjà en charge QWER5/5/5/3 de Trundle. native_hud_spells sélectionne quatre InventoryIcon ; Trundle_W.dds est lié au slot1 de W. Cette image commune au buff n’ajoute pas de slot passif. Le widget passif Ezreal reste spécifique ; le libellé diagnostic du passif dans main.rs concerne Annie. Aucun TrundleDiseaseOverseer/Trundle_Passive/King's Tribute dans les fichiers client sélectionnés : absence de liaison nommée bornée, sans conclusion mondiale.

## 4. Attendu, observé et contrôles

Attendu : références et consommateurs exacts, acquis conservés, champs inconnus non inventés. Observé : icônes et textes identifiés, soin partiel existant, porteur générique de PV, liaison spécifique du texte/f2/icône/état non établie.

78/78 contrôles de preuves,65/65 de cohérence séparée du même agent : identités, lignes font,17 ancres, DDS/manifeste, chemins de données et limites. Refus de fin de partie/soin invalide/cible morte relevés statiquement dans heal ; non exécutés ici.

V534 rapporte37 tests de fixtures dont neuf Trundle, non relancés et non requalifiés aujourd’hui. Binaire hérité inerte787789824 octets/SHA `8ba219f17d8e5a17202514971497f54e743c867a93ebc5a55b87c9fa31696c97` : aucune copie ni relecture de ses1158 dépendances. Ni nouveau jeu/build/VM/REA/rendu/réseau, ni acceptation humaine.

Première relecture coherence01 : SyntaxError avant exécution ; script/logs conservés, unique correction de parenthèse en v2, coherence02 réussie. Deux lectures/préparations exploratoires ont échoué sur clé de schéma/motif avant correction ; aucun produit modifié.

## 5. Écarts et inconnues

f2, portée/catégories historiques, ordre, expiration hors dégâts, provider, tooltip/hover, transport spécifique éventuel et pixels restent ouverts. La question HUD enregistrée est générique : ce rapport précise désormais le chemin partiel existant sans modifier le registre gelé. QWER et NETWORK ne sont pas clos par cette unité.

## 6. Corrections et reprise

`COR-TRUNDLE-KINGS-TRIBUTE-POLICY-01` : reprendre la question SOURCE existante pour qualifier f2 et exceptions historiques. Fin : formule et frontières sourcées, reconstruction explicitement séparée.

`COR-TRUNDLE-KINGS-TRIBUTE-LIFECYCLE-01` : reprendre les questions SIMULATION existantes sur expirations, catégories et ordre. Fin : parcours concernés vérifiés, sans reconstruire le récepteur déjà présent.

`COR-TRUNDLE-KINGS-TRIBUTE-HUD-BINDINGS-01` : relier icône passive/buff, nom/texte et valeur autoritaire qualifiée au HUD ; réutiliser la barre de PV. Fin : sélection, tooltip, transitions, audiences et pixels observés ; pas de rang appris, stacks ou cooldown inventés. Reprendre sur source/callsite nouveau, dérive ou autorisation fonctionnelle ; aucune réparation produit ici.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_trundle_passive_hud_20261105` : evidence_review/coherence_review, sélection/capture V641, DDS, prérequis, resource_provenance.json, journaux et correction syntaxique. Contrôle hook7/7 réutilisé ; limites Python/contexte/TOCTOU conservées.

Rapport et ajouts CURRENT/HANDOFF uniquement, anciens octets sauvegardés et sept protégés contrôlés à la publication. Une unité documentaire close ; zéro tâche/fonctionnalité/inconnue/acceptation close. Goal/Plan/UI/bases/registres/produit inchangés ; SYS-01.2-02 actif.
