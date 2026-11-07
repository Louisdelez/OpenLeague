package
{
   import com.riotgames.platform.common.components.controls.InternalBrowser;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_common_components_controls_InternalBrowserWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_common_components_controls_InternalBrowserWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         InternalBrowser.watcherSetupUtil = new _com_riotgames_platform_common_components_controls_InternalBrowserWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[1] = new PropertyWatcher("isSecure",{"propertyChange":true},[param3[1]],param2);
         param4[0] = new PropertyWatcher("showBrowserBar",{"propertyChange":true},[param3[0]],param2);
         param4[2] = new PropertyWatcher("_html",{"propertyChange":true},[param3[2]],param2);
         param4[3] = new PropertyWatcher("location",{"locationChange":true},[param3[2]],null);
         param4[1].updateParent(param1);
         param4[0].updateParent(param1);
         param4[2].updateParent(param1);
         param4[2].addChild(param4[3]);
      }
   }
}

