package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.components.summoner.SummonerQuickView;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_components_summoner_SummonerQuickViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_components_summoner_SummonerQuickViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         SummonerQuickView.watcherSetupUtil = new _com_riotgames_platform_gameclient_components_summoner_SummonerQuickViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[11] = new PropertyWatcher("rankedWinsText",{"propertyChange":true},[param3[10]],param2);
         param4[3] = new PropertyWatcher("player_img",{"propertyChange":true},[param3[2]],param2);
         param4[4] = new PropertyWatcher("height",{"heightChanged":true},[param3[2]],null);
         param4[12] = new PropertyWatcher("normalWinsText",{"propertyChange":true},[param3[13]],param2);
         param4[8] = new PropertyWatcher("areStatsVisible",{"propertyChange":true},[param3[6],param3[8],param3[11],param3[14]],param2);
         param4[2] = new PropertyWatcher("height",{"heightChanged":true},[param3[1]],param2);
         param4[5] = new PropertyWatcher("playerImagePath",{"propertyChange":true},[param3[3]],param2);
         param4[9] = new PropertyWatcher("rankedRatingText",{"propertyChange":true},[param3[7]],param2);
         param4[10] = new PropertyWatcher("rankedQueueName",{"propertyChange":true},[param3[9],param3[12]],param2);
         param4[0] = new StaticPropertyWatcher("instance",null,[param3[0]],null);
         param4[7] = new PropertyWatcher("playerLevelInfo",{"propertyChange":true},[param3[5]],param2);
         param4[6] = new PropertyWatcher("displayName",{"propertyChange":true},[param3[4]],param2);
         param4[11].updateParent(param1);
         param4[3].updateParent(param1);
         param4[3].addChild(param4[4]);
         param4[12].updateParent(param1);
         param4[8].updateParent(param1);
         param4[2].updateParent(param1);
         param4[5].updateParent(param1);
         param4[9].updateParent(param1);
         param4[10].updateParent(param1);
         param4[0].updateParent(ImagePackLookup);
         param4[7].updateParent(param1);
         param4[6].updateParent(param1);
      }
   }
}

