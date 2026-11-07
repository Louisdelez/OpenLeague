# SYS-01.2-02 — Xerath : Mana Surge et consommateurs VFX, V1425

6 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-XERATH-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé ; fonctionnalité et acceptation ouvertes.

## 1. Exigence et périmètre

`CH-Xerath-PASSIF-PRESENTATION-VFX`, `OLF-f505fde5-0bb3-59d2-ab26-5daf9c116084` :relier état prêt,on-hit,restauration et dépendances aux consommateurs réels. Contrat VFX,prérequis de phase/lot,consommateurs et inconnues préservés dans initial_scope.json. V651/HUD V1299 conservés. Liaison close ne signifie ni passif,QWER,fonctionnalité ou goal terminés.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ;build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus. Catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/xerath-passive-mana-surge-links-v651.json`,3087836octets,SHA `c2ac9df5dd8acfd45d209c43ab7a3e274ce019b153e6d29f17f3fdc34f93815d`,UTC documentaire2026-10-27T02:10:52.950997+00:00. Acquisitions retenues dans E ;aucun accès renouvelé D ou F/OpenLeague-work.

Douze primaires :quatre INIBIN,quatre Lua,trois preloads,font.63autres identités restent contextuelles ;huit candidats exclus,noDDF dans75candidats vérifiés,non-absence universelle. Définition1798octets,SHA `87b047e4abf8bcfb2afbc453a19ac8f8baa913811867d97ae0ec5a9637db9e93` :XerathAscended2/Xerath_Passive1.dds ;Passive1/Desc/Level1..6 absents,non zéro.

28vues Lua héritées,lecture antérieure complète,zéro prototype enfant,15initialisations littérales,13limites,49globals. Quatre chunks directs :Char56 vide ;Ascended219 etOnHit220,noms/icônes/persistance et `Nondispellable` exact ;BasicAttack119 avec limite du lecteur. Métadonnées persistantes distinctes du lifecycle. Aucun AutoBuff reconnu dans ces vues,non-absence globale d’effet.

Font4488/4312/2948/2949 relie attaques et restauration :f1 sbire/monstre,f2 champion,f3 période. Aucun fournisseur qualifié ;ni12secondes ni ratio2 adoptés. Miroir font vérifié par identité,sans reparcours sémantique complet.

Trois preloads relus depuis la découverte archivée :Char961/SHA8b5a9267,Ascended97/SHAcc83b7c1,OnHit110/SHAb6fd6765,1168octets.14appels littéraux,sans exécution/résolution typée complète. Char déclare xerathascended2 ;Ascended déclare xerathascended2onhit ;OnHit déclare **xerath_base_p_manarestore.troy**. Les onze autres déclarations du Char restent contextuelles,W/R et apbonusdamagetotowers non promus en passif. Préchargement distinct de création,lookup/provider/attache/horloge.

Deux DDS relus uniquement dans E :Passive1 propre HUD2176octets,64×64/DXT1/mip0,SHA `7925c8d5c3d5d39f7d71fbf2634111c2589e91e5d41f73aefe62d02caabf27dc`,membre0.0.0.196 ;AscendedForm partagé4224/DXT5/mip1,SHA `de7dfafe93ccd01fd436d5ec59827db6ec41d9957b5fa64ab3b6aab8b43a0e09`,membre0.0.0.48. Membership core0.0.1.7 hérité,contenus/formats distincts,priorité et pixels ouverts.

## 3. Consommateurs réels

Quatorze fichiers actuels,douze Rust/deux Python ;29ancres. Treize sources/frontières et38contextes concordants ;14entrées VFX communes et deux animations ordinaires inchangées.

Attack→attacks→lifesteal::basic_attack_hit produit le physique ;progression expose statistiques,shop::refresh_item_caps les plafonds,consumables la potion,regeneration la régénération. Ordre lib.rs727/739/742 :consommables,régénération,attaques. Profil à distance/projectile2000 conservé. Ces mécanismes ne produisent pas Mana Surge. Aucun producteur nommé dans les douze préfixes Rust examinés,conclusion bornée.

Barre Mana et MPStat acquis après garde d’identité ;provenance de ressource distincte de l’INIBIN natif. Aucun binding dédié d’état/icône/f1/f2/f3 qualifié. Owner,projection et animations génériques ne créent pas l’effet natif.

## 4. Attendu, observé et contrôles

Attendu :source exacte,consommateur ou manque borné,refus et reprise. Observé :chaîne déclarative et consommateurs reliés,producteur/rendu non établis. **28/28 contrôles documentaires qualifiés,56/56 de cohérence du même agent.** HUD107/107 et93/93 hérités.

Deux cas Xerath1/18,Annie18 ;trois attributions XP diagnostiques,huit mouvements/arrivées hérités. Achat public1027/2004 :825→390or,pool conservé,max+200 nominal ;soustraction f32 réelle199,99996948242188 au niveau1,200au18. Politique du pool et rayon fontaine1000+100 courants non acceptés comme règles natives.

1111calculs f32 mana hérités,non recalculés :209frames d’attaque et902de potion. Six impacts et leurs frames mana relus ;chacune correspond à l’attendu générique archivé. Dégâts physiques/cible et régénération avant attaque hérités. Régénération0,04000000283122063/0,13066667318344116 par tick ;déficit>50 aux attaques,disponibilité native inconnue.

Six témoins de potion relus :premier,450e et451e par cas. Potion0,2222222238779068 pendant450mises à jour,puis0 ;compteur449→0. **Aucune frame de potion n’atteint le maximum.** Fins439,6078796386719/516,9599609375 et1287,120849609375/1315,9599609375 ;branche de saturation non exercée. Ancienne affirmation « avec saturation » demeure rejetée ;pas de montant exactement100 déduit.

54refus principaux et6témoins potion portent des flags,sans60paires brutes individuelles.4599ticks ne sont pas4599frames ;aucun sbire/monstre/bâtiment exercé. RUN comporte deux diagnostics puis JSON équivalent à OBS,preuve héritée,sans relecture du log. Binaire6074880octets/SHA `be65856d09a098c84c8ca88142ba83eebdfaa18a1b31161576e83bb184f00ce6` inerte ;1158entrées et trois anciens journaux non rouverts.

Ancien BUILD0/RUN101 à la garde fontaine :une seule ligne du collecteur change800/8200→900/8550 et ajoute un diagnostic ;diff exact conservé,aucune réparation moteur/navigation,aucun rejeu. Ancien Launcher1 non fraîchement observé.

Deux échecs actuels conservés :fenêtre lib.rs trop courte excluant727,élargie725–745 sans modifier le code ;puis27/28 omettait les six control_refusals. Un seul prédicat corrigé54+6,27autres contrôles et témoins initiaux inchangés,reçus complémentaires séparés. Six productions réussies ;aucun nouveau build,jeu,natif,REA,GPU ou réseau.

## 5. Écarts et inconnues

f1/f2/f3,disponibilité,catégories,cooldown,lifecycle,transport,recette/owner/attache/provider/variante et pixels restent ouverts. **Le rendu Mana Surge reste non qualifié.** Potion/régénération ne prouvent pas le passif ;formule min présente,branche cap non exercée. Aucune revue indépendante/humaine ou inventaire secondaire complet qualifié.

## 6. Corrections et reprise

corrections_and_restart.json :quatre clauses POLICY/ON-HIT/NETWORK/VFX,préconditions,fins et reprises. READY-LIFECYCLE,HUD-BINDINGS et MANA-CAP-WITNESS existants préservés. Piste précise OnHit110/xerath_base_p_manarestore.troy,capture/callsite attribué,non recensement global répété. Implémentation sous autorisation distincte. next_lot.json vise XinZhao,consulter ses audits avant acquisition.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_xerath_passive_vfx_20261106` :evidence_review_corrected.json fait autorité,original27/28 et collecteur initial conservés,cohérence,sources,diff,témoins,corrections,journaux. Rapport et ajouts CURRENT/HANDOFF seuls publiables,sauvegardes exactes,sept registres protégés.

Une unité de liaison close ;zéro tâche VFX,fonctionnalité,inconnue,acceptation ou goal clos. Goal/Plan/UI/bases/registres/produit inchangés ;SYS-01.2-02 actif.
