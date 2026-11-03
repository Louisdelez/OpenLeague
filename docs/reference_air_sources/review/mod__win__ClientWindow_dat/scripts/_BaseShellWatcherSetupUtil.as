package
{
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _BaseShellWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _BaseShellWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         BaseShell.watcherSetupUtil = new _BaseShellWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[0] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[0]],propertyGetter);
         watchers[1] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","main_window_title"];
         },{"change":true},[bindings[0]],null);
         watchers[0].updateParent(target);
         watchers[1].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[1]);
      }
   }
}

