# SYS-01.2-02 — appels non littéraux et différences d’icônes bornés (V208)

Les15sites assets.load non littéraux recensés enV207 ont maintenant une politique de candidats précise :catalogues connus,substitution Ezreal,placements ambiants,carte/relique,Nexus,boutique/états de fin,Garen et pilierTrundle. Cela délimite des ensembles de chemins au source ;cela ne prouve ni toutes les valeurs runtime ni toutes les autres orthographes de récepteurs.

Les52ressources V207 passent à nouveau avec le lecteur étendu aux DDS. Le DDS Garen de BASE_OVERRIDE est relu,décodé et comparé à son SHA déclarée ;le modèle forms/trundlewall.glb ajouté a ses références et plages de stockage vérifiées. Total connu :167glTF et53autres ressources dans ces audits. Un DDS invalide est refusé. Les octets exacts du lecteur initialV207 sont conservés avec son SHA ;aucun reçu historique réécrit.

Précision essentielle :les33icônes PNG ont les mêmes dimensions que les DDS natifs comparés ;le plus grand écart observé est1/255 par canal RGBA. Aucune égalité pixel parfaite,mais aucune corruption ni substitution à effectuer n’en est déduite. La cause d’arrondi reste une hypothèse. Le texte de portée32objets dans le catalogue d’icônes est conservé comme incohérence descriptive face aux33entrées ;son hash de boutique correspond au fichier courant.

Preuve : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision208/BOUNDED_RUNTIME_LOAD_POLICIES.json. Script : revision208_runtime_load_policies.py dans le répertoire parent. Aucun asset,pack,Bevy/GPU ou écoute modifié/exécuté. Suite : intégrer ces chemins/lecteurs aux fiches,élargir les récepteurs et familles dynamiques restantes sans proclamer une fermeture complète.
