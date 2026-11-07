package
{
   import com.riotgames.platform.gameclient.views.game.normal.LeaverBusterDialogue;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_normal_LeaverBusterDialogueWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_normal_LeaverBusterDialogueWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         LeaverBusterDialogue.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_normal_LeaverBusterDialogueWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[0] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[0],bindings[4]],propertyGetter);
         watchers[1] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","matchmaking_joinqueue_leaverbusted_title"];
         },{"change":true},[bindings[0]],null);
         watchers[4] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","matchmaking_joinqueue_leaverbusted_dismiss"];
         },{"change":true},[bindings[4]],null);
         watchers[3] = new PropertyWatcher("formattedPenaltyTimeRemaining",{"propertyChange":true},[bindings[3]],propertyGetter);
         watchers[2] = new PropertyWatcher("informationalMessage",{"propertyChange":true},[bindings[1]],propertyGetter);
         watchers[0].updateParent(target);
         watchers[1].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[1]);
         watchers[4].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[4]);
         watchers[3].updateParent(target);
         watchers[2].updateParent(target);
      }
   }
}

