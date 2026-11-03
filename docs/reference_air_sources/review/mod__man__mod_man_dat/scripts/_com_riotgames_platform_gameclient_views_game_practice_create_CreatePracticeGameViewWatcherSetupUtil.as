package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.views.game.practice.create.CreatePracticeGameView;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_practice_create_CreatePracticeGameViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_practice_create_CreatePracticeGameViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         CreatePracticeGameView.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_practice_create_CreatePracticeGameViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[22] = new PropertyWatcher("teamSize_cb",{"propertyChange":true},[bindings[20],bindings[13]],propertyGetter);
         watchers[34] = new PropertyWatcher("height",{"heightChanged":true},[bindings[20]],null);
         watchers[24] = new PropertyWatcher("width",{"widthChanged":true},[bindings[13]],null);
         watchers[33] = new PropertyWatcher("y",{"yChanged":true},[bindings[20]],null);
         watchers[23] = new PropertyWatcher("x",{"xChanged":true},[bindings[13]],null);
         watchers[11] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[50],bindings[49],bindings[19],bindings[23],bindings[6],bindings[37],bindings[8],bindings[46],bindings[47],bindings[30]],propertyGetter);
         watchers[16] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_createPracticeGame_teamSizeLabel"];
         },{"change":true},[bindings[8]],null);
         watchers[32] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_createPracticeGame_gameTypeLabel"];
         },{"change":true},[bindings[19]],null);
         watchers[64] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_createOrJoinGame_cancelCreateGameButtonLabel"];
         },{"change":true},[bindings[46]],null);
         watchers[65] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_createOrJoinGame_cancelCreateGameButton_tooltip"];
         },{"change":true},[bindings[47]],null);
         watchers[66] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_createOrJoinGame_createGameButtonLabel"];
         },{"change":true},[bindings[49]],null);
         watchers[53] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_createOrJoinGame_privateGamePasswordLabel"];
         },{"change":true},[bindings[37]],null);
         watchers[67] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_createOrJoinGame_createGameButton_tooltip"];
         },{"change":true},[bindings[50]],null);
         watchers[37] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_createPracticeGame_gameServerRegionLabel"];
         },{"change":true},[bindings[23]],null);
         watchers[46] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_createOrJoinGame_gameNameLabel"];
         },{"change":true},[bindings[30]],null);
         watchers[12] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_createPracticeGame_gameOptions_heading"];
         },{"change":true},[bindings[6]],null);
         watchers[13] = new PropertyWatcher("chooseMap_tl",{"propertyChange":true},[bindings[7]],propertyGetter);
         watchers[15] = new PropertyWatcher("height",{"heightChanged":true},[bindings[7]],null);
         watchers[14] = new PropertyWatcher("y",{"yChanged":true},[bindings[7]],null);
         watchers[17] = new PropertyWatcher("gameOptionsHeader",{"propertyChange":true},[bindings[9]],propertyGetter);
         watchers[18] = new PropertyWatcher("y",{"yChanged":true},[bindings[9]],null);
         watchers[38] = new PropertyWatcher("gameType_cb",{"propertyChange":true},[bindings[32],bindings[25],bindings[24],bindings[31]],propertyGetter);
         watchers[47] = new PropertyWatcher("height",{"heightChanged":true},[bindings[32],bindings[31]],null);
         watchers[41] = new PropertyWatcher("width",{"widthChanged":true},[bindings[25]],null);
         watchers[39] = new PropertyWatcher("y",{"yChanged":true},[bindings[32],bindings[24],bindings[31]],null);
         watchers[40] = new PropertyWatcher("x",{"xChanged":true},[bindings[25]],null);
         watchers[19] = new PropertyWatcher("teamSizeLabel",{"propertyChange":true},[bindings[10],bindings[12],bindings[15]],propertyGetter);
         watchers[20] = new PropertyWatcher("y",{"yChanged":true},[bindings[10],bindings[12],bindings[15]],null);
         watchers[42] = new PropertyWatcher("gameRegionLabel",{"propertyChange":true},[bindings[29],bindings[28]],propertyGetter);
         watchers[45] = new PropertyWatcher("visible",{
            "hide":true,
            "show":true
         },[bindings[29]],null);
         watchers[44] = new PropertyWatcher("width",{"widthChanged":true},[bindings[28]],null);
         watchers[43] = new PropertyWatcher("x",{"xChanged":true},[bindings[28]],null);
         watchers[2] = new StaticPropertyWatcher("instance",null,[bindings[1],bindings[4]],null);
         watchers[60] = new PropertyWatcher("passwordLock_img",{"propertyChange":true},[bindings[44]],propertyGetter);
         watchers[61] = new PropertyWatcher("height",{"heightChanged":true},[bindings[44]],null);
         watchers[35] = new PropertyWatcher("gametypeLabel",{"propertyChange":true},[bindings[22],bindings[27]],propertyGetter);
         watchers[36] = new PropertyWatcher("y",{"yChanged":true},[bindings[22],bindings[27]],null);
         watchers[30] = new PropertyWatcher("mapChooseCanvas",{"propertyChange":true},[bindings[17],bindings[33],bindings[21],bindings[40],bindings[26]],propertyGetter);
         watchers[31] = new PropertyWatcher("width",{"widthChanged":true},[bindings[17],bindings[33],bindings[21],bindings[40],bindings[26]],null);
         watchers[48] = new PropertyWatcher("createPracticeGameController",{"propertyChange":true},[bindings[34],bindings[48],bindings[41]],propertyGetter);
         watchers[49] = new PropertyWatcher("isBusy",{"propertyChange":true},[bindings[34],bindings[48],bindings[41]],null);
         watchers[0] = new PropertyWatcher("mapInfoLabel",{"propertyChange":true},[bindings[0]],propertyGetter);
         watchers[1] = new PropertyWatcher("x",{"xChanged":true},[bindings[0]],null);
         watchers[27] = new PropertyWatcher("allowSpectatorsLabel",{"propertyChange":true},[bindings[16]],propertyGetter);
         watchers[29] = new PropertyWatcher("width",{"widthChanged":true},[bindings[16]],null);
         watchers[28] = new PropertyWatcher("x",{"xChanged":true},[bindings[16]],null);
         watchers[51] = new PropertyWatcher("name_txti",{"propertyChange":true},[bindings[36],bindings[43]],propertyGetter);
         watchers[52] = new PropertyWatcher("width",{"widthChanged":true},[bindings[36],bindings[43]],null);
         watchers[25] = new StaticPropertyWatcher("instance",null,[bindings[18],bindings[14]],null);
         watchers[26] = new PropertyWatcher("observerModeEnabled",{"propertyChange":true},[bindings[18],bindings[14]],null);
         watchers[54] = new PropertyWatcher("textEntry",{"propertyChange":true},[bindings[38],bindings[39]],propertyGetter);
         watchers[56] = new PropertyWatcher("height",{"heightChanged":true},[bindings[38],bindings[39]],null);
         watchers[55] = new PropertyWatcher("y",{"yChanged":true},[bindings[38],bindings[39]],null);
         watchers[5] = new PropertyWatcher("chooseMapLabel",{"propertyChange":true},[bindings[3]],propertyGetter);
         watchers[6] = new PropertyWatcher("x",{"xChanged":true},[bindings[3]],null);
         watchers[8] = new PropertyWatcher("heading",{"propertyChange":true},[bindings[5]],propertyGetter);
         watchers[10] = new PropertyWatcher("height",{"heightChanged":true},[bindings[5]],null);
         watchers[9] = new PropertyWatcher("y",{"yChanged":true},[bindings[5]],null);
         watchers[57] = new PropertyWatcher("password_txti",{"propertyChange":true},[bindings[44],bindings[45]],propertyGetter);
         watchers[59] = new PropertyWatcher("height",{"heightChanged":true},[bindings[44]],null);
         watchers[63] = new PropertyWatcher("width",{"widthChanged":true},[bindings[45]],null);
         watchers[58] = new PropertyWatcher("y",{"yChanged":true},[bindings[44]],null);
         watchers[62] = new PropertyWatcher("x",{"xChanged":true},[bindings[45]],null);
         watchers[22].updateParent(target);
         watchers[22].addChild(watchers[34]);
         watchers[22].addChild(watchers[24]);
         watchers[22].addChild(watchers[33]);
         watchers[22].addChild(watchers[23]);
         watchers[11].updateParent(target);
         watchers[16].parentWatcher = watchers[11];
         watchers[11].addChild(watchers[16]);
         watchers[32].parentWatcher = watchers[11];
         watchers[11].addChild(watchers[32]);
         watchers[64].parentWatcher = watchers[11];
         watchers[11].addChild(watchers[64]);
         watchers[65].parentWatcher = watchers[11];
         watchers[11].addChild(watchers[65]);
         watchers[66].parentWatcher = watchers[11];
         watchers[11].addChild(watchers[66]);
         watchers[53].parentWatcher = watchers[11];
         watchers[11].addChild(watchers[53]);
         watchers[67].parentWatcher = watchers[11];
         watchers[11].addChild(watchers[67]);
         watchers[37].parentWatcher = watchers[11];
         watchers[11].addChild(watchers[37]);
         watchers[46].parentWatcher = watchers[11];
         watchers[11].addChild(watchers[46]);
         watchers[12].parentWatcher = watchers[11];
         watchers[11].addChild(watchers[12]);
         watchers[13].updateParent(target);
         watchers[13].addChild(watchers[15]);
         watchers[13].addChild(watchers[14]);
         watchers[17].updateParent(target);
         watchers[17].addChild(watchers[18]);
         watchers[38].updateParent(target);
         watchers[38].addChild(watchers[47]);
         watchers[38].addChild(watchers[41]);
         watchers[38].addChild(watchers[39]);
         watchers[38].addChild(watchers[40]);
         watchers[19].updateParent(target);
         watchers[19].addChild(watchers[20]);
         watchers[42].updateParent(target);
         watchers[42].addChild(watchers[45]);
         watchers[42].addChild(watchers[44]);
         watchers[42].addChild(watchers[43]);
         watchers[2].updateParent(ImagePackLookup);
         watchers[60].updateParent(target);
         watchers[60].addChild(watchers[61]);
         watchers[35].updateParent(target);
         watchers[35].addChild(watchers[36]);
         watchers[30].updateParent(target);
         watchers[30].addChild(watchers[31]);
         watchers[48].updateParent(target);
         watchers[48].addChild(watchers[49]);
         watchers[0].updateParent(target);
         watchers[0].addChild(watchers[1]);
         watchers[27].updateParent(target);
         watchers[27].addChild(watchers[29]);
         watchers[27].addChild(watchers[28]);
         watchers[51].updateParent(target);
         watchers[51].addChild(watchers[52]);
         watchers[25].updateParent(ClientConfig);
         watchers[25].addChild(watchers[26]);
         watchers[54].updateParent(target);
         watchers[54].addChild(watchers[56]);
         watchers[54].addChild(watchers[55]);
         watchers[5].updateParent(target);
         watchers[5].addChild(watchers[6]);
         watchers[8].updateParent(target);
         watchers[8].addChild(watchers[10]);
         watchers[8].addChild(watchers[9]);
         watchers[57].updateParent(target);
         watchers[57].addChild(watchers[59]);
         watchers[57].addChild(watchers[63]);
         watchers[57].addChild(watchers[58]);
         watchers[57].addChild(watchers[62]);
      }
   }
}

