package
{
   import com.riotgames.platform.gameclient.views.game.common.endofgame.EndOfGameStatsView;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameStatsViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameStatsViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         EndOfGameStatsView.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameStatsViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[65] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[69],bindings[70],bindings[62],bindings[61]],propertyGetter);
         watchers[66] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_showStats_playAgainButtonLabel"];
         },{"change":true},[bindings[61]],null);
         watchers[67] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_showStats_playAgainButton_tooltip"];
         },{"change":true},[bindings[62]],null);
         watchers[72] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_showStats_returnToLobbyButtonLabel"];
         },{"change":true},[bindings[69]],null);
         watchers[73] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_showStats_returnToLobbyButton_tooltip"];
         },{"change":true},[bindings[70]],null);
         watchers[34] = new PropertyWatcher("limitedIPTimeIcon",{"propertyChange":true},[bindings[29],bindings[30]],propertyGetter);
         watchers[35] = new PropertyWatcher("visible",{
            "hide":true,
            "show":true
         },[bindings[29],bindings[30]],null);
         watchers[40] = new PropertyWatcher("isDominionStatType",{"propertyChange":true},[bindings[39],bindings[37],bindings[42]],propertyGetter);
         watchers[15] = new PropertyWatcher("normalRankedDisplay",{"propertyChange":true},[bindings[5],bindings[6],bindings[8],bindings[10],bindings[12],bindings[14]],propertyGetter);
         watchers[17] = new PropertyWatcher("height",{"heightChanged":true},[bindings[5],bindings[6],bindings[8],bindings[10],bindings[12],bindings[14]],null);
         watchers[16] = new PropertyWatcher("y",{"yChanged":true},[bindings[5],bindings[6],bindings[8],bindings[10],bindings[12],bindings[14]],null);
         watchers[23] = new PropertyWatcher("endOfGameStatsController",{"propertyChange":true},[bindings[48],bindings[64],bindings[55],bindings[21],bindings[58],bindings[72],bindings[63],bindings[73],bindings[74]],propertyGetter);
         watchers[69] = new PropertyWatcher("overrideHomeButtonLabel",{"propertyChange":true},[bindings[64],bindings[72],bindings[73],bindings[74]],null);
         watchers[59] = new PropertyWatcher("endOfGameStats",{"propertyChange":true},[bindings[55],bindings[58]],null);
         watchers[60] = new PropertyWatcher("teamPlayerParticipantStats",{"propertyChange":true},[bindings[55]],null);
         watchers[61] = new PropertyWatcher("otherTeamPlayerParticipantStats",{"propertyChange":true},[bindings[58]],null);
         watchers[24] = new PropertyWatcher("levelUpInfo",{"propertyChange":true},[bindings[21]],null);
         watchers[25] = new PropertyWatcher("currentLevel",{"propertyChange":true},[bindings[21]],null);
         watchers[68] = new PropertyWatcher("allowedToPlayAgain",{"propertyChange":true},[bindings[63]],null);
         watchers[29] = new PropertyWatcher("rerollOverlay",{"propertyChange":true},[bindings[26]],propertyGetter);
         watchers[31] = new PropertyWatcher("width",{"widthChanged":true},[bindings[26]],null);
         watchers[30] = new PropertyWatcher("x",{"xChanged":true},[bindings[26]],null);
         watchers[38] = new PropertyWatcher("enableAdvancedDetailsButton",{"propertyChange":true},[bindings[34],bindings[33]],propertyGetter);
         watchers[6] = new PropertyWatcher("leagueDisplay",{"propertyChange":true},[bindings[3]],propertyGetter);
         watchers[7] = new PropertyWatcher("visible",{
            "hide":true,
            "show":true
         },[bindings[3]],null);
         watchers[62] = new PropertyWatcher("enemyTeamStats",{"propertyChange":true},[bindings[59]],propertyGetter);
         watchers[64] = new PropertyWatcher("height",{"heightChanged":true},[bindings[59]],null);
         watchers[63] = new PropertyWatcher("y",{"yChanged":true},[bindings[59]],null);
         watchers[26] = new PropertyWatcher("xpOverlay",{"propertyChange":true},[bindings[22]],propertyGetter);
         watchers[28] = new PropertyWatcher("width",{"widthChanged":true},[bindings[22]],null);
         watchers[27] = new PropertyWatcher("x",{"xChanged":true},[bindings[22]],null);
         watchers[51] = new PropertyWatcher("eogViews",{"propertyChange":true},[bindings[49],bindings[46],bindings[45]],propertyGetter);
         watchers[53] = new PropertyWatcher("height",{"heightChanged":true},[bindings[46]],null);
         watchers[52] = new PropertyWatcher("width",{"widthChanged":true},[bindings[45]],null);
         watchers[11] = new PropertyWatcher("seriesDisplay1",{"propertyChange":true},[bindings[5]],propertyGetter);
         watchers[14] = new PropertyWatcher("height",{"heightChanged":true},[bindings[5]],null);
         watchers[12] = new PropertyWatcher("visible",{
            "hide":true,
            "show":true
         },[bindings[5]],null);
         watchers[13] = new PropertyWatcher("y",{"yChanged":true},[bindings[5]],null);
         watchers[8] = new PropertyWatcher("gameModeDisplay",{"propertyChange":true},[bindings[4]],propertyGetter);
         watchers[10] = new PropertyWatcher("height",{"heightChanged":true},[bindings[4]],null);
         watchers[9] = new PropertyWatcher("y",{"yChanged":true},[bindings[4]],null);
         watchers[58] = new PropertyWatcher("teamStatsViewHeight",{"propertyChange":true},[bindings[54],bindings[53],bindings[57],bindings[56]],propertyGetter);
         watchers[55] = new PropertyWatcher("enableShareEndOfGameButton",{"propertyChange":true},[bindings[68],bindings[50],bindings[71],bindings[67]],propertyGetter);
         watchers[19] = new PropertyWatcher("ipOverlay",{"propertyChange":true},[bindings[17],bindings[16],bindings[18],bindings[20],bindings[23],bindings[25]],propertyGetter);
         watchers[21] = new PropertyWatcher("width",{"widthChanged":true},[bindings[17]],null);
         watchers[20] = new PropertyWatcher("x",{"xChanged":true},[bindings[17],bindings[16],bindings[18],bindings[20],bindings[23],bindings[25]],null);
         watchers[4] = new PropertyWatcher("championImage",{"propertyChange":true},[bindings[2]],propertyGetter);
         watchers[5] = new PropertyWatcher("source",{"sourceChanged":true},[bindings[2]],null);
         watchers[0] = new PropertyWatcher("eogTabBar",{"propertyChange":true},[bindings[0]],propertyGetter);
         watchers[2] = new PropertyWatcher("height",{"heightChanged":true},[bindings[0]],null);
         watchers[1] = new PropertyWatcher("y",{"yChanged":true},[bindings[0]],null);
         watchers[65].updateParent(target);
         watchers[66].parentWatcher = watchers[65];
         watchers[65].addChild(watchers[66]);
         watchers[67].parentWatcher = watchers[65];
         watchers[65].addChild(watchers[67]);
         watchers[72].parentWatcher = watchers[65];
         watchers[65].addChild(watchers[72]);
         watchers[73].parentWatcher = watchers[65];
         watchers[65].addChild(watchers[73]);
         watchers[34].updateParent(target);
         watchers[34].addChild(watchers[35]);
         watchers[40].updateParent(target);
         watchers[15].updateParent(target);
         watchers[15].addChild(watchers[17]);
         watchers[15].addChild(watchers[16]);
         watchers[23].updateParent(target);
         watchers[23].addChild(watchers[69]);
         watchers[23].addChild(watchers[59]);
         watchers[59].addChild(watchers[60]);
         watchers[59].addChild(watchers[61]);
         watchers[23].addChild(watchers[24]);
         watchers[24].addChild(watchers[25]);
         watchers[23].addChild(watchers[68]);
         watchers[29].updateParent(target);
         watchers[29].addChild(watchers[31]);
         watchers[29].addChild(watchers[30]);
         watchers[38].updateParent(target);
         watchers[6].updateParent(target);
         watchers[6].addChild(watchers[7]);
         watchers[62].updateParent(target);
         watchers[62].addChild(watchers[64]);
         watchers[62].addChild(watchers[63]);
         watchers[26].updateParent(target);
         watchers[26].addChild(watchers[28]);
         watchers[26].addChild(watchers[27]);
         watchers[51].updateParent(target);
         watchers[51].addChild(watchers[53]);
         watchers[51].addChild(watchers[52]);
         watchers[11].updateParent(target);
         watchers[11].addChild(watchers[14]);
         watchers[11].addChild(watchers[12]);
         watchers[11].addChild(watchers[13]);
         watchers[8].updateParent(target);
         watchers[8].addChild(watchers[10]);
         watchers[8].addChild(watchers[9]);
         watchers[58].updateParent(target);
         watchers[55].updateParent(target);
         watchers[19].updateParent(target);
         watchers[19].addChild(watchers[21]);
         watchers[19].addChild(watchers[20]);
         watchers[4].updateParent(target);
         watchers[4].addChild(watchers[5]);
         watchers[0].updateParent(target);
         watchers[0].addChild(watchers[2]);
         watchers[0].addChild(watchers[1]);
      }
   }
}

