# SYS-01.2-02 — Initialisation audio native, V770

Projet : F:/OpenLeague. Référence : LoL PUBLIC 4.20.0.315, EUW/en_GB. Fiches : SYS-01.2-02 et SYS-02.2-07. Les objectifs complets restent ouverts.

## Résultat attendu et observé

Remplacer les contextes arbitraires du banc précédent par les constructeurs natifs, vérifier leurs entrées et refus, et relier les résultats aux consommateurs actuels. Aucun code du jeu ni asset n’a été modifié.

AF3810 et B0F550 exécutent maintenant leurs corps originaux : pool de contrôle64nœuds, initialisation des huit listeners, choix du périphérique de secours, pool jobs512nœuds et table sinusoïdale129valeurs. Le périphérique sélectionné est écrit par le code natif. Les appels physiques COM/événements et la readiness mémoire restent explicitement adaptés.

Le contexte commun est alloué sur168octets puis construit par B05810/B06020 : deux pages2048octets, table de8entrées et deux pools de32nœuds de12octets. Le manager de transitions est alloué sur28octets puis construit par AF5450/AF5950 : l’entrée0 sélectionne une capacité255 et deux tableaux1020octets. La publication des deux pointeurs globaux reste effectuée par le banc ; les callers entiers AEA640/AEA9D0 sont analysés statiquement seulement.

| Contrôle exécuté | Attendu et observé |
| --- | --- |
| Constructeurs,25profils | 18succès retournent1 ;7refus ciblés retournent52 |
| Common | Remplissages00/A5/FF conservés dans le padding ; budget0/8192/131072 donne maximum2/4/64pages ; deux pages initiales |
| Transitions | Capacités0/1/8 donnent255/1/8 ; champs de compteurs nuls ; tableaux non écrasés par une initialisation inventée |
| Allocations refusées | Cinq positions common et deux positions transitions ; allocations antérieures parfois retenues, détail conservé |
| Lecture native | 31médias,804appels B06950 ;31quotas0,742frames actives et31arrêts |
| Sorties | 742empreintes actives identiques à V768 ;61frames positives, les31médias produisent un signal |
| Décodage | 712buffers et729088échantillons PCM16 ; écart maximal1unité avec31WAV identifiés |
| Intégrité | 4780blocs du parcours média et51blocs des constructeurs comparés au PE original |
| Durée de vie | 3793allocations,2150libérations,1643restantes après nettoyage des voix/objets ; pas de teardown global |
| Rejet de fausses preuves | 16falsifications rejetées, dont faux succès OOM et fausse libération COM |

Les cinq refus common conservent respectivement0/0/2/3/4allocations ; le deuxième libère la première page après échec de sa table. Le refus du deuxième tableau de transitions conserve le premier. Ces observations ne sont pas une preuve de fuite définitive : le teardown supérieur n’est pas exécuté.

## REA et sources

REA6.4.0, SDK2.3.1, Ghidra12.1.4/Java21 :12fonctions,673instructions,13références, session exportée et fermée sans erreur. Fonctions : AEA640,AEA9D0 (résolue depuisAEAC25),B05810,B06020,B089A0,AF5450,AF5950,AF3810,AF7650,B0FEA0,B0C830,B0BF30. Les octets des plages, y compris disjointes, sont vérifiés.

Source PE : `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe`.
SHA256 : `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. L’original reste inchangé ; aucun processus historique lancé.

AEA640 appelle AF3810 puis alloue/construit le common, publie son pointeur et appelle B089A0. AEA9D0 construit une série de managers, dont les transitions avec le paramètre14A79D0. B089A0 crée l’événement manuel du worker puis appelle B20DA0. Ces fonctions parents et le démarrage du worker ne sont pas exécutés dans ce profil.

## Consommateurs actuels

- `audio_common_queue::Context` possède une projection152octets, une table et des pages ; ce n’est pas la classe native entière168octets. Ses consommateurs existants sont conservés.
- `audio_due_actions::Runtime` possède les nœuds, commandes et actions ; la provenance des deux pools natifs et leur intégration complète restent à qualifier.
- `audio_normal_frame::Services::advance_a` exige un service concret pour avancer le manager ; aucune implémentation ordinaire complète de ce manager n’est revendiquée ici.
- `audio_device_factory::Runtime::create` est déjà présent et inscrit. Son lien est réutilisé, avec sa dépendance aux services physiques.

Ces quatre ancres sont relues et vérifiées par empreinte ; trois sont ajoutées au registre. Aucun test Rust nouveau ni compilation produit dans cette révision. Les tests précédents restent des preuves datées, sans promotion de portée.

## Adaptateurs, échecs et limites

Le x86 original s’exécute dans Unicorn ; allocations physiques, verrous, TLS, atomiques, horloge, critical section, événements, COM et atexit sont adaptés. CPUID décrit le modèle Unicorn. Choix kind3, readiness1 et marqueur stream sont fournis. Les banques sont chargées avant AF3810 dans le banc composé : l’ordre historique complet n’est pas qualifié.

L’interface COM fournie reçoit AddRef1→2, l’inscription du callback natif12octets, puis Release2→1. Ce callback et sa référence demeurent vivants. Il ne s’agit pas d’un objet COM Windows ni d’une sortie sonore physique. Les pools de travail sont initialisés mais aucun worker n’est lancé.

Le premier profil avec COM indisponible atteint DF8670, dépendance non fournie sur le chemin alternatif de notification Windows ; aucun succès ou refus propre n’est inventé. REA montre la branche RegisterDeviceNotificationW/SetWindowLongW. L’interprétation préliminaire « CRT logging » du banc est conservée mais corrigée ici : aucun logger n’a été démontré.

Le premier validateur supposait un contexte de capture pour tous les appels ; les appels antérieurs au corps constant5EB4B0 portent context=None. La correction distincte n’autorise cette absence que pour cette fonction et garde l’ordre du démarrage strict. Les preuves natives n’ont pas été retouchées ; le premier échec reste conservé.

Positions nulles, horloge1000+21ms, files commandes/actions échues vides, callbacks/worker/final optionnels vides restent déclarés. Les tableaux et capacités sont réels mais leurs chemins non vides ne sont pas tous exercés. Autres médias/locales, streaming,seek,boucles,concurrence,quotas multiples actifs,sortie physique et teardown global restent ouverts. Un média atteint la borne80 avec première frame positive79.

## Preuves et fichiers

Dossier : `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20`.

- `revision770_rea_audio_contexts/observations/37d12aec-6eeb-4901-b65f-f57fa7170c71/receipt.json` : REA.
- `revision770_contexts_explore/FAILED.json` : premier chemin COM indisponible.
- `revision770_contexts_com_adapter/OBSERVATIONS.json` : premier média avec COM déclaré.
- `revision770_contexts_checked/OBSERVATIONS.json` :31médias et ordonnanceur.
- `revision770_constructor_boundaries/OBSERVATIONS.json` :25profils de construction.
- `revision770_contexts_validation/FAILED.json` et `revision770_contexts_validation_corrected/OBSERVATIONS.json` : échec initial et correction séparée.
- `revision770_contexts_associations/OBSERVATIONS.json` : ancres et16falsifications rejetées.
- `revision770_delivery/VERIFIED.json`, `INDEPENDENT_READBACK.json` : publication ciblée et relecture.

Livrables intégrés : ce rapport et `docs/fidelity_rea_audio_contexts_v770.json`. Registres sources/exigences/tâches, documents de couverture/reprise et deux bases locales sont enrichis ; cases, notes, historiques et inconnues restent conservés. Les deltas ciblés permettent de vérifier les octets antérieurs sans copie intégrale des bases.

## Suite

Qualifier AEA640/AEA9D0 et leurs paramètres/managers, puis B089A0/B20DA0 et le chemin de notifications Windows. Relier ces producteurs au backend actuel, puis vérifier les entrées réelles et le transport physique. Ni le moteur audio complet ni le jeu entier ne sont déclarés terminés.
