package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import spark.skins.spark.windowChrome.GripperSkin;
   
   [ExcludeClass]
   public class _spark_skins_spark_windowChrome_GripperSkinWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _spark_skins_spark_windowChrome_GripperSkinWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         GripperSkin.watcherSetupUtil = new _spark_skins_spark_windowChrome_GripperSkinWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
      }
   }
}

