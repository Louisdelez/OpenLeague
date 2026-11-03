# Timer natif et horloge — référence LoL 4.20

Cette étude concerne SYS-01.2-02/03/05/06. Elle affine l’inconnue existante du script Map10 NeutralMinionSpawn. Le client reste PUBLIC 4.20.0.315, EUW/en_GB. Le Goal complet et les autres inconnues restent conservés.

## Périmètre et provenance

Le PE original est identifié par son chemin, ses 15 973 880 octets et son SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Les expériences exécutent ses instructions dans Unicorn 2.1.4, avec les états fournis explicitement : image, registres, pile, SEH, FPU, horloges et réserve de timers. Aucun processus historique du jeu n’est lancé.

Les 100 profils numériques/arithmétiques hérités sont relus sans rejouer leurs expériences. Les 221 nouveaux profils se répartissent en 144 corps complets timer/réserve, 13 préfixes d’écriture d’horloge et 64 préfixes d’expiration. Les identités de Python, du module d’émulation, du backend DLL et des producteurs sont conservées. Une inspection distincte du backend courant ne prétend pas observer rétroactivement les processus précédents.

## Résultats et limites

| Observation | Résultat sur les états fournis | Limite |
|---|---|---|
| Fonction numérique 0xca5f30, 28 profils | Concordance avec ceil sur les valeurs finies ; signe des zéros conservé | Modes FPU fournis ; NaN, infinis et autres états non qualifiés |
| Préfixe 0x6a6eaa..0x6a6ef6, 72 profils | Prépare ceil(temps écoulé)+délai−temps écoulé et un second flottant nul | Arrêt avant copie du callback et inscription |
| Corps 0x6a6e80 / 0x6a6dc0, 144 profils | Recherche du premier des 64 emplacements dont le type Lua est nul ; inscription aux emplacements 0/2 ou réserve pleine inchangée | Copie, affectation et destruction de références Lua sont trois frontières d’observation opaques |
| Préfixes d’horloge, 13 profils | Une époque négative peut être remplacée par le temps courant ; un autre chemin copie le flottant fourni à EBX+5 | Message, dispatcher, valeurs historiques et suite du cycle non établis |
| Préfixe d’expiration 0x593bf0, 64 profils | Addition du delta au temps écoulé, comparaison au seuil, soustraction du seuil à la première expiration ; drapeau actif retiré pour le cas non répétitif | Arrêt avant préparation du callback ou avant la famille de timers suivante |

Le vrai prédicat 0x48d260 est exécuté. Les corps timer/réserve restaurent la pile et la chaîne SEH dans les profils observés, préservent les canaris et n’ont aucun accès invalide. Les références Lua fournies sont des marqueurs opaques ; leurs liens de propriété et le véritable état Lua ne sont pas qualifiés.

La réserve contient 64 enregistrements de 0x48 octets. La référence de callback commence à +0x28. Les champs +0 et +4 sont respectivement l’accumulateur de temps écoulé et le seuil de durée dans le préfixe d’expiration observé. Le reçu brut préparatoire utilisait le libellé « interval_offset » pour +0 et « countdown_offset » pour +4 : ces noms sont clarifiés par un document distinct, sans modifier ses octets ni ses résultats.

L’époque 85 est une entrée de test. Ni sa présence dans ces profils, ni l’écart de 85 entre les champs de délai Lua Map10 et les configurations actuelles ne prouve la valeur historique ou les horaires absolus de la carte. Les candidats d’opérandes obtenus par recherche des deux adresses globales ne constituent pas une preuve de toutes les écritures ni un graphe de contrôle complet.

## Instructions et consommateurs

Les 283 adresses d’instruction sont relues dans les octets du PE. Le décompte de 93 246 instructions originales exclut l’adaptateur local FSTP, les visites aux trois entrées Lua contournées par l’hôte et les points d’arrêt atteints avant exécution. Les reçus bruts gardent leur compteur de visites ; la normalisation est explicite et liée par SHA.

Cinq ancres Rust identifient les délais initiaux et de réapparition des camps, les délais distincts de la relique et la conversion des secondes en ticks. Six ancres communautaires conservent la création, le stockage, la décrémentation et la remise à la valeur du timer. Ces sources sont inspectées ; aucun nouveau test de gameplay Rust ou serveur communautaire n’est revendiqué. La conversion locale en ticks ne prouve pas une équivalence avec l’époque du client historique.

## Qualification et conditions de résolution

L’auditeur relit les identités, les profils, les flottants, les effets sur toute la réserve, la discipline de pile/SEH, les frontières Lua, la normalisation des traces et les consommateurs. La qualification réussit 58 contrôles : cas nominal, 56 refus de données altérées et un contrôle positif de représentation scalaire. Aucun scénario machine original n’est rejoué par l’auditeur.

L’inconnue Map10 reste ouverte. Il faut encore qualifier la gestion réelle des références Lua, la conversion des arguments, l’exécution des callbacks et la suite complète de la mise à jour, puis identifier le message/dispatcher et les écritures historiques effectives de l’horloge. La comparaison avec Rust et les scripts communautaires doit garder leurs contextes distincts ; le code du client ne qualifie pas un serveur historique complet.

Les identifiants, anciennes sources, relations, questions, conditions de résolution, états et historiques manuels sont conservés. Aucun champion ni jeu complet n’est déclaré terminé.

Preuve de livraison : docs/fidelity_registry_native_timer_revision_4_20.json. Sources et journaux : E:/mapslol3v3/Requirements_registry_4_20_2026-10-20/revision43.
