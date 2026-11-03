# Audit numérique ciblé — 488 ressources de sorts (2026-11-03)

## Périmètre et conclusion

Unité AUD-SYS-01.2-02-CHAMPION-SPELL-NUMERIC-FIELDS-01. Suite de V1112 : comparer 26 champs SpellData par ressource, entre les 488 INIBIN native déjà identifiés et data/4.20/native_spells_420.json, sans inventer de valeur absente. Ce contrôle de données est clos pour les champs et le snapshot décrits; il ne clôt ni les règles du serveur historique, ni les mécaniques, ni les audits de toutes les capacités.

## Source et consommateur

Les chemins et SHA des 488 ressources 4.20.0.315 sont réutilisés du reçu E:/mapslol3v3/champion_spell_source_link_audit/resultats.json, SHA-256 3531d928bbb243d3a2d18d338c1e5ff8ae06034fd8906af4f4e723a4f4d0b801; chaque fichier a été relu et son identité comparée de nouveau avant décodage. Le lecteur F:/OpenLeague/tools/project-plan/reference_inibin.py SHA-256 8649d9775feaa9a8a549e07e8a8b6f57a4d4bf91e68841094fa5ccec383a5da5 interprète les hashes en section SpellData. Export local data/4.20/native_spells_420.json SHA-256 0cae6f5c167aa852e8f86e7f3298d7c797727d5cc92616dcb856ac15c8af5d14. La concordance avec un hash nommé ne prouve pas seule l'absence de collision avec un nom natif inconnu.

Consumers courants inspectés : native_hud_spells.rs:21–31 lit ManaCost{rang} de l'export pour calculer l'état de ressource si rang, cooldown et autres gardes le permettent; il lit le cooldown courant du champion, non les chaînes Cooldown de l'export. spells.rs:60–85 lit des champs de l'export pour Garen uniquement; des parseurs dédiés Ezreal utilisent aussi cet export. Ces liens ne prouvent pas que les autres champions consomment toutes les valeurs. V1110 établit séparément le refus des commandes de sort de 118 champions dans sa fixture, dont Karma et Yasuo; ne pas extrapoler à un rendu graphique.

## Comparaison exécutée

`F:/OpenLeague/.ai-tools/.venv/Scripts/python.exe -B E:/mapslol3v3/champion_spell_numeric_audit/probe.py`, code 0. Les 26 clés ciblées sont ManaCost1–5, Cooldown1–5, Effect1Level1Amount–Effect1Level5Amount, Effect2Level1Amount–Effect2Level5Amount, Coefficient, Coefficient2, CastRange, CastRangeDisplayOverride, CastRadius et CastRadiusSecondary. Comparaison numérique finie via math.isclose, tolérance relative et absolue 10⁻⁶. Résultat sur 12 688 couples fichier/champ :

- 11 776 valeurs présentes des deux côtés et concordantes numériquement à cette tolérance.
- 910 clés absentes des deux côtés; aucune valeur par défaut n'est déduite. Les rangs non utilisés et les attributs optionnels peuvent être inclus; ces absences ne sont pas toutes des erreurs.
- Deux valeurs de Karma Q, Cooldown2 `6.5.0000` et Cooldown4 `5.5.0000`, sont identiques textuellement dans source et export mais ne sont pas convertibles par le parseur numérique strict utilisé pour cette comparaison. Aucune présence unilatérale ni autre divergence dans les clés ciblées.

Le premier probe strict a renvoyé le code 2 sur ces deux textes; son code et son résultat sont conservés sous initial_strict_probe.py et initial_strict_resultats.json. La version finale les classe explicitement comme textes identiques non numériques au lieu de les compter comme nombres. Contrôles synthétiques : fichier INIBIN de version invalide rejeté par le lecteur; valeurs 1,0 et 1,1 distinguées par la tolérance. Ils ne testent ni le runtime original ni les refus du jeu.

Les textes Karma se trouvent aussi tels quels dans les octets du fichier natif KarmaQ.inibin (offsets 1351 et 1360; SHA-256 c79db761d7a00eb62da1d5ae2bf790ae929eb97e2877bb78f2e5654b707bcc54). **Preuve antérieure réutilisée, non rejouée** : FIDELITY_CATALOGUE_COMPARISON_4_20.md:3 et fidelity_registry_numeric_revision_4_20.json documentent que le convertisseur original isolé les lit comme 6,5 et 5,5, sous locale embarquée et avec récupération de pointeur CRT adaptée; getter/cache complet et surcharges historiques de locale restent non qualifiés. Ce résultat historique borné n'ajoute pas de conversion dans OpenLeague et ne démontre pas le gameplay de Karma.

Cas notable parmi les absences : ManaCost1–5 de Yasuo W manquent des deux côtés. FIDELITY_HUD_COST_GRAPH_V230.md:7 l'avait déjà relevé : un rang appris, prêt et autorisé ferait échouer la recherche HUD par lecture du code. Aucune exécution HUD de ce cas n'a été effectuée ici; la progression de Yasuo reste refusée dans V1110. Ne pas supposer un coût nul. Réutiliser CH-Yasuo-W-PRESENTATION-HUD et qualifier les defaults/ressources avant test de rendu.

## Preuves et limites

Répertoire E:/mapslol3v3/champion_spell_numeric_audit : probe.py SHA-256 fa8a954cd590f09102b6b5f429fc68a6076a9c295b30d5e3da88fbaa8657429c; resultats.json 8bbb1972466ecd2b20b16562955978cdda3493fbf3ee360edef68753a5d16f2d; initial_strict_probe.py 6d5fd0acf452314ef7d753b740ed3337c569b94b7f9df5eda6e8cf438830dddb; initial_strict_resultats.json ac729597b4d5c1004616923861955fe886d599d16401a4d7c174a7bccc54da30. Le reçu final contient les 488 couples, clés et classifications, non une comparaison exhaustive de toutes les propriétés INIBIN. Pas d'exécution client, HUD, serveur ou partie historique; aucune conclusion sur la sémantique de chaque coefficient ou cible.

## Suite

Réutiliser CH-<champion>-<slot>-SOURCE et SIMULATION-CONTRAT pour qualifier les valeurs réellement utilisées, les rangs spéciaux, les defaults et la sémantique; les tâches SIMULATION, NETWORK, PRESENTATION et ACCEPTANCE restent distinctes. Pour Karma, conserver la preuve native de conversion et vérifier le consumer qui sera choisi lors de son implémentation; pour Yasuo, reprendre l'analyse de coût et le test HUD quand la progression et le contrat de ressource sont définis. Ne pas refaire une comparaison inchangée sans nouvelle question ou modification d'entrée.

Audit des champs sélectionnés clos, implémentation non évaluée par cette comparaison, vérification runtime absente, acceptation humaine non demandée; SYS-01.2-02 reste ouvert. Aucun goal, registre, application de suivi, base ou code produit modifié.
