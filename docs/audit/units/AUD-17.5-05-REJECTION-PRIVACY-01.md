# AUD-17.5-05-REJECTION-PRIVACY-01

## Résultat et portée

SYS-17.5-05 : chemin SessionGameplayRejected → diagnostic et branche Attack audités par source, prêts pour relecture. **Confidentialité exhaustive encore ouverte. Aucun paquet, jeu ou test Rust exécuté.**

Le garde de contexte et de longueur est utile, mais ne qualifie pas la confidentialité du contenu. Une différence conditionnelle de raisons peut distinguer cible inconnue et cible invisible. Le motif général est reçu/loggé puis placé dans le diagnostic F3 ; ce n’est pas une notification normale complète démontrée.

Audit, implémentation, vérification graphique/réseau et acceptation humaine restent séparés. Aucune modification du goal, de ses critères, de l’application, Plan, UI, registres ou bases.

## Preuves et consommateurs réutilisés

Tâche et prérequis D17-SYS-17-5 inchangés ; quatre prérequis a_faire. Audits contrôle session/pause et scoreboard public relus par identité et observations, sans relancer leurs programmes ni inventer leurs anciens reçus code 0. Le snapshot filtre players/units par visible_to ; le roster contient identité/team/score et ne doit pas être assimilé à tous les états privés. La politique historique de permission/divulgation reste non qualifiée.

Trois queries de symboles ont été exécutées une fois : trajet GameplayRejected/command, report/Connection, target_info/protected/visible_to. Leurs dix hits, scopes, lignes et identifiants de retours outils sont consignés ; aucun scanner n’est relancé par les contrôleurs documentaires.

## Chaîne observée dans les sources

- **1 command outcome** — An accepted command error String becomes a GameplayRejection with the accepted context and sequence. Pause and clock errors share this channel. Limite : Accepted session input is a precondition; no packet/session admission executed.

- **2 receive guard** — Foreign context or reason.len()>512 returns Foreign gameplay rejection; otherwise the String is forwarded. Limite : Length is Rust String bytes and context is identity; neither classifies the reason by public/private knowledge.

- **3 receive/report** — The pause controller receives context+sequence, then connection.report gets the reason independently of pause matching. A ready presented state clears connection.rejection. Limite : A source update may clear the diagnostic; persistence is not a verified user notice.

- **4 storage and log** — A changed reason is logged and stored as supplied, without a field-level projection in this method. Limite : Hiding a label does not prevent this client from receiving/logging the reason.

- **5 display** — Not-ready state displays session_status. Ready in-match diagnostic uses F3 visibility, snapshot/player gates and hides after winner. Its text includes connection.rejection. Limite : This is a gated diagnostic, not proof of a normal dedicated rejection notice for every command.

## Témoin conditionnel Attack

Préconditions : requête admise, acteur valide/vivant et non bloqué, hôte non en pause, attaque non bloquée par le cast, visibilité susceptible d’être fausse. L’existence/identité visée doit être non publique selon le contrat retenu. Si interactions est absent, visible_to retourne true : le témoin invisible ne s’applique alors pas.

`target_info` consulte players puis units. Ordre Attack : unknown target → target protected → invalid enemy target → target not visible. Le motif est transmis sans projection de catégorie par l’hôte inspecté ; réception et report ne le rendent pas public par leur seule limite de longueur.

Deux branches source : cible non résolue → « unknown target » ; cible ennemie vivante non protégée résolue mais invisible → « target not visible ». Si ces états sont indiscernables au regard de la connaissance publique admise, le motif distingue l’existence d’une cible cachée. **Constat conditionnel de source, pas fuite/exploit réseau observé**, ni récupération de la politique native. Aucun contenu numérique privé n’est affirmé dans ces littéraux.

La pause filtre son feedback par contexte/séquence, mais main appelle ensuite report indépendamment du succès de cette corrélation. Le diagnostic peut être effacé au prochain état présenté ready. Masquer F3 ne supprime pas la réception/le log du motif.

## Travail documentaire restant, délimité

- **Buy** — `self.buy_item(id, item)?` : définir le producteur réel, inventorier ses erreurs propagées, classer ce qui est publiable au destinataire. Arbre non audité dans ce lot.
- **Sell** — `self.sell_item(id, slot)?` : définir le producteur réel, inventorier ses erreurs propagées, classer ce qui est publiable au destinataire. Arbre non audité dans ce lot.
- **UseItem** — `self.use_item(id, slot)?` : définir le producteur réel, inventorier ses erreurs propagées, classer ce qui est publiable au destinataire. Arbre non audité dans ce lot.
- **SwapItems** — `self.swap_items(id, from, to)?` : définir le producteur réel, inventorier ses erreurs propagées, classer ce qui est publiable au destinataire. Arbre non audité dans ce lot.
- **SwapItemsChecked** — `self.swap_items_checked(id, from, to, expected_inventory, expected_counts)?` : définir le producteur réel, inventorier ses erreurs propagées, classer ce qui est publiable au destinataire. Arbre non audité dans ce lot.
- **Summoner** — `self.cast_summoner(id, slot)?` : définir le producteur réel, inventorier ses erreurs propagées, classer ce qui est publiable au destinataire. Arbre non audité dans ce lot.
- **SummonerTarget** — `self.cast_summoner_on(id, slot, target)?` : définir le producteur réel, inventorier ses erreurs propagées, classer ce qui est publiable au destinataire. Arbre non audité dans ce lot.
- **Learn** — `self.learn(id, slot)?` : définir le producteur réel, inventorier ses erreurs propagées, classer ce qui est publiable au destinataire. Arbre non audité dans ce lot.
- **Cast** — `self.cast(id, slot, target)?` : définir le producteur réel, inventorier ses erreurs propagées, classer ce qui est publiable au destinataire. Arbre non audité dans ce lot.
- **CastAt** — `self.cast_at(id,slot,point)?` : définir le producteur réel, inventorier ses erreurs propagées, classer ce qui est publiable au destinataire. Arbre non audité dans ce lot.

Move/Stop, ClockAck/pause, SessionRejected et legacy sont aussi hors clôture de ce chemin borné. Le prochain lot traite les dix appels ci-dessus sans refaire le trajet clos.

## Corrections proposées, non appliquées

### HUD-ATTACK-REJECTION-DISCLOSURE-01

Qualifier la divulgation du motif de refus pour la seule commande Attack.

Écart : Les raisons unknown/protected/invalid/not visible suivent des branches distinctes avant ou à la garde visibilité et sont transmises telles quelles ; contexte et longueur ne prouvent pas la confidentialité.

Travail : Définir une projection de refus fondée sur la connaissance publique admise du destinataire, puis appliquer ce contrat au producteur transmis/loggé. Garder les diagnostics internes distincts si nécessaire sans exposer au client le motif secret. Ne pas imposer un ordre naïf des gardes ni supprimer les validations de simulation.

Fin : Pour deux états ne différant que par une cible non publique absente/résolue invisible, la réponse publique suit le contrat choisi sans oracle. Cible publique valide/invalide, contexte étranger et limite de message restent vérifiés. Source, état public et décisions comparées sont nommés.

Reprise : Contrat de divulgation 4.20 ou politique locale explicitement admise, scénarios appariés correspondant au témoin conditionnel, puis autorisation produit distincte.

### HUD-REJECTION-PRESENTATION-01

Qualifier un canal normal de retour de refus de commande.

Écart : Le motif général est dans un diagnostic F3 et peut être effacé à la présentation d’un état ready ; la pause a un retour générique corrélé distinct.

Travail : Choisir le canal utilisateur, la corrélation commande/contexte, la traduction et la durée/retrait admise pour un motif déjà public. Raccorder un refus nommé sans substituer le diagnostic F3 à la notification attendue.

Fin : Un refus public identifié est lisible dans le contexte attendu sans F3 selon contrat ; une réponse étrangère/ancienne et un changement de contexte ne réaffichent pas un motif périmé ; effacement et succès sont explicitement vérifiés.

Reprise : Politique de présentation native ou locale nommée et motif public qualifié, puis autorisation produit distincte.

## Manques et reprise

- **REJECTION-DELEGATED-TREES** — Les dix appels délégués, Move/Stop, erreurs ClockAck/pause, SessionRejected et chemins legacy ne sont pas intégralement classifiés ici. Ce n’est pas un inventaire complet des messages du jeu. Reprise : Prochain lot : dix appels nommés ci-dessous, définition réelle et erreurs propagées une famille à la fois ; réutiliser les audits existants avant tout locator nouveau.

- **REJECTION-DISCLOSURE-CONTRACT** — La politique native de divulgation des motifs n’est pas qualifiée. Le témoin Attack est conditionnel à une différence de cible non publique, pas une fuite réseau observée. Reprise : Une règle/observation 4.20 précise ou une politique locale explicitement admise qui décide les connaissances publiques et la classification des erreurs. Le manque produit reste une correction ; ne pas relancer de recherche générale sans nouvelle piste.

- **REJECTION-PLAYER-PRESENTATION** — Le diagnostic F3 et le feedback pause générique ne qualifient pas le parcours complet de refus utilisateur, sa persistance, localisation ou lisibilité. Reprise : Politique du canal normal et un motif déjà public, puis vérification du vrai parcours sous autorisation de modification/exécution distincte.

## Vérifications et décision

Nouveaux fichiers uniquement sous F:/OpenLeague-work/audit-units/AUD-17.5-05-REJECTION-PRIVACY-01/ et ce rapport. Le producteur vérifie identités, pointeurs, dix fenêtres actuelles, trois fenêtres empruntées, douze invariants, dix routes déléguées et les gardes de conservation ; le lecteur séparé vérifie le sens, les empreintes, les corrections et les limites. Les codes et nombres réellement exécutés sont dans producer-execution.json et reader-execution.json.

Cinq registres, 25 fichiers protégés et 1168 sources comparés avant/après ; modifications Git antérieures conservées. Aucun install, migration, exécution originale/AS/Rust/jeu/GUI/réseau, émulation, export ou accès aux bases. Les anciens tests/queries/lecteurs ne sont pas relancés.

Clôture après lecteur : ce sous-audit documentaire seulement. SYS-17.5-05 entier reste ouvert ; fonctionnalité et confidentialité globale non qualifiées, acceptation humaine non revendiquée. Prochain lot : AUD-17.5-05-DELEGATED-REJECTIONS-01.
