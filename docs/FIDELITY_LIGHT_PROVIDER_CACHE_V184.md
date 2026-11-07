# SYS-01.2-02 — origine du fournisseur de lumière (V184)

Le caller 575460 obtient le fournisseur via 90AEF0, conserve EAX dans EBX et le passe à 573DD0, qui le transmet à 867DF0. Neuf ancres vérifiées dans trois régions décodées sans lacune. Les deux callers sont des préfixes statiques, pas des fonctions exécutées.

La recherche 90AEF0 est exécutée sur quatre arbres explicitement construits en mémoire : clé11 présente (retour exact du pointeur), clés10 et12 absentes, arbre vide. Les trois absences atteignent l’appel de fabrique90ADE0 ; arrêt avant cet appel. Quatre résultats attendus/observés concordent.

Source : League of Legends.exe SHA256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Preuve et script : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision184.

Limites : arbres synthétiques ; aucune exécution historique, fabrique ou méthode virtuelle+28 qualifiée. Aucune case, inconnue ou association de registre modifiée. Prochaine recherche : fabrique90ADE0 et constructeur du fournisseur avant intégration des liens.
