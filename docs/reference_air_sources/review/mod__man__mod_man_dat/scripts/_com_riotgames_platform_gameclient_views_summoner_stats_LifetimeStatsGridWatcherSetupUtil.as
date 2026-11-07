package
{
   import com.riotgames.platform.gameclient.views.summoner.stats.LifetimeStatsGrid;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_summoner_stats_LifetimeStatsGridWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_summoner_stats_LifetimeStatsGridWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         LifetimeStatsGrid.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_summoner_stats_LifetimeStatsGridWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[0] = new PropertyWatcher("width",{"widthChanged":true},[param3[0],param3[1]],param2);
         param4[0].updateParent(param1);
      }
   }
}

