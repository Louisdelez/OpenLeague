# SYS-01.2-02 — Demandes natives de voix et repli, V723

Projet : F:/OpenLeague. Référence : PUBLIC 4.20.0.315, EUW/en_GB. Catalogue 4.20.1 distinct.

## Résultat

Le parcours natif de voix simple est exécuté de son paramètre ordinal jusqu'à la construction du nom, la recherche de disponibilité et le choix d'un éventuel repli. La capsule couvre 1 098 demandes pour 122 champions. Parmi elles, 713 correspondent à un événement dans les banques sélectionnées ;385 n'ont pas de correspondance dans les conditions déclarées.

Ce résultat qualifie le parcours de demande sous ces conditions. Il ne démontre pas une lecture sonore ou une session du client historique.

## Chaîne originale vérifiée

1. Le wrapper `627890` transforme l'ordinal fourni en libellé de la table `10AB938`.
2. La vtable originale `1090EA8`, slot `270`, conduit au consommateur `627990`.
3. Le provider `702750` lit les noms courant et de base par `56D850`. Le flag `+864` choisit la branche audio du skin ou celle du personnage ;le suffixe du héros est ajouté aux deux noms.
4. `6F72E0` appelle `702540` et produit le nom à trois parties `play_vo_<nom>_<rôle>`.
5. `6F8210` demande la disponibilité du premier nom. En cas d'absence et si les noms diffèrent, le consommateur essaie le nom de base.
6. La demande retenue atteint `6F78A0`. Cette fonction est ici un point de collecte explicite : aucun décodage, mixage ou périphérique audio n'est exécuté.

La voie utilisant un objet événement, `6275C0`, reste distincte. Son champ `event+18` ne doit pas être remplacé par l'identité du dossier du champion.

## Vérifications exécutées

- 244 banques BNK reparsées ;622 identités de sources vérifiées.
- 790 adresses exécutées comparées aux octets de l'exécutable original.
- 12 diagnostics de priorité, repli, flags, suffixe, absence et réponse de la frontière sonore.
- 5 refus du banc pour ordinal ou chaîne hors contrat ;4 falsifications de preuve rejetées.
- Conservation des 718 occurrences HIRC correspondant aux 713 demandes, dont les doublons Lissandra déjà recensés.
- 611 fiches publiées et leurs instructions copiables vérifiées dans les deux bases. Cases, notes, historiques, autres fiches et inconnues conservés.

Exécutable original : `League of Legends.exe`, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Python, Unicorn, Capstone et les scripts sont identifiés dans la preuve.

## Limites

- Original ordinal wrapper627890 and simple-voice consumer627990 execute through PE vtable1090EA8+270. Provider702750 executes getter56D850 and appends hero suffix to both names. Wrapper6F72E0/provider702540 produce the simple three-part voice name. This is distinct from event-object caller6275C0 and provider702400.
- Selected hero definitions,base/current names,flags+864,suffix,audio object123,position and role ordinal are declared. Actual champion subtype dispatch,hero construction,flag producer,command admission and role selection are not qualified.
- Original availability wrapper6F8210 executes with legacy lookup disabled; backend virtual+34 is adapted to the actual selected same-champion HIRC event set using independently calculated FNV. Historical loaded-bank lookup,precedence and hash collision policy are not qualified.
- Playback6F78A0 is an explicit recording boundary returning false for all 1098 nominal requests. Tests prove request construction/fallback and native return codes,not successful playback. Diagnostic true responses exercise return4 only. No audio device,media decode,full original client or current game run.
- String/CRT operations and supplied definition getters are adapted. Native string-compare control5FA720 executes with bounded byte-compare leaf5FA6B0; move-assign5FADB0 and storage leaves are adapted. Original getter scalar/position/cached-audio-object code executes.
- Death3D ordinal5 is visible at63E531 and645E5C/649BE9; the generic emote path6281B5 forwards its input ordinal and excludes0x1C. These callers are static evidence only; Move/Attack/FirstMove producers and actual emote inputs remain open.
- Existing V721 candidates and V722 alias-context selector remain retained; no old result is promoted retroactively. Selection AIR,media graph,current voice implementation and audible comparison remain open.
- Les 713 demandes avec evenement correspondent a 718 occurrences HIRC : cinq IDs Lissandra existent dans deux banques. Toutes les occurrences sont conservees. Aucun ordre historique de chargement ni politique de collisions ne sont deduits.
- Les 622 sources sont verifiees, dont les configurations [Data].CharAudioNameOverride des 122 champions. Les 244 BNK sont reparses. Le champ de Sion vaut Sion ; les absences restent absentes. Le flag natif +864 est fourni a zero pour les cas nominaux ; sa production historique reste ouverte.
- Douze diagnostics couvrent presence,refus,absence,priorite du nom courant,repli vers la base,overrides de skin avec flag actif/inactif,suffixe et definition absente. Le code natif renvoie 1 en absence d evenement,0 quand la frontiere refuse,4 quand une reponse true est fournie ; ce dernier cas ne prouve aucune lecture sonore.
- Cinq refus avant entree viennent des gardes du banc,et quatre mutations de preuves sont rejetees. Les 790 adresses executees sont comparees aux octets du PE. Aucun nouveau test Rust,client complet,audio audible,asset ou code du jeu modifie.
- La voie simple 627890/627990 ne remplace pas la voie event-object 6275C0 et son champ event+18. Les producteurs effectifs de Move,FirstMove,Attack et les conditions precises des emotes restent ouverts. Les fragments de callers Death3D/emote ne sont inspectes que statiquement.
- Les 610 fiches de voix et la fiche SYS sont enrichies ;les 122 fiches VOIX-SELECT restent inchangees. Les consommateurs actuels restent des frontieres inspectees,sans fournisseur fonctionnel de voix promu.

## Fichiers et preuves

Le [reçu détaillé](fidelity_native_voice_dispatch_links_v723.json) contient les entrées déclarées, sorties, événements HIRC, instructions et adaptateurs. Les registres `completion_tasks_2026-10-20.json`, `fidelity_requirement_trace_4_20.json` et `fidelity_sources_4_20.json` sont enrichis, ainsi que `coverage.json`, `completion_plan.json`, `resume_checkpoint.json`, `CURRENT.md`, `HANDOFF.md` et les deux bases du plan.

Les reçus terminaux sont `VERIFIED.json` et `INDEPENDENT_READBACK.json` dans `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision723_delivery/`. Les sauvegardes contiennent les changements ciblés, sans copie intégrale de base. Aucun code du jeu ou asset modifié.

Le goal reste ouvert. Les producteurs d'événements, le backend sonore historique, les médias et le consommateur de voix actuel restent à qualifier.
