package
{
   import com.riotgames.platform.gameclient.views.game.common.endofgame.XPBarSegment;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_common_endofgame_XPBarSegmentWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_common_endofgame_XPBarSegmentWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         XPBarSegment.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_common_endofgame_XPBarSegmentWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[1] = new PropertyWatcher("height",{"heightChanged":true},[param3[1]],param2);
         param4[0] = new PropertyWatcher("width",{"widthChanged":true},[param3[0]],param2);
         param4[1].updateParent(param1);
         param4[0].updateParent(param1);
      }
   }
}

