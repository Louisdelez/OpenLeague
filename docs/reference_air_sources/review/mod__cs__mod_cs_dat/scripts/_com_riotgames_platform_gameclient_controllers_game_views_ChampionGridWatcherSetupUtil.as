package
{
   import com.riotgames.platform.gameclient.controllers.game.views.ChampionGrid;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_controllers_game_views_ChampionGridWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_controllers_game_views_ChampionGridWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ChampionGrid.watcherSetupUtil = new _com_riotgames_platform_gameclient_controllers_game_views_ChampionGridWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[7] = new StaticPropertyWatcher("userPrefs",null,[param3[4]],null);
         param4[8] = new PropertyWatcher("enableAnimations",{"propertyChange":true},[param3[4]],null);
         param4[2] = new PropertyWatcher("championSelectionModel",{"propertyChange":true},[param3[1],param3[2],param3[3]],param2);
         param4[5] = new PropertyWatcher("showChampionGrid",{"showChampionGridChanged":true},[param3[3]],null);
         param4[4] = new PropertyWatcher("championSelections",{"championSelectionsChanged":true},[param3[2]],null);
         param4[3] = new PropertyWatcher("championSelectionState",{"championSelectionStateChanged":true},[param3[1]],null);
         param4[0] = new PropertyWatcher("interactiveRenderers",{"propertyChange":true},[param3[0]],param2);
         param4[7].updateParent(UserPreferencesManager);
         param4[7].addChild(param4[8]);
         param4[2].updateParent(param1);
         param4[2].addChild(param4[5]);
         param4[2].addChild(param4[4]);
         param4[2].addChild(param4[3]);
         param4[0].updateParent(param1);
      }
   }
}

