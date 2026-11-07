package
{
   import com.riotgames.platform.gameclient.views.summoner.stats.ProfileStatsLifetimeView;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import mx.resources.ResourceManager;
   
   public class _com_riotgames_platform_gameclient_views_summoner_stats_ProfileStatsLifetimeViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_summoner_stats_ProfileStatsLifetimeViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ProfileStatsLifetimeView.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_summoner_stats_ProfileStatsLifetimeViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[21] = new PropertyWatcher("summonerProfileController",{"propertyChange":true},[bindings[17],bindings[19],bindings[21],bindings[23]],propertyGetter);
         watchers[22] = new PropertyWatcher("isViewingOtherSummonerStats",{"propertyChange":true},[bindings[17],bindings[19],bindings[21],bindings[23]],null);
         watchers[28] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[20]],null);
         watchers[29] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","summonerProfile_stats_lifetime_ratioLabel"];
         },{"change":true},[bindings[20]],null);
         watchers[18] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[16]],null);
         watchers[19] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","summonerProfile_stats_lifetime_winLabel"];
         },{"change":true},[bindings[16]],null);
         watchers[11] = new PropertyWatcher("championImage",{"propertyChange":true},[bindings[8],bindings[9],bindings[12],bindings[13]],propertyGetter);
         watchers[13] = new PropertyWatcher("width",{"widthChanged":true},[bindings[8],bindings[12]],null);
         watchers[14] = new PropertyWatcher("y",{"yChanged":true},[bindings[9],bindings[13]],null);
         watchers[12] = new PropertyWatcher("x",{"xChanged":true},[bindings[8],bindings[12]],null);
         watchers[35] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[24]],null);
         watchers[36] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","summonerProfile_stats_lifetime_totals"];
         },{"change":true},[bindings[24]],null);
         watchers[6] = new PropertyWatcher("profileLifetimeStatsPresentationModel",{"propertyChange":true},[bindings[34],bindings[35],bindings[32],bindings[33],bindings[6],bindings[7],bindings[10],bindings[11],bindings[14],bindings[15],bindings[16],bindings[18],bindings[20],bindings[22],bindings[27],bindings[26],bindings[29],bindings[28],bindings[31],bindings[30]],propertyGetter);
         watchers[9] = new PropertyWatcher("champion",{"propertyChange":true},[bindings[7],bindings[10],bindings[14]],null);
         watchers[10] = new PropertyWatcher("skinName",{"propertyChange":true},[bindings[7]],null);
         watchers[16] = new PropertyWatcher("description",{"propertyChange":true},[bindings[14]],null);
         watchers[15] = new PropertyWatcher("displayName",{"propertyChange":true},[bindings[10]],null);
         watchers[39] = new PropertyWatcher("totalKills",{"propertyChange":true},[bindings[26]],null);
         watchers[42] = new PropertyWatcher("totalLeftColStats",{"propertyChange":true},[bindings[29]],null);
         watchers[45] = new PropertyWatcher("avgDeaths",{"propertyChange":true},[bindings[32]],null);
         watchers[20] = new PropertyWatcher("totalWins",{"propertyChange":true},[bindings[16]],null);
         watchers[40] = new PropertyWatcher("totalDeaths",{"propertyChange":true},[bindings[27]],null);
         watchers[41] = new PropertyWatcher("totalAssists",{"propertyChange":true},[bindings[28]],null);
         watchers[44] = new PropertyWatcher("avgKills",{"propertyChange":true},[bindings[31]],null);
         watchers[46] = new PropertyWatcher("avgAssists",{"propertyChange":true},[bindings[33]],null);
         watchers[34] = new PropertyWatcher("totalGames",{"propertyChange":true},[bindings[22]],null);
         watchers[30] = new PropertyWatcher("winRatio",{"propertyChange":true},[bindings[20]],null);
         watchers[26] = new PropertyWatcher("totalLosses",{"propertyChange":true},[bindings[18]],null);
         watchers[7] = new PropertyWatcher("championId",{"propertyChange":true},[bindings[6],bindings[11],bindings[15]],null);
         watchers[43] = new PropertyWatcher("totalRightColStats",{"propertyChange":true},[bindings[30]],null);
         watchers[48] = new PropertyWatcher("avgRightColStats",{"propertyChange":true},[bindings[35]],null);
         watchers[47] = new PropertyWatcher("avgLeftColStats",{"propertyChange":true},[bindings[34]],null);
         watchers[37] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[25]],null);
         watchers[38] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","summonerProfile_stats_lifetime_avg"];
         },{"change":true},[bindings[25]],null);
         watchers[24] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[18]],null);
         watchers[25] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","summonerProfile_stats_lifetime_lostLabel"];
         },{"change":true},[bindings[18]],null);
         watchers[32] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[22]],null);
         watchers[33] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","summonerProfile_stats_lifetime_gamesLabel"];
         },{"change":true},[bindings[22]],null);
         watchers[21].updateParent(target);
         watchers[21].addChild(watchers[22]);
         watchers[28].updateParent(ResourceManager);
         watchers[29].parentWatcher = watchers[28];
         watchers[28].addChild(watchers[29]);
         watchers[18].updateParent(ResourceManager);
         watchers[19].parentWatcher = watchers[18];
         watchers[18].addChild(watchers[19]);
         watchers[11].updateParent(target);
         watchers[11].addChild(watchers[13]);
         watchers[11].addChild(watchers[14]);
         watchers[11].addChild(watchers[12]);
         watchers[35].updateParent(ResourceManager);
         watchers[36].parentWatcher = watchers[35];
         watchers[35].addChild(watchers[36]);
         watchers[6].updateParent(target);
         watchers[6].addChild(watchers[9]);
         watchers[9].addChild(watchers[10]);
         watchers[9].addChild(watchers[16]);
         watchers[9].addChild(watchers[15]);
         watchers[6].addChild(watchers[39]);
         watchers[6].addChild(watchers[42]);
         watchers[6].addChild(watchers[45]);
         watchers[6].addChild(watchers[20]);
         watchers[6].addChild(watchers[40]);
         watchers[6].addChild(watchers[41]);
         watchers[6].addChild(watchers[44]);
         watchers[6].addChild(watchers[46]);
         watchers[6].addChild(watchers[34]);
         watchers[6].addChild(watchers[30]);
         watchers[6].addChild(watchers[26]);
         watchers[6].addChild(watchers[7]);
         watchers[6].addChild(watchers[43]);
         watchers[6].addChild(watchers[48]);
         watchers[6].addChild(watchers[47]);
         watchers[37].updateParent(ResourceManager);
         watchers[38].parentWatcher = watchers[37];
         watchers[37].addChild(watchers[38]);
         watchers[24].updateParent(ResourceManager);
         watchers[25].parentWatcher = watchers[24];
         watchers[24].addChild(watchers[25]);
         watchers[32].updateParent(ResourceManager);
         watchers[33].parentWatcher = watchers[32];
         watchers[32].addChild(watchers[33]);
      }
   }
}

