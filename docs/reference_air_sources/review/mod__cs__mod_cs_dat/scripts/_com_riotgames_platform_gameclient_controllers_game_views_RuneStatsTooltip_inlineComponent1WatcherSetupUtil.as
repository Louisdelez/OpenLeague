package
{
   import com.riotgames.platform.gameclient.controllers.game.views.RuneStatsTooltip_inlineComponent1;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_controllers_game_views_RuneStatsTooltip_inlineComponent1WatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_controllers_game_views_RuneStatsTooltip_inlineComponent1WatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         RuneStatsTooltip_inlineComponent1.watcherSetupUtil = new _com_riotgames_platform_gameclient_controllers_game_views_RuneStatsTooltip_inlineComponent1WatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[0] = new PropertyWatcher("data",{"dataChange":true},[param3[0],param3[1]],param2);
         param4[1] = new PropertyWatcher("displayName",null,[param3[0]],null);
         param4[0].updateParent(param1);
         param4[0].addChild(param4[1]);
      }
   }
}

