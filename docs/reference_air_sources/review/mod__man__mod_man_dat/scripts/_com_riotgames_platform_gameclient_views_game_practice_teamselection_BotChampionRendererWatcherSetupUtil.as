package
{
   import com.riotgames.platform.gameclient.views.game.practice.teamselection.BotChampionRenderer;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_practice_teamselection_BotChampionRendererWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_practice_teamselection_BotChampionRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         BotChampionRenderer.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_practice_teamselection_BotChampionRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[1] = new PropertyWatcher("data",{"dataChange":true},[param3[2],param3[4]],param2);
         param4[2] = new PropertyWatcher("champion",null,[param3[2],param3[4]],null);
         param4[3] = new PropertyWatcher("skinName",null,[param3[2],param3[4]],null);
         param4[8] = new PropertyWatcher("displayName",null,[param3[4]],null);
         param4[4] = new PropertyWatcher("championIcon_img",{"propertyChange":true},[param3[3]],param2);
         param4[6] = new PropertyWatcher("width",{"widthChanged":true},[param3[3]],null);
         param4[5] = new PropertyWatcher("x",{"xChanged":true},[param3[3]],null);
         param4[1].updateParent(param1);
         param4[1].addChild(param4[2]);
         param4[2].addChild(param4[3]);
         param4[2].addChild(param4[8]);
         param4[4].updateParent(param1);
         param4[4].addChild(param4[6]);
         param4[4].addChild(param4[5]);
      }
   }
}

