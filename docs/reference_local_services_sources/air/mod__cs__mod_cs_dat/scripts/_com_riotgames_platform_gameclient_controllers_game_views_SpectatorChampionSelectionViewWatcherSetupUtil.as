package
{
   import com.riotgames.platform.gameclient.controllers.game.views.SpectatorChampionSelectionView;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_controllers_game_views_SpectatorChampionSelectionViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_controllers_game_views_SpectatorChampionSelectionViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         SpectatorChampionSelectionView.watcherSetupUtil = new _com_riotgames_platform_gameclient_controllers_game_views_SpectatorChampionSelectionViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[0] = new PropertyWatcher("championSelectionModel",{"propertyChange":true},[param3[0],param3[1],param3[4],param3[5],param3[6],param3[7],param3[8],param3[9],param3[10],param3[11],param3[12],param3[13]],param2);
         param4[8] = new PropertyWatcher("enemyTeamSelections",{"enemyTeamSelectionsChanged":true},[param3[11]],null);
         param4[5] = new PropertyWatcher("friendlyTeammatesVisible",{"friendlyTeammatesVisibleChanged":true},[param3[8]],null);
         param4[6] = new PropertyWatcher("currentTeamSelections",{"currentTeamSelectionsChanged":true},[param3[9]],null);
         param4[3] = new PropertyWatcher("progressBarVisible",{"progressBarVisibleChanged":true},[param3[6]],null);
         param4[9] = new PropertyWatcher("enemyTeamVisible",{"enemyTeamVisibleChanged":true},[param3[12],param3[13]],null);
         param4[7] = new PropertyWatcher("enemyTeamName",{"enemyTeamNameChanged":true},[param3[10]],null);
         param4[4] = new PropertyWatcher("currentTeamName",{"currentTeamNameChanged":true},[param3[7]],null);
         param4[11] = new PropertyWatcher("quitButton",{"propertyChange":true},[param3[15]],param2);
         param4[12] = new PropertyWatcher("width",{"widthChanged":true},[param3[15]],null);
         param4[0].updateParent(param1);
         param4[0].addChild(param4[8]);
         param4[0].addChild(param4[5]);
         param4[0].addChild(param4[6]);
         param4[0].addChild(param4[3]);
         param4[0].addChild(param4[9]);
         param4[0].addChild(param4[7]);
         param4[0].addChild(param4[4]);
         param4[11].updateParent(param1);
         param4[11].addChild(param4[12]);
      }
   }
}

