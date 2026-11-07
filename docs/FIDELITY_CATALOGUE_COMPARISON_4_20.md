# Révision courante — conversion originale de Karma

Il reste **2comparaisons numériques ouvertes**, pour les caps de maîtrise4312/4313. Les deux textesKarmaQ `6.5.0000` et `5.5.0000` donnent6.5et5.5 via le convertisseur original0xc99987/0xc998e9, puis la boucle originale0x767a86..0x767c49 les stocke dans les cooldowns. La qualification vaut pour les tables initiales de locale embarquées ; la récupération du pointeur de donnéesCRT de thread est adaptée, sans remplacement du parser ni du calcul. Les surcharges historiques de locale restent une question distincte. Les11contrôles couvrent valeurs usuelles, exposants, suffixes, virgule, chaîne invalide/vide et refus des entréesNUL/nonASCII/trop longues. Le getter natif est lié statiquement : lectureString0x8af290, appelconvertisseur0x8ae255, storefloat32à0x8ae260 ; le getter/cache complet n’est pas exécuté. Relecture : `python -B tools/project-plan/original_numeric_reference.py --root E:/OpenLeague`. Aucun gameplayKarma ni règle locale de parsing global ajoutés.

Les9139exportsAIR n’ont aucun littéral4312/4313 pertinent ;285journaux ne contiennent pas les tokens talentTree/maxRank. Le manifesteAIR119 et les consommateurs effectifs du DTO sont examinés. Ces recherches textuelles ne décodent pas un fluxAMF arbitraire et ne récupèrent pas le backend ; les caps restent ouverts. Les preuves précédentes sont conservées. Preuve courante : `docs/fidelity_registry_numeric_revision_4_20.json`.

---

# Révision courante — 147 résolutions supplémentaires

Sur18414comparaisons, il reste **4lignes ouvertes**, contre151avant cette révision : KarmaQCooldown2/4 (textes6.5.0000/5.5.0000, conversionCRT non qualifiée), maîtrises4312/4313 (cap Talent.maxRank effectif non récupéré). 138defaults rangés sont prouvés par la boucle originale0x767a86..0x767c49, un effetJayce par0x767427..0x7674a4.511entrées ont été exercées, avec refus strict deKarma et5contrôles. Le code original fournit les defaults et effectue les stores ; INIBIN/sprintf/setupscalaire sont adaptés, sans cache/overlay complet ni match natif. Les3portéesNami2750 désignentNamiRMissile explicitement lié parExtraSpell1 ; NamiR garde ses autres champs de targeting/affichage. Les5liens SpecialRecipe3169 d’objets InStore0 ne deviennent pas des recettes achetables.

Relecture réelle : `python -B tools/project-plan/native_constructor_reference.py --root E:/OpenLeague`. Les résolutions, sources, SHA et limites sont persistés dans le JSON de comparaison et les reçus docs/reference_native_constructor_sources/. 147questions sont résolues sans suppression ; le comportement du serveur et la fidélité complète des descriptions ne sont pas prouvés. Preuve : docs/fidelity_registry_constructor_revision_4_20.json.

---

# Comparaison native et DataDragon4.20.1 — SYS-01.2-04

18 414valeurs/repères sont comparés dans122champions,499entrées de capacités (dont11formes supplémentaires),280objets,296runes,57maîtrises et13sorts invocateur.1267sources INIBIN sont hachées et recoupées avec un lecteur indépendant. Les JSON exportés et leurs SHA ne sont jamais présentés comme les octets INIBIN originaux.

16 216comparaisons sont égales.146écarts de régénération sont résolus dans leur consommateur actuel : champion_growth conserve la valeur native par seconde et regeneration.rs l’utilise comme telle ; le nombre du catalogue par cinq secondes reste séparé.1876cas de portée/affichage restent dans leur espace de présentation : une sentinelle CastRange25000 ne devient pas une portée serveur.16écarts d’effets sont expliqués par les expressions anglaises originales : KatarinaR `Effect1Amount*10` ; AzirQ et LissandraQ/R `*-100`. Les champs bruts, la formule et les lignes natives sont conservés. Cela ne prouve pas l’ordonnancement des coups du serveur.

Cinq liens de transformation d’objets non achetables restent distincts d’une recette achetable : le RecipeItem natif vaut0, le catalogue décrit un lien from, et la boutique actuelle refuse ces entrées absentes. Quatre conflits de rangs de maîtrise sont expliqués par les descriptions natives localisées et la séparation de SpellData.Ranks et du Talent.maxRank AIR. MasteriesController.grabCatalog utilise session.summonerCatalog.talentTree ; buildFakeMasteryTree est exclu, car il contient un ancien arbre factice.55/57nombres de descriptions natives non vides concordent avec le catalogue ;4312/4313restent divergents.

**La tâche reste partielle :151lignes sont ouvertes.** Elles incluent des champs par rang absents avec scalaire candidat, le sens de valeurs d’effet/défaut, la portée de NamiR et les deux maîtrises ci-dessus. Aucune valeur manquante n’est transformée en zéro, aucun héritage scalaire n’est supposé. Les recherches exactes et conditions de résolution sont reliées au registre des inconnues.

Les choix et preuves ligne par ligne se trouvent dans `fidelity_catalogue_comparison_4_20.json` ; les refus de normalisation sont testés. Les descriptions, toutes les règles dynamiques et l’exécution native intégrale ne sont pas qualifiées par une comparaison numérique. Aucun contenu runtime n’est réécrit sans nécessité démontrée.
