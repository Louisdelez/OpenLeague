package
{
   import com.riotgames.platform.gameclient.views.summoner.stats.ChampionStatsTooltip;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_summoner_stats_ChampionStatsTooltipWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_summoner_stats_ChampionStatsTooltipWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ChampionStatsTooltip.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_summoner_stats_ChampionStatsTooltipWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[0] = new PropertyWatcher("colLeft",{"propertyChange":true},[param3[0]],param2);
         param4[1] = new PropertyWatcher("width",{"widthChanged":true},[param3[0]],null);
         param4[2] = new PropertyWatcher("data",{"dataChange":true},[param3[1]],param2);
         param4[4] = new PropertyWatcher("description",null,[param3[1]],null);
         param4[3] = new PropertyWatcher("displayName",null,[param3[1]],null);
         param4[5] = new PropertyWatcher("champName",{"propertyChange":true},[param3[2]],param2);
         param4[7] = new PropertyWatcher("height",{"heightChanged":true},[param3[2]],null);
         param4[6] = new PropertyWatcher("y",{"yChanged":true},[param3[2]],null);
         param4[0].updateParent(param1);
         param4[0].addChild(param4[1]);
         param4[2].updateParent(param1);
         param4[2].addChild(param4[4]);
         param4[2].addChild(param4[3]);
         param4[5].updateParent(param1);
         param4[5].addChild(param4[7]);
         param4[5].addChild(param4[6]);
      }
   }
}

