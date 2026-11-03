package
{
   import com.riotgames.platform.gameclient.controllers.game.views.SpectatorWaitBar;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_controllers_game_views_SpectatorWaitBarWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_controllers_game_views_SpectatorWaitBarWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         SpectatorWaitBar.watcherSetupUtil = new _com_riotgames_platform_gameclient_controllers_game_views_SpectatorWaitBarWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
      }
   }
}

