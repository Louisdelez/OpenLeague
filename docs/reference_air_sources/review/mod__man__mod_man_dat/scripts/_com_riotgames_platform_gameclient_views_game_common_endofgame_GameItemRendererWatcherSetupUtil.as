package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.views.game.common.endofgame.GameItemRenderer;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_common_endofgame_GameItemRendererWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_common_endofgame_GameItemRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         GameItemRenderer.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_common_endofgame_GameItemRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[0] = new PropertyWatcher("imageSource",{"propertyChange":true},[param3[0]],param2);
         param4[2] = new PropertyWatcher("itemImg",{"propertyChange":true},[param3[2],param3[5]],param2);
         param4[3] = new PropertyWatcher("width",{"widthChanged":true},[param3[2],param3[5]],null);
         param4[1] = new PropertyWatcher("width",{"widthChanged":true},[param3[1],param3[4]],param2);
         param4[4] = new StaticPropertyWatcher("instance",null,[param3[3]],null);
         param4[0].updateParent(param1);
         param4[2].updateParent(param1);
         param4[2].addChild(param4[3]);
         param4[1].updateParent(param1);
         param4[4].updateParent(ImagePackLookup);
      }
   }
}

