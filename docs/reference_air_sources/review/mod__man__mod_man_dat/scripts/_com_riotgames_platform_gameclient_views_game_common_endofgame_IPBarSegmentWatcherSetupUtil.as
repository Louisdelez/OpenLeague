package
{
   import com.riotgames.platform.gameclient.views.game.common.endofgame.IPBarSegment;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_common_endofgame_IPBarSegmentWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_common_endofgame_IPBarSegmentWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         IPBarSegment.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_common_endofgame_IPBarSegmentWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[2] = new PropertyWatcher("ipLabel",{"propertyChange":true},[param3[3]],param2);
         param4[3] = new PropertyWatcher("width",{"widthChanged":true},[param3[3]],null);
         param4[1] = new PropertyWatcher("height",{"heightChanged":true},[param3[1]],param2);
         param4[0] = new PropertyWatcher("width",{"widthChanged":true},[param3[0]],param2);
         param4[4] = new PropertyWatcher("_ipGain",{"propertyChange":true},[param3[4]],param2);
         param4[2].updateParent(param1);
         param4[2].addChild(param4[3]);
         param4[1].updateParent(param1);
         param4[0].updateParent(param1);
         param4[4].updateParent(param1);
      }
   }
}

