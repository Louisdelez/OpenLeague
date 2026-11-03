package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import spark.skins.spark.SparkChromeWindowedApplicationSkin;
   
   [ExcludeClass]
   public class _spark_skins_spark_SparkChromeWindowedApplicationSkinWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _spark_skins_spark_SparkChromeWindowedApplicationSkinWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         SparkChromeWindowedApplicationSkin.watcherSetupUtil = new _spark_skins_spark_SparkChromeWindowedApplicationSkinWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("titleBar",{"propertyChange":true},[param4[0]],param2);
         param5[1] = new PropertyWatcher("visible",{
            "show":true,
            "hide":true
         },[param4[0]],null);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[1]);
      }
   }
}

