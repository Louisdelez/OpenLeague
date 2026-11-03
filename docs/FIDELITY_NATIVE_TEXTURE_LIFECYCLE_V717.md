# SYS-01.2-02 — Registre natif et cycle de vie des textures, V717

Date : 28 octobre 2026. Projet : F:/OpenLeague. Référence : PUBLIC4.20.0.315 EUW/en_GB, catalogue4.20.1 distinct.

V717 : registre de textures original composé avec le device Direct3D9 réel sous refus multi-GPU déclaré. Le constructeur crée texture_registry_system_default1x1 ; copie D3DX réelle et relectureFFFFFFFF exactes. ARGB8/DXT1/DXT5 : création réelle, inscription, doublon refusé, références1/2/1/0, réutilisation et retrait vérifiés. Fermeture978510 exécutée, textures libérées et global2D79030 remis à0 ; deuxième fermeture sans effet. Les quatre consommateurs actuels existants sont relus et reliés sans promotion de portée.

## Attendu et observé

| Contrôle | Résultat observé |
|---|---|
| Construction originale du registre en mode0 | Publication2D79030, texture native nommée texture_registry_system_default,1x1,ARGB8 |
| Copie du pixel blanc | D3DXLoadSurfaceFromMemory0 ; LockRect/relectureFFFFFFFF/UnlockRect0 |
| ARGB8 et DXT1 | Textures512x1024,1mip ; formats Direct3D21 et827611204 ; HRESULT0 |
| DXT5 | Texture512x1024,3mips ; format894720068 ; HRESULT0 |
| Inscription de chaque nom | Objet trouvé par lookup natif ; dimensions et mips issus des vrais GetLevelDesc/GetLevelCount |
| Doublon actif | Sortie nulle ; table,liste et événements API/allocation inchangés |
| Références puis réutilisation |1→2→1→0, objet conservé puis réutilisé avec référence1 |
| Retrait et libération | Objet,descripteur et wrapper libérés ; référence COM détenue0 |
| Fermeture du manager | Texture par défaut libérée,manager libéré,global0 ; deuxième fermeture sans effet |

Dix-huit opérations diagnostiques,38 appels natifs de haut niveau et5392 adresses d’instructions originales sont vérifiés contre le PE. SHA256 : `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Les quatre objets textures possèdent des identités de proxy distinctes,même si Windows réutilise une adresse COM. Le nettoyage hôte n’a plus aucune texture à libérer après le shutdown natif. Les autres ressources du périphérique restent traitées par le nettoyage du banc.

Six falsifications sont rejetées : mauvais pixel,faux shutdown,faux upload de portraits,mauvais mipcountDXT5,faux succès de doublon et faux appel privé réel.

## Consommateurs actuels et portée

Les quatre ancres existantes sont relues : `crates/client/src/relic_image_reference_store.rs` lignes23,67,82 et `vendor/bevy_render/src/texture/gpu_image.rs` ligne63. Le premier gère les leases/ImagesCPU ; le second crée ou met à jour la texture wgpu,sa vue et son sampler. Le cache actuel autorise l’acquisition répétée d’une clé et détruit l’entrée à la dernière libération ; le registre natif refuse un nom actif et peut le retenir à zéro. La preuveV713 de ces différences reste valable ; V717 étend le côté natif aux vrais objets Direct3D9 et à la fermeture du manager. Aucune nouvelle exécution Rust n’est revendiquée.

## Appel privé au pilote toujours ouvert

La structure publique D3DKMT_ESCAPE et Type0 sont identifiés dans le SDK installé et la [documentation Microsoft](https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/d3dkmthk/ns-d3dkmthk-_d3dkmt_escape). Le tampon privé de536octets a dix mots non nuls,reproduits dans le reçu. Le protocole du fournisseur correspondant n’est pas établi par les recherches effectuées ; l’absence de résultat ne prouve pas son indisponibilité. L’initialisation du device reste donc explicitement conditionnelle au refus synthétiqueV716. Aucun appel privé n’est transmis au pilote dansV717.

## Limites

- InitialisationV716 reprise dans la même exécution avec refus synthétique0xC000000D à48AC16. Le format privé du pilote reste non qualifié ; aucun appel privé réel, aucun démarrage normal complet ni contexte historique2014.
- Instructions originales du manager9783D0,default978660,texture9C2D40,inscription978820/9BF1B0/9AF410,références,retirage979210 et shutdown978510 exécutées. API COM et D3DX actuelles64bits réelles via traduction explicite ; CRT/arène/cookies/logs et certains services restent adaptés commeV716,plus memmove borné.
- Seul le pixel blanc natif par défaut est envoyé à une surface et relu. Les trois textures de512x1024 sont des ressources diagnostiques sans pixels de portraits. Noms diagnostiques OpenLeagueV717_* ; quatrième argument de978820 conservé opaque. Le nomVFS du portrait,loader989500 complet et upload des DDS restent ouverts.
- Le registre Direct3D9 contient une texture par défaut dès sa construction, contrairement au profilPE2 deV713. Les descripteurs observés portent dimensions,mips et formats normalisés ; leur présence ne prouve pas un draw ou une image affichée.
- Deux premières tentatives arrêtées aux API non encore adaptées GetSurfaceLevel puis D3DXLoadSurfaceFromMemory ; ressources hôte nettoyées. La troisième termine les18opérations ; la dernière ajoute le shutdown original et des identités proxy distinctes lors de réutilisation des adresses COM. Le premier générateur s’était arrêté avant création de script sur un motif de remplacement ambigu ; aucune exécution native à cette étape.
- Les trois textures diagnostiques et la texture par défaut sont libérées par le code original avant le nettoyage hôte. Le manager natif est libéré,mais le teardown complet du device/renderer et la libération physiqueVRAM ne sont pas qualifiés. Les allocations de bootstrap restantes sont exposées.
- Côté Rust : Store::acquire_dds/release/cleanup_renderer et GpuImage::prepare_asset sont des consommateurs réels existants,relus sans nouvelle exécution. Le cache de clés/références et les branches wgpu n’équivalent pas automatiquement au registre de noms natif. Aucun source de production modifié ; aucune texture de remplacement générée.
- Pas de frame,UV,sampler,recadrage,qualitécompression,écranStandard ou jeu complet accepté. Les écarts de localisationV715,mode2V714,Kalista288octets et12noms antérieurs restent ouverts. Les preuves et états manuels précédents sont conservés.

## Livraison et suite

Les liens et le contexte des fiches SYS-01.2-02 et SYS-17.3-01 sont enrichis,avec leurs consommateurs existants. Aucune nouvelle entrée artificielle de consommateur. Les deux bases du plan,couverture,plan de complétion et documents de reprise sont actualisés par deltas ciblés,sans copie intégrale de base. Les autres tâches,cases,notes,historiques et inconnues sont conservés. La vérification réelle Store/copy_text,les contrôles SQLite et les empreintes sont dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision717_delivery/VERIFIED.json.

[Reçu détaillé](fidelity_native_texture_lifecycle_v717.json). Fichiers modifiés : ce rapport et reçu,docs/completion_tasks_2026-10-20.json,docs/fidelity_requirement_trace_4_20.json,docs/fidelity_sources_4_20.json,docs/coverage.json,docs/completion_plan.json,docs/resume_checkpoint.json,docs/ai/CURRENT.md,docs/ai/HANDOFF.md et les deux bases du plan. Scripts et observations détaillées sur F:/OpenLeague-work.

Suite : composer le vrai loader de portraits et l’upload DDS avec ce registre natif,qualifier son nomVFS et les consommateurs GPU actuels. Conserver séparément l’initialisation conditionnelle,le protocole privé manquant et le teardown complet du renderer. Le Goal et les fiches restent incomplets.
