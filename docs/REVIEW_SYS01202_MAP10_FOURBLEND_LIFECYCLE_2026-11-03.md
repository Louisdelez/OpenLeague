# Revue indépendante V1156 — lifecycle FOUR_BLEND exact

Verdict : **PASS 57/57, aucun écart**.

## Contrôles indépendants

- manifeste source : 6/6 artefacts, tailles et SHA exacts ;
- syntaxe du producteur et du validateur : valide ;
- validateur source : `PASS 50/50`, code 0, reçu inchangé avant/après ;
- deux runs source postérieurs au producteur ;
- troisième run physique current-host exécuté par la revue ;
- trois projections identiques : `1cf2464ae587bdb4fbbaabd3daad52892aafaf0ed1e529738837d6ea64172c3d` ;
- PE 4.20 rehashé : `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

## Identités et lifecycle

Les trois runs concordent pour :

- VS : source `b7631de1…01e5`, expansion `6694b4cb…066ed`, code 992 octets `c1a169e3…be42`, CTAB 464 octets `74ac0675…ddc40` ;
- PS : source `d59435b2…95f3`, expansion `74858d63…6e021`, code 1 244 octets `3d184c79…ca58`, CTAB 500 octets `791e0d1c…03f0` ;
- 2 puis 5 includes chargés/libérés exactement ;
- allocation originale au slot 0, bit feuille vrai et bits de résumé faux ;
- cleanup original : CTAB/shader libérés à zéro, record/refcount et trois niveaux bitmap remis à zéro ;
- rollbacks compilation, device et saturation passés ;
- ownership final nul, device/D3D9 libérés à zéro et fenêtre détruite.

Les digests de traces nominales concordent avec les primitives originales V1155 : allocation `24faad3c…59ab`, cleanup VS `91cc2231…dee`, cleanup PS `12cac564…cc7`. Les runs V1156 n'émettent pas les octets de chaque instruction ; la revue confronte donc ces digests aux preuves V1155 déjà qualifiées et rehash le PE complet, sans prétendre une nouvelle comparaison instruction-par-instruction.

## Borne

Aucun producteur `0x98D960/0x98C070`, paire, bind, `Set*Shader`, draw, `Present` ou readback n'est exécuté. Le corpus est exact, mais provider, D3DX/D3D9, managers et records restent respectivement adaptés/current-host/synthétiques exact-layout ; le runtime Riot 2014 n'est pas qualifié.

Le lot peut être repris comme prérequis d'une entrée producteur bornée, toujours avec arrêt avant paire/bind/draw.

