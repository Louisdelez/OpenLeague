# AUD-17.5-01-OPTIONS-KEYBIND-DESCRIPTOR-01 — descripteur et lecteur commun Input.ini

2026-10-31T08:27:48.483964+00:00. Parent SYS-17.5-01 / OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46 / OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd. Goal SYS-01.2-02 conservé.

## R1 — Portée et fin

Deux entrées :8E51A0 et8B0750,leurs paramètres,hash,branches de lecture et limites de copie. Ne pas qualifier le moteur input,les providers ou tous les modes àpartir de ce fragment. Producteur non auto-clôturant ;relecture indépendante requise.

Audit :contrat etfrontières établis. Implémentation :aucune correction produit,consommateur générique de hash présent mais éditeur/Input.ini non qualifié. Vérification :statique et calculs documentaires seulement. Acceptation :non demandée. Parent etgoal restent ouverts.

## R2 — Sources et versions

PE4.20 original SHA402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Le reçu original-skin-resources-execution du21octobre nommait déjà8E51A0 section_field_hash ;cette preuve etses limites sont réutilisées,aucun ancien profil natif rejoué. Le callback etgetter précédents fournissent les CALL directs àces entrées.

Corps normaux :8E51A0..8E520C et8B0750..8B089D. Le hash a deuxRET :la branche sectionNULL après le premier retour reste incluse. Voisin8E5210 distinct ;aucune fusion de son algorithme. Une première inspection a échoué sur l'exigence injustifiée de décoder toute une fenêtre exploratoire jusqu'àune frontière arbitraire ;versionv2 distincte conserve l'octet8D d'une instruction voisine tronquée,sans l'inventer ni l'intégrer aux corps. Script etéchec initiaux préservés.

L'erratum SSO précédent est conservé etle contrat qualifié capacity2D8563C repris. Le nouveau scratchSSO a base2D83FDC,longueur2D83FEC(+10h),capacité2D83FF0(+14h),sans confusion des champs.

## R3 — Hash et consommateurs réels

8E51A0 reçoit section dansECX etclé sur pile[EBP+8]. Le troisième mot du descripteur estdonc hash(section*clé),pas un hash d'événement seul. SectionNULL retourne0 ;sinon les chaînes s'arrêtent auNUL,le séparateur* est ajouté,les majusculesASCII deviennent minuscules etchaque étape fait h=h*65599+octet signé8bits,modulo2^32. Le champ clé n'a pas de gardeNULL locale dans ce chemin.

Les trois noms précis evtCastSpell1/evtNormalCastSpell1/evtSmartCastSpell1 ont des hash distincts calculés d'après ces instructions. Il n'y a aucune réécriture textuelle normal→base ici. Cela n'exclut pas des entrées/alias matérialisés dans un stockage/provider ;les collisions globales ne sont pas qualifiées.

Le helper courant native_game_cfg_text::key_hash multiplie aussi par65599 et replieASCII,mais convertit l'octet par asu32 non signé. Les nomsASCII comparés concordent ;un octet80h terminal donne une différence256 entre les deux calculs. C'est une limite de domaine d'octets/encodage ou une correction ultérieure àqualifier,pas un échec courant observé de Q. Les vrais consommateurs sont le parser générique des entrées etnative_user_settings::environment ;ce n'est pas un éditeur Input.ini ou une preuve de keymap native.

8B0750 remet àvide unSSO partagé,puis initialise le contexte global au besoin etappelle8ACEF0(filename,0). Si objet+4 existe,8B01C0 reçoit le hashdescripteur+8 etle fallback ;ALnonzero évite objet+0,sinon celui-ci est consulté. Les pointeurs de noms du descripteur ne sont pas lus par ce corps. La signification exacte d'AL,l'origine du stockage etses entrées restent à8B01C0 etau contexte cache/provider.

La sortie copie min(longueur,13A0h) octets vers[EBP+8],puis écritNUL àdestination+compte. Le slot[EBP+0C] n'est pas lu par ce corps ;aucune capacité fournie n'y limite la copie. Le maximum nécessite donc13A1h octets de destination. Dans le caller8B16C0,bufferEBP-13B0h etcompte maximum13A0h placent ceNUL àEBP-10h,l'emplacement de la valeur de contrôle de pile. L'atteignabilité d'une chaîne aussi longue etses effets runtime ne sont pas établis ;aucun débordement,crash ou refus reproduit. La longueur normale des sources etles garanties amont doivent rester séparées de ce calcul de borne.

## R4 — Attendu,observé,contrôles

- Deux corps complets normaux,140 instructions et37 points fixes vérifiés dans les octets ;deuxRET duhash etvoisinage explicitement contrôlés.
- Sept vecteurs de calcul documentaire :trois noms tirés des sources,puis cas synthétiques casse,NUL,octet80h etsectionNULL. Aucun code natif/Rust exécuté ;ces calculs ne remplacent pas une preuve de retour du client original.
- Branches objet+4/AL/objet+0,hash+8,SSO etmin/copie/NUL vérifiés statiquement ;capacité/borne du caller conservées aveclimite d'atteignabilité.
- Sources actuelles duhash etconsommateurs réellement inspectées ;les anciens scans de noms/tests CPU ne sont pas relancés.
- Corpus1168,25 fichiers protégés,5 registres,Git,preuves,erratum précédent etéchec du premier explorateur conservés. Aucun logiciel installé,migration,produit,GUI,input physique,réseau,AS,x86,Rust ouchargeur productif exécuté.

## R5 — Inconnues etconditions de reprise

- **DESC-VALUE-STORE-ALIAS** :8B01C0 semantics,hash-key storage and input entry materialization may determine normal-alias resolution. Impact :No textual rewrite in these two functions does not prove that normal binding cannot resolve elsewhere. Reprise :Inspect8B01C0 and precise storage/registration consumers;reuse existing generic config/cache proofs before new analysis. Require provider/source context for actual values.
- **DESC-CURRENT-NONASCII** :Current byte-domain policy or correction for signed native hash versus unsigned Rust helper onbytes>=80h. Impact :ASCII binding comparisons are qualified;full byte-domain fidelity remains open. Reprise :Reuse BIND-NATIVE-PROVIDER-01 for field encoding/domain and locate the generic configuration task when product work is authorized;qualify literal bytes and encoding,not a Unicode guess.
- **DESC-COPY-LENGTH** :Upstream string length guarantees and maximum-copy terminator behavior in actual callers. Impact :Fixed copy ceiling is not proof that every destination hascount+1bytes;maximum branch reachability remains unknown. Reprise :Inspect8B01C0 length bounds and other callers before any runtime probe;require separate authorization for original execution. Preserve arithmetic fact without declaring a reproduced memory failure.
- **DESC-PROVIDER-STATE** :Effective filename initialization8B3CF0,cache/provider selection,overlays and shared scratch lifetime/reentrancy. Impact :Layer branch order does not determine effective historical/current configuration value. Reprise :Reuse native read and existing config audits;inspect only a concrete source/vtable/filename or threading lead,without repeating archive scans.
- **DESC-CURRENT-INTEGRATION** :Real current editable Input.ini/modes,apply/cancel/persistence and native-equivalent dispatch still unestablished. Impact :Generic Game.cfg hash/parser use is not an Input.ini editor or a complete keymap consumer. Reprise :Reuse ten unchanged binding/mode corrections andOptions entry when product work is authorized;retain existing Q/Ctrl/focus behavior.

## R6 — Corrections conservées etprochain résultat

Les dix corrections de bindings/modes etHUD-OPTIONS-ENTRY-01 sont conservées,proposées/non appliquées,définitions inchangées. BIND-NATIVE-PROVIDER-01 porte déjà le besoin de contexte/encodage ;les nouvelles limites de byte-domain etde longueur sont des entrées précises de l'audit générique/configuration etdes corrections distinctes autorisées ultérieurement. Aucun doublon de tâche,critère normatif ou correction produit automatique.

Prochain lot :AUD-17.5-01-OPTIONS-KEYBIND-VALUE-READ-01,lecteur8B01C0,statutAL,stockage par hash etbornes de longueur. Réutiliser les preuves de cache/parser existantes avant analyse nouvelle ;ne pas relancer les recherches d'archives/includes.

## R7 — Livraison etrelecture

Preuve neuve :`F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-DESCRIPTOR-01\keybind-descriptor-proof.json` (SHA6363629f357fd261fe8b59b529d2e7ebf0b3a5fb70a50c39abf2a5c60056ebd7).

Fiche :`F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-DESCRIPTOR-01\audit-unit.json` ;synthèse :`F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-DESCRIPTOR-01\verify_keybind_descriptor.py` ;inspection effective :`F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-DESCRIPTOR-01\descriptor-static-inspection-v2.json`,avecscript etéchec antérieurs identifiés. Relecture indépendante :`F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-DESCRIPTOR-01\verify_delivery.py` →`F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-DESCRIPTOR-01\delivery-readback.json` et`INDEPENDENT-REVIEW.md`.

Seuls ces nouveaux artefacts documentaires etce rapport sont écrits. Goal,critères,registres,produit,assets,suivi,interface,bases etpreuves antérieures inchangés. Pas de clôture fonctionnelle,parent ouglobale ;aucun pourcentage du jeu.
