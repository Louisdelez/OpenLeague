package
{
   import com.riotgames.platform.gameclient.controllers.game.views.ChampionSelectionView;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_controllers_game_views_ChampionSelectionViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_controllers_game_views_ChampionSelectionViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ChampionSelectionView.watcherSetupUtil = new _com_riotgames_platform_gameclient_controllers_game_views_ChampionSelectionViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[19] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[25]],propertyGetter);
         watchers[20] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","championSelection_quitTutorial_button"];
         },{"change":true},[bindings[25]],null);
         watchers[0] = new PropertyWatcher("championSelectionModel",{"propertyChange":true},[bindings[0],bindings[1],bindings[3],bindings[4],bindings[5],bindings[6],bindings[7],bindings[8],bindings[9],bindings[10],bindings[11],bindings[12],bindings[13],bindings[14],bindings[17],bindings[16],bindings[18],bindings[20],bindings[23],bindings[22],bindings[27],bindings[26],bindings[29],bindings[28],bindings[30]],propertyGetter);
         watchers[24] = new PropertyWatcher("enemyTeamSelections",{"enemyTeamSelectionsChanged":true},[bindings[29]],null);
         watchers[4] = new PropertyWatcher("showChampionGrid",{"showChampionGridChanged":true},[bindings[5]],null);
         watchers[22] = new PropertyWatcher("friendlyTeammatesVisible",{"friendlyTeammatesVisibleChanged":true},[bindings[27]],null);
         watchers[14] = new PropertyWatcher("lockInState",{"lockInStateChanged":true},[bindings[18]],null);
         watchers[23] = new PropertyWatcher("enemyTeamName",{"enemyTeamNameChanged":true},[bindings[28]],null);
         watchers[11] = new PropertyWatcher("masteriesSynced",{"masteriesSyncedChanged":true},[bindings[16],bindings[13],bindings[14]],null);
         watchers[6] = new PropertyWatcher("masteriesMenuState",{"masteriesMenuStateChanged":true},[bindings[8],bindings[9]],null);
         watchers[8] = new PropertyWatcher("runeBook",{"runeBookChanged":true},[bindings[10]],null);
         watchers[17] = new PropertyWatcher("chatRoom",{"chatRoomChanged":true},[bindings[23]],null);
         watchers[10] = new PropertyWatcher("masteryPages",{"masteryPagesChanged":true},[bindings[12]],null);
         watchers[3] = new PropertyWatcher("championSelectionIsBusy",{"championSelectionIsBusyChanged":true},[bindings[4],bindings[20],bindings[22]],null);
         watchers[5] = new PropertyWatcher("progressBarVisible",{"progressBarVisibleChanged":true},[bindings[7]],null);
         watchers[1] = new PropertyWatcher("mainMenuState",{"mainMenuStateChanged":true},[bindings[1]],null);
         watchers[13] = new PropertyWatcher("spellsMenuState",{"spellsMenuStateChanged":true},[bindings[17]],null);
         watchers[25] = new PropertyWatcher("enemyTeamVisible",{"enemyTeamVisibleChanged":true},[bindings[30]],null);
         watchers[21] = new PropertyWatcher("currentTeamName",{"currentTeamNameChanged":true},[bindings[26]],null);
         watchers[9] = new PropertyWatcher("runePageSynced",{"runePageSyncedChanged":true},[bindings[11]],null);
         watchers[15] = new PropertyWatcher("lockInButtonLabel",{"propertyChange":true},[bindings[19]],propertyGetter);
         watchers[19].updateParent(target);
         watchers[20].parentWatcher = watchers[19];
         watchers[19].addChild(watchers[20]);
         watchers[0].updateParent(target);
         watchers[0].addChild(watchers[24]);
         watchers[0].addChild(watchers[4]);
         watchers[0].addChild(watchers[22]);
         watchers[0].addChild(watchers[14]);
         watchers[0].addChild(watchers[23]);
         watchers[0].addChild(watchers[11]);
         watchers[0].addChild(watchers[6]);
         watchers[0].addChild(watchers[8]);
         watchers[0].addChild(watchers[17]);
         watchers[0].addChild(watchers[10]);
         watchers[0].addChild(watchers[3]);
         watchers[0].addChild(watchers[5]);
         watchers[0].addChild(watchers[1]);
         watchers[0].addChild(watchers[13]);
         watchers[0].addChild(watchers[25]);
         watchers[0].addChild(watchers[21]);
         watchers[0].addChild(watchers[9]);
         watchers[15].updateParent(target);
      }
   }
}

