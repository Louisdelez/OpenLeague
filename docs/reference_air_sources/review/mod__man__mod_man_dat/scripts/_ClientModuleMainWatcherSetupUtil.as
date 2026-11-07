package
{
   import com.riotgames.platform.common.AppConfig;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _ClientModuleMainWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _ClientModuleMainWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ClientModuleMain.watcherSetupUtil = new _ClientModuleMainWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[4] = new StaticPropertyWatcher("instance",null,[param3[6]],null);
         param4[5] = new PropertyWatcher("antiIndulgenceMessage",{"propertyChange":true},[param3[6]],null);
         param4[2] = new PropertyWatcher("applicationContent_c",{"propertyChange":true},[param3[5]],param2);
         param4[3] = new PropertyWatcher("y",{"yChanged":true},[param3[5]],null);
         param4[1] = new PropertyWatcher("swizConfig",{"propertyChange":true},[param3[3]],param2);
         param4[4].updateParent(AppConfig);
         param4[4].addChild(param4[5]);
         param4[2].updateParent(param1);
         param4[2].addChild(param4[3]);
         param4[1].updateParent(param1);
      }
   }
}

