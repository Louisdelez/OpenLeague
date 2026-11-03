# Échelles de base : consommateur Rust effectivement exercé

Le test est compilé dans le vrai binaire de tests openleague-client et appelle animation::request, Catalog::default et AssetServerBevy réels. Le constructeur fusionne aussi world_animation_manifest.json et remplace uniquement le chemin du modèleEzreal ; ces entrées sont hachées. Tous les122IDs/noms et chemins de demandes sont enregistrés. Aucun remplacement du corps de request, fauxAssetServer ou projectionPython du cast.

Résultat installé :110échelles au même float32 que la référence conservée,12différentes d’unULP (Akali,Corki,Fizz,Kassadin,Orianna,Quinn,Sivir,Skarner,Sona,Veigar,Warwick,Zyra). Les résultats de lecture/calcul natifs antérieurs sont hérités, non revendiqués comme fraîchement réexécutés ; les122sources natives sont fraîchement hachées. Le binaire de test, compilateur/outils, commande et log sont identifiés dans le reçu.

Contrôle séparé : sur une copie en mémoire du catalogue, sérialiser la valeur float32 native exacte en nombreJSON conserve tous les122résultats dans le même consommateur. Les données distribuées restent inchangées. Ce contrôle situe donc la correction future dans les valeurs choisies par le producteur ; il ne qualifie pas le choix du fichier natif effectif ni son environnement flottant historique.

Deux testsRust passent après correction d’une assertion du contrôle qui supposait à tort un champasset dans chaque entrée : le chemin est désormais comparé à la vraie demande de base. Le premier essai1passé/1échoué et son source/journal restent conservés. Inventaire explicite des12écarts ; réussite des tests ne signifie pas parité installée. Les12questions restent ouvertes avec ancien texte/conditions/historique. La nouvelle recherche distingue le résultat réel, le contrôle mémoire et le correctif restant. Métadonnées/casesSKIN conservées. Seule une déclaration cfg(test) est ajoutée à animation.rs et les fixtures/tests sont nouveaux ; tout son préfixe préexistant est inchangé octet pour octet. Aucun code de production ni donnée de modèle corrigé.

Limites : aucun chargementGLTF attendu ni transformation enmonde/GPU observé, aucune qualification des skins non-base, du bootstrap historique, des12scales corrigées enproduction ou du jeu complet. Les autres questions et preuves restent conservées.

Reproduction : `cargo test --locked --offline -p openleague-client animation::scale_reference_audit:: -- --nocapture --test-threads=1`. [Reçu](reference_native_skin_loader_sources/actual-rust-base-scale-request.json).


## Revalidation de l’état courant — 2026-11-02

Le résultat du 21 octobre (110/122 égales, 12 écarts d’un ULP) est conservé comme historique. Le manifeste de production a depuis changé : son SHA-256 courant est 019fbb54debb0b9bdb3c7124de3ca30958fb84842fe20091ba62cc34eb279880, différent de celui inscrit dans le reçu ancien. L’origine de cette modification n’est pas établie ici.

Comparaison en lecture seule du manifeste courant et des 122 valeurs de référence du fixture : 122/122 mêmes bits float32. Le test réel a été relancé contre l’état courant :

    cargo test --locked --offline -p openleague-client animation::scale_reference_audit:: -- --nocapture --test-threads=1

Résultat observé : code 0, 2 passés, 0 échoués, 1541 filtrés. Le test appelle Catalog::default, animation::request et le véritable Bevy AssetServer, puis compare les 122 échelles retournées et les chemins enregistrés. Le contrôle mémoire distinct confirme également 122/122 valeurs exactes; aucune donnée distribuée n’est modifiée par ce contrôle.

Fizz, skin_id 105000, modèle demandé champions/fizz.glb : le reçu historique observait 0x6666a63f contre la référence 0x6766a63f. Le manifeste courant donne scale=1.3000000715255737; la demande courante retourne 0x6766a63f. La source native liée dans le registre est DATA/Characters/Fizz/Fizz.ini, section MeshSkin, ChampionSkinID=105000. Le consumer actuel dans crates/client/src/animation.rs:410-429 lit catalog.0[name].scale, la convertit en f32 et demande le modèle par l’AssetServer.

Empreintes courantes : animation.rs AF685F610A3185E8D845A8398C420C54346B32C980B0A7AF3952E00EBFFF7D32; animation_scale_reference_tests.rs 19FD2EFE68803C5301880036BD48EC95F09ACE0CD163BEB10634ACA32D1CB225; animation_scale_reference_cases.json E2227519D2BCF814BED614D920D5503CC3CDBED0D55CF015E6FD83648C1D0A50; animation_manifest.json 019FBB54DEBB0B9BDB3C7124DE3CA30958FB84842FE20091BA62CC34EB279880; world_animation_manifest.json 0BE954971818C3A8A96D062E289AC23EBDFDD7C11F3856300294549122D665EA. Binaire de test existant : target/debug/deps/openleague_client-2075976f45e26136.exe, 332030976 octets, SHA-256 5b242a0a248f5bf4486ddf4477898b5fcc593eb38adabba491989edf9698646f.

Portée clôturée : liaison numérique actuelle du catalogue au consumer de demande de modèle, pour les 122 skins de base de ce jeu de références. Cela corrige le constat numérique antérieur dans l’état présent; aucun fichier produit n’a été changé dans cette intervention. Ce n’est pas la clôture de SKIN-Fizz-0-ASSET-MESH : son statut est toujours a_faire, implementation_complete=false, acceptance_complete=false. L’AssetServer n’attend pas le chargement GLTF dans ce test; GPU, scène, taille visible, acceptation et identité effective de la source historique après bootstrap/provider/overlays restent non qualifiés. Le receipt ancien n’a pas été écrasé.
