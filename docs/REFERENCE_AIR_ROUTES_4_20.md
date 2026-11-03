# SYS-01.1-05 — Écrans et parcours du client AIR 4.20

Référence : client de partie PUBLIC4.20.0.315, EUW/en_GB, build littéral du 17 novembre2014 à17:46:45 ; fuseau et déploiement inconnus. Client AIR **4.20.14_11_18_18_52**, projet lol_air_client, release **0.0.1.119**. Catalogue DataDragon4.20.1 distinct. Relevé du20octobre2026.

Le résultat est un **recensement du code original**, intégré au référentiel et à la consigne du plan. Il ne prétend ni reconstruire ces écrans dans le launcher Rust, ni exécuter Adobe AIR ou les services Riot. Les identités, empreintes et relations complètes sont dans [le contrat](reference_air_routes_4_20.json).

## Sources et méthode

Le manifeste exact contient7886 membres. Les **109 fichiers de code** (108.dat et LolClient.swf), **31 descripteurs de modules**, **38 fragments de dépendances**, les **5 cadres HTML**, le descripteur AIR exact et locale/theme sont préservés : **186 fichiers originaux**, tous comparés par chemin/release/taille/MD5 au manifeste puis hachés en SHA-256. La copie native D: ne contient pas AIR : la provenance archivée est corroborée par ses journaux d’installation et le build de ClientLibCommon, revérifiés par le contrat SYS-01.1-02.

Décompilation avec JPEXS FFDec26.4.0 portable, archive officielle vérifiée, Java21. Les 109 commandes se terminent avec code0 ; **9139 exports ActionScript** sont indexés. Les premiers exports filtrés ont été remplacés comme base de recensement par un export complet, incluant les classes sans préfixe. Les fichiers originaux et les reçus restent conservés.

L’index compte **788 classes de vues/conteneurs/composants/skins** issues du code applicatif, **320 constantes d’état** et **707 instructions de changement de vue/état**. Ces annexes complètent les51 groupes de vues et47 parcours commentés ci-dessous. Elles incluent des composants techniques et des branches héritées, dont la visibilité publique n’est pas présumée.

## Groupes de vues et états

| ID | Vue ou famille | Portée de disponibilité | Classes sources |
|---|---|---|---|
| bootstrap | Démarrage, fenêtre et erreurs fatales | source_defined — Définition présente dans la release ; affichage natif non observé. | [LolClient](reference_air_sources/review/LolClient_swf/scripts/LolClient.as), [ClientWindow](reference_air_sources/review/mod__win__ClientWindow_dat/scripts/ClientWindow.as), [ShellErrorWindow](reference_air_sources/review/LolClient_swf/scripts/ShellErrorWindow.as), [FatalErrorWindow](reference_air_sources/review/mod__win__ClientWindow_dat/scripts/com/riotgames/pvpnet/fatal/FatalErrorWindow.as) |
| chrome | Cadre, barre de navigation et commandes de fenêtre | source_defined — Définition présente dans la release ; affichage natif non observé. | [ChromeFrameView](reference_air_sources/review/mod__chrome__mod_chrome_dat/scripts/com/riotgames/pvpnet/chrome/views/ChromeFrameView.as), [ChromeTopLevelNavigationView](reference_air_sources/review/mod__chrome__mod_chrome_dat/scripts/com/riotgames/pvpnet/chrome/views/ChromeTopLevelNavigationView.as), [ChromeWindowControlsView](reference_air_sources/review/mod__chrome__mod_chrome_dat/scripts/com/riotgames/pvpnet/chrome/views/ChromeWindowControlsView.as) |
| login | Connexion, identifiants, préférences de musique et animation | source_defined — Définition présente dans la release ; affichage natif non observé. | [LoginView](reference_air_sources/review/mod__lgn__mod_lgn2_dat/scripts/com/riotgames/pvpnet/login/LoginView.as), [LoginModule](reference_air_sources/review/mod__lgn__mod_lgn2_dat/scripts/com/riotgames/pvpnet/login/LoginModule.as) |
| login-status | Attente de connexion, file, erreurs et bannissement | service_dependent — Définition présente dans la release ; affichage natif non observé. | [LoginQueueStatusPane](reference_air_sources/review/mod__lgn__mod_lgn2_dat/scripts/com/riotgames/pvpnet/login/LoginQueueStatusPane.as), [LoginView](reference_air_sources/review/mod__lgn__mod_lgn2_dat/scripts/com/riotgames/pvpnet/login/LoginView.as) |
| summoner-name | Création ou changement du nom d’invocateur | source_defined — Définition présente dans la release ; affichage natif non observé. | [SummonerNameView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/summoner/wizard/SummonerNameView.as) |
| summoner-icon | Choix de l’icône d’invocateur | source_defined — Définition présente dans la release ; affichage natif non observé. | [ChooseSummonerIcon](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/summoner/wizard/ChooseSummonerIcon.as) |
| questionnaire | Questionnaire de niveau initial | feature_gated — Affiché selon displayEloQuestionaire, pas une étape universelle. | [EloQuestionaire](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/summoner/wizard/EloQuestionaire.as) |
| tutorial | Proposition de tutoriel et fin de tutoriel | feature_gated — Définition présente dans la release ; affichage natif non observé. | [PlayTutorialGame](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/summoner/wizard/PlayTutorialGame.as), [EndOfTutorialGameView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/common/endofgame/EndOfTutorialGameView.as) |
| partner-block | Blocage bêta partenaire et avertissement de durée | region_or_partner_gated — Chemin partenaire présent ; disponibilité EUW non déduite. | [ApplicationContentView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/application/ApplicationContentView.as), [AntiIndulgenceWarningView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/partner/AntiIndulgenceWarningView.as) |
| home | Accueil, actualités, parties vedettes et aide débutant | service_dependent — Définition présente dans la release ; affichage natif non observé. | [LobbyLanding](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/lobby/landing/LobbyLanding.as), [LandingPageRootView](reference_air_sources/review/mod__lp__mod_lp_dat/scripts/com/riotgames/landing/LandingPageRootView.as), [FeaturedGamesScroller](reference_air_sources/review/mod__lp__mod_lp_dat/scripts/com/riotgames/landing/featuredgames/FeaturedGamesScroller.as), [TakeoverView](reference_air_sources/review/mod__lp__mod_lp_dat/scripts/com/riotgames/landing/takeover/TakeoverView.as), [NewbieTipsView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/help/NewbieTipsView.as) |
| choose-game | Choix PvP, coop, personnalisé, tutoriel et options de file | source_defined — Définition présente dans la release ; affichage natif non observé. | [ChooseGameOptionsView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/lobby/ChooseGameOptionsView.as), [ChooseGameViewLayoutPVP](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/lobby/ChooseGameViewLayoutPVP.as), [ChooseGameViewLayoutPVE](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/lobby/ChooseGameViewLayoutPVE.as), [ChooseGameViewLayoutCustom](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/lobby/ChooseGameViewLayoutCustom.as), [ChooseGameViewLayoutTutorial](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/lobby/ChooseGameViewLayoutTutorial.as) |
| arranged-team | Salon de groupe normal/classé et invitations | service_dependent — Définition présente dans la release ; affichage natif non observé. | [CreateNormalArrangedGame](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/normal/CreateNormalArrangedGame.as), [NormalTeamPanel](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/normal/normalTeamSelection/NormalTeamPanel.as), [InviteePanel](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/common/invite/InviteePanel.as), [InvitePlayersView](reference_air_sources/review/mod__ivi__mod_ivi_dat/scripts/com/riotgames/pvpnet/invite/legacy/view/InvitePlayersView.as) |
| queue | File de matchmaking, partie trouvée et confirmation | service_dependent — Définition présente dans la release ; affichage natif non observé. | [EnterChampionSelectView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/common/EnterChampionSelectView.as), [ConfirmStartChampionSelectView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/common/ConfirmStartChampionSelectView.as), [EnterChampionSelectDialog](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/normal/EnterChampionSelectDialog.as) |
| queue-refusal | Dodge, refus classé, LeaverBuster et attente imposée | service_dependent — Définition présente dans la release ; affichage natif non observé. | [QueueDodgeDialog](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/normal/QueueDodgeDialog.as), [RankedQueueFailuresDialog](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/normal/RankedQueueFailuresDialog.as), [LeaverBusterDialogue](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/normal/LeaverBusterDialogue.as), [FirstTimeLeaverDialogue](reference_air_sources/review/mod__clb__mod_clb_dat/scripts/com/riotgames/pvpnet/celebration/views/FirstTimeLeaverDialogue.as) |
| custom-browser | Liste et recherche des parties personnalisées | service_dependent — Définition présente dans la release ; affichage natif non observé. | [JoinGamePanel](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/practice/join/JoinGamePanel.as), [CustomGameDataGrid](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/practice/join/CustomGameDataGrid.as) |
| custom-create | Création de partie personnalisée | service_dependent — Définition présente dans la release ; affichage natif non observé. | [CreatePracticeGameView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/practice/create/CreatePracticeGameView.as) |
| custom-lobby | Salon personnalisé, équipes, bots et spectateurs | service_dependent — Définition présente dans la release ; affichage natif non observé. | [TeamSelectionView2](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/practice/teamselection/TeamSelectionView2.as), [TeamSelectionPanel2](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/practice/teamselection/TeamSelectionPanel2.as), [SpectatorPanel](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/practice/teamselection/SpectatorPanel.as), [TeamPanel2](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/practice/teamselection/TeamPanel2.as) |
| tournament | Saisie de code tournoi | service_dependent — Définition présente dans la release ; affichage natif non observé. | [TournamentCodePanel](reference_air_sources/review/mod__cg__mod_csg_dat/scripts/com/riotgames/pvpnet/tournament/view/TournamentCodePanel.as) |
| team-builder | Team Builder : capitaine, invité et joueur solo | feature_gated — Présence du module GroupFinder ; activation de file et services requise. | [CapView](reference_air_sources/review/mod__cap__mod_cap_dat/scripts/com/riotgames/pvpnet/cap/views/CapView.as), [CapSoloViewContent](reference_air_sources/review/mod__cap__mod_cap_dat/scripts/com/riotgames/pvpnet/cap/views/CapSoloViewContent.as), [CapTeamViewContent](reference_air_sources/review/mod__cap__mod_cap_dat/scripts/com/riotgames/pvpnet/cap/views/CapTeamViewContent.as), [DemandBoardView](reference_air_sources/review/mod__cap__mod_cap_dat/scripts/com/riotgames/pvpnet/cap/views/DemandBoardView.as), [CapMatchFoundPopup](reference_air_sources/review/mod__cap__mod_cap_dat/scripts/com/riotgames/pvpnet/cap/views/popups/CapMatchFoundPopup.as), [CapSoloGroupFoundPopup](reference_air_sources/review/mod__cap__mod_cap_dat/scripts/com/riotgames/pvpnet/cap/views/popups/CapSoloGroupFoundPopup.as) |
| champ-select | Sélection, bans, ordre des joueurs, carte et verrouillage | service_dependent — Définition présente dans la release ; affichage natif non observé. | [ChampionSelectionView](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/views/ChampionSelectionView.as), [BannedChampionsView](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/views/BannedChampionsView.as), [ChampionGrid](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/views/ChampionGrid.as), [ChampionSelectChatWindow](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/views/ChampionSelectChatWindow.as), [MatchDetailsView](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/views/MatchDetailsView.as) |
| champ-loadout | Skins, sorts, runes, maîtrises, échange et reroll | service_dependent — Définition présente dans la release ; affichage natif non observé. | [SpellSelectDialog](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/views/popup/SpellSelectDialog.as), [RunePageSelecter](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/views/RunePageSelecter.as), [ChampSelectMasteriesParentView](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/toMove/components/ChampSelectMasteriesParentView.as), [TradeRequestPanel](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/views/TradeRequestPanel.as), [TradeMessagePanel](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/views/TradeMessagePanel.as) |
| spectate-select | Sélection et délai spectateur | service_dependent — Définition présente dans la release ; affichage natif non observé. | [SpectatorChampionSelectionView](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/views/SpectatorChampionSelectionView.as), [SpectatorWaitBar](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/views/SpectatorWaitBar.as) |
| game-reconnect | Partie en cours, lancement et reconnexion | source_defined — Définition présente dans la release ; affichage natif non observé. | [InGameView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/common/ingame/InGameView.as) |
| end-game | Résultats, statistiques, graphes, score et discussion | service_dependent — Définition présente dans la release ; affichage natif non observé. | [EndOfGameView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/common/endofgame/EndOfGameView.as), [EndOfGameScoreboard](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/common/endofgame/EndOfGameScoreboard.as), [EndOfGameStatsView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/common/endofgame/EndOfGameStatsView.as), [EndOfGameGraph](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/common/endofgame/EndOfGameGraph.as), [EndOfGameChatWindow](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/common/endofgame/EndOfGameChatWindow.as) |
| profile | Profil, recherche d’invocateur et aperçu | service_dependent — Définition présente dans la release ; affichage natif non observé. | [ProfileView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/profile/ProfileView.as), [SummonerProfileView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/summoner/SummonerProfileView.as), [SummonerSummaryView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/summoner/SummonerSummaryView.as), [SummonerInfoQuickView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/summoner/SummonerInfoQuickView.as) |
| profile-stats | Statistiques, classements et statistiques de champions | service_dependent — Définition présente dans la release ; affichage natif non observé. | [ProfileStatsView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/summoner/stats/ProfileStatsView.as), [ProfileStatsLifetimeView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/summoner/stats/ProfileStatsLifetimeView.as), [ProfileStatsRankingView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/summoner/stats/ProfileStatsRankingView.as), [ChampionStatsGraphs](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/summoner/stats/ChampionStatsGraphs.as) |
| match-history | Historique ancien/nouveau, détails, chronologie et graphes | service_dependent — Définition présente dans la release ; affichage natif non observé. | [MatchHistoryIronView](reference_air_sources/review/mod__mhi__mod_mhi_dat/scripts/com/riotgames/pvpnet/matchhistoryiron/ironviews/MatchHistoryIronView.as), [NewMatchHistoryView](reference_air_sources/review/mod__mhi__mod_mhi_dat/scripts/com/riotgames/pvpnet/matchhistoryiron/newmatchhistory/view/NewMatchHistoryView.as), [MatchHistoryGameDetailsView](reference_air_sources/review/mod__mhi__mod_mhi_dat/scripts/com/riotgames/pvpnet/matchhistoryiron/newmatchhistory/view/MatchHistoryGameDetailsView.as), [MatchHistoryDetailsOverTimeView](reference_air_sources/review/mod__mhi__mod_mhi_dat/scripts/com/riotgames/pvpnet/matchhistoryiron/newmatchhistory/view/MatchHistoryDetailsOverTimeView.as), [MatchHistoryGraphPanelView](reference_air_sources/review/mod__mhi__mod_mhi_dat/scripts/com/riotgames/pvpnet/matchhistoryiron/newmatchhistory/view/MatchHistoryGraphPanelView.as) |
| champ-inventory | Collection et filtre des champions | source_defined — Définition présente dans la release ; affichage natif non observé. | [ChampionInventoryRootView](reference_air_sources/review/mod__cinv__mod_cinv_dat/scripts/com/riotgames/pvpnet/championinventory/views/ChampionInventoryRootView.as), [ChampionInventoryView](reference_air_sources/review/mod__cinv__mod_cinv_dat/scripts/com/riotgames/pvpnet/championinventory/views/ChampionInventoryView.as), [ChampionInventoryFilterView](reference_air_sources/review/mod__cinv__mod_cinv_dat/scripts/com/riotgames/pvpnet/championinventory/views/ChampionInventoryFilterView.as), [ChampionInventorySearchView](reference_air_sources/review/mod__cinv__mod_cinv_dat/scripts/com/riotgames/pvpnet/championinventory/views/ChampionInventorySearchView.as) |
| champ-detail | Fiche champion : aperçu, capacités, histoire, conseils, achat | service_dependent — Définition présente dans la release ; affichage natif non observé. | [OverviewScreen](reference_air_sources/review/mod__chp__mod_chp_dat/scripts/com/riotgames/championdetails/overview/OverviewScreen.as), [AbilitiesScreen](reference_air_sources/review/mod__chp__mod_chp_dat/scripts/com/riotgames/championdetails/abilities/AbilitiesScreen.as), [LoreScreen](reference_air_sources/review/mod__chp__mod_chp_dat/scripts/com/riotgames/championdetails/lore/LoreScreen.as), [TipsScreen](reference_air_sources/review/mod__chp__mod_chp_dat/scripts/com/riotgames/championdetails/tips/TipsScreen.as), [PurchaseScreen](reference_air_sources/review/mod__chp__mod_chp_dat/scripts/com/riotgames/championdetails/PurchaseScreen.as) |
| runes | Livre, pages, statistiques et combineur de runes | service_dependent — Définition présente dans la release ; affichage natif non observé. | [RunesRootView](reference_air_sources/review/mod__rune__mod_rune_dat/scripts/com/riotgames/pvpnet/runes/views/RunesRootView.as), [RunesBookView](reference_air_sources/review/mod__rune__mod_rune_dat/scripts/com/riotgames/pvpnet/runes/views/runesbook/RunesBookView.as), [RunesPageView](reference_air_sources/review/mod__rune__mod_rune_dat/scripts/com/riotgames/pvpnet/runes/views/runespage/RunesPageView.as), [RuneCombinerView](reference_air_sources/review/mod__rune__mod_rune_dat/scripts/com/riotgames/pvpnet/runes/views/combiner/RuneCombinerView.as) |
| masteries | Livre, pages et arbre de maîtrises | service_dependent — Définition présente dans la release ; affichage natif non observé. | [MasteriesBookView](reference_air_sources/review/mod__mst__mod_mst_dat/scripts/com/riotgames/platform/module/masteries/views/MasteriesBookView.as), [MasteriesTreeView](reference_air_sources/review/mod__mst__mod_mst_dat/scripts/com/riotgames/platform/module/masteries/views/MasteriesTreeView.as), [TalentTreeView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/talent/TalentTreeView.as) |
| summoner-spells | Catalogue et détail des sorts d’invocateur | source_defined — Définition présente dans la release ; affichage natif non observé. | [SpellsView](reference_air_sources/review/mod__spells__mod_spells_dat/scripts/com/riotgames/pvpnet/spells/SpellsView.as), [SpellDetailsView](reference_air_sources/review/mod__spells__mod_spells_dat/scripts/com/riotgames/pvpnet/spells/SpellDetailsView.as) |
| item-sets | Objets, recettes, ensembles, import et associations | source_defined — Définition présente dans la release ; affichage natif non observé. | [ItemBrowserModuleView](reference_air_sources/review/mod__itb__mod_itb_dat/scripts/com/riotgames/pvpnet/itembrowser/views/ItemBrowserModuleView.as), [ItemSetEditorView](reference_air_sources/review/mod__itb__mod_itb_dat/scripts/com/riotgames/pvpnet/itembrowser/views/ItemSetEditorView.as), [ItemSetImportView](reference_air_sources/review/mod__itb__mod_itb_dat/scripts/com/riotgames/pvpnet/itembrowser/views/ItemSetImportView.as), [ItemSetAssociationManagementView](reference_air_sources/review/mod__itb__mod_itb_dat/scripts/com/riotgames/pvpnet/itembrowser/views/ItemSetAssociationManagementView.as) |
| leagues | Ligues, promotions, séries et statistiques classées | service_dependent — Définition présente dans la release ; affichage natif non observé. | [LeagueSystemMainView](reference_air_sources/review/mod__lsi__mod_lsi_dat/scripts/com/riotgames/pvpnet/CLS/views/LeagueSystemMainView.as), [LeagueSystemOverviewView](reference_air_sources/review/mod__lsi__mod_lsi_dat/scripts/com/riotgames/pvpnet/CLS/views/LeagueSystemOverviewView.as), [RankingView](reference_air_sources/review/mod__lsi__mod_lsi_dat/scripts/com/riotgames/pvpnet/CLS/views/rankingview/RankingView.as), [PromotionSeriesView](reference_air_sources/review/mod__lsi__mod_lsi_dat/scripts/com/riotgames/pvpnet/CLS/views/promotionseries/PromotionSeriesView.as), [NoLeaguesView](reference_air_sources/review/mod__lsi__mod_lsi_dat/scripts/com/riotgames/pvpnet/CLS/views/noleagues/NoLeaguesView.as) |
| ranked-teams | Équipes classées : création, gestion, profil et historique | service_dependent — Définition présente dans la release ; affichage natif non observé. | [RTModuleShell](reference_air_sources/review/mod__rkt__mod_rkt_dat/scripts/com/riotgames/platform/gameclient/module/rt/view/RTModuleShell.as), [CreateTeamModal](reference_air_sources/review/mod__rkt__mod_rkt_dat/scripts/com/riotgames/platform/gameclient/module/rt/view/modal/CreateTeamModal.as), [ManageTeamView](reference_air_sources/review/mod__rkt__mod_rkt_dat/scripts/com/riotgames/platform/gameclient/module/rt/view/manage/ManageTeamView.as), [ProfileTeamView](reference_air_sources/review/mod__rkt__mod_rkt_dat/scripts/com/riotgames/platform/gameclient/module/rt/view/profile/ProfileTeamView.as), [HistoryView](reference_air_sources/review/mod__rkt__mod_rkt_dat/scripts/com/riotgames/platform/gameclient/module/rt/view/history/HistoryView.as) |
| store | Boutique embarquée, navigateur et page indisponible | service_dependent — Hôte AIR et cadre local présents ; pages et transactions distantes non reconstituées par cet inventaire. | [StoreView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/store/StoreView.as), [StoreHtmlView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/store/StoreHtmlView.as), [InternalBrowser](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/common/components/controls/InternalBrowser.as) |
| friends | Amis, ignorés, récents, notes et notifications | source_defined — Définition présente dans la release ; affichage natif non observé. | [BuddyPanelView](reference_air_sources/review/mod__cht2__mod_cht2_dat/scripts/com/riotgames/pvpnet/docked/chat/view/buddypanel/BuddyPanelView.as), [BuddyPanelFriendsListView](reference_air_sources/review/mod__cht2__mod_cht2_dat/scripts/com/riotgames/pvpnet/docked/chat/view/buddypanel/BuddyPanelFriendsListView.as), [BuddyPanelIgnoreListView](reference_air_sources/review/mod__cht2__mod_cht2_dat/scripts/com/riotgames/pvpnet/docked/chat/view/buddypanel/BuddyPanelIgnoreListView.as), [BuddyPanelRecentPlayersView](reference_air_sources/review/mod__cht2__mod_cht2_dat/scripts/com/riotgames/pvpnet/docked/chat/view/buddypanel/BuddyPanelRecentPlayersView.as), [BuddyNotePopup](reference_air_sources/review/mod__cht2__mod_cht2_dat/scripts/com/riotgames/pvpnet/docked/friendlist/view/BuddyNotePopup.as) |
| chat | Conversations privées, salons, groupe et barre ancrée | service_dependent — Définition présente dans la release ; affichage natif non observé. | [ChatWindowView](reference_air_sources/review/mod__cht2__mod_cht2_dat/scripts/com/riotgames/pvpnet/docked/chat/view/ChatWindowView.as), [ChatRoomView](reference_air_sources/review/mod__cht2__mod_cht2_dat/scripts/com/riotgames/pvpnet/docked/chat/view/groupchat/ChatRoomView.as), [GroupChatWindowView](reference_air_sources/review/mod__cht2__mod_cht2_dat/scripts/com/riotgames/pvpnet/docked/chat/view/groupchat/GroupChatWindowView.as), [DockedChatRootView](reference_air_sources/review/mod__cht2__mod_cht2_dat/scripts/com/riotgames/pvpnet/docked/chat/view/DockedChatRootView.as), [DockedChatTaskBar](reference_air_sources/review/mod__cht2__mod_cht2_dat/scripts/com/riotgames/pvpnet/docked/chat/view/taskbar/DockedChatTaskBar.as) |
| invites | Notifications et acceptation des invitations | service_dependent — Définition présente dans la release ; affichage natif non observé. | [BuddyPanelInviteNotificationsView](reference_air_sources/review/mod__cht2__mod_cht2_dat/scripts/com/riotgames/pvpnet/docked/chat/view/notifications/BuddyPanelInviteNotificationsView.as), [InvitePlayersView](reference_air_sources/review/mod__ivi__mod_ivi_dat/scripts/com/riotgames/pvpnet/invite/legacy/view/InvitePlayersView.as), [BuddyPanelFriendNotificationsView](reference_air_sources/review/mod__cht2__mod_cht2_dat/scripts/com/riotgames/pvpnet/docked/chat/view/notifications/BuddyPanelFriendNotificationsView.as) |
| reporting | Signalement de joueur et honneur | service_dependent — Définition présente dans la release ; affichage natif non observé. | [ReportPlayerView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/Support/ReportPlayerView.as), [EndOfGameScoreboard](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/common/endofgame/EndOfGameScoreboard.as) |
| gifting | Cadeau de fin de partie : liste, détail, confirmation et erreur | service_dependent — Définition présente dans la release ; affichage natif non observé. | [EndOfGameGiftWindowView](reference_air_sources/review/mod__eogg__mod_eogg_dat/scripts/com/riotgames/pvpnet/endofgamegiftwindow/views/EndOfGameGiftWindowView.as), [GiftListView](reference_air_sources/review/mod__eogg__mod_eogg_dat/scripts/com/riotgames/pvpnet/endofgamegiftwindow/views/components/GiftListView.as), [GiftDetailView](reference_air_sources/review/mod__eogg__mod_eogg_dat/scripts/com/riotgames/pvpnet/endofgamegiftwindow/views/components/GiftDetailView.as), [GiftSendCompleteView](reference_air_sources/review/mod__eogg__mod_eogg_dat/scripts/com/riotgames/pvpnet/endofgamegiftwindow/views/components/GiftSendCompleteView.as) |
| celebration | Promotions et remise d’icônes | service_dependent — Définition présente dans la release ; affichage natif non observé. | [CelebrationDialog](reference_air_sources/review/mod__clb__mod_clb_dat/scripts/com/riotgames/pvpnet/celebration/views/CelebrationDialog.as), [TierPromotionDialog](reference_air_sources/review/mod__clb__mod_clb_dat/scripts/com/riotgames/pvpnet/celebration/views/TierPromotionDialog.as), [SummonerIconCeremonyDialogue](reference_air_sources/review/mod__clb__mod_clb_dat/scripts/com/riotgames/pvpnet/celebration/views/SummonerIconCeremonyDialogue.as) |
| season-rewards | Récompenses de saison et progression | feature_gated — Définition présente dans la release ; affichage natif non observé. | [SeasonRewardsMainView](reference_air_sources/review/mod__srw__mod_srw_dat/scripts/com/riotgames/pvpnet/seasonrewards/views/SeasonRewardsMainView.as), [TeamRewardsProgressView](reference_air_sources/review/mod__srw__mod_srw_dat/scripts/com/riotgames/pvpnet/seasonrewards/views/progress/TeamRewardsProgressView.as), [TierRewardsProgressView](reference_air_sources/review/mod__srw__mod_srw_dat/scripts/com/riotgames/pvpnet/seasonrewards/views/progress/TierRewardsProgressView.as) |
| education-feedback | Aide contextuelle, astuces et sondage | feature_gated — Définition présente dans la release ; affichage natif non observé. | [ContextualEducationView](reference_air_sources/review/mod__ced__mod_ced_dat/scripts/com/riotgames/pvpnet/contextualeducation/views/ContextualEducationView.as), [SurveyPopup](reference_air_sources/review/mod__mf__mod_mf_dat/scripts/com/riotgames/pvpnet/microfeedback/popup/SurveyPopup.as), [DefaultToolTipView](reference_air_sources/review/mod__tips__mod_tips_dat/scripts/com/riotgames/pvpnet/tips/views/DefaultToolTipView.as) |
| preferences | Options audio, discussion, notifications et transitions | source_defined — Définition présente dans la release ; affichage natif non observé. | [PreferencesView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/account/PreferencesView.as) |
| support | Aide et soumission de journaux | source_defined — Définition présente dans la release ; affichage natif non observé. | [HelpDialog](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/help/HelpDialog.as), [SubmitLogsDialog](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/application/SubmitLogsDialog.as) |
| transfer | Transfert de compte et états de résultat | service_dependent — Définition présente dans la release ; affichage natif non observé. | [AccountTransferDialog](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/AccountTransfer/AccountTransferDialog.as) |
| alerts | Messages, confirmation, erreur et attente | source_defined — Définition présente dans la release ; affichage natif non observé. | [ErrorAlertView](reference_air_sources/review/mod__ale__mod_ale_dat/scripts/com/riotgames/alerter/view/ErrorAlertView.as), [StandardMessageAlertView](reference_air_sources/review/mod__ale__mod_ale_dat/scripts/com/riotgames/alerter/view/StandardMessageAlertView.as), [WaitAlertView](reference_air_sources/review/mod__ale__mod_ale_dat/scripts/com/riotgames/alerter/view/WaitAlertView.as), [MessageWithCheckBoxAlertView](reference_air_sources/review/mod__ale__mod_ale_dat/scripts/com/riotgames/alerter/view/MessageWithCheckBoxAlertView.as) |
| shutdown | Arrêt programmé, désactivation du jeu et fermeture | source_defined — Définition présente dans la release ; affichage natif non observé. | [PlatformShutdownStatusPane](reference_air_sources/review/mod__win__ClientWindow_dat/scripts/com/riotgames/platform/gameclient/shell/platformshutdown/PlatformShutdownStatusPane.as), [PlatformShutdownFinalPane](reference_air_sources/review/mod__win__ClientWindow_dat/scripts/com/riotgames/platform/gameclient/shell/platformshutdown/PlatformShutdownFinalPane.as) |
| hidden-lore-watch | Anciens points d’entrée histoire et replays | internal_or_hidden — Lore masqué ; module WatchTab absent du manifeste ; bouton replay conditionnel, aucune disponibilité publique déduite. | [StoryView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/lobby/landing/StoryView.as), [LobbyView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/lobby/LobbyView.as), [ChromeTopLevelNavigationView](reference_air_sources/review/mod__chrome__mod_chrome_dat/scripts/com/riotgames/pvpnet/chrome/views/ChromeTopLevelNavigationView.as) |
| developer | Journal et panneau développeur | internal_or_hidden — Diagnostic interne, pas un écran public EUW. | [LogView](reference_air_sources/review/mod__win__ClientWindow_dat/scripts/com/riotgames/platform/gameclient/LogView.as), [DevPanelShell](reference_air_sources/review/mod__win__ClientWindow_dat/scripts/DevPanelShell.as) |

`source_defined` signifie défini dans la release. Les autres libellés signalent une condition de fonctionnalité, région/partenaire, service distant ou usage interne. **Aucun écran n’est marqué observé nativement.**

## Parcours et leurs consommateurs

Les flèches relient les vues concernées ; certains groupes sont des alternatives ou des branches conditionnelles. Les notes précisent ces cas. Les ancres renvoient aux méthodes réelles, jamais aux méthodes vides de LobbyViewController/DummyViewMediator.

| ID | Parcours | Vues concernées | Ancres |
|---|---|---|---|
| J01 | Démarrage, fragments, fournisseurs et écran de connexion — Parcours lu statiquement ; réponse des services et affichage non exécutés. | bootstrap → chrome → login | [A001](#a001), [A002](#a002), [A003](#a003), [A004](#a004), [A170](#a170) |
| J02 | Connexion depuis les champs utilisateur — Parcours lu statiquement ; réponse des services et affichage non exécutés. | login → login-status → home | [A005](#a005), [A006](#a006), [A007](#a007), [A008](#a008) |
| J03 | File de connexion, attente, annulation et reprise — Parcours lu statiquement ; réponse des services et affichage non exécutés. | login → login-status → login | [A009](#a009), [A010](#a010), [A011](#a011) |
| J04 | Échec d’authentification, erreurs et bannissement — Parcours lu statiquement ; réponse des services et affichage non exécutés. | login → login-status → login | [A012](#a012), [A013](#a013), [A014](#a014) |
| J05 | Création, renommage, icône et questionnaire — Branches conditionnelles : ne pas interpréter chaque écran comme obligatoire ni ordonné pour tous les comptes. | login → summoner-name → summoner-icon → questionnaire → tutorial → home | [A015](#a015), [A016](#a016) |
| J06 | Tutoriel proposé et retour à l’accueil — Parcours lu statiquement ; réponse des services et affichage non exécutés. | tutorial → choose-game → champ-select → end-game | [A017](#a017), [A018](#a018) |
| J07 | Accueil, profil, boutique et aide via le cadre — Destinations alternatives depuis le cadre, pas une séquence imposée. | home → chrome → profile → store → support | [A019](#a019), [A020](#a020), [A021](#a021) |
| J08 | Choix du mode et de la file — Parcours lu statiquement ; réponse des services et affichage non exécutés. | home → choose-game → arranged-team → queue | [A022](#a022), [A023](#a023), [A024](#a024) |
| J09 | Partie normale — Parcours lu statiquement ; réponse des services et affichage non exécutés. | choose-game → arranged-team → queue → champ-select | [A025](#a025), [A026](#a026), [A027](#a027) |
| J10 | Coop contre IA — Parcours lu statiquement ; réponse des services et affichage non exécutés. | choose-game → arranged-team → queue → champ-select | [A028](#a028), [A029](#a029) |
| J11 | File classée et refus de participation — Parcours lu statiquement ; réponse des services et affichage non exécutés. | choose-game → arranged-team → queue → queue-refusal | [A030](#a030), [A031](#a031) |
| J12 | Dodge, LeaverBuster et annulation de file — Parcours lu statiquement ; réponse des services et affichage non exécutés. | queue → queue-refusal → home | [A032](#a032), [A033](#a033), [A034](#a034) |
| J13 | Parcourir et créer une partie personnalisée — Navigation alternative parcourir/créer, activée selon la configuration des parties personnalisées. | choose-game → custom-browser → custom-create → custom-lobby | [A035](#a035), [A036](#a036), [A037](#a037) |
| J14 | Invitation vers une partie personnalisée — Parcours lu statiquement ; réponse des services et affichage non exécutés. | invites → custom-lobby → champ-select | [A038](#a038), [A039](#a039) |
| J15 | Code de tournoi — Parcours lu statiquement ; réponse des services et affichage non exécutés. | choose-game → tournament → custom-lobby | [A040](#a040), [A041](#a041), [A171](#a171), [A172](#a172) |
| J16 | Team Builder capitaine — Parcours lu statiquement ; réponse des services et affichage non exécutés. | team-builder → queue → champ-select | [A042](#a042), [A043](#a043) |
| J17 | Team Builder invité — Parcours lu statiquement ; réponse des services et affichage non exécutés. | team-builder → queue → champ-select | [A044](#a044), [A045](#a045) |
| J18 | Team Builder solo et groupe trouvé — Parcours lu statiquement ; réponse des services et affichage non exécutés. | team-builder → queue → champ-select | [A046](#a046), [A047](#a047) |
| J19 | Sélection et verrouillage du champion — Parcours lu statiquement ; réponse des services et affichage non exécutés. | queue → champ-select → game-reconnect | [A048](#a048), [A049](#a049), [A050](#a050), [A051](#a051) |
| J20 | Préparation : skin, sorts, runes et maîtrises — Parcours lu statiquement ; réponse des services et affichage non exécutés. | champ-select → champ-loadout → champ-select | [A052](#a052), [A053](#a053), [A054](#a054), [A055](#a055) |
| J21 | Demande, acceptation, refus et annulation d’échange — Parcours lu statiquement ; réponse des services et affichage non exécutés. | champ-select → champ-loadout → champ-select | [A056](#a056), [A057](#a057), [A058](#a058), [A059](#a059) |
| J22 | Reroll selon le mode — Parcours lu statiquement ; réponse des services et affichage non exécutés. | champ-select → champ-loadout → champ-select | [A060](#a060), [A061](#a061) |
| J23 | Spectateur et délai — Parcours lu statiquement ; réponse des services et affichage non exécutés. | custom-lobby → spectate-select → game-reconnect | [A062](#a062), [A063](#a063), [A064](#a064) |
| J24 | Lancement, déconnexion et reconnexion — Le binaire de partie est une application distincte ; aucun lancement réel dans cette tâche. | champ-select → game-reconnect → champ-select | [A065](#a065), [A066](#a066), [A067](#a067), [A068](#a068) |
| J25 | Résultats et rejouer — Parcours lu statiquement ; réponse des services et affichage non exécutés. | game-reconnect → end-game → choose-game | [A069](#a069), [A070](#a070), [A071](#a071) |
| J26 | Profil et recherche d’invocateur — Parcours lu statiquement ; réponse des services et affichage non exécutés. | chrome → profile → profile-stats | [A072](#a072), [A073](#a073), [A074](#a074) |
| J27 | Historique, détails et chronologie — L’historique peut afficher les détails localement ou ouvrir l’URL web configurée ; absence de template/identifiants produit une URL vide. La disponibilité du site distant n’est pas établie. | profile → match-history | [A075](#a075), [A076](#a076), [A077](#a077), [A078](#a078), [A173](#a173), [A174](#a174), [A175](#a175) |
| J28 | Collection et fiche de champion — Parcours lu statiquement ; réponse des services et affichage non exécutés. | profile → champ-inventory → champ-detail | [A079](#a079), [A080](#a080), [A081](#a081), [A082](#a082), [A083](#a083), [A176](#a176) |
| J29 | Livre de runes et combineur — Parcours lu statiquement ; réponse des services et affichage non exécutés. | profile → runes | [A084](#a084), [A085](#a085), [A086](#a086), [A177](#a177), [A178](#a178), [A179](#a179) |
| J30 | Livre de maîtrises — Parcours lu statiquement ; réponse des services et affichage non exécutés. | profile → masteries | [A087](#a087), [A088](#a088), [A089](#a089), [A180](#a180), [A181](#a181), [A182](#a182) |
| J31 | Catalogue de sorts d’invocateur — Parcours lu statiquement ; réponse des services et affichage non exécutés. | profile → summoner-spells | [A090](#a090), [A091](#a091), [A183](#a183) |
| J32 | Ensembles d’objets, import et associations — Parcours lu statiquement ; réponse des services et affichage non exécutés. | profile → item-sets | [A092](#a092), [A093](#a093), [A094](#a094), [A095](#a095), [A184](#a184), [A185](#a185) |
| J33 | Ligues et promotions — Parcours lu statiquement ; réponse des services et affichage non exécutés. | profile → leagues → celebration | [A096](#a096), [A097](#a097), [A098](#a098), [A099](#a099), [A186](#a186), [A187](#a187) |
| J34 | Équipes classées et gestion — Parcours lu statiquement ; réponse des services et affichage non exécutés. | profile → ranked-teams | [A100](#a100), [A101](#a101), [A102](#a102), [A103](#a103), [A104](#a104), [A188](#a188), [A189](#a189), [A190](#a190) |
| J35 | Boutique disponible, chargement ou fermeture — Parcours lu statiquement ; réponse des services et affichage non exécutés. | chrome → store → store | [A105](#a105), [A106](#a106), [A107](#a107) |
| J36 | Amis, ignorés, récents et notes — Parcours lu statiquement ; réponse des services et affichage non exécutés. | friends → chat → friends | [A108](#a108), [A109](#a109), [A110](#a110), [A111](#a111), [A191](#a191) |
| J37 | Discussion privée, groupe et salon — Parcours lu statiquement ; réponse des services et affichage non exécutés. | friends → chat | [A112](#a112), [A113](#a113), [A114](#a114), [A115](#a115), [A192](#a192) |
| J38 | Invitations et groupe — Parcours lu statiquement ; réponse des services et affichage non exécutés. | friends → invites → arranged-team | [A116](#a116), [A117](#a117), [A118](#a118), [A119](#a119), [A193](#a193) |
| J39 | Signalement après partie — Parcours lu statiquement ; réponse des services et affichage non exécutés. | end-game → reporting | [A120](#a120), [A121](#a121), [A122](#a122), [A194](#a194) |
| J40 | Cadeau : liste, choix, envoi et erreur — Parcours lu statiquement ; réponse des services et affichage non exécutés. | end-game → gifting | [A123](#a123), [A124](#a124), [A125](#a125), [A126](#a126), [A127](#a127) |
| J41 | Récompenses de saison — Parcours lu statiquement ; réponse des services et affichage non exécutés. | profile → season-rewards | [A128](#a128), [A129](#a129), [A130](#a130), [A195](#a195) |
| J42 | Aide contextuelle et sondage — Parcours lu statiquement ; réponse des services et affichage non exécutés. | home → education-feedback | [A131](#a131), [A132](#a132), [A133](#a133), [A196](#a196) |
| J43 | Préférences et aide — Parcours lu statiquement ; réponse des services et affichage non exécutés. | chrome → preferences → support | [A134](#a134), [A135](#a135), [A136](#a136), [A137](#a137) |
| J44 | Transfert de compte et réponses — Parcours lu statiquement ; réponse des services et affichage non exécutés. | profile → transfer → alerts | [A138](#a138), [A139](#a139), [A140](#a140), [A141](#a141), [A197](#a197) |
| J45 | Déconnexion, session expirée et sortie — Parcours lu statiquement ; réponse des services et affichage non exécutés. | home → login → alerts | [A142](#a142), [A143](#a143), [A144](#a144) |
| J46 | Arrêt programmé et refus de nouvelles files — Parcours lu statiquement ; réponse des services et affichage non exécutés. | chrome → shutdown → login | [A145](#a145), [A146](#a146), [A147](#a147) |
| J47 | Anciennes routes et onglets conditionnels — Points d’entrée de code conservés ; Lore explicitement masqué, WatchTab absent, replays conditionnels. Ne pas présenter comme parcours public confirmé. | chrome → hidden-lore-watch | [A148](#a148), [A149](#a149), [A150](#a150) |

## Gardes, refus et variantes

| ID | Condition | Résultat attendu et observé dans la source | Preuve |
|---|---|---|---|
| G01 | Ancien module exclu du chargeur | fale et rds ne sont pas chargés. Condition et branche de refus retrouvées dans les sources originales décompilées. | [A151](#a151) |
| G02 | Connexion désactivée | Identifiants vides, occupé, login interdit ou délai de reprise : bouton désactivé. Condition et branche de refus retrouvées dans les sources originales décompilées. | [A152](#a152) |
| G03 | Compte banni | Texte de statut et bouton de dismissal ; pas un succès de connexion. Condition et branche de refus retrouvées dans les sources originales décompilées. | [A153](#a153) |
| G04 | Wizard conditionnel | Créer/renommer/choisir icône/questionnaire/tutoriel selon les champs de session. Condition et branche de refus retrouvées dans les sources originales décompilées. | [A154](#a154) |
| G05 | Files fermées ou arrêt proche | navigateToGameFlow retourne sans ouvrir le flux. Condition et branche de refus retrouvées dans les sources originales décompilées. | [A155](#a155) |
| G06 | Navigation pendant sélection | Une demande hors PLAY_GAME est abandonnée pendant la sélection non spectateur. Condition et branche de refus retrouvées dans les sources originales décompilées. | [A156](#a156) |
| G07 | Confirmation avant navigation | navigationPromptFunction est appelée avant mutation du lobby. Condition et branche de refus retrouvées dans les sources originales décompilées. | [A157](#a157) |
| G08 | Profil occupé | L’ancien profil occupé refuse une nouvelle consultation. Condition et branche de refus retrouvées dans les sources originales décompilées. | [A158](#a158) |
| G09 | Boutique fermée ou non prête | Page locale storeClosed ou URL vide ; pas de page distante inventée. Condition et branche de refus retrouvées dans les sources originales décompilées. | [A159](#a159) |
| G10 | Boutique et paramètres réservés | token/original_account_id/original_platform_id fournis par la requête sont supprimés. Condition et branche de refus retrouvées dans les sources originales décompilées. | [A160](#a160) |
| G11 | Flux CAP inconnu | initialize lève Unexpected flow - unable to proceed. Condition et branche de refus retrouvées dans les sources originales décompilées. | [A161](#a161) |
| G12 | Navigation relative hors racine | navigate lève ArgumentError si trop de .. Condition et branche de refus retrouvées dans les sources originales décompilées. | [A162](#a162) |
| G13 | Récursion de navigation | setPath lève une erreur après plus de dix navigations réentrantes. Condition et branche de refus retrouvées dans les sources originales décompilées. | [A163](#a163) |
| G14 | Lore masqué | Le bouton Lore est explicitement invisible. Condition et branche de refus retrouvées dans les sources originales décompilées. | [A164](#a164) |
| G15 | Replays conditionnels | Visibilité liée à replayServiceEnabled ; module WatchTab absent de la release. Condition et branche de refus retrouvées dans les sources originales décompilées. | [A165](#a165) |
| G16 | Succès/achievements restreints | getShouldAchievements reste faux sauf liste de comptes interne ; pas un onglet public universel. Condition et branche de refus retrouvées dans les sources originales décompilées. | [A166](#a166) |
| G17 | DTO de sélection hors séquence | Le contrôleur distingue les messages d’une autre partie ou arrivés dans le désordre. Condition et branche de refus retrouvées dans les sources originales décompilées. | [A167](#a167), [A168](#a168) |
| G18 | Bouton Jouer indisponible | Arrêt, choix de file courant ou salon personnalisé désactivent Jouer. Condition et branche de refus retrouvées dans les sources originales décompilées. | [A169](#a169) |

## Modules et graphe du chargeur

Les31 fichiers info.riotmod de la release sont recensés sans limite artificielle. Le chargeur utilise les fragments lib/mod ; ses listes noires et le filtre servicesMode sont lus dans leur implémentation. La fenêtre ClientWindow est chargée directement par LolClient et apparaît donc en plus de ces descripteurs.

| Module | Code | Fournisseurs | Mode services |
|---|---|---|---|
| Tips | mod/tips/mod_tips.dat | com.riotgames.pvpnet.tips::ITipsProvider | 0 |
| SeasonRewards | mod/srw/mod_srw.dat | com.riotgames.pvpnet.seasonrewards::ISeasonRewardsProvider | 0 |
| Spells | mod/spells/mod_spells.dat | com.riotgames.pvpnet.spells::ISpellsProvider | 0 |
| SuggestedPlayers | mod/sgst/mod_sgst.dat | com.riotgames.pvpnet.suggestedplayers::ISuggestedPlayersProvider | 0 |
| Services | mod/ser/mod_ser.dat | com.riotgames.platform.common.provider::IServicesProvider | 1 |
| Runes | mod/rune/mod_rune.dat | com.riotgames.pvpnet.runes::IRunesProvider | 0 |
| Ranked Teams | mod/rkt/mod_rkt.dat | com.riotgames.pvpnet.rankedteams::IRankedTeamsProvider | 0 |
| Reporting | mod/rep/mod_rep.dat | com.riotgames.platform.common.provider::IReportingProvider | 0 |
| Metrics | mod/mtrk/cmmtrks.dat | com.riotgames.platform.common.provider::IMetricsProvider, com.riotgames.pvpnet.tracking::ICrossModuleTrackerProvider, com.riotgames.platform.common.provider::ISessionMetricsProvider | 0 |
| Masteries | mod/mst/mod_mst.dat | com.riotgames.platform.masteries::IMasteriesProvider | 0 |
| MatchHistoryIron | mod/mhi/mod_mhi.dat | com.riotgames.pvpnet.matchhistoryiron::IMatchHistoryIronProvider | 0 |
| MicroFeedback | mod/mf/mod_mf.dat | com.riotgames.platform.common.provider::IMicroFeedbackProvider | 0 |
| Main | mod/man/mod_man.dat | com.riotgames.platform.common.provider::IMainProvider, com.riotgames.platform.gameclient.views::IEndOfGameScoreboardProvider, com.riotgames.platform.gameclient.views::IEndOfGameProvider, com.riotgames.platform.common.provider::IGameProvider, com.riotgames.platform.common.provider::IChampionImagesProvider, com.riotgames.pvpnet.practice::ICreatePracticeGameProvider, com.riotgames.pvpnet.navigation::INavigationProvider | 0 |
| CLS | mod/lsi/mod_lsi.dat | com.riotgames.platform.common.provider::ICLSProvider | 0 |
| Landing Page | mod/lp/mod_lp.dat | com.riotgames.landing::ILobbyLandingPage | 0 |
| Login 2 | mod/lgn/mod_lgn2.dat | com.riotgames.platform.common.provider::ILoginProvider | 0 |
| Invite | mod/ivi/mod_ivi.dat | com.riotgames.pvpnet.invite::IInviteProvider | 0 |
| ItemBrowser | mod/itb/mod_itb.dat | com.riotgames.pvpnet.itembrowser::IItemBrowserProvider | 0 |
| Inventory | mod/inv/mod_inv.dat | com.riotgames.platform.common.provider::IInventory, com.riotgames.platform.common.provider::IInventoryProvider, com.riotgames.platform.common.provider::IRuneBookController | 0 |
| EndOfGameGiftWindow | mod/eogg/mod_eogg.dat | com.riotgames.pvpnet.endofgamegiftwindow::IEndOfGameGiftWindowProvider | 0 |
| Champ Select | mod/cs/mod_cs.dat | com.riotgames.platform.gameclient.championselection::IChampionSelection | 0 |
| Celebration | mod/clb/mod_clb.dat | com.riotgames.pvpnet.celebration::ICelebrationProvider | 0 |
| ChampionInventory | mod/cinv/mod_cinv.dat | com.riotgames.pvpnet.championinventory::IChampionInventoryProvider | 0 |
| Chat | mod/cht2/mod_cht2.dat | com.riotgames.pvpnet.chat::IChatWindowProvider, com.riotgames.pvpnet.chat::IFriendListProvider, com.riotgames.pvpnet.docked::IBuddyPanelProvider, com.riotgames.pvpnet.docked::IDockedChatViewProvider | 0 |
| Chrome | mod/chrome/mod_chrome.dat | com.riotgames.pvpnet.chrome::IChromeProvider | 0 |
| Champ Detail | mod/chp/mod_chp.dat | com.riotgames.platform.common.provider::IChampionDetailProvider | 0 |
| Tournament Code | mod/cg/mod_csg.dat | com.riotgames.pvpnet.tournament::ITournamentCodeProvider | 0 |
| ContextualEducation | mod/ced/mod_ced.dat | com.riotgames.pvpnet.contextualeducation::IContextualEducationProvider | 0 |
| GroupFinder | mod/cap/mod_cap.dat | com.riotgames.platform.common.provider::ICapProvider | 0 |
| AccountManagement | mod/am/mod_am.dat | com.riotgames.pvpnet.accountmanagement::IAccountManagementProvider | 0 |
| Alerter | mod/ale/mod_ale.dat | com.riotgames.pvpnet.system.alerter::IAlerterProvider | 0 |

Les110 entrées des fragments référencent uniquement des identifiants déclarés. Deux chemins de fichier restent absents du manifeste ; aucune autre entrée ne les référence :

- `lib/extension-Windows-x86.dat` — `lib/dependencies.properties` ligne376. Le chargement ou une exemption runtime ne sont pas établis.
- `lib/external/swc/flex3/airglobal.dat` — `lib/external/swc/flex3/dependencies.properties` ligne5. Le chargement ou une exemption runtime ne sont pas établis.

Candidats anciens exclus de la release exacte :

- **ClientFeaturedContent** : `mod/cfct/mod_cfct.dat` ; Absent du manifeste exact AIR0.0.1.119 ; candidat conservé dans l’union d’archives.
- **FlexAlerter** : `mod/fale/mod_fale.dat` ; Absent du manifeste exact AIR0.0.1.119 ; candidat conservé dans l’union d’archives.
- **RDS** : `mod/rds/cmrds.dat` ; Absent du manifeste exact AIR0.0.1.119 ; candidat conservé dans l’union d’archives.
- **Mock Services** : `mod/ser_mock/ClientModuleServicesMock_DO_NOT_SHIP.dat` ; Absent du manifeste exact AIR0.0.1.119 ; candidat conservé dans l’union d’archives.
- **WatchTab** : `mod/wat/mod_wat.dat` ; Absent du manifeste exact AIR0.0.1.119 ; candidat conservé dans l’union d’archives.

Lore reste explicitement masqué ; replays dépend de replayServiceEnabled et WatchTab est absent. Le code des achievements comprend une liste de comptes interne. Ces chemins ne deviennent pas des écrans publics EUW par leur seule présence dans un enum.

## Cadres web et descripteur

Les5 HTML locaux incluent les cadres d’accueil/parent/enfant, le repli de l’accueil et la boutique fermée. Ils ne contiennent pas le catalogue distant de la boutique. Les fonctions JavaScript originales du cadre sont testées en VM Node avec un hôte simulé, selon le reçu de vérification ; aucun site distant ni transaction n’est ouvert.

Le descripteur exact, membre hérité de0.0.1.67, est désormais récupéré et conforme au manifeste119 : versionNumber1.0.0, namespace AIR3.7. Ce sont des métadonnées de descripteur, pas le build PvP.net ni une preuve du runtime installé. Le candidat différent de l’union0.0.1.76 reste exclu comme preuve ; la revalidation SYS-01.1-02 n’est pas réécrite rétroactivement.

## Vérification, intégration et limites

Lecteur maintenu : `tools/project-plan/air_reference.py`. Tests : `test_air_reference.py` et `test_air_frames.cjs`. Les résultats réellement exécutés et fichiers modifiés sont consignés dans [reference_air_routes_4_20_verification.json](reference_air_routes_4_20_verification.json). Les succès/refus du recensement sont distincts de la validation native des écrans.

```powershell
python -B tools/project-plan/air_reference.py --root E:/OpenLeague
python -B -m unittest discover -s tools/project-plan -p test_air_reference.py -v
node --test tools/project-plan/test_air_frames.cjs
```

La seule tâche SYS-01.1-05 reçoit les liens du contrat, de ce rapport et de ses preuves. La consigne stockée dans SQLite et lue par le site/application est vérifiée. Couverture et reprise sont complétées ; aucun cochage, note ou révision utilisateur n’est modifié, aucune acceptation n’est ajoutée. La graine de première installation Tauri reste distincte de la base utilisateur liée.

- Parcours relus statiquement dans les contrôleurs originaux, non exécutés dans Adobe AIR ; aucune observation visuelle, authentification, transaction ni envoi de journaux.
- Activation des files, contenus d’accueil et pages de boutique dépend de services/configurations distants ; leur disponibilité historique EUW et actuelle ne se déduit pas des classes présentes.
- Les classes et constantes annexes incluent composants, points d’entrée hérités et fonctions internes ; leur présence ne prouve pas un écran public.
- Trois fonctions décompilées de styles/framework comportent une erreur : leurs SWF originaux restent conservés. Elles ne servent pas d’ancre de parcours.
- Les graphismes de timelines et les milliers de médias du manifeste ne sont pas rendus ni qualifiés par cet inventaire ; le manifeste complet est conservé.
- Le fuseau du build AIR et la date de déploiement EUW restent inconnus ; le client de partie et le catalogue4.20.1 sont des identités distinctes.
- Le launcher Rust actuel reste un consommateur différent : cet inventaire alimente le référentiel et le plan, sans prétendre implémenter les écrans historiques.
- Deux entrées déclarées dans les fragments (extension-Windows-x86.dat et flex3/airglobal.dat) sont absentes du manifeste et ne sont référencées par aucune autre entrée ; aucune disponibilité ou exemption de chargement n’est inventée. Elles sont recensées explicitement, sans qualifier un démarrage AIR complet.

Exports incomplets de fonctions de style/framework, exclus des ancres de parcours :

- [_ClientWindow_FlexInit](reference_air_sources/review/mod__win__ClientWindow_dat/scripts/_ClientWindow_FlexInit.as)
- [CanvasLayout](reference_air_sources/review/lib__external__swc__flex4__mx_dat/scripts/mx/containers/utilityClasses/CanvasLayout.as)
- [CanvasLayout](reference_air_sources/review/lib__external__swc__flex3__framework_dat/scripts/mx/containers/utilityClasses/CanvasLayout.as)

L’inventaire ne qualifie ni la fidélité visuelle, ni l’audio, ni l’accès aux services historiques, ni le jeu entier. Ces limites restent ouvertes dans le plan. Voir aussi [l’annexe des composants](REFERENCE_AIR_COMPONENTS_4_20.md).

## Ancres de lecture

### A001

[LolClient](reference_air_sources/review/LolClient_swf/scripts/LolClient.as) L23 — lignes23 à32. Empreinte de l’extrait dans le contrat.

### A002

[buildDependenciesDescriptionsFromFragments](reference_air_sources/review/LolClient_swf/scripts/com/riotgames/dependencyloader/DependenciesManagerImpl.as) L117 — lignes117 à132. Empreinte de l’extrait dans le contrat.

### A003

[loadProviders](reference_air_sources/review/lib__ClientLibProvider_dat/scripts/com/riotgames/platform/gameclient/config/ProvidersLoader.as) L20 — lignes20 à69. Empreinte de l’extrait dans le contrat.

### A004

[show](reference_air_sources/review/mod__lgn__mod_lgn2_dat/scripts/com/riotgames/pvpnet/login/LoginModule.as) L77 — lignes77 à83. Empreinte de l’extrait dans le contrat.

### A005

[validateButtonState](reference_air_sources/review/mod__lgn__mod_lgn2_dat/scripts/com/riotgames/pvpnet/login/LoginView.as) L454 — lignes454 à460. Empreinte de l’extrait dans le contrat.

### A006

[initiateLoginSequence](reference_air_sources/review/lib__ClientLibLogin_dat/scripts/com/riotgames/platform/gameclient/module/login/controller/LoginMediator.as) L254 — lignes254 à275. Empreinte de l’extrait dans le contrat.

### A007

[onChatLoginComplete](reference_air_sources/review/mod__lgn__mod_lgn2_dat/scripts/com/riotgames/pvpnet/login/LoginModule.as) L122 — lignes122 à127. Empreinte de l’extrait dans le contrat.

### A008

[showSummonerWizardOrMainLobbyView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/ViewMediatorImpl.as) L146 — lignes146 à176. Empreinte de l’extrait dans le contrat.

### A009

[displayLoginQueueStatus](reference_air_sources/review/lib__ClientLibLogin_dat/scripts/com/riotgames/platform/gameclient/module/login/controller/LoginMediator.as) L174 — lignes174 à181. Empreinte de l’extrait dans le contrat.

### A010

[handleLoginQueueCancel](reference_air_sources/review/lib__ClientLibLogin_dat/scripts/com/riotgames/platform/gameclient/module/login/controller/LoginMediator.as) L152 — lignes152 à162. Empreinte de l’extrait dans le contrat.

### A011

[retryWaitStart](reference_air_sources/review/mod__lgn__mod_lgn2_dat/scripts/com/riotgames/pvpnet/login/LoginView.as) L224 — lignes224 à229. Empreinte de l’extrait dans le contrat.

### A012

[onAuthFailed](reference_air_sources/review/lib__ClientLibLogin_dat/scripts/com/riotgames/platform/gameclient/module/login/controller/LoginMediator.as) L377 — lignes377 à478. Empreinte de l’extrait dans le contrat.

### A013

[onLoginError](reference_air_sources/review/lib__ClientLibLogin_dat/scripts/com/riotgames/platform/gameclient/module/login/controller/LoginMediator.as) L566 — lignes566 à601. Empreinte de l’extrait dans le contrat.

### A014

[displayAccountBanned](reference_air_sources/review/mod__lgn__mod_lgn2_dat/scripts/com/riotgames/pvpnet/login/LoginView.as) L136 — lignes136 à148. Empreinte de l’extrait dans le contrat.

### A015

[showSummonerWizardOrMainLobbyView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/ViewMediatorImpl.as) L146 — lignes146 à176. Empreinte de l’extrait dans le contrat.

### A016

[continueCreateSummonerFlow](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/ViewMediatorImpl.as) L278 — lignes278 à300. Empreinte de l’extrait dans le contrat.

### A017

[showPlayTutorialGame](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/ViewMediatorImpl.as) L321 — lignes321 à324. Empreinte de l’extrait dans le contrat.

### A018

[startTutorialGame](reference_air_sources/review/lib__ClientLibGame_dat/scripts/com/riotgames/pvpnet/game/controllers/MasterGameController.as) L1741 — lignes1741 à1758. Empreinte de l’extrait dans le contrat.

### A019

[navigateToProfile](reference_air_sources/review/mod__chrome__mod_chrome_dat/scripts/com/riotgames/pvpnet/chrome/ChromeController.as) L182 — lignes182 à189. Empreinte de l’extrait dans le contrat.

### A020

[navigateToStore](reference_air_sources/review/mod__chrome__mod_chrome_dat/scripts/com/riotgames/pvpnet/chrome/ChromeController.as) L191 — lignes191 à198. Empreinte de l’extrait dans le contrat.

### A021

[openHelpDialog](reference_air_sources/review/mod__chrome__mod_chrome_dat/scripts/com/riotgames/pvpnet/chrome/ChromeController.as) L218 — lignes218 à225. Empreinte de l’extrait dans le contrat.

### A022

[navigateToGameFlow](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/controllers/lobby/LobbyController.as) L228 — lignes228 à244. Empreinte de l’extrait dans le contrat.

### A023

[prepareForDisplay](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/controllers/lobby/ChooseGameFlowViewController.as) L231 — lignes231 à245. Empreinte de l’extrait dans le contrat.

### A024

[selectQueue](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/controllers/lobby/ChooseGameFlowViewController.as) L578 — lignes578 à617. Empreinte de l’extrait dans le contrat.

### A025

[startNormalGameFlow](reference_air_sources/review/lib__ClientLibGame_dat/scripts/com/riotgames/pvpnet/game/controllers/MasterGameController.as) L1692 — lignes1692 à1702. Empreinte de l’extrait dans le contrat.

### A026

[handleJoinQueue](reference_air_sources/review/lib__ClientLibGame_dat/scripts/com/riotgames/pvpnet/game/controllers/MasterGameViewController.as) L471 — lignes471 à502. Empreinte de l’extrait dans le contrat.

### A027

[startChampionSelect](reference_air_sources/review/lib__ClientLibGame_dat/scripts/com/riotgames/pvpnet/game/controllers/MasterGameController.as) L1218 — lignes1218 à1243. Empreinte de l’extrait dans le contrat.

### A028

[startCoopVsAIGameFlow](reference_air_sources/review/lib__ClientLibGame_dat/scripts/com/riotgames/pvpnet/game/controllers/MasterGameController.as) L1704 — lignes1704 à1714. Empreinte de l’extrait dans le contrat.

### A029

[handleJoinQueue](reference_air_sources/review/lib__ClientLibGame_dat/scripts/com/riotgames/pvpnet/game/controllers/MasterGameViewController.as) L471 — lignes471 à502. Empreinte de l’extrait dans le contrat.

### A030

[startRankedGameFlow](reference_air_sources/review/lib__ClientLibGame_dat/scripts/com/riotgames/pvpnet/game/controllers/MasterGameController.as) L1716 — lignes1716 à1730. Empreinte de l’extrait dans le contrat.

### A031

[handleFailedJoinPlayers](reference_air_sources/review/lib__ClientLibGame_dat/scripts/com/riotgames/pvpnet/game/controllers/MasterGameViewController.as) L560 — lignes560 à728. Empreinte de l’extrait dans le contrat.

### A032

[handleFailedJoinPlayers](reference_air_sources/review/lib__ClientLibGame_dat/scripts/com/riotgames/pvpnet/game/controllers/MasterGameViewController.as) L560 — lignes560 à728. Empreinte de l’extrait dans le contrat.

### A033

[handleLeaverBusterDialogueAborted](reference_air_sources/review/lib__ClientLibGame_dat/scripts/com/riotgames/pvpnet/game/controllers/MasterGameViewController.as) L755 — lignes755 à767. Empreinte de l’extrait dans le contrat.

### A034

[cancelWaitingForGame](reference_air_sources/review/lib__ClientLibGame_dat/scripts/com/riotgames/pvpnet/game/controllers/MasterGameViewController.as) L797 — lignes797 à816. Empreinte de l’extrait dans le contrat.

### A035

[startPracticeGameFlowAtJoinGame](reference_air_sources/review/lib__ClientLibGame_dat/scripts/com/riotgames/pvpnet/game/controllers/MasterGameController.as) L1732 — lignes1732 à1739. Empreinte de l’extrait dans le contrat.

### A036

[startPracticeGameFlowAtCreateGame](reference_air_sources/review/lib__ClientLibGame_dat/scripts/com/riotgames/pvpnet/game/controllers/MasterGameController.as) L1760 — lignes1760 à1767. Empreinte de l’extrait dans le contrat.

### A037

[onCurrentStateChange](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/NewGameViews.as) L639 — lignes639 à673. Empreinte de l’extrait dans le contrat.

### A038

[joinPracticeGameFromInvitation](reference_air_sources/review/lib__ClientLibGame_dat/scripts/com/riotgames/pvpnet/game/controllers/MasterGameController.as) L1770 — lignes1770 à1778. Empreinte de l’extrait dans le contrat.

### A039

[startChampionSelect](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/mediators/ChampionSelectionViewMediator.as) L305 — lignes305 à318. Empreinte de l’extrait dans le contrat.

### A040

[TournamentCodePanel](reference_air_sources/review/mod__cg__mod_csg_dat/scripts/com/riotgames/pvpnet/tournament/view/TournamentCodePanel.as) L13 — lignes13 à13. Empreinte de l’extrait dans le contrat.

### A041

[ClientModuleCustomGame](reference_air_sources/review/mod__cg__mod_csg_dat/scripts/ClientModuleCustomGame.as) L14 — lignes14 à14. Empreinte de l’extrait dans le contrat.

### A042

[setupCaptainFlow](reference_air_sources/review/mod__cap__mod_cap_dat/scripts/com/riotgames/pvpnet/cap/mediators/CapViewMediator.as) L128 — lignes128 à140. Empreinte de l’extrait dans le contrat.

### A043

[initialize](reference_air_sources/review/mod__cap__mod_cap_dat/scripts/com/riotgames/pvpnet/cap/mediators/CapViewMediator.as) L89 — lignes89 à110. Empreinte de l’extrait dans le contrat.

### A044

[setupInviteeFlow](reference_air_sources/review/mod__cap__mod_cap_dat/scripts/com/riotgames/pvpnet/cap/mediators/CapViewMediator.as) L60 — lignes60 à72. Empreinte de l’extrait dans le contrat.

### A045

[initialize](reference_air_sources/review/mod__cap__mod_cap_dat/scripts/com/riotgames/pvpnet/cap/mediators/CapViewMediator.as) L89 — lignes89 à110. Empreinte de l’extrait dans le contrat.

### A046

[setupSoloFlow](reference_air_sources/review/mod__cap__mod_cap_dat/scripts/com/riotgames/pvpnet/cap/mediators/CapViewMediator.as) L74 — lignes74 à87. Empreinte de l’extrait dans le contrat.

### A047

[initialize](reference_air_sources/review/mod__cap__mod_cap_dat/scripts/com/riotgames/pvpnet/cap/mediators/CapViewMediator.as) L89 — lignes89 à110. Empreinte de l’extrait dans le contrat.

### A048

[startChampionSelect](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/mediators/ChampionSelectionViewMediator.as) L305 — lignes305 à318. Empreinte de l’extrait dans le contrat.

### A049

[onChampionClicked](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/mediators/ChampionSelectionViewMediator.as) L194 — lignes194 à198. Empreinte de l’extrait dans le contrat.

### A050

[onLockInChoicesClicked](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/mediators/ChampionSelectionViewMediator.as) L188 — lignes188 à192. Empreinte de l’extrait dans le contrat.

### A051

[launchGame](reference_air_sources/review/lib__ClientLibGame_dat/scripts/com/riotgames/pvpnet/game/controllers/MasterGameController.as) L2008 — lignes2008 à2040. Empreinte de l’extrait dans le contrat.

### A052

[onNewSkinSelected](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/mediators/ChampionSelectionViewMediator.as) L155 — lignes155 à159. Empreinte de l’extrait dans le contrat.

### A053

[showSpellSelectDialog](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/mediators/ChampionSelectionViewMediator.as) L231 — lignes231 à268. Empreinte de l’extrait dans le contrat.

### A054

[onPageSelected](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/mediators/ChampionSelectionViewMediator.as) L340 — lignes340 à349. Empreinte de l’extrait dans le contrat.

### A055

[showMasteries](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/mediators/ChampionSelectionViewMediator.as) L379 — lignes379 à385. Empreinte de l’extrait dans le contrat.

### A056

[onTradeRequested](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/mediators/ChampionSelectionViewMediator.as) L219 — lignes219 à223. Empreinte de l’extrait dans le contrat.

### A057

[onTradeAccepted](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/mediators/ChampionSelectionViewMediator.as) L136 — lignes136 à140. Empreinte de l’extrait dans le contrat.

### A058

[onTradeRefused](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/mediators/ChampionSelectionViewMediator.as) L329 — lignes329 à333. Empreinte de l’extrait dans le contrat.

### A059

[onTradeCanceled](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/mediators/ChampionSelectionViewMediator.as) L487 — lignes487 à491. Empreinte de l’extrait dans le contrat.

### A060

[onRerollRequested](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/mediators/ChampionSelectionViewMediator.as) L373 — lignes373 à377. Empreinte de l’extrait dans le contrat.

### A061

[onRerollUpdated](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/mediators/ChampionSelectionViewMediator.as) L335 — lignes335 à338. Empreinte de l’extrait dans le contrat.

### A062

[waitForObserverGame](reference_air_sources/review/lib__ClientLibGame_dat/scripts/com/riotgames/pvpnet/game/controllers/MasterGameController.as) L1287 — lignes1287 à1294. Empreinte de l’extrait dans le contrat.

### A063

[SpectatorChampionSelectionView](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/views/SpectatorChampionSelectionView.as) L59 — lignes59 à59. Empreinte de l’extrait dans le contrat.

### A064

[SpectatorWaitBar](reference_air_sources/review/mod__cs__mod_cs_dat/scripts/com/riotgames/platform/gameclient/controllers/game/views/SpectatorWaitBar.as) L39 — lignes39 à39. Empreinte de l’extrait dans le contrat.

### A065

[launchGame](reference_air_sources/review/lib__ClientLibGame_dat/scripts/com/riotgames/pvpnet/game/controllers/MasterGameController.as) L2008 — lignes2008 à2040. Empreinte de l’extrait dans le contrat.

### A066

[setPlayingDisconnected](reference_air_sources/review/lib__ClientLibGame_dat/scripts/com/riotgames/pvpnet/game/controllers/MasterGameController.as) L1514 — lignes1514 à1517. Empreinte de l’extrait dans le contrat.

### A067

[reconnectToGame](reference_air_sources/review/lib__ClientLibGame_dat/scripts/com/riotgames/pvpnet/game/controllers/MasterGameController.as) L1843 — lignes1843 à1885. Empreinte de l’extrait dans le contrat.

### A068

[reconnectToGameInProgress](reference_air_sources/review/lib__ClientLibLogin_dat/scripts/com/riotgames/platform/gameclient/module/login/controller/LoginMediator.as) L642 — lignes642 à652. Empreinte de l’extrait dans le contrat.

### A069

[gameCompleted](reference_air_sources/review/lib__ClientLibGame_dat/scripts/com/riotgames/pvpnet/game/controllers/MasterGameController.as) L1825 — lignes1825 à1831. Empreinte de l’extrait dans le contrat.

### A070

[onPlayAgainClicked](reference_air_sources/review/lib__ClientLibGame_dat/scripts/com/riotgames/pvpnet/game/controllers/MasterGameController.as) L1628 — lignes1628 à1632. Empreinte de l’extrait dans le contrat.

### A071

[onCurrentStateChange](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/game/NewGameViews.as) L639 — lignes639 à673. Empreinte de l’extrait dans le contrat.

### A072

[reviewSummonerProfile](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/controllers/lobby/LobbyController.as) L94 — lignes94 à116. Empreinte de l’extrait dans le contrat.

### A073

[searchForSummoner](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/controllers/lobby/LobbyController.as) L401 — lignes401 à424. Empreinte de l’extrait dans le contrat.

### A074

[setProfileState](reference_air_sources/review/lib__ClientLibSummonerProfile_dat/scripts/com/riotgames/platform/gameclient/controllers/summoner/SummonerProfileController.as) L722 — lignes722 à756. Empreinte de l’extrait dans le contrat.

### A075

[MatchHistoryIronView](reference_air_sources/review/mod__mhi__mod_mhi_dat/scripts/com/riotgames/pvpnet/matchhistoryiron/ironviews/MatchHistoryIronView.as) L41 — lignes41 à41. Empreinte de l’extrait dans le contrat.

### A076

[NewMatchHistoryView](reference_air_sources/review/mod__mhi__mod_mhi_dat/scripts/com/riotgames/pvpnet/matchhistoryiron/newmatchhistory/view/NewMatchHistoryView.as) L21 — lignes21 à21. Empreinte de l’extrait dans le contrat.

### A077

[MatchHistoryGameDetailsView](reference_air_sources/review/mod__mhi__mod_mhi_dat/scripts/com/riotgames/pvpnet/matchhistoryiron/newmatchhistory/view/MatchHistoryGameDetailsView.as) L18 — lignes18 à18. Empreinte de l’extrait dans le contrat.

### A078

[MatchHistoryDetailsOverTimeView](reference_air_sources/review/mod__mhi__mod_mhi_dat/scripts/com/riotgames/pvpnet/matchhistoryiron/newmatchhistory/view/MatchHistoryDetailsOverTimeView.as) L20 — lignes20 à20. Empreinte de l’extrait dans le contrat.

### A079

[createNewChampionInventory](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/summoner/SummonerProfileView.as) L557 — lignes557 à564. Empreinte de l’extrait dans le contrat.

### A080

[ChampionInventoryRootView](reference_air_sources/review/mod__cinv__mod_cinv_dat/scripts/com/riotgames/pvpnet/championinventory/views/ChampionInventoryRootView.as) L28 — lignes28 à28. Empreinte de l’extrait dans le contrat.

### A081

[OverviewScreen](reference_air_sources/review/mod__chp__mod_chp_dat/scripts/com/riotgames/championdetails/overview/OverviewScreen.as) L19 — lignes19 à19. Empreinte de l’extrait dans le contrat.

### A082

[AbilitiesScreen](reference_air_sources/review/mod__chp__mod_chp_dat/scripts/com/riotgames/championdetails/abilities/AbilitiesScreen.as) L23 — lignes23 à23. Empreinte de l’extrait dans le contrat.

### A083

[PurchaseScreen](reference_air_sources/review/mod__chp__mod_chp_dat/scripts/com/riotgames/championdetails/PurchaseScreen.as) L37 — lignes37 à37. Empreinte de l’extrait dans le contrat.

### A084

[createNewRunePage](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/summoner/SummonerProfileView.as) L399 — lignes399 à408. Empreinte de l’extrait dans le contrat.

### A085

[RunesRootView](reference_air_sources/review/mod__rune__mod_rune_dat/scripts/com/riotgames/pvpnet/runes/views/RunesRootView.as) L44 — lignes44 à44. Empreinte de l’extrait dans le contrat.

### A086

[RuneCombinerView](reference_air_sources/review/mod__rune__mod_rune_dat/scripts/com/riotgames/pvpnet/runes/views/combiner/RuneCombinerView.as) L6 — lignes6 à6. Empreinte de l’extrait dans le contrat.

### A087

[MasteriesViewMediator](reference_air_sources/review/mod__mst__mod_mst_dat/scripts/com/riotgames/platform/module/masteries/controller/MasteriesViewMediator.as) L19 — lignes19 à19. Empreinte de l’extrait dans le contrat.

### A088

[MasteriesBookView](reference_air_sources/review/mod__mst__mod_mst_dat/scripts/com/riotgames/platform/module/masteries/views/MasteriesBookView.as) L28 — lignes28 à28. Empreinte de l’extrait dans le contrat.

### A089

[MasteriesTreeView](reference_air_sources/review/mod__mst__mod_mst_dat/scripts/com/riotgames/platform/module/masteries/views/MasteriesTreeView.as) L22 — lignes22 à22. Empreinte de l’extrait dans le contrat.

### A090

[SpellsView](reference_air_sources/review/mod__spells__mod_spells_dat/scripts/com/riotgames/pvpnet/spells/SpellsView.as) L10 — lignes10 à10. Empreinte de l’extrait dans le contrat.

### A091

[SpellDetailsView](reference_air_sources/review/mod__spells__mod_spells_dat/scripts/com/riotgames/pvpnet/spells/SpellDetailsView.as) L27 — lignes27 à27. Empreinte de l’extrait dans le contrat.

### A092

[ItemBrowserModuleView](reference_air_sources/review/mod__itb__mod_itb_dat/scripts/com/riotgames/pvpnet/itembrowser/views/ItemBrowserModuleView.as) L25 — lignes25 à25. Empreinte de l’extrait dans le contrat.

### A093

[ItemSetEditorView](reference_air_sources/review/mod__itb__mod_itb_dat/scripts/com/riotgames/pvpnet/itembrowser/views/ItemSetEditorView.as) L12 — lignes12 à12. Empreinte de l’extrait dans le contrat.

### A094

[ItemSetImportView](reference_air_sources/review/mod__itb__mod_itb_dat/scripts/com/riotgames/pvpnet/itembrowser/views/ItemSetImportView.as) L28 — lignes28 à28. Empreinte de l’extrait dans le contrat.

### A095

[ItemSetAssociationManagementView](reference_air_sources/review/mod__itb__mod_itb_dat/scripts/com/riotgames/pvpnet/itembrowser/views/ItemSetAssociationManagementView.as) L18 — lignes18 à18. Empreinte de l’extrait dans le contrat.

### A096

[LeagueSystemMainView](reference_air_sources/review/mod__lsi__mod_lsi_dat/scripts/com/riotgames/pvpnet/CLS/views/LeagueSystemMainView.as) L29 — lignes29 à29. Empreinte de l’extrait dans le contrat.

### A097

[RankingView](reference_air_sources/review/mod__lsi__mod_lsi_dat/scripts/com/riotgames/pvpnet/CLS/views/rankingview/RankingView.as) L30 — lignes30 à30. Empreinte de l’extrait dans le contrat.

### A098

[PromotionSeriesView](reference_air_sources/review/mod__lsi__mod_lsi_dat/scripts/com/riotgames/pvpnet/CLS/views/promotionseries/PromotionSeriesView.as) L23 — lignes23 à23. Empreinte de l’extrait dans le contrat.

### A099

[TierPromotionDialog](reference_air_sources/review/mod__clb__mod_clb_dat/scripts/com/riotgames/pvpnet/celebration/views/TierPromotionDialog.as) L19 — lignes19 à19. Empreinte de l’extrait dans le contrat.

### A100

[RTModuleShell](reference_air_sources/review/mod__rkt__mod_rkt_dat/scripts/com/riotgames/platform/gameclient/module/rt/view/RTModuleShell.as) L25 — lignes25 à25. Empreinte de l’extrait dans le contrat.

### A101

[CreateTeamModal](reference_air_sources/review/mod__rkt__mod_rkt_dat/scripts/com/riotgames/platform/gameclient/module/rt/view/modal/CreateTeamModal.as) L43 — lignes43 à43. Empreinte de l’extrait dans le contrat.

### A102

[ManageTeamView](reference_air_sources/review/mod__rkt__mod_rkt_dat/scripts/com/riotgames/platform/gameclient/module/rt/view/manage/ManageTeamView.as) L28 — lignes28 à28. Empreinte de l’extrait dans le contrat.

### A103

[ProfileTeamView](reference_air_sources/review/mod__rkt__mod_rkt_dat/scripts/com/riotgames/platform/gameclient/module/rt/view/profile/ProfileTeamView.as) L11 — lignes11 à11. Empreinte de l’extrait dans le contrat.

### A104

[HistoryView](reference_air_sources/review/mod__rkt__mod_rkt_dat/scripts/com/riotgames/platform/gameclient/module/rt/view/history/HistoryView.as) L28 — lignes28 à28. Empreinte de l’extrait dans le contrat.

### A105

[showStoreView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/controllers/lobby/LobbyController.as) L523 — lignes523 à528. Empreinte de l’extrait dans le contrat.

### A106

[getCurrentStoreUrl](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/controllers/store/StoreController.as) L169 — lignes169 à207. Empreinte de l’extrait dans le contrat.

### A107

[sessionExpired](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/store/StoreHtmlView.as) L282 — lignes282 à285. Empreinte de l’extrait dans le contrat.

### A108

[BuddyPanelFriendsListView](reference_air_sources/review/mod__cht2__mod_cht2_dat/scripts/com/riotgames/pvpnet/docked/chat/view/buddypanel/BuddyPanelFriendsListView.as) L16 — lignes16 à16. Empreinte de l’extrait dans le contrat.

### A109

[BuddyPanelIgnoreListView](reference_air_sources/review/mod__cht2__mod_cht2_dat/scripts/com/riotgames/pvpnet/docked/chat/view/buddypanel/BuddyPanelIgnoreListView.as) L18 — lignes18 à18. Empreinte de l’extrait dans le contrat.

### A110

[BuddyPanelRecentPlayersView](reference_air_sources/review/mod__cht2__mod_cht2_dat/scripts/com/riotgames/pvpnet/docked/chat/view/buddypanel/BuddyPanelRecentPlayersView.as) L16 — lignes16 à16. Empreinte de l’extrait dans le contrat.

### A111

[BuddyNotePopup](reference_air_sources/review/mod__cht2__mod_cht2_dat/scripts/com/riotgames/pvpnet/docked/friendlist/view/BuddyNotePopup.as) L20 — lignes20 à20. Empreinte de l’extrait dans le contrat.

### A112

[ChatWindowView](reference_air_sources/review/mod__cht2__mod_cht2_dat/scripts/com/riotgames/pvpnet/docked/chat/view/ChatWindowView.as) L46 — lignes46 à46. Empreinte de l’extrait dans le contrat.

### A113

[ChatRoomView](reference_air_sources/review/mod__cht2__mod_cht2_dat/scripts/com/riotgames/pvpnet/docked/chat/view/groupchat/ChatRoomView.as) L28 — lignes28 à28. Empreinte de l’extrait dans le contrat.

### A114

[GroupChatWindowView](reference_air_sources/review/mod__cht2__mod_cht2_dat/scripts/com/riotgames/pvpnet/docked/chat/view/groupchat/GroupChatWindowView.as) L33 — lignes33 à33. Empreinte de l’extrait dans le contrat.

### A115

[DockedChatTaskBar](reference_air_sources/review/mod__cht2__mod_cht2_dat/scripts/com/riotgames/pvpnet/docked/chat/view/taskbar/DockedChatTaskBar.as) L22 — lignes22 à22. Empreinte de l’extrait dans le contrat.

### A116

[InvitePlayersView](reference_air_sources/review/mod__ivi__mod_ivi_dat/scripts/com/riotgames/pvpnet/invite/legacy/view/InvitePlayersView.as) L66 — lignes66 à66. Empreinte de l’extrait dans le contrat.

### A117

[BuddyPanelInviteNotificationsView](reference_air_sources/review/mod__cht2__mod_cht2_dat/scripts/com/riotgames/pvpnet/docked/chat/view/notifications/BuddyPanelInviteNotificationsView.as) L10 — lignes10 à10. Empreinte de l’extrait dans le contrat.

### A118

[NormalGameInviteAcceptAction](reference_air_sources/review/mod__ivi__mod_ivi_dat/scripts/com/riotgames/pvpnet/invite/legacy/action/NormalGameInviteAcceptAction.as) L8 — lignes8 à8. Empreinte de l’extrait dans le contrat.

### A119

[PracticeGameInviteAcceptAction](reference_air_sources/review/mod__ivi__mod_ivi_dat/scripts/com/riotgames/pvpnet/invite/legacy/action/PracticeGameInviteAcceptAction.as) L8 — lignes8 à8. Empreinte de l’extrait dans le contrat.

### A120

[ShowReportPlayerPopupAction](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/popup/ShowReportPlayerPopupAction.as) L24 — lignes24 à24. Empreinte de l’extrait dans le contrat.

### A121

[ReportPlayerView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/Support/ReportPlayerView.as) L54 — lignes54 à54. Empreinte de l’extrait dans le contrat.

### A122

[Reporter](reference_air_sources/review/mod__rep__mod_rep_dat/scripts/com/riotgames/platform/gameclient/module/reporting/Reporter.as) L9 — lignes9 à9. Empreinte de l’extrait dans le contrat.

### A123

[showNewGiftList](reference_air_sources/review/mod__eogg__mod_eogg_dat/scripts/com/riotgames/pvpnet/endofgamegiftwindow/views/EndOfGameGiftViewMediator.as) L74 — lignes74 à78. Empreinte de l’extrait dans le contrat.

### A124

[showConfirmGift](reference_air_sources/review/mod__eogg__mod_eogg_dat/scripts/com/riotgames/pvpnet/endofgamegiftwindow/views/EndOfGameGiftViewMediator.as) L90 — lignes90 à94. Empreinte de l’extrait dans le contrat.

### A125

[showSendingGift](reference_air_sources/review/mod__eogg__mod_eogg_dat/scripts/com/riotgames/pvpnet/endofgamegiftwindow/views/EndOfGameGiftViewMediator.as) L102 — lignes102 à106. Empreinte de l’extrait dans le contrat.

### A126

[showSentGiftConfirmation](reference_air_sources/review/mod__eogg__mod_eogg_dat/scripts/com/riotgames/pvpnet/endofgamegiftwindow/views/EndOfGameGiftViewMediator.as) L108 — lignes108 à112. Empreinte de l’extrait dans le contrat.

### A127

[showGiftServiceError](reference_air_sources/review/mod__eogg__mod_eogg_dat/scripts/com/riotgames/pvpnet/endofgamegiftwindow/views/EndOfGameGiftViewMediator.as) L114 — lignes114 à118. Empreinte de l’extrait dans le contrat.

### A128

[SeasonRewardsMainView](reference_air_sources/review/mod__srw__mod_srw_dat/scripts/com/riotgames/pvpnet/seasonrewards/views/SeasonRewardsMainView.as) L25 — lignes25 à25. Empreinte de l’extrait dans le contrat.

### A129

[TeamRewardsProgressView](reference_air_sources/review/mod__srw__mod_srw_dat/scripts/com/riotgames/pvpnet/seasonrewards/views/progress/TeamRewardsProgressView.as) L21 — lignes21 à21. Empreinte de l’extrait dans le contrat.

### A130

[TierRewardsProgressView](reference_air_sources/review/mod__srw__mod_srw_dat/scripts/com/riotgames/pvpnet/seasonrewards/views/progress/TierRewardsProgressView.as) L12 — lignes12 à12. Empreinte de l’extrait dans le contrat.

### A131

[ContextualEducationView](reference_air_sources/review/mod__ced__mod_ced_dat/scripts/com/riotgames/pvpnet/contextualeducation/views/ContextualEducationView.as) L16 — lignes16 à16. Empreinte de l’extrait dans le contrat.

### A132

[SurveyPopup](reference_air_sources/review/mod__mf__mod_mf_dat/scripts/com/riotgames/pvpnet/microfeedback/popup/SurveyPopup.as) L21 — lignes21 à21. Empreinte de l’extrait dans le contrat.

### A133

[DefaultToolTipView](reference_air_sources/review/mod__tips__mod_tips_dat/scripts/com/riotgames/pvpnet/tips/views/DefaultToolTipView.as) L12 — lignes12 à12. Empreinte de l’extrait dans le contrat.

### A134

[ShowPreferencesPopupAction](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/popup/ShowPreferencesPopupAction.as) L11 — lignes11 à11. Empreinte de l’extrait dans le contrat.

### A135

[savePreferences](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/account/PreferencesView.as) L834 — lignes834 à839. Empreinte de l’extrait dans le contrat.

### A136

[ShowHelpPopupAction](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/popup/ShowHelpPopupAction.as) L12 — lignes12 à12. Empreinte de l’extrait dans le contrat.

### A137

[ShowSubmitLogsPopupAction](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/popup/ShowSubmitLogsPopupAction.as) L11 — lignes11 à11. Empreinte de l’extrait dans le contrat.

### A138

[AccountTransferDialog](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/AccountTransfer/AccountTransferDialog.as) L44 — lignes44 à44. Empreinte de l’extrait dans le contrat.

### A139

[ShowAccountTransferStartedPopupAction](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/domain/accountState/ShowAccountTransferStartedPopupAction.as) L5 — lignes5 à5. Empreinte de l’extrait dans le contrat.

### A140

[ShowAccountTransferFailedPopupAction](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/domain/accountState/ShowAccountTransferFailedPopupAction.as) L5 — lignes5 à5. Empreinte de l’extrait dans le contrat.

### A141

[ShowAccountTransferCompletedPopupAction](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/domain/accountState/ShowAccountTransferCompletedPopupAction.as) L5 — lignes5 à5. Empreinte de l’extrait dans le contrat.

### A142

[logout](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/ApplicationController.as) L1134 — lignes1134 à1151. Empreinte de l’extrait dans le contrat.

### A143

[logoutSessionExpired](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/ApplicationController.as) L1253 — lignes1253 à1256. Empreinte de l’extrait dans le contrat.

### A144

[handleExit](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/ApplicationController.as) L1102 — lignes1102 à1105. Empreinte de l’extrait dans le contrat.

### A145

[updatePlayButtonState](reference_air_sources/review/mod__chrome__mod_chrome_dat/scripts/com/riotgames/pvpnet/chrome/ChromeController.as) L82 — lignes82 à96. Empreinte de l’extrait dans le contrat.

### A146

[navigateToGameFlow](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/controllers/lobby/LobbyController.as) L228 — lignes228 à244. Empreinte de l’extrait dans le contrat.

### A147

[PlatformShutdownFinalPane](reference_air_sources/review/mod__win__ClientWindow_dat/scripts/com/riotgames/platform/gameclient/shell/platformshutdown/PlatformShutdownFinalPane.as) L42 — lignes42 à42. Empreinte de l’extrait dans le contrat.

### A148

[showStoryView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/controllers/lobby/LobbyController.as) L570 — lignes570 à579. Empreinte de l’extrait dans le contrat.

### A149

[showWatchTab](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/controllers/lobby/LobbyController.as) L369 — lignes369 à373. Empreinte de l’extrait dans le contrat.

### A150

[ChromeTopLevelNavigationView](reference_air_sources/review/mod__chrome__mod_chrome_dat/scripts/com/riotgames/pvpnet/chrome/views/ChromeTopLevelNavigationView.as) L17 — lignes17 à17. Empreinte de l’extrait dans le contrat.

### A151

[DependenciesManagerImpl](reference_air_sources/review/LolClient_swf/scripts/com/riotgames/dependencyloader/DependenciesManagerImpl.as) L17 — lignes17 à17. Empreinte de l’extrait dans le contrat.

### A152

[validateButtonState](reference_air_sources/review/mod__lgn__mod_lgn2_dat/scripts/com/riotgames/pvpnet/login/LoginView.as) L454 — lignes454 à460. Empreinte de l’extrait dans le contrat.

### A153

[displayAccountBanned](reference_air_sources/review/mod__lgn__mod_lgn2_dat/scripts/com/riotgames/pvpnet/login/LoginView.as) L136 — lignes136 à148. Empreinte de l’extrait dans le contrat.

### A154

[showSummonerWizardOrMainLobbyView](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/ViewMediatorImpl.as) L146 — lignes146 à176. Empreinte de l’extrait dans le contrat.

### A155

[navigateToGameFlow](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/controllers/lobby/LobbyController.as) L228 — lignes228 à244. Empreinte de l’extrait dans le contrat.

### A156

[requestLobbyState](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/controllers/lobby/LobbyController.as) L287 — lignes287 à313. Empreinte de l’extrait dans le contrat.

### A157

[requestLobbyState](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/controllers/lobby/LobbyController.as) L287 — lignes287 à313. Empreinte de l’extrait dans le contrat.

### A158

[reviewSummonerProfile](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/controllers/lobby/LobbyController.as) L94 — lignes94 à116. Empreinte de l’extrait dans le contrat.

### A159

[getCurrentStoreUrl](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/controllers/store/StoreController.as) L169 — lignes169 à207. Empreinte de l’extrait dans le contrat.

### A160

[getCurrentStoreUrl](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/controllers/store/StoreController.as) L169 — lignes169 à207. Empreinte de l’extrait dans le contrat.

### A161

[initialize](reference_air_sources/review/mod__cap__mod_cap_dat/scripts/com/riotgames/pvpnet/cap/mediators/CapViewMediator.as) L89 — lignes89 à110. Empreinte de l’extrait dans le contrat.

### A162

[navigate](reference_air_sources/review/lib__ClientLibNavigation_dat/scripts/com/riotgames/pvpnet/navigation/NavigationManagerImpl.as) L79 — lignes79 à136. Empreinte de l’extrait dans le contrat.

### A163

[setPath](reference_air_sources/review/lib__ClientLibNavigation_dat/scripts/com/riotgames/pvpnet/navigation/NavigationManagerImpl.as) L49 — lignes49 à72. Empreinte de l’extrait dans le contrat.

### A164

[ChromeTopLevelNavigationView](reference_air_sources/review/mod__chrome__mod_chrome_dat/scripts/com/riotgames/pvpnet/chrome/views/ChromeTopLevelNavigationView.as) L54 — lignes54 à54. Empreinte de l’extrait dans le contrat.

### A165

[ChromeTopLevelNavigationView](reference_air_sources/review/mod__chrome__mod_chrome_dat/scripts/com/riotgames/pvpnet/chrome/views/ChromeTopLevelNavigationView.as) L73 — lignes73 à73. Empreinte de l’extrait dans le contrat.

### A166

[getShouldAchievements](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/summoner/SummonerProfileView.as) L708 — lignes708 à723. Empreinte de l’extrait dans le contrat.

### A167

[checkForOutOfSequenceGame](reference_air_sources/review/lib__ClientLibGame_dat/scripts/com/riotgames/pvpnet/game/controllers/MasterGameController.as) L349 — lignes349 à365. Empreinte de l’extrait dans le contrat.

### A168

[checkForOutOfOrderChampSelectDto](reference_air_sources/review/lib__ClientLibGame_dat/scripts/com/riotgames/pvpnet/game/controllers/MasterGameController.as) L384 — lignes384 à392. Empreinte de l’extrait dans le contrat.

### A169

[updatePlayButtonState](reference_air_sources/review/mod__chrome__mod_chrome_dat/scripts/com/riotgames/pvpnet/chrome/ChromeController.as) L82 — lignes82 à96. Empreinte de l’extrait dans le contrat.

### A170

[doInvocation](reference_air_sources/review/lib__ClientLibSystem_dat/scripts/com/riotgames/pvpnet/system/boot/actions/InitializeProviderLayerAction.as) L25 — lignes25 à37. Empreinte de l’extrait dans le contrat.

### A171

[onTextChanged](reference_air_sources/review/mod__cg__mod_csg_dat/scripts/com/riotgames/pvpnet/tournament/view/TournamentCodePanel.as) L31 — lignes31 à53. Empreinte de l’extrait dans le contrat.

### A172

[onJoinClicked](reference_air_sources/review/mod__cg__mod_csg_dat/scripts/com/riotgames/pvpnet/tournament/view/TournamentCodePanel.as) L81 — lignes81 à87. Empreinte de l’extrait dans le contrat.

### A173

[onGameClicked](reference_air_sources/review/mod__mhi__mod_mhi_dat/scripts/com/riotgames/pvpnet/matchhistoryiron/ironviews/MatchHistoryIronView.as) L233 — lignes233 à243. Empreinte de l’extrait dans le contrat.

### A174

[navigateToMatchHistoryPage](reference_air_sources/review/mod__mhi__mod_mhi_dat/scripts/com/riotgames/pvpnet/matchhistoryiron/ironviews/MatchHistoryIronView.as) L245 — lignes245 à254. Empreinte de l’extrait dans le contrat.

### A175

[buildMatchURL](reference_air_sources/review/mod__mhi__mod_mhi_dat/scripts/com/riotgames/pvpnet/matchhistoryiron/ironviews/MatchHistoryIronView.as) L256 — lignes256 à276. Empreinte de l’extrait dans le contrat.

### A176

[show](reference_air_sources/review/mod__cinv__mod_cinv_dat/scripts/com/riotgames/pvpnet/championinventory/views/ChampionInventoryRootView.as) L120 — lignes120 à124. Empreinte de l’extrait dans le contrat.

### A177

[setCurrentRuneBookPage](reference_air_sources/review/mod__rune__mod_rune_dat/scripts/com/riotgames/pvpnet/runes/viewcontroller/RunesViewController.as) L130 — lignes130 à144. Empreinte de l’extrait dans le contrat.

### A178

[save](reference_air_sources/review/mod__rune__mod_rune_dat/scripts/com/riotgames/pvpnet/runes/viewcontroller/RunesViewController.as) L214 — lignes214 à224. Empreinte de l’extrait dans le contrat.

### A179

[revert](reference_air_sources/review/mod__rune__mod_rune_dat/scripts/com/riotgames/pvpnet/runes/viewcontroller/RunesViewController.as) L226 — lignes226 à234. Empreinte de l’extrait dans le contrat.

### A180

[displayView](reference_air_sources/review/mod__mst__mod_mst_dat/scripts/com/riotgames/platform/module/masteries/controller/MasteriesViewMediator.as) L77 — lignes77 à101. Empreinte de l’extrait dans le contrat.

### A181

[onSaveBookRequest](reference_air_sources/review/mod__mst__mod_mst_dat/scripts/com/riotgames/platform/module/masteries/controller/MasteriesViewMediator.as) L103 — lignes103 à107. Empreinte de l’extrait dans le contrat.

### A182

[onCloseEditedViewRequest](reference_air_sources/review/mod__mst__mod_mst_dat/scripts/com/riotgames/platform/module/masteries/controller/MasteriesViewMediator.as) L207 — lignes207 à214. Empreinte de l’extrait dans le contrat.

### A183

[SpellsView](reference_air_sources/review/mod__spells__mod_spells_dat/scripts/com/riotgames/pvpnet/spells/SpellsView.as) L23 — lignes23 à28. Empreinte de l’extrait dans le contrat.

### A184

[show](reference_air_sources/review/mod__itb__mod_itb_dat/scripts/com/riotgames/pvpnet/itembrowser/views/ItemBrowserModuleView.as) L160 — lignes160 à169. Empreinte de l’extrait dans le contrat.

### A185

[hide](reference_air_sources/review/mod__itb__mod_itb_dat/scripts/com/riotgames/pvpnet/itembrowser/views/ItemBrowserModuleView.as) L84 — lignes84 à110. Empreinte de l’extrait dans le contrat.

### A186

[dispatchOnViewLeaguesPressed](reference_air_sources/review/mod__lsi__mod_lsi_dat/scripts/com/riotgames/pvpnet/CLS/managers/LeagueSystemModuleNavigation.as) L150 — lignes150 à153. Empreinte de l’extrait dans le contrat.

### A187

[dispatchOnLeagueSelectionSignal](reference_air_sources/review/mod__lsi__mod_lsi_dat/scripts/com/riotgames/pvpnet/CLS/managers/LeagueSystemModuleNavigation.as) L220 — lignes220 à223. Empreinte de l’extrait dans le contrat.

### A188

[onManageClick](reference_air_sources/review/mod__rkt__mod_rkt_dat/scripts/com/riotgames/platform/gameclient/module/rt/view/RTModuleShellMediator.as) L31 — lignes31 à34. Empreinte de l’extrait dans le contrat.

### A189

[onHistoryClick](reference_air_sources/review/mod__rkt__mod_rkt_dat/scripts/com/riotgames/platform/gameclient/module/rt/view/RTModuleShellMediator.as) L26 — lignes26 à29. Empreinte de l’extrait dans le contrat.

### A190

[onProfileClick](reference_air_sources/review/mod__rkt__mod_rkt_dat/scripts/com/riotgames/platform/gameclient/module/rt/view/RTModuleShellMediator.as) L139 — lignes139 à142. Empreinte de l’extrait dans le contrat.

### A191

[BuddyPanelFriendsListView](reference_air_sources/review/mod__cht2__mod_cht2_dat/scripts/com/riotgames/pvpnet/docked/chat/view/buddypanel/BuddyPanelFriendsListView.as) L33 — lignes33 à36. Empreinte de l’extrait dans le contrat.

### A192

[ChatWindowView](reference_air_sources/review/mod__cht2__mod_cht2_dat/scripts/com/riotgames/pvpnet/docked/chat/view/ChatWindowView.as) L115 — lignes115 à121. Empreinte de l’extrait dans le contrat.

### A193

[NormalGameInviteAcceptAction](reference_air_sources/review/mod__ivi__mod_ivi_dat/scripts/com/riotgames/pvpnet/invite/legacy/action/NormalGameInviteAcceptAction.as) L11 — lignes11 à14. Empreinte de l’extrait dans le contrat.

### A194

[Reporter](reference_air_sources/review/mod__rep__mod_rep_dat/scripts/com/riotgames/platform/gameclient/module/reporting/Reporter.as) L20 — lignes20 à24. Empreinte de l’extrait dans le contrat.

### A195

[SeasonRewardsMainView](reference_air_sources/review/mod__srw__mod_srw_dat/scripts/com/riotgames/pvpnet/seasonrewards/views/SeasonRewardsMainView.as) L42 — lignes42 à47. Empreinte de l’extrait dans le contrat.

### A196

[SurveyPopup](reference_air_sources/review/mod__mf__mod_mf_dat/scripts/com/riotgames/pvpnet/microfeedback/popup/SurveyPopup.as) L80 — lignes80 à86. Empreinte de l’extrait dans le contrat.

### A197

[AccountTransferDialog](reference_air_sources/review/mod__man__mod_man_dat/scripts/com/riotgames/platform/gameclient/views/AccountTransfer/AccountTransferDialog.as) L91 — lignes91 à97. Empreinte de l’extrait dans le contrat.

### A198

[doInvocation](reference_air_sources/review/lib__ClientLibSystem_dat/scripts/com/riotgames/pvpnet/system/boot/actions/InitializeProviderLayerAction.as) L25 — lignes25 à37. Empreinte de l’extrait dans le contrat.

