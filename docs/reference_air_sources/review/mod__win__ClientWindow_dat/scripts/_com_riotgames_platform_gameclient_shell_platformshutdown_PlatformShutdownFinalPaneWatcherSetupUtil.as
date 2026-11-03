package
{
   import com.riotgames.platform.gameclient.shell.platformshutdown.PlatformShutdownFinalPane;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_shell_platformshutdown_PlatformShutdownFinalPaneWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_shell_platformshutdown_PlatformShutdownFinalPaneWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         PlatformShutdownFinalPane.watcherSetupUtil = new _com_riotgames_platform_gameclient_shell_platformshutdown_PlatformShutdownFinalPaneWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
      }
   }
}

