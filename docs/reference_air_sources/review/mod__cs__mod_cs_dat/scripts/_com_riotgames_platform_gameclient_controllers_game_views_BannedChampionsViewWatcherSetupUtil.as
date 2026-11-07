package
{
   import com.riotgames.platform.gameclient.controllers.game.views.BannedChampionsView;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_controllers_game_views_BannedChampionsViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_controllers_game_views_BannedChampionsViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         BannedChampionsView.watcherSetupUtil = new _com_riotgames_platform_gameclient_controllers_game_views_BannedChampionsViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[1] = new PropertyWatcher("bannedChamps",{"propertyChange":true},[param3[1]],param2);
         param4[1].updateParent(param1);
      }
   }
}

