package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.views.summoner.SummonerInfoQuickView;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_summoner_SummonerInfoQuickViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_summoner_SummonerInfoQuickViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         SummonerInfoQuickView.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_summoner_SummonerInfoQuickViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[3] = new PropertyWatcher("summonerHeaderTierAsset",{"propertyChange":true},[bindings[2]],propertyGetter);
         watchers[2] = new PropertyWatcher("summonerHeaderAsset",{"propertyChange":true},[bindings[1]],propertyGetter);
         watchers[7] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[6]],propertyGetter);
         watchers[8] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","BuddyListTooltip_summonerLevel",[target.summonerProfileController.levelUpInfo.currentLevel]];
         },{"change":true},[bindings[6]],null);
         watchers[6] = new PropertyWatcher("blackTextGlow",{"propertyChange":true},[bindings[16],bindings[20],bindings[5],bindings[8],bindings[15]],propertyGetter);
         watchers[0] = new PropertyWatcher("summonerProfileController",{"propertyChange":true},[bindings[0],bindings[3],bindings[4],bindings[6],bindings[7],bindings[9],bindings[11],bindings[13],bindings[14],bindings[17],bindings[19],bindings[21],bindings[23]],propertyGetter);
         watchers[1] = new PropertyWatcher("isSummonerStatsLoaded",{"propertyChange":true},[bindings[0]],null);
         watchers[4] = new PropertyWatcher("currentSummonerIconSource",{"propertyChange":true},[bindings[3]],null);
         watchers[9] = new PropertyWatcher("levelUpInfo",{"propertyChange":true},[bindings[6],bindings[7],bindings[9],bindings[11],bindings[13],bindings[14]],null);
         watchers[14] = new PropertyWatcher("percentCompleteForNextLevel",{"propertyChange":true},[bindings[13]],null);
         watchers[16] = new PropertyWatcher("totalPointsNeededForNextLevel",{"propertyChange":true},[bindings[14]],null);
         watchers[10] = new PropertyWatcher("currentLevel",{"propertyChange":true},[bindings[6],bindings[7],bindings[9],bindings[11],bindings[13],bindings[14]],null);
         watchers[15] = new PropertyWatcher("totalExperiencePoints",{"propertyChange":true},[bindings[14]],null);
         watchers[5] = new PropertyWatcher("summonerName",{"propertyChange":true},[bindings[4]],null);
         watchers[17] = new PropertyWatcher("isLocalSummoner",{"propertyChange":true},[bindings[17],bindings[19],bindings[21],bindings[23]],null);
         watchers[11] = new StaticPropertyWatcher("instance",null,[bindings[25],bindings[24],bindings[10],bindings[12]],null);
         watchers[3].updateParent(target);
         watchers[2].updateParent(target);
         watchers[7].updateParent(target);
         watchers[8].parentWatcher = watchers[7];
         watchers[7].addChild(watchers[8]);
         watchers[6].updateParent(target);
         watchers[0].updateParent(target);
         watchers[0].addChild(watchers[1]);
         watchers[0].addChild(watchers[4]);
         watchers[0].addChild(watchers[9]);
         watchers[9].addChild(watchers[14]);
         watchers[9].addChild(watchers[16]);
         watchers[9].addChild(watchers[10]);
         watchers[9].addChild(watchers[15]);
         watchers[0].addChild(watchers[5]);
         watchers[0].addChild(watchers[17]);
         watchers[11].updateParent(ImagePackLookup);
      }
   }
}

