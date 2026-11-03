package
{
   import com.riotgames.platform.gameclient.views.game.common.endofgame.EndOfGameScoreboard;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameScoreboardWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameScoreboardWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         EndOfGameScoreboard.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameScoreboardWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[4] = new PropertyWatcher("isDominionStatType",{"propertyChange":true},[param3[17],param3[20],param3[5],param3[23],param3[8],param3[11]],param2);
         param4[5] = new PropertyWatcher("toolTipKDA",{"propertyChange":true},[param3[6]],param2);
         param4[11] = new PropertyWatcher("showPointCapIcon",{"propertyChange":true},[param3[14]],param2);
         param4[4].updateParent(param1);
         param4[5].updateParent(param1);
         param4[11].updateParent(param1);
      }
   }
}

