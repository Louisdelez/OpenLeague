# SYS-01.2-02 — Corki : liaison de RapidReload au HUD, V1206

4 novembre 2026. Unité `AUD-SYS-01.2-02-CORKI-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture et publication racine ; mécanique, HUD complet, rendu et acceptation restent ouverts.

## 1. Exigence et frontière

`CH-Corki-PASSIF-PRESENTATION-HUD`, `OLF-7ee8cf6c-0846-57ce-a740-41d9b2fd6d28`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance `CH-Corki-PASSIF-NETWORK`. L’inconnue `OLU-ff6bb908-82e8-5939-98b2-c2958d5f100b` reste ouverte.

Le lot rapproche les ressources RapidReload/Hextech Shrapnel Shells des consommateurs HUD inspectés. Arithmétique True, événement monde, déclenchement passif et présentation restent distincts. V561 est une preuve datée, sans transfert de clôture ni nouveau combat ou contrôle arithmétique.

## 2. Sources, identité et provenance

Référence PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Six identités V561 sont réutilisées, non rouvertes : nouvelle empreinte documentaire distincte d’un hash D frais. SOURCE porte 9 relations/6 identités ; HUD une relation vers Corki.inibin, `OLS-bba4fe4b-1b38-5fb0-9ece-32f2c210f881`.

`Passive1LuaName=RapidReload`, `Passive1Icon=Corki_RapidReload.dds` et les globals du buff concordent. Deux Lua hérités littéraux sans prototype enfant, CharScript vide et un preload ne prouvent aucun serveur ou rendu. PersistsThroughDeath/NonDispellable restent déclarations. Passive1 absent n’est pas remplacé ; la phrase Annie «cinq sorts» et les niveaux1/4/7/«10»/13/16, dont10 stocké comme texte, ne deviennent ni règle Corki ni politique de rang. Aucune règle moderne importée.

Inventaire préalable puis lecture de deux DDS, 8448 octets :

| Chemin sous DATA | Octets / format | Membre |
|---|---|---|
| Characters/Corki/Info/Corki_RapidReload.dds | 4224 / 64×64 DXT5 | 0.0.0.25 |
| Spells/Icons2D/Corki_RapidReload.dds | identique | 0.0.0.25 |

Un contenu SHA-256 `9858f3f2ad8518e0c21d0ff4e7fec9799deb3e313910aec10278713c2e108ba1`. Taille/MD5 concordent au manifeste sélectionné lol_game_client0.0.1.7. Aucun OLS créé ; résolution, priorité, variante et pixels rendus inconnus.

Trois textes exacts du miroir F en_GB, lignes2510/4176/4352, nomment Hextech Shrapnel Shells. Le tooltip annonce un supplément de dégâts vrais égal à10% de l’AD total, hors structures ; la description cite sbires, monstres et champions. Aucune substitution dans ces trois chaînes, mais échantillonnage AD, déclencheur et état/audience restent non qualifiés. Provenance : identité font V561, reçu Ahri exact et empreinte F comparée ; Font D non relu, locale effective et rendu ouverts.

## 3. Consommateurs courants

Le CID HUD enregistré `OLC-93924678-ea15-5516-8f55-08616c5450cc` est le catalogue appelé par `Simulation::new`. Catalogue et cinq sites de lecteurs SOURCE ne sont pas des producteurs RapidReload ou des widgets.

Provider/StartupHud et plugins ordinaires existent. Le manifeste déclare sept entrées Corki : quatre InventoryIcon principales et trois variantes Q/R, zéro unresolved. Setup filtre InventoryIcon ; ces variantes, dont Big de R, ne sont pas sélectionnées dynamiquement par ce corps. Cette limite adjacente ne constitue pas un nouvel audit de Q/R. Présence des icônes ne prouve pas des sorts implémentés.

Les 18 textes, 11 barres/fonds et 14 widgets QWER/D-F sélectionnés n’identifient aucun binding RapidReload icône/texte/rang/état. Buff0, texture BuffIcon0 et BuffStack0 restent liés à Ezreal ; Annie4, F3 et stun QWER conditionnel restent distincts. La recherche nommée .rs core/client/server corrobore les corps lus, sans absence globale de code, alias ou assets.

advance_attacks/basic_attack_hit produisent les attaques physiques ordinaires ; leur échantillonnage AD n’est pas celui d’un passif qualifié. mitigate possède une branche True et apply_damage consomme génériquement ce type ; aucune liaison RapidReload n’en découle. Le récapitulatif agrège True et affiche des montants sous «Brut» via son canal propriétaire/mort/session, sans identité capacité/buff, icône/rang/état RapidReload. Ce trajet conditionnel réel n’est pas un déclencheur du passif ni un rendu observé dans ce lot.

## 4. Attendu, observé et contrôles

Attendu : ressources et états autoritaires reliés aux audiences et widgets qualifiés. Observé : sources identifiées et voies génériques réelles, sans binding RapidReload établi dans le trajet inspecté. Sources49/49 et consommateurs33/33 contrôles documentaires ; deux DDS lus, un parse manifeste. Gardes/omissions, refus Learn/Cast/CastAt et ordre shop_guard lus seulement ; aucun nouveau nominal/refus HUD exécuté.

Seize pins/29 fenêtres communs, onze fichiers/22 sites V561 et deux readers/six sites SOURCE concordent. Auxiliaires V1200 2/11,V1201 1/3,V1202 2/3,V1203 2/9,V1204 1/2 réutilisés ; trois configurations/neuf fenêtres directes sélectionnées. Inventaire1219 hérité sans census ;1334pins source V561, dont ancien corpus1158, non rehashés globalement.

V561 conserve quatre cas publics : trois contre champion, six impacts chacun, et deux impacts sur tourelle extérieure. AD51.24/61.24 et armures27.536/42.536/67 expliquent les dégâts physiques ordinaires, sans supplément vrai observé. Le cas tourelle ne qualifie pas l’exclusion du passif absent aussi sur champion. Sbires/monstres/autres structures non testés. Les68refus comprennent huit Buy/Sell hors boutique avant inspection objet/slot : l’analyse initiale attendait de mauvaises erreurs et a échoué ; wrapper/échec conservés, analyse seule corrigée sans combat/build rejoué. Le contrôle séparé mitigate100True sur trois armures/trois refus est arithmétique, pas apply_damage ou événement True en partie. Aucun replay, build, test produit, VM, REA, runtime, GPU, audio, réseau ou rendu exécuté.

## 5. Écarts et inconnues

Déclencheur, AD total/échantillonnage, ordre, critique, vol de vie, boucliers, cibles complètes, persistance/reset, rang/état applicable, lookup/alias/allocation, audiences, fraîcheur/reconnexion et rendu restent ouverts. Texte, calcul True, application générique et agrégat recap ne remplacent pas RapidReload. Aucun besoin de reconstruction graphique démontré.

## 6. Correction et reprise

Réutiliser `CH-Corki-PASSIF-PRESENTATION-HUD`, NETWORK et dépendances SOURCE/SIMULATION ; aucune tâche créée. Six critères : qualifier ressources/textes/rang/lookup sans Annie ou défaut hérité ; qualifier attaques/True/états/audiences autoritaires ; intégrer widgets/refus sans faux zéro/activation ; vérifier cibles, AD/échantillonnage, annulation/projectile, critique/boucliers/ordre, mort/reconnexion et confidentialité avec rendu identifié ; séparer Physical/True générique/recap/QWER/F3/Ezreal de RapidReload ; obtenir l’acceptation humaine applicable séparément. Reprise sur primaire, producteur/consommateur ou contrat pertinent, ou dérive précise, sans rejeu inchangé ni adoption d’une règle moderne.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_corki_passive_hud_20261104` : source_worker/sourceproof.json, reçu consommateur, scripts/journaux et archives de révision, result.json, finalpeer_review.json. Publication racine : rapport et ajouts CURRENT/HANDOFF seulement, sauvegardes exactes et sept protégés contrôlés avant/après puis relus.

Une clôture d’audit borné après ces contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Vérification fonctionnelle non exécutée, fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code/assets inchangés ; SYS-01.2-02 actif/partiel.
