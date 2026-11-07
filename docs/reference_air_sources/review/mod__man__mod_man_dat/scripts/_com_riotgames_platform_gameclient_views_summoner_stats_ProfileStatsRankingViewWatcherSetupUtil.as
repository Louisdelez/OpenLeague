package
{
   import com.riotgames.platform.gameclient.views.summoner.stats.ProfileStatsRankingView;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_summoner_stats_ProfileStatsRankingViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_summoner_stats_ProfileStatsRankingViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ProfileStatsRankingView.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_summoner_stats_ProfileStatsRankingViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[1] = new PropertyWatcher("infoFadeIn",{"propertyChange":true},[param3[1],param3[3]],param2);
         param4[4] = new PropertyWatcher("_gameMode",{"propertyChange":true},[param3[4],param3[5],param3[6]],param2);
         param4[1].updateParent(param1);
         param4[4].updateParent(param1);
      }
   }
}

