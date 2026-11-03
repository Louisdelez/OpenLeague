# SYS-01.2-02 — identités de consommateurs corrigées après déplacement

L’audit V177 a comparé les octets de1781 consommateurs dans428 fichiers :1778 identités conformes et3 liens incorrects vers l’ancienne source E de source_versions.py. Les ancres textuelles étaient présentes, mais les octets F différaient de la source référencée.

Les trois consommateurs validate_history, prepare_version et historical_record sont maintenant reliés à l’identité F déjà enregistrée. Chaque enregistrement précédent est conservé intégralement dans source_binding_history ; la source E, son historique et ses octets ne sont pas réaffectés. Aucun code de production modifié.

Les22 tests source_versions et source_versions_relocation ont passé sur F avant correction des liens. Les cinq fiches SYS-01.2-02 à06 sont mises à jour dans les deux bases ; cinq fiches/copies/traces, cinq pointeurs et deux refus vérifiés.42606 états et historique conservés ; inconnues inchangées.

Preuve : docs/fidelity_source_binding_graph_v178.json. Associations : docs/reference_event_lookup_sources/source-binding-v178.json. Audit initial : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision177/CURRENT_CONSUMER_SOURCE_IDENTITIES.json. Sauvegardes et correction : revision178.

Cette correction ne qualifie pas tous les comportements des lecteurs ni le jeu. Suite : revérifier les identités après correction puis poursuivre les consommateurs et rôles fonctionnels restants.
