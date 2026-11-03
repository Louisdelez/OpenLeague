package
{
   import com.riotgames.platform.gameclient.views.summoner.SummonerProfileView;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_summoner_SummonerProfileViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_summoner_SummonerProfileViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         SummonerProfileView.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_summoner_SummonerProfileViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[27] = new PropertyWatcher("profilePages_c",{"propertyChange":true},[param3[26]],param2);
         param4[0] = new PropertyWatcher("summonerProfileController",{"propertyChange":true},[param3[17],param3[0],param3[19],param3[21],param3[22],param3[24],param3[13]],param2);
         param4[1] = new PropertyWatcher("currentState",{"propertyChange":true},[param3[0]],null);
         param4[25] = new PropertyWatcher("isBusy",{"propertyChange":true},[param3[24]],null);
         param4[14] = new PropertyWatcher("isLocalSummoner",{"propertyChange":true},[param3[21],param3[13]],null);
         param4[22] = new PropertyWatcher("achievementsLabel",{"propertyChange":true},[param3[20]],param2);
         param4[23] = new PropertyWatcher("itemSetsEnabled",{"propertyChange":true},[param3[21]],param2);
         param4[16] = new PropertyWatcher("clientConfig",{"propertyChange":true},[param3[15]],param2);
         param4[17] = new PropertyWatcher("clientMode",{"propertyChange":true},[param3[15]],null);
         param4[27].updateParent(param1);
         param4[0].updateParent(param1);
         param4[0].addChild(param4[1]);
         param4[0].addChild(param4[25]);
         param4[0].addChild(param4[14]);
         param4[22].updateParent(param1);
         param4[23].updateParent(param1);
         param4[16].updateParent(param1);
         param4[16].addChild(param4[17]);
      }
   }
}

