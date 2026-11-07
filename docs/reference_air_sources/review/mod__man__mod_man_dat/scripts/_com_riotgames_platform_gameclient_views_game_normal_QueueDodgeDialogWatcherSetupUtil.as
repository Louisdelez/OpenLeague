package
{
   import com.riotgames.platform.gameclient.views.game.normal.QueueDodgeDialog;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_normal_QueueDodgeDialogWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_normal_QueueDodgeDialogWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         QueueDodgeDialog.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_normal_QueueDodgeDialogWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[11] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[11],bindings[13]],propertyGetter);
         watchers[12] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","matchmaking_joinqueue_user_dodged_title"];
         },{"change":true},[bindings[11]],null);
         watchers[14] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","matchmaking_joinqueue_user_dodged_button"];
         },{"change":true},[bindings[13]],null);
         watchers[1] = new PropertyWatcher("contentBox",{"propertyChange":true},[bindings[1],bindings[4]],propertyGetter);
         watchers[5] = new PropertyWatcher("player_rpt",{"propertyChange":true},[bindings[6],bindings[7],bindings[8],bindings[9],bindings[10]],propertyGetter);
         watchers[6] = new PropertyWatcher("dataProvider",{"collectionChange":true},[bindings[6],bindings[7],bindings[8],bindings[9],bindings[10]],null);
         watchers[3] = new PropertyWatcher("failedJoinPlayers",{"propertyChange":true},[bindings[5]],propertyGetter);
         watchers[2] = new PropertyWatcher("formattedPenaltyTimeRemaining",{"propertyChange":true},[bindings[3]],propertyGetter);
         watchers[13] = new PropertyWatcher("informationalMessage",{"propertyChange":true},[bindings[12]],propertyGetter);
         watchers[0] = new PropertyWatcher("close_btn",{"propertyChange":true},[bindings[0]],propertyGetter);
         watchers[11].updateParent(target);
         watchers[12].parentWatcher = watchers[11];
         watchers[11].addChild(watchers[12]);
         watchers[14].parentWatcher = watchers[11];
         watchers[11].addChild(watchers[14]);
         watchers[1].updateParent(target);
         watchers[5].updateParent(target);
         watchers[5].addChild(watchers[6]);
         watchers[3].updateParent(target);
         watchers[2].updateParent(target);
         watchers[13].updateParent(target);
         watchers[0].updateParent(target);
      }
   }
}

