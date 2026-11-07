package
{
   import com.riotgames.platform.gameclient.views.lobby.LobbyView;
   import com.riotgames.pvpnet.game.controllers.lobby.LobbyConfig;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_lobby_LobbyViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_lobby_LobbyViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         LobbyView.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_lobby_LobbyViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[0] = new StaticPropertyWatcher("instance",null,[param3[0]],null);
         param4[1] = new PropertyWatcher("currentLobbyState",{"propertyChange":true},[param3[0]],null);
         param4[0].updateParent(LobbyConfig);
         param4[0].addChild(param4[1]);
      }
   }
}

