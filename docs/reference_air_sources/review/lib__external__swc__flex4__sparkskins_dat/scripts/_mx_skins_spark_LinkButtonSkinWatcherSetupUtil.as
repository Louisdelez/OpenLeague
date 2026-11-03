package
{
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import mx.skins.spark.LinkButtonSkin;
   
   [ExcludeClass]
   public class _mx_skins_spark_LinkButtonSkinWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _mx_skins_spark_LinkButtonSkinWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         LinkButtonSkin.watcherSetupUtil = new _mx_skins_spark_LinkButtonSkinWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var staticPropertyGetter:Function = param3;
         var bindings:Array = param4;
         var watchers:Array = param5;
         watchers[4] = new FunctionReturnWatcher("getStyle",target,function():Array
         {
            return ["selectionColor"];
         },null,[bindings[4]],propertyGetter,true);
         watchers[1] = new FunctionReturnWatcher("getStyle",target,function():Array
         {
            return ["rollOverColor"];
         },null,[bindings[1]],propertyGetter,true);
         watchers[3] = new FunctionReturnWatcher("getStyle",target,function():Array
         {
            return ["selectionColor"];
         },null,[bindings[3]],propertyGetter,true);
         watchers[0] = new FunctionReturnWatcher("getStyle",target,function():Array
         {
            return ["cornerRadius"];
         },null,[bindings[0]],propertyGetter,true);
         watchers[2] = new FunctionReturnWatcher("getStyle",target,function():Array
         {
            return ["rollOverColor"];
         },null,[bindings[2]],propertyGetter,true);
         watchers[4].updateParent(target);
         watchers[1].updateParent(target);
         watchers[3].updateParent(target);
         watchers[0].updateParent(target);
         watchers[2].updateParent(target);
      }
   }
}

