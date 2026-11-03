package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import spark.skins.spark.StackedFormItemSkin;
   
   [ExcludeClass]
   public class _spark_skins_spark_StackedFormItemSkinWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _spark_skins_spark_StackedFormItemSkinWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         StackedFormItemSkin.watcherSetupUtil = new _spark_skins_spark_StackedFormItemSkinWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[8] = new PropertyWatcher("hostComponent",{"propertyChange":true},[param4[3],param4[4]],param2);
         param5[9] = new PropertyWatcher("errorString",{"errorStringChanged":true},[param4[3],param4[4]],null);
         param5[0] = new PropertyWatcher("contentGroup",{"propertyChange":true},[param4[0],param4[1],param4[2]],param2);
         param5[2] = new PropertyWatcher("contentWidth",{"propertyChange":true},[param4[0]],null);
         param5[3] = new PropertyWatcher("y",{"yChanged":true},[param4[1]],null);
         param5[7] = new PropertyWatcher("contentHeight",{"propertyChange":true},[param4[2]],null);
         param5[1] = new PropertyWatcher("x",{"xChanged":true},[param4[0]],null);
         param5[5] = new PropertyWatcher("indicatorDisplay",{"propertyChange":true},[param4[2]],param2);
         param5[6] = new PropertyWatcher("height",{"heightChanged":true},[param4[2]],null);
         param5[8].updateParent(param1);
         param5[8].addChild(param5[9]);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[2]);
         param5[0].addChild(param5[3]);
         param5[0].addChild(param5[7]);
         param5[0].addChild(param5[1]);
         param5[5].updateParent(param1);
         param5[5].addChild(param5[6]);
      }
   }
}

