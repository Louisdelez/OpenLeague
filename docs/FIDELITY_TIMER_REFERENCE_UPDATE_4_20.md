# Références Lua et mise à jour des timers — LoL 4.20 — V44

Cette preuve enrichit SYS-01.2-02/03/05/06 et la question existante sur `Maps/Map10/NeutralMinionSpawn.cs`. Elle conserve les six objectifs du Goal et toutes les preuves V43. Les statuts des tâches et les états manuels ne sont pas acceptés automatiquement.

## Sources et consommateur

Le PE original `League of Legends.exe` est celui de la référence PUBLIC4.20.0.315, Releases/4.20, EUW/en_GB : SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`,15973880octets. Le source Lua Map10 et le fichier communautaire exact sont reliés par le registre existant ; un fichier communautaire modifié ne devient pas un blob amont vérifié.

L'auditeur installé `tools/project-plan/audit_timer_reference_update.py` vérifie les reçus terminés, les matrices de profils, les pools complets, listes, états et instructions PE. Il ne rejoue pas les expériences natives. Les cinq ancres Rust de planification/conversion déjà présentes sont réutilisées ; elles sont lues en source. Les chemins, versions et SHA des entrées/outils figurent dans le contrat et le reçu. Unicorn2.1.4 est une émulation isolée ; aucun processus historique du jeu n'est lancé.

## Résultats attendus et observés

| Portée | Attendu | Observé |
|---|---|---|
| Références :144profils avec contexte,12sans contexte | Copie/affectation/destruction et insertion/unlink originaux ; premier emplacement nil ou pool inchangé si plein |156profils concordants, avec les SHA des pools complets et les liens exacts |
| Mise à jour :128profils | Boucles et épilogue originaux, temps écoulé/durée/flag/état actif cohérents |128profils concordants ; famille nommée fournie inactive |
| Invocation Lua | Une frontière déclarée0x5bf450, valeur fournie de type6, résultat fourni nil sans propriétaire |48demandes observées ; aucune instruction de cette frontière comptée comme exécutée |
| Reset et rattrapage | Code original0x490800 et boucles réelles |Type du callback remis à nil après première demande ; soustractions suivantes sans nouvelle demande dans ces profils |
| Interprétation du flag | Ne pas déduire une répétition des callbacks d'un nom provisoire |Offset8 contrôle ici le maintien du flag actif ; les anciens libellés/reçus sont conservés avec cette clarification |
| Refus et contrôle positif | Refuser les identités, états, résultats, listes, types et comptes altérés ; accepter une représentation scalaire équivalente |63contrôles :61refus attendus,1nominal et1contrôle positif |

Le cumul couvre605profils :321hérités plus284nouveaux.446adresses d'instruction et300196instructions originales sont identifiées, dont206950dans les nouveaux profils. Les48visites de hook à0x5bf450 sont exclues. Les adaptateurs et frontières des321profils hérités conservent leur portée initiale.

## Limites conservées

Les structures de contexte et d'état Lua, les listes et la valeur opaque de type fonction sont fournies. Les opérations de référence exécutées ne prouvent pas une VM historique, une vraie fermeture Lua ou son cycle GC. L'appel et ses effets/réordonnancements, ainsi que la propriété d'un vrai résultat Lua, restent ouverts. La famille des timers nommés actifs n'est pas qualifiée. Les états historiques d'époque, la source du delta, la conversion des arguments et le contexte serveur original restent inconnus. La lecture des consommateurs Rust/CSharp ne prouve pas une équivalence de gameplay.

L'inconnue Map10 est enrichie avec ses recherches et conditions de résolution, sans être fermée. Les plafonds4312/4313 et les autres consommateurs/scripts requis restent distincts. Aucun jeu, champion, moteur ou serveur complet n'est déclaré terminé.

## Livraison

Le reçu `docs/fidelity_registry_timer_reference_update_revision_4_20.json` contient les contrôles exécutés, les identités, les fichiers modifiés, la publication additive et l'audit de conservation. La couverture, le plan, le checkpoint et les notes de reprise sont actualisés. Le contrôle final exige les42214consignes,15échantillons HTTP, la même base pour Tauri et la conservation des42606états et de tout l'historique manuel. Ces contrôles sont distincts d'une observation de fenêtre native et de l'acceptation utilisateur.
