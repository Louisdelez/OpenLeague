package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import spark.skins.spark.StackedFormSkin;
   
   [ExcludeClass]
   public class _spark_skins_spark_StackedFormSkinWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _spark_skins_spark_StackedFormSkinWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         StackedFormSkin.watcherSetupUtil = new _spark_skins_spark_StackedFormSkinWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("hostComponent",{"propertyChange":true},[param4[0]],param2);
         param5[1] = new PropertyWatcher("errorString",{"errorStringChanged":true},[param4[0]],null);
         param5[2] = new PropertyWatcher("width",{"widthChanged":true},[param4[1]],param2);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[1]);
         param5[2].updateParent(param1);
      }
   }
}

