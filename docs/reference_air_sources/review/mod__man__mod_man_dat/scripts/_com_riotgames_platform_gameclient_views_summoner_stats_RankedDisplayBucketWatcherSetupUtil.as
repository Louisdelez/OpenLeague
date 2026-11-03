package
{
   import com.riotgames.platform.gameclient.views.summoner.stats.RankedDisplayBucket;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_summoner_stats_RankedDisplayBucketWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_summoner_stats_RankedDisplayBucketWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         RankedDisplayBucket.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_summoner_stats_RankedDisplayBucketWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
      }
   }
}

