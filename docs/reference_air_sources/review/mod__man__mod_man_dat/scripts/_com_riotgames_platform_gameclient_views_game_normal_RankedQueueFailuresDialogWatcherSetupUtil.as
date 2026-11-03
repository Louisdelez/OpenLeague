package
{
   import com.riotgames.platform.gameclient.views.game.normal.RankedQueueFailuresDialog;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.RepeaterItemWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_normal_RankedQueueFailuresDialogWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_normal_RankedQueueFailuresDialogWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         RankedQueueFailuresDialog.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_normal_RankedQueueFailuresDialogWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[12] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[16],bindings[13]],propertyGetter);
         watchers[13] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","matchmaking_join_rankedqueue_title"];
         },{"change":true},[bindings[13]],null);
         watchers[15] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","matchmaking_joinqueue_user_dodged_button"];
         },{"change":true},[bindings[16]],null);
         watchers[1] = new PropertyWatcher("contentBox",{"propertyChange":true},[bindings[1],bindings[6]],propertyGetter);
         watchers[6] = new PropertyWatcher("player_rpt",{"propertyChange":true},[bindings[9],bindings[11]],propertyGetter);
         watchers[7] = new PropertyWatcher("dataProvider",{"collectionChange":true},[bindings[9],bindings[11]],null);
         watchers[8] = new RepeaterItemWatcher(watchers[7]);
         watchers[11] = new PropertyWatcher("reasonFailed",null,[bindings[11]],null);
         watchers[9] = new PropertyWatcher("name",null,[bindings[9]],null);
         watchers[5] = new PropertyWatcher("failedJoinPlayers",{"propertyChange":true},[bindings[7]],propertyGetter);
         watchers[14] = new PropertyWatcher("informationalMessage",{"propertyChange":true},[bindings[14]],propertyGetter);
         watchers[3] = new PropertyWatcher("failedMessageSingle",{"propertyChange":true},[bindings[4]],propertyGetter);
         watchers[0] = new PropertyWatcher("close_btn",{"propertyChange":true},[bindings[0]],propertyGetter);
         watchers[12].updateParent(target);
         watchers[13].parentWatcher = watchers[12];
         watchers[12].addChild(watchers[13]);
         watchers[15].parentWatcher = watchers[12];
         watchers[12].addChild(watchers[15]);
         watchers[1].updateParent(target);
         watchers[6].updateParent(target);
         watchers[6].addChild(watchers[7]);
         watchers[7].addChild(watchers[8]);
         watchers[8].addChild(watchers[11]);
         watchers[8].addChild(watchers[9]);
         watchers[5].updateParent(target);
         watchers[14].updateParent(target);
         watchers[3].updateParent(target);
         watchers[0].updateParent(target);
      }
   }
}

