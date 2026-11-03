package
{
   import com.riotgames.platform.gameclient.views.game.practice.teamselection.TeamSelectionView2;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_practice_teamselection_TeamSelectionView2WatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_practice_teamselection_TeamSelectionView2WatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         TeamSelectionView2.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_practice_teamselection_TeamSelectionView2WatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[8] = new PropertyWatcher("inviteGroup",{"propertyChange":true},[bindings[4]],propertyGetter);
         watchers[10] = new PropertyWatcher("allowedToInvite",{"allowedToInviteChanged":true},[bindings[4]],null);
         watchers[9] = new PropertyWatcher("isOwner",{"isOwnerChanged":true},[bindings[4]],null);
         watchers[16] = new PropertyWatcher("teamSelectionController",{"propertyChange":true},[bindings[7],bindings[10],bindings[11],bindings[12]],propertyGetter);
         watchers[17] = new PropertyWatcher("isBusy",{"propertyChange":true},[bindings[7],bindings[12]],null);
         watchers[20] = new PropertyWatcher("isOwner",{"propertyChange":true},[bindings[10],bindings[11]],null);
         watchers[7] = new PropertyWatcher("htmlMapDescription",{"propertyChange":true},[bindings[3]],propertyGetter);
         watchers[2] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[1],bindings[5],bindings[6],bindings[8],bindings[9]],propertyGetter);
         watchers[19] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_new_startGameButton_tooltip"];
         },{"change":true},[bindings[9]],null);
         watchers[18] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_new_startGameButtonLabel"];
         },{"change":true},[bindings[8]],null);
         watchers[3] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","normalGame_arrangedTeam_mapOptionsHeaderLabel"];
         },{"change":true},[bindings[1]],null);
         watchers[14] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_new_quitGameButtonLabel"];
         },{"change":true},[bindings[5]],null);
         watchers[15] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_new_quitGameButton_tooltip"];
         },{"change":true},[bindings[6]],null);
         watchers[0] = new PropertyWatcher("mapDetails",{"propertyChange":true},[bindings[0]],propertyGetter);
         watchers[1] = new PropertyWatcher("x",{"xChanged":true},[bindings[0]],null);
         watchers[4] = new PropertyWatcher("map_holder",{"propertyChange":true},[bindings[2]],propertyGetter);
         watchers[6] = new PropertyWatcher("height",{"heightChanged":true},[bindings[2]],null);
         watchers[5] = new PropertyWatcher("y",{"yChanged":true},[bindings[2]],null);
         watchers[11] = new PropertyWatcher("masterGameViewController",{"propertyChange":true},[bindings[4]],propertyGetter);
         watchers[12] = new PropertyWatcher("masterGameController",{"propertyChange":true},[bindings[4]],null);
         watchers[13] = new PropertyWatcher("isSpectating",{"propertyChange":true},[bindings[4]],null);
         watchers[8].updateParent(target);
         watchers[8].addChild(watchers[10]);
         watchers[8].addChild(watchers[9]);
         watchers[16].updateParent(target);
         watchers[16].addChild(watchers[17]);
         watchers[16].addChild(watchers[20]);
         watchers[7].updateParent(target);
         watchers[2].updateParent(target);
         watchers[19].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[19]);
         watchers[18].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[18]);
         watchers[3].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[3]);
         watchers[14].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[14]);
         watchers[15].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[15]);
         watchers[0].updateParent(target);
         watchers[0].addChild(watchers[1]);
         watchers[4].updateParent(target);
         watchers[4].addChild(watchers[6]);
         watchers[4].addChild(watchers[5]);
         watchers[11].updateParent(target);
         watchers[11].addChild(watchers[12]);
         watchers[12].addChild(watchers[13]);
      }
   }
}

