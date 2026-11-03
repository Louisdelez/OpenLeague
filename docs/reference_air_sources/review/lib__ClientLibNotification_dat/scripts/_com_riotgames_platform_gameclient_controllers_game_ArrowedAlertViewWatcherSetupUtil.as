package
{
   import com.riotgames.platform.gameclient.controllers.game.ArrowedAlertView;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   [Mixin]
   [ExcludeClass]
   public class _com_riotgames_platform_gameclient_controllers_game_ArrowedAlertViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_controllers_game_ArrowedAlertViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ArrowedAlertView.watcherSetupUtil = new _com_riotgames_platform_gameclient_controllers_game_ArrowedAlertViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[2] = new PropertyWatcher("shadowFilter",{"propertyChange":true},[bindings[2]],propertyGetter);
         watchers[0] = new PropertyWatcher("alertParameters",{"propertyChange":true},[bindings[1],bindings[4]],propertyGetter);
         watchers[1] = new PropertyWatcher("message",{"propertyChange":true},[bindings[1]],null);
         watchers[5] = new PropertyWatcher("button",{"propertyChange":true},[bindings[4]],null);
         watchers[3] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[3]],propertyGetter);
         watchers[4] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","summonerFirstLogin_continue"];
         },{"change":true},[bindings[3]],null);
         watchers[2].updateParent(target);
         watchers[0].updateParent(target);
         watchers[0].addChild(watchers[1]);
         watchers[0].addChild(watchers[5]);
         watchers[3].updateParent(target);
         watchers[4].parentWatcher = watchers[3];
         watchers[3].addChild(watchers[4]);
      }
   }
}

