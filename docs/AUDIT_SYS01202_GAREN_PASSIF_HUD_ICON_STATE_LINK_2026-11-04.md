# SYS-01.2-02 — Garen : liaison de Perseverance au HUD, V1217

4 novembre 2026. Unité `AUD-SYS-01.2-02-GAREN-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture et publication racine. Implémentation partielle préservée ; HUD complet, fidélité native et acceptation restent ouverts.

## 1. Exigence et frontière

`CH-Garen-PASSIF-PRESENTATION-HUD`, `OLF-b18a27cd-34b8-52b1-a90e-24c8af8662d3`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance NETWORK. L’inconnue `OLU-cdada9a0-36be-59bd-8695-4cbadf4dc9a9` reste ouverte.

Ce lot relie les déclarations passif/attente/soin aux vrais producteurs de régénération et d’interruption, puis au HUD inspecté. Il conserve les acquis du moteur et les preuves réseau datées ; il ne qualifie pas tout le passif ni le kit.

## 2. Sources, identité et provenance

PUBLIC4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Deux relations HUD natives : définition `OLS-54c053ba-3fa9-5cd2-ae4f-348528a85153` et CharScript `OLS-3dbb1986-1295-5382-82b1-ce158b1ec5cb`, métadonnée client sans corps serveur original.

Les reçus garen_passive_source_audit/progress/network_validation d’octobre3 sont conservés. Quatre Lua audités sans fonction enfant : CharScript, Passive, Cooldown, Heal. Constantes et icônes ne prouvent pas la machine d’états originale.

Révision65 : reçu Garen.inibin qualifié le22 octobre, identité/champs/chaînes/membership retenus sans relecture D. Passive1Icon3810483779=Garen_Passive.dds ; Passive1LuaName=GarenPassive ; hash743602011=PassLev1Desc1. Passive1Desc4219300475 non recensé dans la table héritée ne signifie pas absent du fichier. Aucun rang numérique inventé.

Ancienne preuve font en_US explicitement séparée. Cinq clés en_GB1934/1935/1936/4190/4366 vérifiées dans le miroir F avec la provenance Ahri exacte, sans relire font D. Texte dynamique : f2 secondes, f1 santé par5 secondes, f3%HPmax ; cooldown/heal : SourceName. Aucun producteur/format de substitution qualifié. La description statique10secondes/0.4% ne fournit pas les paliers.

Le contrat local retient9/6/4secondes et0.4/0.8/2%HPmax par seconde aux niveaux1/11/16, d’après une copie republiée de notes4.17 attribuées à Riot et le texte dynamique. Provenance secondaire, conflit statique et historical_runtime_qualified=false conservés ; aucune nouvelle autorité4.20 ou vérification web revendiquée.

Inventaire exact avant les trois lectures DDS :

| Chemin | Octets / format / mip brut | Membre sous core0.0.1.7 |
|---|---|---|
| DATA/Characters/Garen/HUD/Icons2D/Garen_Passive.dds | 2176 / 64×64 DXT1 / 0 | 0.0.0.181 |
| DATA/Spells/Icons2D/Garen_Perseverance.dds | 2176 / 64×64 DXT1 / 1 | 0.0.0.25 |
| DATA/Spells/Icons2D/Garen_PerseveranceCD.dds | 5616 / 64×64 DXT3 / 7 | 0.0.0.111 |

Trois contenus SHA-256 respectifs : `799da595fda865b9a29bb1a223560d81cc6fd4e8931c292c85b4d62ef00e8fd9`, `94657ab49a0afcfcadb8de27e1168ed9078eb15330e01d0fc409453a24216305`, `4bdfe55d9e46f7cb7f4de28e91a35dbe7bd6fb9748d6b9c766e81e808e35c696`. Captures E exactes, tailles/MD5 conformes au manifeste ; aucun OLS créé. Mip brut0 ne signifie pas zéro image. Priorité, alias, pixels et rendu non qualifiés.

## 3. Consommateurs courants

Producteur partiel réel : garen_passive_per_second, note_garen_damage, règles incluses et appel par advance_regeneration. Taux supplémentaire ajouté à base/objets avant multiplicateur de soins reçus et clamp HPmax. Getter retourne0 pour mauvais champion, mort ou partie finie ; timestamp=None rend immédiatement actif. Après Some(at), délai relatif et palier du niveau courant s’appliquent.

Dégâts→note_garen_damage ; Exhaust→record_enemy_ability_hit ; TrundleE écrit aussi perseverance_interrupted_at. Cela ne couvre pas toutes les capacités. Alliés/sbires et monstres ordinaires après11 ont des exceptions dans les corps lus ; inconnus/environnement, boucliers et transitions restent partiellement reconstruits.

perseverance_interrupted_at est sérialisé avec défaut. Snapshot/projection/session/horloges existent. HUD enregistré reste le catalogue ; SOURCE comprend neuf ancres sur quatre fichiers, dont cinq sites dans deux lecteurs et trois sites Garen spécifiques. Ce n’est pas une absence de consommateurs.

Provider/StartupHud et plugins ordinaires existent ; HPBar/HPStat lisent la santé. Cela ne qualifie pas l’icône passive, le texte, le rang ou l’état d’attente/soin. Liaison dédiée non identifiée dans les sélecteurs inspectés ; QWER, Buff0 Ezreal et F3/Annie distincts. Aucune absence globale déduite.

## 4. Attendu, observé et contrôles

Attendu : préserver producteurs partiels et qualifier leurs liaisons HUD applicables. Observé : mécanique et timestamp réels, liaison dédiée non qualifiée. Sources49/49, consommateurs48/48 contrôles documentaires ; aucun nouveau scénario produit/HUD exécuté.

Seize fichiers/29 extraits communs ;11 ancres Garen/six fichiers et neuf SOURCE/quatre fichiers, union huit ;31 nouveaux pins/20 fenêtres nécessaires. Comparaisons historiques de code Garen vides : nouvelles identités/corps vérifiés, sans ancienne fidélité déduite.

Libellé source d’un ancien lot refusé puis corrigé avec archives exactes, sans recapture native. Gate consumer incomplet et contrôle CRLF corrigés avant premières sorties. Filtre ensuite corrigé pour trois lignes production classées tests :48contrôles,12hits production/28tests ; anciennes versions conservées. Aucun échec produit déduit. Première écriture de l’assembleur refusée syntaxiquement sans fichier créé ; erreur conservée.

UDP hérité : reçu du3 octobre2026 à13:50:55.278653+00:00, deux Garens opposés niveau1, Q sans injection HP/XP, timestamp répliqué,102samples/six contrôles. Régénération observée1.56738 contre1.568 de base, puis4.03381 contre4.03312 active. SHA serveur historique `ab6da73137b871ea41bfdb578344d7834edb0dae91cf2b866b5983187a1c3cc6` ; aucune équivalence avec un binaire courant déduite. Niveaux supérieurs/exceptions provenaient de fixtures. Aucun replay, build, VM, REA, GPU, réseau, audio ou rendu ici.

## 5. Écarts et inconnues

Corps serveur original, ticks/boucliers/None-source, apparition/niveaux/mort/réapparition, producteurs par capacité, f1/f2/f3/SourceName, lookup/rang/états, audiences/reconnexion et rendu restent ouverts. Ne pas convertir unité5secondes en unité1seconde sans contrat, ni un timestamp absent en état prêt qualifié.

## 6. Correction et reprise

Réutiliser `CH-Garen-PASSIF-PRESENTATION-HUD`, NETWORK et SOURCE/SIMULATION ; aucune tâche créée. Critères : qualifier textes/icônes/lookup/rangs/substitutions ; compléter politique native et producteurs manquants sans perdre les acquis ; qualifier identité/session/fraîcheur/audiences/transitions ; relier les états au HUD avec refus/retrait des données absentes/invalides/périmées/non autorisées ; vérifier paliers, sources de dégâts/aptitudes, boucliers, soins reçus, mort/reconnexion et rendu identifié ; préserver preuve UDP niveau1 et distinguer fixtures/acceptation humaine. Reprise sur primaire, mapping, nouveau producteur/consommateur ou dérive précise, sans replay inchangé.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_garen_passive_hud_20261104` : sources/captures/manifestes, consommateurs, scripts/journaux/archives, result/finalpeer. Publication racine : rapport et ajouts CURRENT/HANDOFF, sauvegardes exactes, sept protégés avant/après/readback.

Une clôture d’audit borné après contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Vérification statique et preuves partielles datées ; fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code du jeu/assets inchangés ; SYS-01.2-02 actif/partiel.
