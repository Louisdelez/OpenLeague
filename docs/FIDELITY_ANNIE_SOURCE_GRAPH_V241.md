# SYS-01.2-02 — règles annexes Annie et consommateurs réels (V241)

Les12fiches SOURCE/SIMULATION-CONTRAT/SIMULATION d’Annie Q/W/E/R et l’objectif reçoivent leurs sources précises, ancres et preuves. Le gameplay lit annie_q_rules.json, annie_w_rules.json, annie_e_rules.json, annie_r_rules.json et une définition Tibbers distincte. Le catalogue native_spells_420 n’est pas son autorité runtime. Aucun statut de tâche ni case utilisateur n’est changé.

| Capacité | Clés réellement consommées |
|---|---:|
| Q |16|
| W |15|
| E |18|
| R |36|

Les85clés consommées comprennent75correspondances numériques natives,2délais construits depuis un offset natif et une formule communautaire GetCastTime,1fraction de remboursement issue d’une exigence textuelle native et d’une arithmétique locale,6littéraux locaux et1littéral de producteur correspondant à une valeur native de guidage. Les87clés du total des annexes ne deviennent donc pas85valeurs natives directes. pet_scale et pet_cant_cancel restent présents mais sans lecture Rust trouvée ; ils sont exclus des clés consommées.

Les10ressources natives inspectées concordent avec les manifestes sélectionnés. Les SHA des JSON décodés restent distincts des INIBIN. Les valeurs sont comparées avec le lecteur local conservé, sans nouvelle exécution de getter natif. Les textes anglais/français associés au remboursementQ sont des ressources stockées ; leur présence ne démontre pas la priorité effective de locale en_GB. Le délai0.25seconde deQ/W et les politiques du pet restent qualifiés selon leur origine communautaire/locale, sans algorithme serveur Riot reconstitué.

La définition Tibbers est insérée par world.rs:192 et peut être remplacée sur certains champs par les valeurs de rangR lors de l’invocation. AcquisitionRange625 et AttackRange125 correspondent à deux champs natifs distincts. Le générateur historique qui recopiait AttackRange vers l’acquisition décrit une filiation incomplète du JSON actuel ; il reste conservé. Les défauts de cadence/windup communautaires, l’IA, les durées et conversions locales ne sont pas une preuve de fidélité native complète.

## Vérifications

V239 exécute8tests existants, deux par capacité : nominal et refus/atomicité. Résultat8/8, code0,1926autres tests filtrés à chaque invocation. Le binaire est une copie byte-identique deV235 :F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision239/bin/openleague_core_v235.exe,787789824octets,SHA256cbe1c8e0e74f3a9a99e911462d2cbe84b4745a3dfceb476f96b976c2449b1ee0. Les sources/données observées sont rehashées avant/après et le binaireV235 est préservé. Aucun nouveau Cargo ni compilation ; aucune assertion de reproductibilité intégrale source→binaire ajoutée. Les fixtures simulent le moteur actuel, sans recette historique/GUI/GPU/audio/réseau.

Q vérifie coût,délai,dégât,remboursement sur son propre impact létal et refus atomiques. W couvre les cinq rangs et des refus géométriques/commandes. E couvre les défenses par rang, l’expiration et des gardes/CDR. R couvre les trois rangs, invocation unique, statistiques/coût/CD/durée et plusieurs refus/contrôles/mort. Ce choix ne rejoue pas tous les31tests disponibles ni toutes les interactions, l’aura, le guidage, la poursuite ou les effets de retour de dégâts. Les détails attendus/observés figurent dans les huit casV240 et leurs journauxV239.

L’audit final vérifie13sélecteurs et4refus de mauvaise affectation/section/bornes,4refus de mauvaise interprétation des sources,84identités ciblées,79ancres dont71production et8tests. Seize ancres désignent des corps fonctionnels dans cette portée. Lesdeuxbases exposent13fiches/copies/traces, integrity_check=ok, et conservent42606états manuels ainsi que l’historique. Les anciens enregistrements, liens, autres champs des tâches et inconnues restent inchangés.

Le premier précontrôle refusait une différence lexicale Menu/menu sousWindows. Même fichier physique,même taille/SHA ; le critère corrigé utilise samefile+taille+SHA sans changer les chemins historiques. Le refus survient avant mutation ;preuve :revision241/SOURCE_IDENTITY_PREFLIGHT.json. Le catalogue du plan observé avantV238 a évolué enV237 ;V240 conserve ses deux identités, compare les fichesAnnie individuellement et exclut le livecatalogue des sources immuables. L’auditV241 compare son baseline au gzip antérieur.

Validation globale structurelle :98118sources,2305consommateurs,25319inconnues ouvertes. Aucun rehash global ; les84identités sont un contrôle ciblé distinct. La revueV242 vérifie que les36tâchesGaren/Ezreal/Trundle n’avaient aucun unknown_id avant ni aprèsV237 ;aucune perte de lien. Les5inconnues de l’objectif portent sur des conditions globales historiques non satisfaites :0résolution proposée,registre inchangé.

## Livraison et suite

Modifiés :docs/fidelity_sources_4_20.json,docs/fidelity_requirement_trace_4_20.json,docs/completion_tasks_2026-10-20.json et lesdeuxbases du plan. Ajoutés :docs/reference_annie_source_links/annie-v241.json,docs/fidelity_annie_source_graph_v241.json et ce rapport. Couverture,plan et reprise reçoivent un checkpoint ;critères/statuts du jeu préservés. Aucun code/asset/distribution modifié par ce lot.

Sources/scripts/preuves sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 :revision238_annie_source_review,revision239,revision240_annie_qualification,revision241,revision242_scoped_unknown_resolution_review ;scriptsrevision239_run_annie_source_tests.py,revision241_register_Annie_annex.py,revision241_audit_delivery.py. Les anciennes preuves restent disponibles.

La séquenceV235/V239 totalise28tests exacts réussis sur16capacités ;elle ne qualifie aucun champion complet. L’objectif reste actif. Suite engagée :46JSON de production horscatalogue ont été inventoriés,51inclusions ;35routes statiquescore/serveur et7client identifiées,4chargeurs encore sans route aval qualifiée. Le prochainlot compare les27définitions du mondeMap10 aux sources natives et sépare les coordonnées, voies, camps et politiques locales. Les origines communautaires sousGameServer ne deviennent jamais natives par leur chemin ou leur nom.
