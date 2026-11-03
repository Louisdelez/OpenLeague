package
{
   import com.riotgames.platform.gameclient.shell.platformshutdown.PlatformShutdownStatusPane;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_shell_platformshutdown_PlatformShutdownStatusPaneWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_shell_platformshutdown_PlatformShutdownStatusPaneWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         PlatformShutdownStatusPane.watcherSetupUtil = new _com_riotgames_platform_gameclient_shell_platformshutdown_PlatformShutdownStatusPaneWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[4] = new PropertyWatcher("nextUpdateProgress",{"propertyChange":true},[param3[4]],param2);
         param4[7] = new PropertyWatcher("timeLeft",{"propertyChange":true},[param3[7]],param2);
         param4[4].updateParent(param1);
         param4[7].updateParent(param1);
      }
   }
}

