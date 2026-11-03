package
{
   import com.riotgames.platform.common.JoinGamePopup;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_common_JoinGamePopupWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_common_JoinGamePopupWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         JoinGamePopup.watcherSetupUtil = new _com_riotgames_platform_common_JoinGamePopupWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[2] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[2],bindings[5],bindings[8],bindings[10]],propertyGetter);
         watchers[3] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_passwordPrompt_passwordPromptTitle"];
         },{"change":true},[bindings[2]],null);
         watchers[6] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_passwordPrompt_passwordPromptLabel"];
         },{"change":true},[bindings[5]],null);
         watchers[8] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_passwordPrompt_okButtonLabel"];
         },{"change":true},[bindings[8]],null);
         watchers[10] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_passwordPrompt_cancelButtonLabel"];
         },{"change":true},[bindings[10]],null);
         watchers[0] = new PropertyWatcher("b1",{"propertyChange":true},[bindings[0]],propertyGetter);
         watchers[2].updateParent(target);
         watchers[3].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[3]);
         watchers[6].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[6]);
         watchers[8].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[8]);
         watchers[10].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[10]);
         watchers[0].updateParent(target);
      }
   }
}

