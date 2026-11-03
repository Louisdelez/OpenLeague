package
{
   import com.riotgames.platform.gameclient.views.game.common.endofgame.EndOfGameGridSectionRenderer;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.RepeaterItemWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameGridSectionRendererWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameGridSectionRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         EndOfGameGridSectionRenderer.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameGridSectionRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[13] = new PropertyWatcher("formatter",{"propertyChange":true},[param3[11]],param2);
         param4[0] = new PropertyWatcher("LINE_HEIGHT",{"propertyChange":true},[param3[0],param3[8],param3[10]],param2);
         param4[9] = new PropertyWatcher("statsRepeater",{"propertyChange":true},[param3[8],param3[11]],param2);
         param4[10] = new PropertyWatcher("dataProvider",{"collectionChange":true},[param3[8],param3[11]],null);
         param4[11] = new RepeaterItemWatcher(param4[10]);
         param4[15] = new PropertyWatcher("value",null,[param3[11]],null);
         param4[12] = new PropertyWatcher("displayName",null,[param3[11]],null);
         param4[4] = new PropertyWatcher("height",{"heightChanged":true},[param3[4]],param2);
         param4[6] = new PropertyWatcher("localizedHeaderText",{"propertyChange":true},[param3[5]],param2);
         param4[5] = new PropertyWatcher("headerColumn",{"propertyChange":true},[param3[5],param3[7],param3[9],param3[11]],param2);
         param4[3] = new PropertyWatcher("width",{"widthChanged":true},[param3[3]],param2);
         param4[1] = new PropertyWatcher("data",{"dataChange":true},[param3[1],param3[6]],param2);
         param4[7] = new PropertyWatcher("header",{"propertyChange":true},[param3[8]],param2);
         param4[8] = new PropertyWatcher("height",{"heightChanged":true},[param3[8]],null);
         param4[13].updateParent(param1);
         param4[0].updateParent(param1);
         param4[9].updateParent(param1);
         param4[9].addChild(param4[10]);
         param4[10].addChild(param4[11]);
         param4[11].addChild(param4[15]);
         param4[11].addChild(param4[12]);
         param4[4].updateParent(param1);
         param4[6].updateParent(param1);
         param4[5].updateParent(param1);
         param4[3].updateParent(param1);
         param4[1].updateParent(param1);
         param4[7].updateParent(param1);
         param4[7].addChild(param4[8]);
      }
   }
}

