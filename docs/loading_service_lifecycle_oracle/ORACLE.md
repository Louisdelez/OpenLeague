# Oracle natif du cycle extérieur service / chargement

**52 cas passent** :18 pourStop72A9F0,14 pour l'arrêt extérieur avec callbacks dynamiques explicites,4 avec le vrai destructeur72A530,16 pour le reset577DF0. Aucun port Rust, compilation ou changement de production. Cette preuve ne constitue pas un lancement du processus complet.

Source PE4.20 : SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`, base00400000, x86. `probe_lifecycle.py` exécute les instructions originales dansUnicorn et vérifie leurs octets contre l'image source à chaque passage. Le dossier statique précédent `E:\mapslol3v3\loading_service_global_preparation` reste intact.

## Résultats observés

### Stop72A9F0 :18 cas

Deux remplissages mémoire,00 etA5, pour neuf profils : mode désactivé ; objet imbriqué nul ; objet actifA ; flagFF ; activation par le journal ; désactivation par le journal ; remplacement du pointeur imbriqué ; effacement de ce pointeur ; remplacement de sa vtable.

- Le journal5FA170 est appelé avec3,1,0 et le littéral10B1874.
- Le byte`service+122` est effectivement lu à72AA0D **après le callback de journal**, y compris après sa mutation. Le pointeur`service+CC` n'est lu que lorsque ce byte est non nul.
- Le remplacement du pointeur ou de la vtable pendant le journal sélectionne le nouvel objet/slot+30. La branche désactivée n'appelle aucun terminal imbriqué.
- Stop ne détruit pas le service et ne remet pasSERVICE_GLOBAL à zéro.

Le journal et les terminaux virtuelsA/B sont des frontières d'observation et de mutation fournies au test. Ils ne simulent pas un système de réseau, de replay ou d'UI terminé.

### Fragment590F03–590F31 :14 cas avec frontières dynamiques

Les sept profils sont exécutés avec les deux remplissages : aucune mutation ; journal effaçant le global ; journal le remplaçant ; slot+30 effaçant le global ; slot+30 le remplaçant ; journal changeant la vtable du service initial ; destructeur republiant un autre pointeur.

- La première lecture du global est effectuée à590F03 ; la seconde à590F11, **après le vrai corpsStop72A9F0**.
- Les cas de mutation montrent queStop conserve son`this` original, tandis que le destructeur utilise le pointeur relu. Un global devenu nul saute le destructeur ; un global remplacé choisit l'autre service.
- La vtable du service est également relue pour le destructeur. Changer cette vtable dans le journal modifie le terminal appelé, tout en conservant le même`this` si le global reste identique.
- Le destructeur est appelé avecflags=1 et voit le service encore publié.
- L'unique écriture native deSERVICE_GLOBAL pendant ce fragment est le zéro final à590F27. **Une republication par le destructeur est donc écrasée.** Ce comportement n'est pas identique au reset de paire décrit ci-dessous.

Les destructeursA/B de ces14 cas sont explicitement des terminaux de fixture : ils enregistrent le destinataire, le global visible et lesflags, puis retirent leur allocation de fixture. Les propriétaires non choisis restent présents dans la capture finale ; aucune fermeture intégrale n'est revendiquée pour ces entrées mutatrices.

Le fragment commence dans la fonction590E70, après un autre journal dont quatre arguments restent sur la pile. Le harnais fournit ces16 octets ; l'instruction native`add esp,10` les consomme. L'exécution s'arrête exactement avant590F31. Ni le prologue ni les autres ressources du processus ne sont remplacés par un faux retour de fonction.

### Même fragment avec vrai72A530 :4 cas

Deux états de construction natifs archivés dans `E:\OpenLeague\data\4.20\audio_game_service_lifecycle_contract.json` sont restaurés mot pour mot : remplissages00/A5, chacun testé avec la route de libération par défaut et une route personnalisée explicite. Leur source PE et leur hash de fixture sont enregistrés.

Ici, la vtable d'origine10AFE8C reste intacte. Le fragment appelle le vraiStop72A9F0 puis **le vrai72A530 et ses destructeurs de membres**. Tous les blocs encore vivants de l'état restauré sont libérés, dans l'ordre exact du reçu natif de référence. Chaque libération voit encoreSERVICE_GLOBAL égal au service détruit. Le global n'est effacé qu'ensuite.

Cela qualifie la composition avec la destruction réelle sur ces deux états antérieurement construits. **Le constructeur72A3B0 n'est pas réexécuté dans ces quatre nouveaux cas** ; aucune disponibilité de configuration actuelle n'en est déduite.

### Reset577DF0 :16 cas

Huit profils avec deux remplissages : paire vide ; objet nul avec contrôle ; propriétaire exclusif ; destinataireUI actif ; référence forte externe ; référence faible externe ; republication pendantUI ; changement de la route de libération pendantUI.

Le harnais exécute réellement576280, les factories de contrôles,5C7E30, **577DF0→5CC140**, le contrôle1085E5C, **5DDB80→576410**, la destruction du contrôle5D5B40→5D6840 et les primitives de référence originales. Le destinataire possède un contrôle interne réel ; seuls ses terminauxUI+0C/+10 sont fournis au test.

- Propriétaire exclusif : forte1→2 par la copie temporaire ; effacementcontrol14C7620 puisobject14C761C ; forte2→1 pour la paire globale ; forte1→0 pour la copie temporaire ; destruction du wrapper puis éventuelle destruction du contrôle. Les assertions comparent les valeurs et l'ordre des écritures.
- Le callbackUI de fermeture voit `[14C761C,14C7620] == [0,0]` et le service encore vivant. La copie temporaire retarde la destruction jusqu'à son propre relâchement.
- Avec une forte externe, le wrapper, son verrou et son contrôle restent vivants avecforte1. Avec une faible externe, le wrapper est détruit mais le contrôle reste avecforte0/faible1. Ces références externes sont des préconditions explicites de fixture.
- Objet nul avec contrôle non nul : la copie temporaire est acquise puis relâchée, mais la paire globale reste inchangée,forte1/faible1. L'objet nul ne déclenche pas un effacement inconditionnel.
- **Une republication pendant le callbackUI survit au reset.** Le test transfère une paire propriétaire préparée vers le global, puis efface sa paire temporaire de fixture. L'ancien wrapper et son contrôle sont détruits ; le nouveau couple reste propriétaire.
- Une modification de la route de libération par le callbackUI est observée par les libérations suivantes réelles. Aucun ancien choix de route n'est conservé artificiellement.

Les conteneurs du wrapper sont construits nativement mais restent vides pour cette tranche. L'ancien oracle ownership qualifie séparément les conteneurs peuplés ; ses résultats ne sont pas recomptés ici.

## Artefacts et reproduction

- `native_lifecycle_oracle.json` : entrées, captures avant/après, événements, lectures/écritures pertinentes, instructions exécutées et limites.
- `summary.json` :52 cas et leurs catégories,10 régions d'octets,955 adresses d'instructions natives uniques exécutées. Ces955 adresses incluent la préparation des fixtures de wrapper et les corps effectivement appelés ; ce n'est pas un taux de couverture du jeu.
- `bytes/` :10 régions sources bornées, avec hashes dans la preuve.
- `qualification_manifest.json` : index des fichiers et dépendances figés ; périmètre d'intégration explicitement faux.
- `probe_lifecycle.py` : commande de reproduction ci-dessous ; sorties limitées à son dossier.

```powershell
& 'C:\Users\loicd\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' 'E:\mapslol3v3\loading_service_lifecycle_oracle\probe_lifecycle.py'
```

## Frontières conservées

Allocation/libération/copie mémoire et initialisation/destruction de verrou sont fournies comme primitives du harnais. Les verrous sont suivis dans un registre de fixture en exécution séquentielle : aucune concurrenceWin32 ouConCRT n'est qualifiée ici. Le journal, le slot+30 dynamique et les terminauxUI restent des interfaces explicites, dont les mutations servent à démontrer l'ordre source.

Les séquences proposées pour le prochain port Rust peuvent maintenant reprendre les lectures, callbacks et écritures observés. Les erreurs hôtes, rollback, réentrance de l'adaptateur, fermeture sur erreur et reprise après destruction partielle exigeront leurs propres contrats : ce harnais ne prétend pas convertir une exceptionSEH native en `Result::Err`.

Aucune publication normale deSERVICE_GLOBAL n'est intégrée par cette livraison. Les tests de chargement continuent à binder ce global explicitement. Le démarrage58FCB0, la publication58FE54, les factories de vrais écrans, le rendu, le réseau et la simulation restent hors de cette preuve bornée.
