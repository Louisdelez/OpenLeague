package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.views.summoner.SummonerSummaryView;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_summoner_SummonerSummaryViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_summoner_SummonerSummaryViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         SummonerSummaryView.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_summoner_SummonerSummaryViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[22] = new PropertyWatcher("statsView",{"propertyChange":true},[bindings[19]],propertyGetter);
         watchers[9] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[7],bindings[27]],propertyGetter);
         watchers[10] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","summonerProfile_profile_StatsOverviewHeader"];
         },{"change":true},[bindings[7]],null);
         watchers[29] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","summonerProfile_profile_mostPlayedChampionsHeaderLabel"];
         },{"change":true},[bindings[27]],null);
         watchers[1] = new PropertyWatcher("summonerProfileController",{"propertyChange":true},[bindings[35],bindings[1],bindings[18],bindings[5],bindings[29],bindings[12],bindings[14]],propertyGetter);
         watchers[2] = new PropertyWatcher("isSummonerStatsLoaded",{"propertyChange":true},[bindings[35],bindings[1],bindings[18],bindings[5],bindings[14]],null);
         watchers[31] = new PropertyWatcher("quickChampions",{"propertyChange":true},[bindings[29]],null);
         watchers[26] = new PropertyWatcher("champViewbackground",{"propertyChange":true},[bindings[23],bindings[24]],propertyGetter);
         watchers[28] = new PropertyWatcher("height",{"heightChanged":true},[bindings[24]],null);
         watchers[27] = new PropertyWatcher("width",{"widthChanged":true},[bindings[23]],null);
         watchers[25] = new PropertyWatcher("fadeOutNoDelay",{"propertyChange":true},[bindings[22],bindings[26]],propertyGetter);
         watchers[7] = new StaticPropertyWatcher("instance",null,[bindings[20],bindings[6],bindings[9]],null);
         watchers[3] = new PropertyWatcher("headerHolder",{"propertyChange":true},[bindings[2],bindings[3]],propertyGetter);
         watchers[5] = new PropertyWatcher("height",{"heightChanged":true},[bindings[3]],null);
         watchers[4] = new PropertyWatcher("width",{"widthChanged":true},[bindings[2]],null);
         watchers[32] = new PropertyWatcher("fadeIn2",{"propertyChange":true},[bindings[31]],propertyGetter);
         watchers[24] = new PropertyWatcher("fadeInNoDelay",{"propertyChange":true},[bindings[21],bindings[25]],propertyGetter);
         watchers[16] = new PropertyWatcher("modeSelectComboBox",{"propertyChange":true},[bindings[13]],propertyGetter);
         watchers[17] = new PropertyWatcher("selectedItem",{
            "valueCommit":true,
            "collectionChange":true,
            "change":true
         },[bindings[13]],null);
         watchers[18] = new PropertyWatcher("name",null,[bindings[13]],null);
         watchers[0] = new PropertyWatcher("fadeIn",{"propertyChange":true},[bindings[0]],propertyGetter);
         watchers[19] = new PropertyWatcher("statsViewHolder",{"propertyChange":true},[bindings[16],bindings[15]],propertyGetter);
         watchers[21] = new PropertyWatcher("height",{"heightChanged":true},[bindings[16]],null);
         watchers[20] = new PropertyWatcher("width",{"widthChanged":true},[bindings[15]],null);
         watchers[13] = new PropertyWatcher("statsViewbackground",{"propertyChange":true},[bindings[10],bindings[11]],propertyGetter);
         watchers[15] = new PropertyWatcher("height",{"heightChanged":true},[bindings[11]],null);
         watchers[14] = new PropertyWatcher("width",{"widthChanged":true},[bindings[10]],null);
         watchers[33] = new PropertyWatcher("champions_rf",{"propertyChange":true},[bindings[32],bindings[33]],propertyGetter);
         watchers[35] = new PropertyWatcher("height",{"heightChanged":true},[bindings[33]],null);
         watchers[34] = new PropertyWatcher("width",{"widthChanged":true},[bindings[32]],null);
         watchers[22].updateParent(target);
         watchers[9].updateParent(target);
         watchers[10].parentWatcher = watchers[9];
         watchers[9].addChild(watchers[10]);
         watchers[29].parentWatcher = watchers[9];
         watchers[9].addChild(watchers[29]);
         watchers[1].updateParent(target);
         watchers[1].addChild(watchers[2]);
         watchers[1].addChild(watchers[31]);
         watchers[26].updateParent(target);
         watchers[26].addChild(watchers[28]);
         watchers[26].addChild(watchers[27]);
         watchers[25].updateParent(target);
         watchers[7].updateParent(ImagePackLookup);
         watchers[3].updateParent(target);
         watchers[3].addChild(watchers[5]);
         watchers[3].addChild(watchers[4]);
         watchers[32].updateParent(target);
         watchers[24].updateParent(target);
         watchers[16].updateParent(target);
         watchers[16].addChild(watchers[17]);
         watchers[17].addChild(watchers[18]);
         watchers[0].updateParent(target);
         watchers[19].updateParent(target);
         watchers[19].addChild(watchers[21]);
         watchers[19].addChild(watchers[20]);
         watchers[13].updateParent(target);
         watchers[13].addChild(watchers[15]);
         watchers[13].addChild(watchers[14]);
         watchers[33].updateParent(target);
         watchers[33].addChild(watchers[35]);
         watchers[33].addChild(watchers[34]);
      }
   }
}

