# SYS-01.2-02 — lecteur Light.dat et contenu vide

Le membre LEVELS/map11/Light.dat correspond au manifeste sélectionné lol_game_client0.0.1.7, contenu0.0.0.254 :0octet. Cette preuve antérieure d’appartenance est réutilisée et distinguée de l’exécution nouvelle des branches.

Six fragments de deux instructions du binaire original ont été exécutés en mémoire isolée : flux nul/non nul, état initial nul/non nul, lecture nulle/non nulle. Les six destinations correspondent aux attentes. Un état initial non nul ou une lecture nulle atteint le destructeur avant le parsing des sept entiers et l’appel7172B0 de création. Les octets de la région native86821C..8683E7 ont été revérifiés contre leur empreinte antérieure.

Aucune ouverture de flux, destruction ou création d’objet n’a été exécutée dans ces fragments. La sélection effective du fournisseur et du chemin map11 reste non qualifiée. Le contenu vide ne signifie pas que toute la carte est sans éclairage : d’autres sources et consommateurs peuvent intervenir.

Preuve : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision180/LIGHT_EMPTY_READER_CASES.json. Script : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision180_light_reader.py.

Suite : intégrer cette preuve aux deux tâches EMPTY063 et préciser la décision de classification dans les limites du membre vide attesté. Les inconnues, fiches et bases du plan ne sont pas modifiées par cette recherche. L’objectif global reste ouvert.
