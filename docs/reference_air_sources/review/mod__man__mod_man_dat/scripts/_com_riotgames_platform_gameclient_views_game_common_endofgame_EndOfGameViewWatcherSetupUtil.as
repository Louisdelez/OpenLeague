package
{
   import com.riotgames.platform.gameclient.views.game.common.endofgame.EndOfGameView;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         EndOfGameView.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[6] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[8],bindings[9],bindings[10]],propertyGetter);
         watchers[7] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_waitingForStats_statusLabel"];
         },{"change":true},[bindings[8]],null);
         watchers[8] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_waitingForStats_playAgainButtonLabel"];
         },{"change":true},[bindings[9]],null);
         watchers[9] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_waitingForStats_playAgainButton_tooltip"];
         },{"change":true},[bindings[10]],null);
         watchers[5] = new PropertyWatcher("selectedEndOfGameViewIndex",{"propertyChange":true},[bindings[7]],propertyGetter);
         watchers[0] = new PropertyWatcher("endOfGameStatsController",{"propertyChange":true},[bindings[0]],propertyGetter);
         watchers[1] = new PropertyWatcher("currentEndOfGameState",{"propertyChange":true},[bindings[0]],null);
         watchers[6].updateParent(target);
         watchers[7].parentWatcher = watchers[6];
         watchers[6].addChild(watchers[7]);
         watchers[8].parentWatcher = watchers[6];
         watchers[6].addChild(watchers[8]);
         watchers[9].parentWatcher = watchers[6];
         watchers[6].addChild(watchers[9]);
         watchers[5].updateParent(target);
         watchers[0].updateParent(target);
         watchers[0].addChild(watchers[1]);
      }
   }
}

