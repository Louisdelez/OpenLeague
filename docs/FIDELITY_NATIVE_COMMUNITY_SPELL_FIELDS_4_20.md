# Champs de sorts natifs et chargeur communautaire

Les488emplacements de base des122champions sont comparés sur leurs vrais fichiers. Le wrapper natif0x8B0630 reçoit la valeur par défaut Attack1 observée au caller0x767504 ;0x8B1A80 lit Flags comme un entier. Le profil Unicorn exécute les octets originaux du binaire4.20.0.315,avec les frontières mémoire/chaînes/provider/CRT déclarées. Ces essais précédents sont qualifiés ici,sans relancer le client Windows ni prétendre exécuter le chargeur complet ou un sort.

Le composant communautaire compile les vrais ContentFile.cs,HashFunctions.cs et CoreSpellDataFlags.cs inchangés. SpellData.Load est inspecté,et ses appels GetString avec file.Name par défaut et GetInt sont reproduits ;la méthode complète et le serveur ne sont pas exécutés. Newtonsoft.Json13.0.1 provient du cache exact,pas d’un téléchargement. Hôte observé :.NET8.0.25,X64,fr-CH ;aucune équivalence de conversion avec un JIT historique n’est déduite.

Résultats :477champs nommés,huit explicitement vides et trois absents. Le natif préserve les huit chaînes vides et utilise Attack1 pour les trois absences. Le getter communautaire ignore les valeurs nommées vides et fournit le nom du sort pour ces onze cas ;aucun alias UNKNOWN_HASHES n’est présent dans leurs vrais documents. CinqFlags diffèrent malgré une valeur brute communautaire identique au natif :GnarE,JaxLeapStrike,KatarinaE,BlindMonkWOne etChronoShift. GetInt passe par GetFloat,puis cast int :les quatre premiers perdent4 par arrondi float32 ;ChronoShift dépasse int32 et donne2147483648 en u32 sur l’hôte observé,contre2147551492 au natif. Les libellés communautaires InstantCast/AlwaysSelf ne prouvent pas la sémantique native.

| Champion/emplacement | Champ | Natif | Composant communautaire |
|---|---|---|---|
|Braum/3|AnimationName|'Attack1'|'BraumE'|
|Gnar/3|Flags|201452548|201452544|
|Jax/1|Flags|201452548|201452544|
|Karma/3|AnimationName|''|'KarmaSolKimShield'|
|Katarina/3|Flags|201452548|201452544|
|LeeSin/2|Flags|201426948|201426944|
|Lissandra/1|AnimationName|''|'LissandraQ'|
|Sion/1|AnimationName|'Attack1'|'SionQ'|
|Thresh/1|AnimationName|''|'ThreshQ'|
|Varus/2|AnimationName|''|'VarusW'|
|Vayne/2|AnimationName|''|'VayneSilveredBolts'|
|Velkoz/2|AnimationName|''|'VelkozW'|
|Vi/1|AnimationName|''|'ViQ'|
|Vi/2|AnimationName|''|'ViW'|
|Yasuo/1|AnimationName|'Attack1'|'YasuoQW'|
|Zilean/4|Flags|2147551492|2147483648|

Décision de référence : conserver les sorties natives de ce contrat et enregistrer les contradictions communautaires séparément. Aucun remappage d’animation ni comportement de sort n’est inventé. Les autres sémantiques des797scripts ne sont pas qualifiées par ces deux champs. Les15inconnues de rôles sont précisées et restent ouvertes,avec l’historique antérieur conservé.

36contrôles passent,dont16refus :preuves/sources divergentes,slot manquant/dupliqué,mauvais sort,fausse valeur par défaut,promotion d’une chaîne vide,accès mémoire invalide,Flags modifié,type invalide et fausse exécution du chargeur complet. Le premier binaire compilé échouait à résoudre Newtonsoft.Json sous son nom de copie ;l’échec terminal est conservé et un projet séparé ne corrige que le chemin/nom du DLL. Une étiquette de reçu distinguant trois fichiers compilés de cinq fichiers inspectés est corrigée dans un reçu dérivé,avec l’original intact.

Le consommateur maintenu compare_native_community_spell_fields.py est exécuté après installation ;488exigences de présentation,dixROLE et quatreSYS sont reliées. Sources/versions/SHA,statuts,acceptations,cases,notes et historique antérieurs sont conservés. Aucun codeRust/C de production ni asset n’est changé. Flags de cast,graphes,poses,playback,RADS/lifecycle,les capsAIR4312/4313 et les autres lacunes du Goal restent ouverts.

Preuves : [comparaison qualifiée](reference_native_skin_loader_sources/native-community-spell-field-comparison.json),[intégration](fidelity_registry_native_community_spell_fields_revision_4_20.json).
