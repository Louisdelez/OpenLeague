package
{
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _LolClientBeansWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _LolClientBeansWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         LolClientBeans.watcherSetupUtil = new _LolClientBeansWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[30] = new PropertyWatcher("lcdsHeartBeatController",{"propertyChange":true},[param3[49]],param2);
         param4[25] = new PropertyWatcher("enterChampionSelectManager",{"propertyChange":true},[param3[39]],param2);
         param4[17] = new PropertyWatcher("applicationController",{"propertyChange":true},[param3[70],param3[21],param3[67],param3[93],param3[59],param3[79],param3[73],param3[28],param3[91]],param2);
         param4[7] = new PropertyWatcher("viewMediator",{"propertyChange":true},[param3[50],param3[87],param3[38],param3[83],param3[9],param3[57],param3[89]],param2);
         param4[26] = new PropertyWatcher("practiceGameManager",{"propertyChange":true},[param3[40]],param2);
         param4[41] = new PropertyWatcher("showAccountTransferCompletedPopupAction",{"propertyChange":true},[param3[94]],param2);
         param4[12] = new PropertyWatcher("rssAlertController",{"propertyChange":true},[param3[15]],param2);
         param4[45] = new PropertyWatcher("keybindingController",{"propertyChange":true},[param3[99]],param2);
         param4[16] = new PropertyWatcher("playerPreferencesSyncController",{"propertyChange":true},[param3[19],param3[98]],param2);
         param4[27] = new PropertyWatcher("showAFKFilterChampionSelectionPopupAction",{"propertyChange":true},[param3[41]],param2);
         param4[36] = new PropertyWatcher("summonerSearchController",{"propertyChange":true},[param3[74]],param2);
         param4[37] = new PropertyWatcher("summonerProfileController",{"propertyChange":true},[param3[85],param3[75]],param2);
         param4[18] = new PropertyWatcher("playTutorialGameController",{"propertyChange":true},[param3[25],param3[104]],param2);
         param4[15] = new PropertyWatcher("accountStateChangeNotificationListener",{"propertyChange":true},[param3[18]],param2);
         param4[28] = new PropertyWatcher("showLegacyChampionSelectionPopupAction",{"propertyChange":true},[param3[42]],param2);
         param4[44] = new PropertyWatcher("showAccountTransferUnknownPopupAction",{"propertyChange":true},[param3[97]],param2);
         param4[22] = new PropertyWatcher("createTutorialGameController",{"propertyChange":true},[param3[102],param3[32],param3[53]],param2);
         param4[35] = new PropertyWatcher("showQueueDodgePopupAction",{"propertyChange":true},[param3[66]],param2);
         param4[43] = new PropertyWatcher("showAccountTransferStartedPopupAction",{"propertyChange":true},[param3[96]],param2);
         param4[48] = new PropertyWatcher("createSummonerWizardController",{"propertyChange":true},[param3[105]],param2);
         param4[0] = new PropertyWatcher("presenceController",{"propertyChange":true},[param3[0],param3[84],param3[52],param3[63],param3[13]],param2);
         param4[2] = new PropertyWatcher("privacyListController",{"propertyChange":true},[param3[2]],param2);
         param4[46] = new PropertyWatcher("chooseSummonerIconController",{"propertyChange":true},[param3[101]],param2);
         param4[40] = new PropertyWatcher("profileStatsSummaryPresentationModel",{"propertyChange":true},[param3[82]],param2);
         param4[4] = new PropertyWatcher("summonerController",{"propertyChange":true},[param3[5],param3[22]],param2);
         param4[47] = new PropertyWatcher("eloQuestionaireController",{"propertyChange":true},[param3[103]],param2);
         param4[24] = new PropertyWatcher("endOfGameStatsController",{"propertyChange":true},[param3[36]],param2);
         param4[20] = new PropertyWatcher("joinGameController",{"propertyChange":true},[param3[30]],param2);
         param4[6] = new PropertyWatcher("lobbyController",{"propertyChange":true},[param3[86],param3[33],param3[23],param3[8],param3[62]],param2);
         param4[1] = new PropertyWatcher("chatProperSessionLogger",{"propertyChange":true},[param3[1]],param2);
         param4[13] = new PropertyWatcher("leaverBusterController",{"propertyChange":true},[param3[16]],param2);
         param4[11] = new PropertyWatcher("masterGameViewController",{"propertyChange":true},[param3[72],param3[29],param3[14]],param2);
         param4[23] = new PropertyWatcher("teamSelectionController",{"propertyChange":true},[param3[34]],param2);
         param4[8] = new PropertyWatcher("inGameController",{"propertyChange":true},[param3[35],param3[10]],param2);
         param4[9] = new PropertyWatcher("gameQueueManager",{"propertyChange":true},[param3[68],param3[11],param3[61]],param2);
         param4[3] = new PropertyWatcher("chatController",{"propertyChange":true},[param3[51],param3[3],param3[4],param3[80],param3[20],param3[37],param3[7],param3[77],param3[47],param3[90],param3[60]],param2);
         param4[10] = new PropertyWatcher("storeController",{"propertyChange":true},[param3[12]],param2);
         param4[42] = new PropertyWatcher("showAccountTransferFailedPopupAction",{"propertyChange":true},[param3[95]],param2);
         param4[5] = new PropertyWatcher("masterGameController",{"propertyChange":true},[param3[69],param3[100],param3[71],param3[6],param3[76],param3[43],param3[46],param3[44],param3[45],param3[92],param3[24],param3[58],param3[27],param3[88]],param2);
         param4[34] = new PropertyWatcher("showLeaverBusterAlertAction",{"propertyChange":true},[param3[65]],param2);
         param4[21] = new PropertyWatcher("createPracticeGameController",{"propertyChange":true},[param3[31]],param2);
         param4[31] = new PropertyWatcher("arrowedAlertController",{"propertyChange":true},[param3[54]],param2);
         param4[19] = new PropertyWatcher("showRatingsPopupAction",{"propertyChange":true},[param3[26]],param2);
         param4[14] = new PropertyWatcher("realNameController",{"propertyChange":true},[param3[17]],param2);
         param4[29] = new PropertyWatcher("showRankedQueueFailurePopupAction",{"propertyChange":true},[param3[48],param3[64]],param2);
         param4[39] = new PropertyWatcher("profileLifetimeStatsPresentationModel",{"propertyChange":true},[param3[81]],param2);
         param4[33] = new PropertyWatcher("showReportPlayerPopupAction",{"propertyChange":true},[param3[56]],param2);
         param4[38] = new PropertyWatcher("chooseGameFlowViewController",{"propertyChange":true},[param3[78]],param2);
         param4[32] = new PropertyWatcher("glowComponentController",{"propertyChange":true},[param3[55]],param2);
         param4[30].updateParent(param1);
         param4[25].updateParent(param1);
         param4[17].updateParent(param1);
         param4[7].updateParent(param1);
         param4[26].updateParent(param1);
         param4[41].updateParent(param1);
         param4[12].updateParent(param1);
         param4[45].updateParent(param1);
         param4[16].updateParent(param1);
         param4[27].updateParent(param1);
         param4[36].updateParent(param1);
         param4[37].updateParent(param1);
         param4[18].updateParent(param1);
         param4[15].updateParent(param1);
         param4[28].updateParent(param1);
         param4[44].updateParent(param1);
         param4[22].updateParent(param1);
         param4[35].updateParent(param1);
         param4[43].updateParent(param1);
         param4[48].updateParent(param1);
         param4[0].updateParent(param1);
         param4[2].updateParent(param1);
         param4[46].updateParent(param1);
         param4[40].updateParent(param1);
         param4[4].updateParent(param1);
         param4[47].updateParent(param1);
         param4[24].updateParent(param1);
         param4[20].updateParent(param1);
         param4[6].updateParent(param1);
         param4[1].updateParent(param1);
         param4[13].updateParent(param1);
         param4[11].updateParent(param1);
         param4[23].updateParent(param1);
         param4[8].updateParent(param1);
         param4[9].updateParent(param1);
         param4[3].updateParent(param1);
         param4[10].updateParent(param1);
         param4[42].updateParent(param1);
         param4[5].updateParent(param1);
         param4[34].updateParent(param1);
         param4[21].updateParent(param1);
         param4[31].updateParent(param1);
         param4[19].updateParent(param1);
         param4[14].updateParent(param1);
         param4[29].updateParent(param1);
         param4[39].updateParent(param1);
         param4[33].updateParent(param1);
         param4[38].updateParent(param1);
         param4[32].updateParent(param1);
      }
   }
}

