package
{
   import com.riotgames.platform.gameclient.controllers.game.views.ChampionSkinSelector;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   [Mixin]
   [ExcludeClass]
   public class _com_riotgames_platform_gameclient_controllers_game_views_ChampionSkinSelectorWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_controllers_game_views_ChampionSkinSelectorWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ChampionSkinSelector.watcherSetupUtil = new _com_riotgames_platform_gameclient_controllers_game_views_ChampionSkinSelectorWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[10] = new PropertyWatcher("championSkins",{"propertyChange":true},[param3[8]],param2);
         param4[11] = new PropertyWatcher("length",{"collectionChange":true},[param3[8]],null);
         param4[12] = new PropertyWatcher("skinsCoverFlow",{"propertyChange":true},[param3[9]],param2);
         param4[13] = new PropertyWatcher("selectedIndex",{
            "valueCommit":true,
            "creationComplete":true,
            "change":true
         },[param3[9]],null);
         param4[0] = new PropertyWatcher("scrollbar",{"propertyChange":true},[param3[0]],param2);
         param4[1] = new PropertyWatcher("height",{"heightChanged":true},[param3[0]],null);
         param4[2] = new PropertyWatcher("championSkinUnlock_txt",{"propertyChange":true},[param3[1]],param2);
         param4[4] = new PropertyWatcher("height",{"heightChanged":true},[param3[1]],null);
         param4[3] = new PropertyWatcher("y",{"yChanged":true},[param3[1]],null);
         param4[5] = new PropertyWatcher("championSkinName_txt",{"propertyChange":true},[param3[2],param3[4],param3[6]],param2);
         param4[6] = new PropertyWatcher("height",{"heightChanged":true},[param3[2],param3[4],param3[6]],null);
         param4[10].updateParent(param1);
         param4[10].addChild(param4[11]);
         param4[12].updateParent(param1);
         param4[12].addChild(param4[13]);
         param4[0].updateParent(param1);
         param4[0].addChild(param4[1]);
         param4[2].updateParent(param1);
         param4[2].addChild(param4[4]);
         param4[2].addChild(param4[3]);
         param4[5].updateParent(param1);
         param4[5].addChild(param4[6]);
      }
   }
}

