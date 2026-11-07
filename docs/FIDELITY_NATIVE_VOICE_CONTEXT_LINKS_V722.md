# SYS-01.2-02 — Choix natif des noms audio, V722

Projet F:/OpenLeague. Reference PUBLIC4.20.0.315 EUW/en_GB ; catalogue4.20.1 distinct.

V722 : le selecteur natif des noms audio du hero est execute sur704variantes de configuration couvrant122champions et668identites de skins. Les champs CharAudioNameOverride et SkinAudioNameOverride sont relies a leurs lecteurs originaux et aux fichiers exacts. Douze controles de priorite et trois refus du banc passent. Les noms et contextes du hero,le contenu de la table de disponibilite et le choix des evenements restent des entrees declarees.

## Resultats verifies

- 122 champions,668 identites de skins,704 compositions de variantes current/base conservees.
- 456 configurations exactes ;462 sources selectionnees avec executable et consommateurs actuels.
- 834 adresses natives comparees au PE ;12 controles de comportement,3 refus du banc,4 falsifications rejetees.
- 610 fiches de voix et SYS-01.2-02 enrichies dans les registres et les deux bases du plan.

Le lecteur56CC71 lit [Data].CharAudioNameOverride puis stocke la chaine a+7B8. Le lecteur56CD7C lit SkinAudioNameOverride dans la section de skin puis ecrit+840. Le selecteur6F82C0 fournit le nom de definition si le premier override est vide,et le nom de skin+944 si le second est vide. Il prepare aussi les noms current/base,le suffixe et un scalaire du hero.

Le provider702D70 initialise les deux sorties courantes et les deux sorties de base. Il ajoute le suffixe a la premiere sortie courante. Avec un contexte non nul,il consulte successivement le nom audio du skin courant,base-alias+suffixe,skin-alias+suffixe,et le nom audio du skin de base. Les correspondances peuvent remplacer les sorties ; l ordre est verifie sur les diagnostics. La population reelle de cette table reste ouverte.

Les champs absents sont conserves comme absents dans la preuve. Aucun SkinAudioNameOverride non vide n est observe dans les configurations inspectees. Le champ CharAudioNameOverride de Sion contient Sion. Les autres noms declares au banc proviennent de l identite du dossier ; leur production par le hero historique n est pas prouvee.

Executable : League of Legends.exe ; SHA256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Les instructions s executent dans une capsule Unicorn isolee,avec runtime et adaptateurs identifies. Aucun lancement du client original ou du jeu actuel.

## Limites

- Original6F82C0 and702D70 execute in isolated Unicorn memory with supplied hero definitions and active Wwise service. Character names,skin configuration choice,hero virtual getters,suffix and context map contents are declared inputs. Historical hero state and context population not qualified.
- Actual CharAudioNameOverride is read from Data in champion INIBIN. SkinAudioNameOverride is read in each explicitly matching skin configuration section. Native readers56CC71/56CCA7 and56CD7C/56CDAF identify fields7B8/840; full readers/config mounting are not executed in this capsule.
- All actual configuration variants use null context and empty suffix. Diagnostic nonnull maps qualify branch precedence only,not actual loaded bank membership. String/CRT leaves and membership lookup5BD730 are adapted. Native5FA560 and709770 execute with storage adapters.
- Missing values remain absent in field records and are supplied as empty strings following native reader default; ambiguous bindings remain distinct,including Renekton. No new source precedence is claimed.
- Event caller627680..627723 is inspected statically only. Its event+18 text and event ordinal are separate upstream inputs,not inferred from the champion folder. V721 names/hashes remain conditional candidates; this result does not promote them to playback selection.
- No original full client,current game,audible playback,media graph,AI or server executed. No sound,asset or game code modified.
- Les456fichiers de configuration sont relus et verifies. CharAudioNameOverride est non vide pour Sion et vaut Sion ; aucun SkinAudioNameOverride non vide dans les configurations liees inspectees. Cela ne qualifie ni les transformations,ni les variantes de repertoire non liees,ni les banques chargees en jeu.
- Les704compositions conservent toutes les variantes de liaison admissibles,avec combinaisons current/base distinctes. Les ambiguites Renekton ne sont ni tranchees ni effacees. Les cases sources absentes restent explicitement present=false,value=null.
- La capsule nominale fournit un contexte nul et un suffixe vide. Les douze diagnostics couvrent overrides distincts,longues chaines,suffixe,table vide,miss,skin alias/fallback,priorites base+suffixe puis skin+suffixe,vecteur de transformation et noms vides. Ce sont des configurations de banc,pas des observations de session historique.
- Les834adresses executees sont comparees aux octets du PE original. Les getters virtuels du hero sont fournis ; allocation/copie/append/destruction de chaines,CRT %s et lookup5BD730 sont adaptes. Les fonctions6F82C0,702D70,5FA560 et709770 sont executees,avec limites detaillees dans la preuve.
- Le caller627680..627723 fournit au constructeur de noms le resultat courant du selecteur et le texte event+18 distinct. Le producteur de ce texte et celui de l ordinal ne sont pas qualifies. Les1098noms conditionnels deV721 et ses713correspondances restent une preuve precedente,sans promotion en selection effective.
- Quatre falsifications de champs,resultats ou portee sont rejetees. Les refus ASCII/NUL/longueur sont ceux du banc,aucun refus natif invente.
- Les points actuels sont relus sans nouveau fournisseur fonctionnel de voix. Les122fiches VOIX-SELECT restent inchangees,le cue AIR distinct reste ouvert. Aucun nouveau test Rust,jeu complet,son audible,asset ou code du jeu modifie.

## Livraison et verification

[Preuve detaillee](fidelity_native_voice_context_links_v722.json) : configurations,absences,variantes,entrees declarees,sorties attendues/observees,instructions,adaptateurs,ancres et preconditions. Le consommateur reel du resultat est le plan et ses instructions copiables ; cette liaison ne fournit pas la fonctionnalite sonore dans le jeu.

Registres completion_tasks,fidelity_requirement_trace,fidelity_sources,coverage,completion_plan,resume_checkpoint,CURRENT/HANDOFF et deux bases mis a jour. Les autres fiches,etats manuels,notes,historiques et inconnues sont preserves. Deltas cibles sur F,aucune copie integrale de base. Relecture independante : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision722_delivery/INDEPENDENT_READBACK.json. Resultat de publication : VERIFIED.json dans le meme dossier.

Un premier essai de preparation du script a echoue sur une delimitation de chaine Python avant toute ecriture. Le script corrige est compile syntaxiquement avant lancement. Aucun echec de capsule ou modification de registre ne provient de cet essai.

Le goal reste ouvert ; aucune voix complete ni acceptation du jeu deduite.
