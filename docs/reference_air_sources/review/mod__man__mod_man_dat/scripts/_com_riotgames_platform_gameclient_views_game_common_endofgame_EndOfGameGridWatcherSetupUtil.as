package
{
   import com.riotgames.platform.gameclient.views.game.common.endofgame.EndOfGameGrid;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameGridWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameGridWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         EndOfGameGrid.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameGridWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[4] = new PropertyWatcher("headerMask",{"propertyChange":true},[param3[5]],param2);
         param4[0] = new PropertyWatcher("dataColumnsCanvas",{"propertyChange":true},[param3[0]],param2);
         param4[1] = new PropertyWatcher("verticalScrollPosition",{
            "scroll":true,
            "viewChanged":true
         },[param3[0]],null);
         param4[4].updateParent(param1);
         param4[0].updateParent(param1);
         param4[0].addChild(param4[1]);
      }
   }
}

