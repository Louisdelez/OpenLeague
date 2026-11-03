# D01-SYS-01-2 — filtrage des groupes natifs — V36

Relevé du22octobre2026. Référence PUBLIC4.20.0.315/Releases4.20,
EUW/en_GB conservée ;catalogue4.20.1 distinct.

## Résultat sur les sources exactes

Les689 candidats de préchargement exacts de V33/V35 sont conservés. La
découverte, le montage et la priorité historiques de leurs packages ne sont pas
déduits de ce profil de recherche.

Les6396 lectures de GroupPartN retrouvent1575 groupes :195 sont au-delà des
huit premiers emplacements. Le code continue après8 jusqu'à la première
sentinelle ultérieure ;huit ne constitue donc pas une capacité maximale.
La composition de cette itération par l'outil reste distincte de l'exécution de
la boucle entière918E90 et de son scanf. Les noms de ce corpus sont ASCII,
non vides, sans whitespace ;les profils malformés restent hors qualification.

La fonction entière918D50, son cache/parseur et son callback92C9D0 originaux
s'exécutent sous **émulation Unicorn x86 avec garde des octets d'instructions**.
Les3150 décisions représentent1575 groupes avec deux octets d'état explicitement
fournis :0 et1.3128 admissions et22 refus correspondent aux11 groupes dont
e-disabled=1. Le callback n'est pas appelé pour ces groupes désactivés.

Tous les e-censor-policy effectifs de ce corpus valent0. Leur admission ne
détermine donc pas la valeur réelle de l'état de censure du gestionnaire EUW.

## Branches locales et état du gestionnaire

Les21 fichiers INIBIN de test construits localement restent séparés des
ressources historiques. Ils ne sont installés ni dans les assets ni dans le
client original.42 essais combinent l'absence/0/1 de e-disabled et
l'absence/0/1/2/3/-1/255 de e-censor-policy avec les deux états fournis.

| Condition | Résultat original observé |
|---|---|
| e-disabled vrai |Refus avant le callback |
| Politique absente/0 |Admission, après lecture du callback |
| Politique1 |Admission avec état0 ;refus avec état1 |
| Politique2 |Refus avec état0 ;admission avec état1 |
| Autres politiques des essais |Refus et passage par le site de diagnostic natif |

Ces fixtures donnent12 admissions et30 refus ;12 diagnostics invalid-policy
passent par le site918E71, avec journalisation adaptée explicitement.

Seize essais distincts exécutent le setter primaire92C9E0 et le getter
secondaire92C9D0 pour les octets0/1/7/255. Le pointeur secondaire vaut primaire+4 ;
primaire+359 et secondaire+355 désignent le même octet. Le setter ne change que
cet octet et renvoie si sa valeur a changé ;le getter conserve sa valeur brute.
Ces objets/vtables et valeurs sont fournis. Aucun constructeur ni appelant
historique du setter, aucune valeur effective EUW ne sont qualifiés.

## Exécution, consommateur et contrôles

L'expérience principale termine normalement0 :34801090 instructions originales
observées,6193PC,aucun accès invalide. L'expérience des accès d'état termine0 :
160 instructions/10PC,sans accès invalide ni allocation invitée restante.
Le pilote de deux décisions est conservé séparément.

Les racines DATA et fixtures, les handles/streams de fichiers virtuels et les
adaptations d'allocateur, chaînes/copie, thread/locale initiale, OS et logs sont
déclarés. Les octets exacts sont consommés entièrement par le parseur original.
Chaque payload commence un contexte PE/cache isolé ;le teardown historique et
les overlays/montages du processus complet restent séparés.

`tools/project-plan/audit_native_group_admission.py` recoupe les sources,
groupes, valeurs, décisions, callbacks, diagnostics, ABI et reçus réels.
Les56 contrôles passent, dont54 refus d'observations altérées ;les observations
originales et les reçus d'exécution restent inchangés.

Le consommateur Rust existant `native_particle_class.rs::EmitterClass::from_system`
est identifié pour le choix Simple/Complex. Il ne constitue pas une preuve de
raccordement du filtre de censure. Les anciens18 cas de sélection,14 cas de
lecture à cache/config fournis et52 groupes de map restent des preuves héritées,
relues mais non réexécutées ici. Aucun test Rust, build, rendu ou audio nouveau
n'est revendiqué.

## Intégration et limites

Trois traces SYS-01.2-02/03/06 et une inconnue composée existante sont enrichies.
Les IDs, versions/SHA, preuves antérieures, statuts et suivi manuel restent
conservés. Les résultats d'intégration et les fichiers réellement modifiés sont
dans `docs/fidelity_registry_native_group_admission_revision_4_20.json`.

Restent le constructeur/appelant/config du véritable état EUW, la priorité des
packages/locale/IO, la totalité918B30/918E90 et la construction/retraite des groupes,
les callbacks et événements suivants, le raccordement Rust et le rendu/audio.
Les deux caps AIR4312/4313 et les contradictions communautaires restent ouverts.
Un filtre de groupe qualifié ne clôture ni ces six tâches ni le jeu.
