package
{
   import com.riotgames.platform.gameclient.tooltips.SummonerToolTip;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_tooltips_SummonerToolTipWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_tooltips_SummonerToolTipWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         SummonerToolTip.watcherSetupUtil = new _com_riotgames_platform_gameclient_tooltips_SummonerToolTipWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[2] = new PropertyWatcher("stats",{"propertyChange":true},[param3[3]],param2);
         param4[0] = new StaticPropertyWatcher("DEFAULT_WIDTH",{"propertyChange":true},[param3[0],param3[1]],null);
         param4[1] = new PropertyWatcher("info",{"propertyChange":true},[param3[2]],param2);
         param4[2].updateParent(param1);
         param4[0].updateParent(SummonerToolTip);
         param4[1].updateParent(param1);
      }
   }
}

