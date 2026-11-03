# SYS-01.2-02 — Noms et identifiants natifs des voix, V721

Projet F:/OpenLeague. Reference PUBLIC4.20.0.315 EUW/en_GB ; catalogue4.20.1 distinct.

V721 : les instructions originales du constructeur de noms de voix et du hash produisent1098couples pour122champions sous contexte fourni.713IDs correspondent aux evenements des banques de base,385restent sans correspondance dans ce contexte.488fiches de roles et122parents sont enrichis ; le cue AIR de selection et le choix effectif des repliques restent ouverts.500sources verifiees,592adresses originales controlees,aucun fournisseur de voix actuel promu.

## Resultats observes

| Role | Fiches | Noms calcules | IDs presents | Champions avec au moins un candidat |
|---|---:|---:|---:|---:|
|MOVE|122|244|125|122|
|ATTACK|122|122|119|119|
|DEATH|122|244|119|119|
|EMOTE|122|488|350|122|

Le wrapper original6F7260 appelle le provider voix702400 par la vtable10AF484. Le format natif utilise play_vo,le nom de champion fourni,le role de la table10AB938 et un contexte optionnel. Le hashAEA430 execute le repli ASCII et FNV-1. Les noms nominaux sont compares aux evenements HIRC type4 reparses dans244BNK de base. Les713correspondances sont des candidats precis ; les385non-correspondances ne sont pas rebaptisees ressources manquantes.

Executable de reference : League of Legends.exe,SHA256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Execution d instructions en memoire isolee,avec adaptateurs declares ; aucun lancement du client original ou du jeu actuel.

## Verifications

-1098noms et hashes compares aux expressions independantes et aux banques ; les592adresses executees correspondent aux octets de l executable.
-500identites de sources natives/actuelles controlees. Les bibliotheques Python/Unicorn/Capstone sont identifiees dans le recu.
-Sept profils supplementaires et un hash nul verifies. Trois refus du banc et quatre falsifications de preuve rejetes.
-Les points de code actuels restent des entrees inspectees,sans fournisseur de voix revendique. Aucun test de sortie sonore ou test Rust nouveau.

## Limites et suite

- PE instructions executed in isolated Unicorn memory under explicitly supplied service mode,champion name and optional context. Native upstream champion/audio alias and skin context producer not executed.
- String storage/copy/destruction,security cookie check,CRT %s formatting and bounded memcpy_s are adapted. Native wrapper,format construction,placeholder formatting and FNV name hash execute.
- FirstMove versus Move,Attack special contexts,emote admission,Death2D/3D choice,throttling and historical startup remain open. Bank membership by ID proves a candidate event association,not actual original playback selection.
- Event actions/media graph,voice mixing,hardware playback and AIR champion-selection cue are not qualified. No game source or bank modified.
- ASCII/no-NUL diagnostic inputs bounded to128characters. Refusals are harness guards,not claims about original input validation. Native unsafe oversized input behavior is not executed.
- Le role deplacement a au moins un candidat pour122champions ; attaque119,mort119,emotes122. Attaque Azir/Kalista/Sion et mort Nautilus/Sion/Sona n ont aucun candidat correspondant dans les contextes nominaux examines. Ceci ne prouve aucune ressource manquante ou corrompue.
- Les713 correspondances sont des identifiants HIRC type4 du meme champion,avec offsets,payloads et listes Action conserves. La preuve ne suppose pas une absence generale de collisions de hash ou une selection historique de ces noms.
- La table native distingue notamment Move2D/FirstMove2D,Death2D/Death3D et les quatre emotes. Le provider voix702400 utilise play_vo ; le provider SFX702360 est distinct. Ne pas attribuer automatiquement un son de danse a une voix parlee.
- Le provider est configure explicitement par sa vtable dans la capsule. Le chemin de fabrique et la reference du caller de hero sont inspectes statiquement ; leur bootstrap et les producteurs effectifs des alias/contextes ne sont pas executes.
- Sept profils de noms supplementaires couvrent provider inactif,contexte non vide,stockage long,casse et chaines vides. Le hash natif recoit aussi un pointeur nul et renvoie0. Trois refus avant entree native viennent des gardes ASCII/NUL/longueur du banc ; quatre falsifications de preuve sont rejetees separement.
- Le premier recu prive employait un libelle de compteur ambigu :244 signifiait fichiers BNK reparses. Une nouvelle execution corrige le libelle bank_files_reparsed et epingle les bibliotheques d emulation. Premier essai conserve,non publie.
- Les six frontieres actuelles introduites enV720 sont relues et conservees sans changement. Aucun nouveau code du jeu,son,consommateur fonctionnel,test Rust ou branchement audio ajoute ; les tests PCM deV720 restent une preuve anterieure distincte.
- Les122fiches VOIX-SELECT ne sont pas modifiees par cette livraison : leur cue AIR reste non identifie. Les parents conservent ces sous-taches ouvertes,les etats manuels,notes,historiques et inconnues.

## Livraison

Les488fiches de roles,122parents et SYS-01.2-02 sont enrichis dans completion_tasks,fidelity_requirement_trace et les deux bases du plan. Le [recu detaille](fidelity_native_voice_name_links_v721.json) contient noms,hashes,offsets HIRC,adresses natives,adaptateurs,preconditions et controles. Les liens et textes copiables sont verifies,ainsi que la conservation des autres taches,cases,notes et historiques,la synchronisation idempotente et PRAGMA quick_check.

Resultats terminaux : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision721_delivery/VERIFIED.json et INDEPENDENT_READBACK.json. Registres,coverage,completion_plan,resume_checkpoint,CURRENT/HANDOFF et les deux bases mis a jour. Scripts et deltas cibles sur F,sans copie integrale des bases ; aucun asset/source de production modifie.

Le goal reste ouvert ; ni une voix complete ni le jeu ne sont declares termines.
