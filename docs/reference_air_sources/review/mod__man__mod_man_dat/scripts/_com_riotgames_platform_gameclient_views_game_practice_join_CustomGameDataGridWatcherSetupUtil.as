package
{
   import com.riotgames.platform.gameclient.views.game.practice.join.CustomGameDataGrid;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_practice_join_CustomGameDataGridWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_practice_join_CustomGameDataGridWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         CustomGameDataGrid.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_practice_join_CustomGameDataGridWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[1] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[1],bindings[4],bindings[7],bindings[13]],propertyGetter);
         watchers[2] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_createOrJoinGame_gameNameColumnHeader"];
         },{"change":true},[bindings[1]],null);
         watchers[5] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_createOrJoinGame_gameOwnerColumnHeader"];
         },{"change":true},[bindings[4]],null);
         watchers[8] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_createOrJoinGame_numberOfPlayersAvailableColumnHeader"];
         },{"change":true},[bindings[7]],null);
         watchers[14] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_createOrJoinGame_mapColumnHeader"];
         },{"change":true},[bindings[13]],null);
         watchers[1].updateParent(target);
         watchers[2].parentWatcher = watchers[1];
         watchers[1].addChild(watchers[2]);
         watchers[5].parentWatcher = watchers[1];
         watchers[1].addChild(watchers[5]);
         watchers[8].parentWatcher = watchers[1];
         watchers[1].addChild(watchers[8]);
         watchers[14].parentWatcher = watchers[1];
         watchers[1].addChild(watchers[14]);
      }
   }
}

