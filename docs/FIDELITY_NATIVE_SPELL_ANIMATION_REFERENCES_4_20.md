# Références d’animation :122champions,488emplacements de base

Le contrôle parcourt les quatre champs Data.Spell de chacun des122champions de base,les ressources de sorts exactes et leurs champs SpellData.AnimationName et Flags. Les sources natives correspondent aux chemins,tailles et MD5 des manifestes sélectionnés par la solution EUW68.922fichiers sont fraîchement identifiés par SHA. Les122GLB effectivement référencés par request/Catalog::default sont lus : leurs noms d’animations correspondent tous au catalogue courant. Ezreal utilise explicitement son modèle local joint_identity ; le modèle générique n’est pas substitué.

Résultats :477champs AnimationName nommés,huit explicitement vides et trois absents. Ces états restent distincts. Les dix rôles actuellement absents sont retrouvés précisément ; aucune de ces dix références n’a une arête directe type1 qualifiée depuis son alias dans les graphes candidats inspectés. AzirSpell1 pointe vers un nœud de type4 ;KarmaSpell3 vers un nœud de type3. Leur sémantique est opaque pour le lecteur borné actuel. FioraSpell2/3,GarenSpell2,KhazixSpell4,QuinnSpell3 etVayneSpell4 n’ont pas de nœud portant exactement l’alias recherché dans leurs candidats. Cette absence de nom ne prouve pas une absence d’animation effective.

| Cas du plan | AnimationName natif | Constat distinct |
|---|---|---|
|Karma R|Spell3|Flags262148 ;nœudtype3,aucun remappage automatique|
|Quinn W|Spell3|Flags262148 ;ne pas lui attribuer automatiquement le dash E|
|Varus W|Chaîne vide présente|La propriété existe ;politique no-cast effective à prouver|
|Vayne W|Chaîne vide présente|Même distinction ;aucune animation inventée|
|Azir Q|Spell1|Nœudtype4 ;sélection/transitions à qualifier|

Le lecteur BLNDv1 préexistant est épinglé. Seules ses arêtes directes type1 sont interprétées ;basenames de graphes,autres payloads,transitions et priorités natives restent des candidats ou des inconnues. Le modèleGLB est inspecté pour ses noms/indices,pas pour les valeurs de pose ni la fidélité de conversion des keyframes. Les formes et familles de sorts conditionnelles ne sont pas comprises dans le nombre488.

Le consommateur maintenu audit_native_animation_roles.py réalise l’analyse. Les ancres actuelles request,load_models et la branche de refus de rôle manquant dans animate sont reliées précisément.488exigences de présentation et10exigences ROLE reçoivent leurs sources ;15inconnues sont reformulées avec leurs preuves et conditions précises,toutes restent ouvertes. Leurs anciens libellés de recherche sont conservés dans l’historique ;les déclarations génériques de fichier natif absent sont remplacées par les sources réellement trouvées.

Vingtcontrôles passent,y compris refus d’un AnimationName non textuel et de deuxGLB tronqués/de longueur fausse. Aucun modèle,catalogue d’animations,codeRust/C ou asset n’est modifié. Aucun essai natif,Cargo,Bevy,jeu ou acceptation humaine n’est déduit. Les inconnues RADS/lifecycle,les capsAIR4312/4313,les scripts communautaires et les autres exigences du Goal restent ouverts. Aucun statut ou case utilisateur n’est changé.

Preuves : [audit](reference_native_skin_loader_sources/native-spell-animation-role-references.json),[intégration](fidelity_registry_animation_role_reference_revision_4_20.json).
