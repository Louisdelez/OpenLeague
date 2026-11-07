# SYS-01.2-02 — préflight V1164 des variantes loose

Date : 2026-11-03  
Décision : `STOP_NO_NEW_EVIDENCE`

## Portée

Le préflight a vérifié si une nouvelle analyse des trois inconnues suivantes était justifiée :

- `OLU-6c4ea73e-b19b-5768-b6b0-6f596a6a3a20` — `DATA/Characters/Urf/Urf.inibin` ;
- `OLU-f76e6025-f166-5cef-88b4-24340ec8d4b9` — `DATA/cfg/defaults/Cheats.cfg` ;
- `OLU-0ae207ed-8eed-5b18-8086-c348282caeb5` — `DATA/cfg/defaults/locale.cfg`.

Il ne constitue pas un nouvel audit fonctionnel et ne modifie aucun statut.

## Résultat

Les preuves du 2 novembre couvrent déjà l'identité des variantes, leur séparation d'avec la sélection historique effective et les consommateurs actuels bornés. `DECISIONS`, `CURRENT` et `HANDOFF` imposent de ne pas refaire ces recherches sans nouvelle source de génération, de staging ou d'ordre de montage.

Le contrôle courant confirme seulement :

- `locale.cfg` possède un consommateur Rust partiel limité à la configuration des fontes HUD ;
- aucun littéral Urf/Cheats n'est apparu dans les racines runtime ciblées ; cette absence reste bornée et n'est pas une preuve globale ;
- les trois inconnues demeurent `open` ;
- aucune preuve primaire nouvelle ne permet d'établir le producteur historique ou la priorité effective des variantes.

## Vérifications

- Source/provenance : 24/24 contrôles.
- Prérequis et règle d'arrêt : 24/24 contrôles.
- Consommateurs courants : 14/14 contrôles.
- Aucun REA, D3D9, Cargo, jeu, installation ou écriture sur `F:` pendant le préflight.

Manifestes source :

- `E:/mapslol3v3/audit_sys01202_v1164_loose_source_evidence_20261103/manifest.sha256` — SHA-256 `c7138eb08987b41e756874c182da2fa689c00883c884d71a551c2819fa93dd29` ;
- `E:/mapslol3v3/audit_sys01202_v1164_prereq_review_20261103/MANIFEST.sha256.json` — SHA-256 `f498a84032055fbfc772a2076e2ad094fd3ce2c992141dbbe171a371d689614f` ;
- `E:/mapslol3v3/audit_sys01202_v1164_loose_current_consumers_20261103/manifest.json` — SHA-256 `d2fd233ea4077e1b35158dd262a5304ce4d344647bb7d5f837782e6df9cc44d3`.

## Reprise

Reprendre uniquement avec une preuve primaire nouvelle : producteur/staging historique identifié, manifeste ou package supplémentaire authentifié, ou trace de montage donnant l'ordre et les octets effectivement choisis. Une répétition des mêmes scans ne compte pas comme progrès.

