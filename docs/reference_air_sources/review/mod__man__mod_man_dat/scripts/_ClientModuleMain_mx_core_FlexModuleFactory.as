package
{
   import flash.system.ApplicationDomain;
   import flash.system.Security;
   import flash.utils.Dictionary;
   import mx.core.FlexModuleFactory;
   import mx.core.FlexVersion;
   import mx.core.IFlexModule;
   import mx.core.IFlexModuleFactory;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   public class _ClientModuleMain_mx_core_FlexModuleFactory extends FlexModuleFactory implements IFlexModuleFactory
   {
      
      private var _preloadedRSLs:Dictionary;
      
      public function _ClientModuleMain_mx_core_FlexModuleFactory()
      {
         FlexVersion.compatibilityVersionString = "3.0.0";
         super();
      }
      
      override public function create(... rest) : Object
      {
         if(rest.length > 0 && !(rest[0] is String))
         {
            return super.create.apply(this,rest);
         }
         var _loc2_:String = rest.length == 0 ? "ClientModuleMain" : String(rest[0]);
         var _loc3_:Class = Class(getDefinitionByName(_loc2_));
         if(!_loc3_)
         {
            return null;
         }
         var _loc4_:Object = new _loc3_();
         if(_loc4_ is IFlexModule)
         {
            IFlexModule(_loc4_).moduleFactory = this;
         }
         return _loc4_;
      }
      
      override public function allowInsecureDomain(... rest) : void
      {
         var _loc2_:Object = null;
         Security.allowInsecureDomain(rest);
         for(_loc2_ in this._preloadedRSLs)
         {
            if(Boolean(_loc2_.content) && "allowInsecureDomainInRSL" in _loc2_.content)
            {
               _loc2_.content["allowInsecureDomainInRSL"](rest);
            }
         }
      }
      
      override public function info() : Object
      {
         return {
            "borderStyle":"none",
            "compiledLocales":[],
            "compiledResourceBundleNames":["SharedResources","charts","collections","containers","controls","core","effects","formatters","logging","messaging","skins","states","styles","utils","validators"],
            "currentDomain":ApplicationDomain.currentDomain,
            "horizontalScrollPolicy":"off",
            "initialize":"onInitialize()",
            "layout":"absolute",
            "mainClassName":"ClientModuleMain",
            "mixins":["_ClientModuleMain_FlexInit","_alertButtonStyleStyle","_SWFLoaderStyle","_FormStyle","_headerDateTextStyle","_macMinButtonStyle","_winCloseButtonStyle","_WindowStyle","_todayStyleStyle","_HorizontalListStyle","_windowStylesStyle","_FormItemLabelStyle","_TextInputStyle","_ApplicationControlBarStyle","_dateFieldPopupStyle","_ComboBoxStyle","_FormItemStyle","_winMinButtonStyle","_dataGridStylesStyle","_TabStyle","_headerDragProxyStyleStyle","_popUpMenuStyle","_TabNavigatorStyle","_HSliderStyle","_DragManagerStyle","_ContainerStyle","_TextAreaStyle","_windowStatusStyle","_swatchPanelTextFieldStyle","_RadioButtonStyle","_ButtonBarStyle","_textAreaHScrollBarStyleStyle","_MenuBarStyle","_macCloseButtonStyle","_CheckBoxStyle","_comboDropdownStyle","_winMaxButtonStyle","_ButtonStyle","_linkButtonStyleStyle","_richTextEditorTextAreaStyleStyle","_ControlBarStyle","_textAreaVScrollBarStyleStyle","_globalStyle","_HTMLStyle","_ListBaseStyle","_TabBarStyle","_TileListStyle","_ApplicationStyle"
            ,"_ToolTipStyle","_winRestoreButtonStyle","_ButtonBarButtonStyle","_CursorManagerStyle","_opaquePanelStyle","_errorTipStyle","_MenuStyle","_DataGridStyle","_HRuleStyle","_activeTabStyleStyle","_PanelStyle","_ScrollBarStyle","_statusTextStyleStyle","_macMaxButtonStyle","_plainStyle","_activeButtonStyleStyle","_advancedDataGridStylesStyle","_titleTextStyleStyle","_DataGridItemRendererStyle","_gripperSkinStyle","_VRuleStyle","_weekDayStyleStyle","_com_riotgames_platform_gameclient_controllers_game_ArrowedAlertViewWatcherSetupUtil","_com_riotgames_platform_common_components_MessagePopupTemplateWatcherSetupUtil","_com_riotgames_platform_gameclient_components_WingedHeaderWatcherSetupUtil","_com_riotgames_platform_gameclient_components_summoner_SummonerIconWatcherSetupUtil","_com_riotgames_platform_gameclient_chat_renderer_BuddyTooltipWatcherSetupUtil","_com_riotgames_platform_gameclient_views_summoner_stats_KDAViewWatcherSetupUtil","_com_riotgames_platform_gameclient_views_summoner_stats_LifetimeStatsGridWatcherSetupUtil"
            ,"_com_riotgames_platform_gameclient_views_game_practice_teamselection_BotChampionRendererWatcherSetupUtil","_com_riotgames_platform_gameclient_views_help_NewbieTipsViewWatcherSetupUtil","_com_riotgames_platform_gameclient_views_summoner_stats_ChampionStatsGraphsWatcherSetupUtil","_com_riotgames_platform_gameclient_views_summoner_stats_ProfileStatsLifetimeViewWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_common_endofgame_GameItemRendererWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_common_endofgame_SpellItemRendererWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGamePlayerTooltipWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_common_endofgame_GameItemTooltipWatcherSetupUtil","_com_riotgames_platform_gameclient_tooltips_SpellToolTipWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_practice_teamselection_TeamMemberRenderer2WatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_practice_teamselection_SpectatorMemberRendererWatcherSetupUtil"
            ,"_com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameTeamMemberRendererWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_common_endofgame_IPBarSegmentWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameGridSectionRendererWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_common_endofgame_XPBarSegmentWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameGraphWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameStatsTeamWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameGridWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameScoreboardWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_practice_create_ChooseMapRendererWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_practice_teamselection_SpectatorPanelWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfTutorialGameViewWatcherSetupUtil"
            ,"_com_riotgames_platform_common_JoinGamePopupWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_practice_teamselection_TeamPanel2WatcherSetupUtil","_com_riotgames_platform_gameclient_views_application_SubmitLogsDialogWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_practice_join_JoinGamePanelWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_practice_join_CustomGameDataGridWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameViewWatcherSetupUtil","_com_riotgames_platform_gameclient_views_summoner_BoostToolTipWatcherSetupUtil","_com_riotgames_platform_gameclient_components_summoner_SummonerQuickViewWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameStatsViewWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameChatWindowWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_common_invite_InviteePanelWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_practice_create_CreatePracticeGameViewWatcherSetupUtil"
            ,"_com_riotgames_platform_gameclient_views_game_normal_normalTeamSelection_NormalTeamPanelWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_normal_normalTeamSelection_NormalTeamMemberRendererWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_practice_teamselection_TeamSelectionView2WatcherSetupUtil","_com_riotgames_platform_gameclient_views_summoner_stats_ProfileStatsRankingViewWatcherSetupUtil","_com_riotgames_platform_gameclient_views_summoner_stats_RankedDisplayBucketWatcherSetupUtil","_com_riotgames_platform_gameclient_views_summoner_SummonerInfoQuickViewWatcherSetupUtil","_com_riotgames_platform_gameclient_chat_views_chatpanel_ChampionSelectChatWindowWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_practice_teamselection_TeamSelectionPanel2WatcherSetupUtil","_com_riotgames_platform_gameclient_views_store_StoreHtmlViewWatcherSetupUtil","_com_riotgames_platform_gameclient_views_lobby_ChooseGameOptionsTopLevelRendererWatcherSetupUtil","_com_riotgames_platform_gameclient_views_lobby_ChooseGameOptionsRepeatedRendererWatcherSetupUtil"
            ,"_com_riotgames_platform_gameclient_views_summoner_stats_ProfileStatsViewWatcherSetupUtil","_com_riotgames_platform_gameclient_views_profile_ProfileViewWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_normal_CreateNormalArrangedGameWatcherSetupUtil","_com_riotgames_platform_gameclient_views_store_StoreViewWatcherSetupUtil","_com_riotgames_platform_gameclient_views_summoner_SummonerProfileViewWatcherSetupUtil","_com_riotgames_platform_gameclient_views_summoner_SummonerSummaryViewWatcherSetupUtil","_com_riotgames_platform_gameclient_account_PreferencesViewWatcherSetupUtil","_com_riotgames_platform_gameclient_views_lobby_landing_LobbyLandingWatcherSetupUtil","_com_riotgames_platform_gameclient_views_lobby_landing_StoryViewWatcherSetupUtil","_com_riotgames_platform_gameclient_views_help_HelpDialogWatcherSetupUtil","_com_riotgames_platform_gameclient_views_summoner_wizard_SummonerNameViewWatcherSetupUtil","_com_riotgames_platform_gameclient_views_summoner_wizard_PlayTutorialGameWatcherSetupUtil"
            ,"_com_riotgames_platform_gameclient_views_lobby_ChooseGameViewInfoPanelWatcherSetupUtil","_com_riotgames_platform_common_components_controls_InternalBrowserWatcherSetupUtil","_com_riotgames_platform_gameclient_views_summoner_wizard_EloQuestionaireWatcherSetupUtil","_com_riotgames_platform_gameclient_views_lobby_ChooseGameOptionsViewWatcherSetupUtil","_com_riotgames_platform_gameclient_views_summoner_wizard_ChooseSummonerIconWatcherSetupUtil","_com_riotgames_platform_gameclient_views_partner_AntiIndulgenceWarningViewWatcherSetupUtil","_com_riotgames_platform_gameclient_views_lobby_LobbyViewWatcherSetupUtil","_com_riotgames_platform_gameclient_views_application_ApplicationContentViewWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_common_ingame_InGameViewWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_NewGameViewsWatcherSetupUtil","_ClientModuleMainWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_normal_EnterChampionSelectDialogWatcherSetupUtil"
            ,"_com_riotgames_platform_common_ratings_RatingsPopupWatcherSetupUtil","_com_riotgames_platform_gameclient_tooltips_SummonerToolTipWatcherSetupUtil","_com_riotgames_platform_gameclient_views_Support_ReportPlayerViewWatcherSetupUtil","_com_riotgames_platform_common_components_MessageDialogTemplateWatcherSetupUtil","_com_riotgames_platform_gameclient_views_AccountTransfer_AccountTransferDialogWatcherSetupUtil","_LolClientBeansWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_normal_QueueDodgeDialogWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_normal_LeaverBusterDialogueWatcherSetupUtil","_com_riotgames_platform_gameclient_views_game_normal_RankedQueueFailuresDialogWatcherSetupUtil","_com_riotgames_platform_gameclient_views_summoner_QuickViewChampionsRendererWatcherSetupUtil","_com_riotgames_platform_gameclient_views_summoner_stats_ChampionStatsTooltipWatcherSetupUtil"],
            "verticalScrollPolicy":"off"
         };
      }
      
      override public function get preloadedRSLs() : Dictionary
      {
         if(this._preloadedRSLs == null)
         {
            this._preloadedRSLs = new Dictionary(true);
         }
         return this._preloadedRSLs;
      }
      
      override public function allowDomain(... rest) : void
      {
         var _loc2_:Object = null;
         Security.allowDomain(rest);
         for(_loc2_ in this._preloadedRSLs)
         {
            if(Boolean(_loc2_.content) && "allowDomainInRSL" in _loc2_.content)
            {
               _loc2_.content["allowDomainInRSL"](rest);
            }
         }
      }
   }
}

