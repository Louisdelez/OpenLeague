package
{
   import com.riotgames.platform.gameclient.chat.renderer.BuddyTooltip;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_chat_renderer_BuddyTooltipWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_chat_renderer_BuddyTooltipWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         BuddyTooltip.watcherSetupUtil = new _com_riotgames_platform_gameclient_chat_renderer_BuddyTooltipWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[17] = new PropertyWatcher("leaguesEnabled",null,[bindings[17],bindings[16],bindings[19],bindings[20]],propertyGetter);
         watchers[16] = new PropertyWatcher("showLeagueDetails",{"propertyChange":true},[bindings[17],bindings[16],bindings[19],bindings[20]],propertyGetter);
         watchers[1] = new PropertyWatcher("profileIcon",{"propertyChange":true},[bindings[1]],propertyGetter);
         watchers[2] = new PropertyWatcher("height",{"heightChanged":true},[bindings[1]],null);
         watchers[5] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[5]],propertyGetter);
         watchers[6] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","BuddyListTooltip_summonerLevel",[target.presenceData.level]];
         },{"change":true},[bindings[5]],null);
         watchers[3] = new PropertyWatcher("showDetails",{"propertyChange":true},[bindings[2],bindings[3],bindings[23],bindings[6],bindings[7],bindings[24],bindings[27],bindings[10],bindings[26],bindings[11],bindings[29],bindings[30]],propertyGetter);
         watchers[19] = new PropertyWatcher("gameStatusColor",{"propertyChange":true},[bindings[21]],propertyGetter);
         watchers[18] = new PropertyWatcher("rankedGameLeagueNameText",{"propertyChange":true},[bindings[19],bindings[18],bindings[20]],propertyGetter);
         watchers[13] = new PropertyWatcher("winsHTMLText",{"propertyChange":true},[bindings[12]],propertyGetter);
         watchers[20] = new PropertyWatcher("gameStatus",{"propertyChange":true},[bindings[22]],propertyGetter);
         watchers[21] = new PropertyWatcher("inGameDetails",{"propertyChange":true},[bindings[25]],propertyGetter);
         watchers[7] = new PropertyWatcher("presenceData",{"propertyChange":true},[bindings[5],bindings[8],bindings[27],bindings[26],bindings[29],bindings[30]],propertyGetter);
         watchers[8] = new PropertyWatcher("level",{"propertyChange":true},[bindings[5]],null);
         watchers[22] = new PropertyWatcher("gameType",{"propertyChange":true},[bindings[27],bindings[26],bindings[29],bindings[30]],null);
         watchers[9] = new PropertyWatcher("statusMsg",{"propertyChange":true},[bindings[8]],null);
         watchers[14] = new PropertyWatcher("showWinDetails",{"propertyChange":true},[bindings[13],bindings[14]],propertyGetter);
         watchers[15] = new PropertyWatcher("rankedGameLeagueStandingText",{"propertyChange":true},[bindings[15]],propertyGetter);
         watchers[25] = new PropertyWatcher("showMinsElapsed",{"propertyChange":true},[bindings[29]],propertyGetter);
         watchers[0] = new PropertyWatcher("profileIconSource",{"propertyChange":true},[bindings[0]],propertyGetter);
         watchers[4] = new PropertyWatcher("buddyName",{"propertyChange":true},[bindings[4]],propertyGetter);
         watchers[24] = new PropertyWatcher("timeStampText",{"propertyChange":true},[bindings[28]],propertyGetter);
         watchers[11] = new PropertyWatcher("playerInfoBox",{"propertyChange":true},[bindings[9]],propertyGetter);
         watchers[12] = new PropertyWatcher("width",{"widthChanged":true},[bindings[9]],null);
         watchers[17].updateParent(target);
         watchers[16].updateParent(target);
         watchers[1].updateParent(target);
         watchers[1].addChild(watchers[2]);
         watchers[5].updateParent(target);
         watchers[6].parentWatcher = watchers[5];
         watchers[5].addChild(watchers[6]);
         watchers[3].updateParent(target);
         watchers[19].updateParent(target);
         watchers[18].updateParent(target);
         watchers[13].updateParent(target);
         watchers[20].updateParent(target);
         watchers[21].updateParent(target);
         watchers[7].updateParent(target);
         watchers[7].addChild(watchers[8]);
         watchers[7].addChild(watchers[22]);
         watchers[7].addChild(watchers[9]);
         watchers[14].updateParent(target);
         watchers[15].updateParent(target);
         watchers[25].updateParent(target);
         watchers[0].updateParent(target);
         watchers[4].updateParent(target);
         watchers[24].updateParent(target);
         watchers[11].updateParent(target);
         watchers[11].addChild(watchers[12]);
      }
   }
}

