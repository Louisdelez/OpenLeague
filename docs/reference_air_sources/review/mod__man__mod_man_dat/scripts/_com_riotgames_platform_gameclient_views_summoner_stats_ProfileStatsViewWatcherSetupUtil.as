package
{
   import com.riotgames.platform.gameclient.views.summoner.stats.ProfileStatsView;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import mx.resources.ResourceManager;
   
   public class _com_riotgames_platform_gameclient_views_summoner_stats_ProfileStatsViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_summoner_stats_ProfileStatsViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ProfileStatsView.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_summoner_stats_ProfileStatsViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[15] = new PropertyWatcher("totalNumberOfChampions",{"propertyChange":true},[bindings[8]],propertyGetter);
         watchers[2] = new PropertyWatcher("summonerProfileController",{"propertyChange":true},[bindings[1],bindings[3],bindings[8],bindings[10]],propertyGetter);
         watchers[14] = new PropertyWatcher("championWinCount",{"propertyChange":true},[bindings[8]],null);
         watchers[3] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[2]],null);
         watchers[4] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","summonerProfile_stats_graph_label"];
         },{"change":true},[bindings[2]],null);
         watchers[0] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[0]],null);
         watchers[1] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","summonerProfile_stats_lifetime_label"];
         },{"change":true},[bindings[0]],null);
         watchers[26] = new PropertyWatcher("championList",{"propertyChange":true},[bindings[14]],propertyGetter);
         watchers[27] = new PropertyWatcher("sortedChampions",{"propertyChange":true},[bindings[14]],null);
         watchers[10] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[7]],null);
         watchers[11] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","summonerProfile_stats_championFilter"];
         },{"change":true},[bindings[7]],null);
         watchers[12] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[8]],null);
         watchers[13] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","summonerProfile_stats_championWinsCounter",[target.summonerProfileController.championWinCount,target.totalNumberOfChampions]];
         },{"change":true},[bindings[8]],null);
         watchers[8] = new PropertyWatcher("clientConfig",{"propertyChange":true},[bindings[6]],propertyGetter);
         watchers[9] = new PropertyWatcher("archivedStatsEnabled",{"propertyChange":true},[bindings[6]],null);
         watchers[5] = new StaticPropertyWatcher("instance",null,[bindings[4]],null);
         watchers[6] = new PropertyWatcher("leagueServiceEnabled",{"propertyChange":true},[bindings[4]],null);
         watchers[24] = new PropertyWatcher("profileLifetimeStatsPresentationModel",{"propertyChange":true},[bindings[12]],propertyGetter);
         watchers[25] = new PropertyWatcher("championId",{"propertyChange":true},[bindings[12]],null);
         watchers[16] = new PropertyWatcher("championListView",{"propertyChange":true},[bindings[9]],propertyGetter);
         watchers[17] = new PropertyWatcher("x",{"xChanged":true},[bindings[9]],null);
         watchers[22] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[11]],null);
         watchers[23] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","summonerProfile_stats_clearFilter"];
         },{"change":true},[bindings[11]],null);
         watchers[15].updateParent(target);
         watchers[2].updateParent(target);
         watchers[2].addChild(watchers[14]);
         watchers[3].updateParent(ResourceManager);
         watchers[4].parentWatcher = watchers[3];
         watchers[3].addChild(watchers[4]);
         watchers[0].updateParent(ResourceManager);
         watchers[1].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[1]);
         watchers[26].updateParent(target);
         watchers[26].addChild(watchers[27]);
         watchers[10].updateParent(ResourceManager);
         watchers[11].parentWatcher = watchers[10];
         watchers[10].addChild(watchers[11]);
         watchers[12].updateParent(ResourceManager);
         watchers[13].parentWatcher = watchers[12];
         watchers[12].addChild(watchers[13]);
         watchers[8].updateParent(target);
         watchers[8].addChild(watchers[9]);
         watchers[5].updateParent(ClientConfig);
         watchers[5].addChild(watchers[6]);
         watchers[24].updateParent(target);
         watchers[24].addChild(watchers[25]);
         watchers[16].updateParent(target);
         watchers[16].addChild(watchers[17]);
         watchers[22].updateParent(ResourceManager);
         watchers[23].parentWatcher = watchers[22];
         watchers[22].addChild(watchers[23]);
      }
   }
}

