package
{
   import com.riotgames.platform.gameclient.controllers.game.views.FeaturedRowView;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_controllers_game_views_FeaturedRowViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_controllers_game_views_FeaturedRowViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         FeaturedRowView.watcherSetupUtil = new _com_riotgames_platform_gameclient_controllers_game_views_FeaturedRowViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[0] = new PropertyWatcher("headerLabel",{"propertyChange":true},[param3[0]],param2);
         param4[0].updateParent(param1);
      }
   }
}

