package
{
   import flash.system.ApplicationDomain;
   import flash.system.Security;
   import flash.utils.Dictionary;
   import mx.core.FlexVersion;
   import mx.core.IFlexModule;
   import mx.core.IFlexModuleFactory;
   import mx.managers.SystemManager;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   public class _ClientWindow_mx_managers_SystemManager extends SystemManager implements IFlexModuleFactory
   {
      
      private var _preloadedRSLs:Dictionary;
      
      public function _ClientWindow_mx_managers_SystemManager()
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
         var _loc2_:String = rest.length == 0 ? "ClientWindow" : String(rest[0]);
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
            "compiledResourceBundleNames":["SharedResources","collections","containers","controls","core","effects","formatters","logging","messaging","skins","styles","validators"],
            "cornerRadius":"10",
            "currentDomain":ApplicationDomain.currentDomain,
            "displayStateChanging":"preventUserMaximize(event)",
            "horizontalScrollPolicy":"off",
            "mainClassName":"ClientWindow",
            "mixins":["_ClientWindow_FlexInit","_alertButtonStyleStyle","_SWFLoaderStyle","_FormHeadingStyle","_FormStyle","_headerDateTextStyle","_macMinButtonStyle","_winCloseButtonStyle","_WindowStyle","_todayStyleStyle","_windowStylesStyle","_FormItemLabelStyle","_TextInputStyle","_dateFieldPopupStyle","_ComboBoxStyle","_FormItemStyle","_winMinButtonStyle","_dataGridStylesStyle","_headerDragProxyStyleStyle","_popUpMenuStyle","_DragManagerStyle","_ContainerStyle","_windowStatusStyle","_swatchPanelTextFieldStyle","_textAreaHScrollBarStyleStyle","_macCloseButtonStyle","_CheckBoxStyle","_comboDropdownStyle","_winMaxButtonStyle","_ButtonStyle","_linkButtonStyleStyle","_richTextEditorTextAreaStyleStyle","_ControlBarStyle","_textAreaVScrollBarStyleStyle","_globalStyle","_HTMLStyle","_ListBaseStyle","_AlertStyle","_ApplicationStyle","_ToolTipStyle","_WindowedApplicationStyle","_winRestoreButtonStyle","_CursorManagerStyle","_opaquePanelStyle","_errorTipStyle","_HRuleStyle","_activeTabStyleStyle","_PanelStyle"
            ,"_ScrollBarStyle","_statusTextStyleStyle","_macMaxButtonStyle","_plainStyle","_activeButtonStyleStyle","_advancedDataGridStylesStyle","_titleTextStyleStyle","_gripperSkinStyle","_weekDayStyleStyle","com.riotgames.platform.gameclient.exception.SkinRentalStoreException","com.riotgames.platform.gameclient.exception.ServiceNotAvailableException","com.riotgames.platform.gameclient.exception.MatchmakingException","com.riotgames.platform.gameclient.exception.GameInitiationException","com.riotgames.platform.gameclient.exception.SkinRentalsNotAvailableException","com.riotgames.platform.gameclient.exception.GameException","com.riotgames.platform.common.exception.AdminException","com.riotgames.platform.gameclient.domain.featuredgame.MetadataServiceNotAvailableException","com.riotgames.platform.common.exception.AccountManagementException","com.riotgames.platform.gameclient.exception.NoRollsRemainException","com.riotgames.platform.gameclient.notification.LcdsServiceProxyResponse","com.riotgames.platform.gameclient.exception.SkinRentalAlreadyPurchasedException"
            ,"com.riotgames.platform.gameclient.exception.SkinRentalInsufficientFundsException","com.riotgames.platform.common.exception.AccountException","_BaseShellWatcherSetupUtil","_developer_DevPanelShellViewWatcherSetupUtil","_com_riotgames_platform_gameclient_shell_platformshutdown_PlatformShutdownFinalPaneWatcherSetupUtil","_com_riotgames_platform_gameclient_shell_platformshutdown_PlatformShutdownStatusPaneWatcherSetupUtil","_com_riotgames_platform_gameclient_LogViewWatcherSetupUtil","_com_riotgames_platform_gameclient_LogView_inlineComponent1WatcherSetupUtil"],
            "showFlexChrome":"false",
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

