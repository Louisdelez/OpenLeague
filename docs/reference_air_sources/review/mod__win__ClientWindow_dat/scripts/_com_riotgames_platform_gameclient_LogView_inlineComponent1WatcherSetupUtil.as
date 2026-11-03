package
{
   import com.riotgames.platform.gameclient.LogView_inlineComponent1;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_LogView_inlineComponent1WatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_LogView_inlineComponent1WatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         LogView_inlineComponent1.watcherSetupUtil = new _com_riotgames_platform_gameclient_LogView_inlineComponent1WatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[0] = new PropertyWatcher("data",{"dataChange":true},[param3[0]],param2);
         param4[0].updateParent(param1);
      }
   }
}

