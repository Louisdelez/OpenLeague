package
{
   import com.riotgames.platform.gameclient.views.game.normal.EnterChampionSelectDialog;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_normal_EnterChampionSelectDialogWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_normal_EnterChampionSelectDialogWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         EnterChampionSelectDialog.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_normal_EnterChampionSelectDialogWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[1] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[1],bindings[3]],propertyGetter);
         watchers[2] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","enterChampionSelect_MatchFound"];
         },{"change":true},[bindings[1]],null);
         watchers[4] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","enterChampionSelect_EnterChampionSelect"];
         },{"change":true},[bindings[3]],null);
         watchers[7] = new PropertyWatcher("enterChampionSelectManager",{"propertyChange":true},[bindings[6]],propertyGetter);
         watchers[8] = new PropertyWatcher("timeRemainingStr",{"propertyChange":true},[bindings[6]],null);
         watchers[5] = new PropertyWatcher("body_txt",{"propertyChange":true},[bindings[4]],propertyGetter);
         watchers[6] = new PropertyWatcher("height",{"heightChanged":true},[bindings[4]],null);
         watchers[0] = new PropertyWatcher("enterChampionSelection_btn",{"propertyChange":true},[bindings[0]],propertyGetter);
         watchers[1].updateParent(target);
         watchers[2].parentWatcher = watchers[1];
         watchers[1].addChild(watchers[2]);
         watchers[4].parentWatcher = watchers[1];
         watchers[1].addChild(watchers[4]);
         watchers[7].updateParent(target);
         watchers[7].addChild(watchers[8]);
         watchers[5].updateParent(target);
         watchers[5].addChild(watchers[6]);
         watchers[0].updateParent(target);
      }
   }
}

