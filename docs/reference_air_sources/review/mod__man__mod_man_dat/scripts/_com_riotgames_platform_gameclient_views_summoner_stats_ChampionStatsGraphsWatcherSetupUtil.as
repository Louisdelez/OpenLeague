package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.views.summoner.stats.ChampionStatsGraphs;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import mx.resources.ResourceManager;
   
   public class _com_riotgames_platform_gameclient_views_summoner_stats_ChampionStatsGraphsWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_summoner_stats_ChampionStatsGraphsWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ChampionStatsGraphs.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_summoner_stats_ChampionStatsGraphsWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[15] = new PropertyWatcher("selectedStatName",{"propertyChange":true},[bindings[16],bindings[19],bindings[25]],propertyGetter);
         watchers[23] = new PropertyWatcher("statNames",{"propertyChange":true},[bindings[26]],propertyGetter);
         watchers[24] = new PropertyWatcher("currentSelectedStatIndex",{"propertyChange":true},[bindings[27]],propertyGetter);
         watchers[3] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[2]],null);
         watchers[4] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","summonerProfile_stats_pieGrap"];
         },{"change":true},[bindings[2]],null);
         watchers[5] = new PropertyWatcher("summonerProfileController",{"propertyChange":true},[bindings[18],bindings[4],bindings[5]],propertyGetter);
         watchers[8] = new PropertyWatcher("lifetimeStats",{"propertyChange":true},[bindings[18],bindings[5]],null);
         watchers[6] = new PropertyWatcher("viewingMultipleChamps",{"propertyChange":true},[bindings[4]],null);
         watchers[13] = new PropertyWatcher("friendlyColor",{"propertyChange":true},[bindings[14]],propertyGetter);
         watchers[21] = new StaticPropertyWatcher("instance",null,[bindings[24]],null);
         watchers[0] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[0]],null);
         watchers[1] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","summonerProfile_stats_barGraph"];
         },{"change":true},[bindings[0]],null);
         watchers[16] = new PropertyWatcher("interpolateIn",{"propertyChange":true},[bindings[17],bindings[20]],propertyGetter);
         watchers[10] = new PropertyWatcher("axisStroke",{"propertyChange":true},[bindings[7],bindings[11]],propertyGetter);
         watchers[11] = new PropertyWatcher("tickStroke",{"propertyChange":true},[bindings[8],bindings[9],bindings[12],bindings[13]],propertyGetter);
         watchers[12] = new PropertyWatcher("yAxis",{"propertyChange":true},[bindings[10]],propertyGetter);
         watchers[17] = new PropertyWatcher("myChart",{"propertyChange":true},[bindings[21]],propertyGetter);
         watchers[14] = new PropertyWatcher("friendlyStroke",{"propertyChange":true},[bindings[15]],propertyGetter);
         watchers[18] = new PropertyWatcher("filterLabel",{"propertyChange":true},[bindings[23],bindings[22]],propertyGetter);
         watchers[20] = new PropertyWatcher("y",{"yChanged":true},[bindings[23]],null);
         watchers[19] = new PropertyWatcher("x",{"xChanged":true},[bindings[22]],null);
         watchers[2] = new PropertyWatcher("graphGroup",{"propertyChange":true},[bindings[1],bindings[3],bindings[4]],propertyGetter);
         watchers[7] = new PropertyWatcher("selectedValue",{
            "valueCommit":true,
            "change":true
         },[bindings[4]],null);
         watchers[9] = new PropertyWatcher("xAxis",{"propertyChange":true},[bindings[6]],propertyGetter);
         watchers[15].updateParent(target);
         watchers[23].updateParent(target);
         watchers[24].updateParent(target);
         watchers[3].updateParent(ResourceManager);
         watchers[4].parentWatcher = watchers[3];
         watchers[3].addChild(watchers[4]);
         watchers[5].updateParent(target);
         watchers[5].addChild(watchers[8]);
         watchers[5].addChild(watchers[6]);
         watchers[13].updateParent(target);
         watchers[21].updateParent(ImagePackLookup);
         watchers[0].updateParent(ResourceManager);
         watchers[1].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[1]);
         watchers[16].updateParent(target);
         watchers[10].updateParent(target);
         watchers[11].updateParent(target);
         watchers[12].updateParent(target);
         watchers[17].updateParent(target);
         watchers[14].updateParent(target);
         watchers[18].updateParent(target);
         watchers[18].addChild(watchers[20]);
         watchers[18].addChild(watchers[19]);
         watchers[2].updateParent(target);
         watchers[2].addChild(watchers[7]);
         watchers[9].updateParent(target);
      }
   }
}

