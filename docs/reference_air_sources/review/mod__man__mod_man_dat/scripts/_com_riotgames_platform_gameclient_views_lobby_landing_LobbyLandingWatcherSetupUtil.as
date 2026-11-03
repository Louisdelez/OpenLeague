package
{
   import com.riotgames.platform.gameclient.views.lobby.landing.LobbyLanding;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_lobby_landing_LobbyLandingWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_lobby_landing_LobbyLandingWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         LobbyLanding.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_lobby_landing_LobbyLandingWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[0] = new PropertyWatcher("htmlLandingPanel",{"propertyChange":true},[param3[0],param3[1],param3[3]],param2);
         param4[1] = new PropertyWatcher("scaleX",{"scaleXChanged":true},[param3[0],param3[3]],null);
         param4[2] = new PropertyWatcher("scaleY",{"scaleYChanged":true},[param3[1]],null);
         param4[3] = new PropertyWatcher("lobbyLandingURL",{"lobbyLandingUrlChange":true},[param3[2]],param2);
         param4[4] = new PropertyWatcher("parentApplication",{"initialize":true},[param3[4],param3[5]],param2);
         param4[5] = new PropertyWatcher("scaleX",null,[param3[4]],null);
         param4[6] = new PropertyWatcher("scaleY",null,[param3[5]],null);
         param4[7] = new PropertyWatcher("landingIsLoading",{"propertyChange":true},[param3[6],param3[7]],param2);
         param4[0].updateParent(param1);
         param4[0].addChild(param4[1]);
         param4[0].addChild(param4[2]);
         param4[3].updateParent(param1);
         param4[4].updateParent(param1);
         param4[4].addChild(param4[5]);
         param4[4].addChild(param4[6]);
         param4[7].updateParent(param1);
      }
   }
}

