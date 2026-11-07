# Menu —32descripteurs de choix

## 1. Portée et dimensions

AUD-17.5-01-OPTIONS-MENU-CHOICE-DESCRIPTORS-01,goal SYS-01.2-02,parent SYS-17.5-01.32déclarations option sous7dropdowns déjà audités :audit de rôle descriptif clôturable après relecture,aucun nouveau widget indépendant. Implémentation/effets des réglages restent partiels dans leurs travaux existants ;vérification documentaire seulement ;acceptation humaine non demandée. Parent/goal ouverts.

## 2. Sources et matrice

LoL4.20,en_GB. FoundryOptionsMenu.xml SHA4859ef32283b8f22b69c202299ce5240e199cd7cde9f709fa67360d0270470de et locale SHA1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3.32IDs/source/octets/attributs/ordre et libellés uniques par clé sont liés au parent direct et à son champ option_descriptors/authored_choices/authored_options. Aucun label/value manquant dans ces32 ;aucune factory option indépendante enregistrée.

| Réglage parent | Valeurs XML en ordre | Stratégie source | Graphicslookup source |
|---|---|---|---|
| [General]WindowMode | 0, 1, 2 | regular | — |
| [Performance]CharacterQuality | 0, 1, 2, 3, 4 | savecfg | 0,1,2,2,3,3,4 |
| [Performance]EnvironmentQuality | 0, 1, 2, 3, 4 | savecfg | 0,1,1,2,3,3,4 |
| [Performance]EffectsQuality | 0, 1, 2, 3, 4 | savecfg | 0,1,1,2,3,3,4 |
| [Performance]ShadowQuality | 0, 1, 2, 3, 4 | savecfg | 0,0,1,1,2,3,4 |
| [Performance]FrameCapType | 3, 4, 5, 6, 2 | regular | — |
| [HUD]NumericCooldownFormat | 0, 1, 2, 3 | regular | — |

Les quatre lookups ont7entrées pour les indices de preset ;leurs valeurs correspondent aux domaines de choix0..4. Ce ne sont pas7niveaux propres de qualité ni32nouveaux contrôles. Les répétitions de clés/locales entre parents n’effacent aucune identité physique.

## 3. Consommateurs et contrat réutilisé

Les7main/readers/programmes/rapports existants sont identifiés,leur cible parent et leurs32champs descriptifs comparés exactement. Le contrat ModelDropdown/ViewDropdown déjà audité est réutilisé verbatim par pointeurs et empreintes :createAllChildren passe chaque objet à addOption ;values conserve la chaîne value,labels passe par Utility.LocalizeText(label),ou la valeur si label absent. Une valeur absente produit un texte d’erreur et la chaîne null ;ces branches ne sont pas prises par les32données fournies.

getSelectedIndex cherche exactement getValue dans values. setValue recherche la chaîne et n’appelle setSelectedIndex que si trouvée ;l’argument booléen secondaire n’est pas transmis. setSelectedIndex appelle la valeur de base seulement dans les bornes,mais émet CHANGE même hors bornes. La vue relie son index au modèle et USER_CHANGE ;ces événements source ne sont pas des clics observés ni des accusés d’effet ou sauvegarde.

Les lectures CFG/default ont un repli chaîne0 sur le chemin ingame/GfxPlayer conditionnel,et un autre chemin peut choisir l’index0. FrameCap expose3,4,5,6,2 :le repli0 n’est pas l’un de ces choix,aucun remplacement par le premier choix n’est inventé. Les libellés25/30/60/80FPS/Uncapped ne prouvent ni fréquence,sleep/present ou backend effectif. Les domaines de conversion numérique native et de chaîne UI restent distincts.

EnvironmentQuality conserve son contrat frontend0 versus default natif/courant3 et le différentiel de preset ;aucune réécriture de defaults. Character/Effects/Shadow gardent leurs lookups et contrats natifs propres. NumericCooldown conserve le lien identifié de préférence37 vers formatter37,ainsi que les limites de printf/locale/horloge et de rendu. Aucun effet de shader,fenêtre,fréquence ou formatteur nouveau n’est qualifié par ces32associations.

58fenêtres de consommateurs courants des7parents sont réutilisées après identité ;tous leurs fichiers correspondent aux empreintes actuelles. Leurs loaders ne sont pas appelés,notamment load_using potentiellement migrateur. Les contrats et limites natifs demeurent dans leurs parents,pas réexécutés ou extrapolés ici.

## 4. Attendu,observé et vérifications

Attendu :32choix reliés au bon parent,valeur,ordre et locale. Observé :3+5+5+5+5+5+4choix exacts,32champs parent correspondants,7INI/stratégies et4lookups conservés. Attendu :séparer limites/refus source et résultat en jeu. Observé :branches d’appartenance/index/manque conservées,repli FrameCap0 distinct,aucune invocation originale/produit ou simulation de logique originale.

Contrôles documentaires :identités/octet XML/locale,preuves/relectures parent et champs/fragments source,58consumers actuels,protections/registres/corpus/Git avant-après,sorties réelles et relecture distincte. Aucun nouveau scan/requête AS,Rust ou natif,aucun ancien lecteur/test relancé,aucun jeu/AS/Rust/natif/GUI/OS/réseau exécuté ou émulé.0nouveau cas produit et aucun rendu/sauvegarde déclaré observé.

## 5. Manques et reprise

CHOICE-INITIAL-VALUE-PROVIDER :valeurs déclarées ≠ valeur initiale effective. Repli FrameCap0,écart Environment0/3et preset restent ouverts. Reprise sur le provider/init/sync nommé par chaque parent ou une politique locale versionnée ;ne pas réécrire les données d’après les seuls littéraux.

CHOICE-APPLY-RENDER-PERSISTENCE :source d’un choix ≠ menu réel,effet ou sauvegarde. Reprise sur les7objectifs existants et leurs gaps précis,avec scénarios autorisés UI/state/persistance/rendu ;pas de nouvelle recherche générique identique.

CHOICE-LAYER-DOMAINS :chaînes XML,index,indices de preset,conversion/native raw et effet sont distincts. Reprise sur une nouvelle divergence et son consumer exact ;ne pas inventer de clamp commun ni affirmer un refus physique à partir d’une seule branche source.

## 6. Corrections et couverture

Aucune nouvelle correction produit ni32tâches dupliquées. Les champs de travail/progrès/gaps des7parents sont liés sans modification :notamment HUD-OPTIONS-ENTRY-01 et les adaptations déjà proposées WindowMode,Character/Effects/ShadowQuality,FrameCap et NumericCooldown. EnvironmentQuality conserve ses progrès source et ses5gaps explicites,aucun acquis retiré.

67déclarations Menu déjà possédées conservées,32associations de descripteurs ajoutées,0nouveau contrôle indépendant. Restent30autres nœuds Menu :5panneaux,3includes,19structures/libellés et3présentations. Les32ne s’ajoutent pas aux65préférences,et n’autorisent aucune clôture des effets ou du parent. Le dénominateur129est physique ;aucun pourcentage de jeu terminé.

## 7. Livraison et suite

F:/OpenLeague-work/audit-units/AUD-17.5-01-OPTIONS-MENU-CHOICE-DESCRIPTORS-01/ :spec,programme/preuve/matrice,lecteur distinct et reçus réels. Rapport :F:/OpenLeague/docs/audit/units/AUD-17.5-01-OPTIONS-MENU-CHOICE-DESCRIPTORS-01.md. Les sorties et sept rubriques sont liées aux empreintes/codes réellement obtenus ;clôture limitée aux32rôles descriptifs après relecture.

Goal,critères normatifs,suivi,bases et logiciel inchangés ;aucune installation,migration ou retrait. Prochain lot MENU-PANELS :5déclarations de panneaux,construction/sélection/visibilité et relais lifecycle,avec réutilisation des contrats menu/capture. Les25autres rôles Menu,36Phreakspace et inconnues de provider/runtime restent séparés. SYS-17.5-01 et SYS-01.2-02 restent ouverts.
