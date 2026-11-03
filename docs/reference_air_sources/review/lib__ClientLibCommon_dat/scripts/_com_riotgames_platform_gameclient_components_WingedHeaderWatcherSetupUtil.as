package
{
   import com.riotgames.platform.gameclient.components.WingedHeader;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   [Mixin]
   [ExcludeClass]
   public class _com_riotgames_platform_gameclient_components_WingedHeaderWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_components_WingedHeaderWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         WingedHeader.watcherSetupUtil = new _com_riotgames_platform_gameclient_components_WingedHeaderWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[5] = new PropertyWatcher("remainingLettersFontSize",{"propertyChange":true},[param3[5]],param2);
         param4[5].updateParent(param1);
      }
   }
}

