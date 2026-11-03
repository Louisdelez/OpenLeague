package
{
   import com.riotgames.platform.gameclient.controllers.game.views.MatchDetailsView;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_controllers_game_views_MatchDetailsViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_controllers_game_views_MatchDetailsViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         MatchDetailsView.watcherSetupUtil = new _com_riotgames_platform_gameclient_controllers_game_views_MatchDetailsViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
      }
   }
}

