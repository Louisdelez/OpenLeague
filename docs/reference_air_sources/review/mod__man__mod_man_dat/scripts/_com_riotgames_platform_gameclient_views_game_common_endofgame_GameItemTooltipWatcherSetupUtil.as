package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.views.game.common.endofgame.GameItemTooltip;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_common_endofgame_GameItemTooltipWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_common_endofgame_GameItemTooltipWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         GameItemTooltip.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_common_endofgame_GameItemTooltipWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[11] = new PropertyWatcher("itemName",{"propertyChange":true},[param3[8]],param2);
         param4[13] = new PropertyWatcher("height",{"heightChanged":true},[param3[8]],null);
         param4[12] = new PropertyWatcher("y",{"yChanged":true},[param3[8]],null);
         param4[7] = new PropertyWatcher("imageSource",{"propertyChange":true},[param3[3]],param2);
         param4[0] = new PropertyWatcher("data",{"dataChange":true},[param3[0],param3[7],param3[10]],param2);
         param4[16] = new PropertyWatcher("displayDescription",null,[param3[10]],null);
         param4[1] = new PropertyWatcher("iconName",null,[param3[0]],null);
         param4[10] = new PropertyWatcher("displayName",null,[param3[7]],null);
         param4[14] = new PropertyWatcher("colText",{"propertyChange":true},[param3[9]],param2);
         param4[15] = new PropertyWatcher("width",{"widthChanged":true},[param3[9]],null);
         param4[8] = new StaticPropertyWatcher("instance",null,[param3[4]],null);
         param4[3] = new PropertyWatcher("colIcon",{"propertyChange":true},[param3[1]],param2);
         param4[4] = new PropertyWatcher("width",{"widthChanged":true},[param3[1]],null);
         param4[5] = new PropertyWatcher("itemIcon",{"propertyChange":true},[param3[2],param3[5],param3[6]],param2);
         param4[6] = new PropertyWatcher("width",{"widthChanged":true},[param3[2],param3[5],param3[6]],null);
         param4[11].updateParent(param1);
         param4[11].addChild(param4[13]);
         param4[11].addChild(param4[12]);
         param4[7].updateParent(param1);
         param4[0].updateParent(param1);
         param4[0].addChild(param4[16]);
         param4[0].addChild(param4[1]);
         param4[0].addChild(param4[10]);
         param4[14].updateParent(param1);
         param4[14].addChild(param4[15]);
         param4[8].updateParent(ImagePackLookup);
         param4[3].updateParent(param1);
         param4[3].addChild(param4[4]);
         param4[5].updateParent(param1);
         param4[5].addChild(param4[6]);
      }
   }
}

