# SYS-01.2-02 — Objets Sound natifs et consommateurs actuels, V754

Projet F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB ; catalogue 4.20.1 distinct. Lot limité aux associations source/consommateur de SYS-01.2-02 et SYS-02.2-07. Aucun code produit ni asset modifié. Le goal reste ouvert.

## Résultat et sources

587 objets Sound HIRC type2 de six banques originales, dont 42 sons d’ambiance et 545 d’annonceur, sont identifiés par ID, offset, longueur et SHA256. Les banques VO observées sont en_US : elles ne prouvent pas une couverture complète en_GB.

Les instructions originales construisent et inscrivent chaque objet (B226A0, AF30B0, AFE420), chargent son corps complet (B22AF0, B00A50), calculent ses deux paramètres (AFF450), puis retirent et détruisent l’objet lors de la dernière libération (B00180, B22660). Les 587 curseurs atteignent exactement la fin du corps. 535 tables non vides portent la propriété5 ; les 587 tables de plages sont vides. Les 1174 mots float32 sont consignés exactement. Les 1122 allocations et libérations sont appariées ; registres et allocations de banc sont vides après chaque cas. 2348 paires de verrouillage physique sont adaptées et tracées. 221 blocs machine distincts sont comparés aux octets du PE ; ce ne sont pas 221 instructions.

Les six en-têtes BKHD sont réellement lus par AF7D70/AFB080 : ils produisent le drapeau du gestionnaire à +490, égal à zéro. Celui-ci n’est plus une constante supposée par le banc. L’identité native est League of Legends.exe, 15973880 octets, SHA256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862, sous D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy.

## REA utilisé

REA 6.4.0 analyse le PE complet avec SDK 2.3.1, Ghidra 12.1.4 et JDK 21.0.10.7 : 13 fonctions, 1058 instructions et 115 références recoupées avec le binaire. Fonctions B226A0, AF30B0, AFE420, B22660, B00A50, AF2A90, AF2C20, AF2C60, AF29A0, AF2550, B000C0, B008B0 et B00010. Fermetures du binaire, du client et du transport confirmées ; aucune erreur REA. Analyse statique et exécution native isolée sont documentées séparément. Copies et nouvelles preuves sur F ; aucun lancement normal du jeu historique.

## Consommateurs Rust vérifiés

Deux programmes privés compilent les modules actuels inchangés : 11 et 32 fichiers, soit 36 fichiers uniques. Cargo generate-lockfile --offline, build --locked --offline et les deux exécutables terminent avec le code0. Sources, manifestes, verrous, exécutables et depfiles sont identifiés.

Les catalogues conservent les 587 identités et les 535 valeurs exactes. Une projection privée fournit les drapeaux natifs à audio_pair_controls::evaluate avec les propriétés du catalogue : ses 1174 mots correspondent à AFF450 sur les objets natifs réellement chargés. Cette projection appartient au banc ; elle ne constitue pas une ingestion HIRC ou une orchestration audio dans le produit.

Le véritable audio_effect_bank_loader::load_section refuse les 587 corps Sound sous Reject et SkipNativeDefaults : 1174 refus « HIRC body reader or extension not implemented for this type ». Le corps reste non consommé, les références du holder à zéro et le registre vide ; un emplacement de holder est réservé avant le refus. Aucune qualification générale du cycle de vie du holder n’en est déduite. Le lecteur audio_bank_header correspond aux six en-têtes, à leurs streams et au drapeau natif.

Un rôle précis du calcul de paramètres est ajouté. Quatre rôles existants de catalogues, section HIRC et en-tête sont réutilisés sans modifier leurs anciennes qualifications. Il s’agit d’une limite d’implémentation démontrée, pas d’assets manquants ou corrompus dans ce lot.

## Résultats attendus et observés

Les neuf cas natifs donnent les résultats attendus : nominal1 ; stream3 et plugin de mauvais type2 ; codec inconnu accepté par ce lecteur1 sans preuve de décodage ; bus non trouvé2 ; allocation de propriété refusée2 ; allocation du constructeur refusée avec objet nul ; lecture partielle demandée1 avec arrêt après les effets ; référence supplémentaire2, première libération1, dernière0. Toutes les allocations finales sont libérées et l’index vidé. Aucune sécurité de buffer tronqué revendiquée.

Quatre refus Rust sont observés : hiérarchie vide, propriété non finie, propriété d’ambiance non finie et plage inversée. Six falsifications du reçu sont rejetées : corps incomplet annoncé complet, libération absente, paramètre altéré, parent absent promu, chargeur Sound actuel inventé et objet encore référencé détruit. Ces contrôles de métadonnées sont distincts des essais natifs et Rust.

Premier essai conservé : lecture native arrêtée en B0001B faute de gestionnaire de banque dans le banc. Le contexte a ensuite été fourni explicitement, puis son drapeau produit par les six BKHD originaux. Ce diagnostic ne signale pas un défaut d’asset. Les étapes intermédiaires et leurs sources restent conservées.

## Limites et suite

Les index sont construits vides par le banc. Les IDs de parents sont présents dans les catalogues, mais les liens natifs restent nuls : absence de parent optionnel tolérée. Aucun attachement de hiérarchie complète qualifié. Allocateur borné et verrous physiques sont adaptés ; pas de concurrence historique. Le gestionnaire RTPC est désactivé et les blocs RTPC sélectionnés sont vides. Les branches non vides effets, position, états, ranges et voix restent ouvertes. Pas de nouvelle sortie PCM ou audible dans V754 ; les preuves V753 restent antérieures.

Suite : construction/enregistrement des parents, attachement, héritage et durée de vie, puis consommateurs actuels correspondants. Restent également ingestion DIDX, streaming, seek/boucles, génération, effets, mixage, autres médias/locales et sortie physique. Le jeu et le système audio ne sont pas déclarés terminés.

## Livraison

Preuve docs/fidelity_rea_sound_node_v754.json ; détails privés sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision754_*. Trois registres et documents de couverture/reprise enrichis. Deux fiches et deux bases avec deltas compressés ciblés ; cases, notes, historiques, autres tâches et inconnues conservés. VERIFIED, INDEPENDENT_READBACK et FINAL_VERIFIED consignent respectivement publication, relecture indépendante et contrôle final.
