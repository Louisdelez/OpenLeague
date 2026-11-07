package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.views.game.practice.join.JoinGamePanel;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_practice_join_JoinGamePanelWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_practice_join_JoinGamePanelWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         JoinGamePanel.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_practice_join_JoinGamePanelWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[23] = new PropertyWatcher("canObserveGame",{"propertyChange":true},[bindings[18]],propertyGetter);
         watchers[8] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[23],bindings[6],bindings[22],bindings[7],bindings[10],bindings[11]],propertyGetter);
         watchers[25] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_createOrJoinGame_goToCreateGameButton_tooltip"];
         },{"change":true},[bindings[23]],null);
         watchers[24] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_createOrJoinGame_goToCreateGameButtonLabel"];
         },{"change":true},[bindings[22]],null);
         watchers[9] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_createOrJoinGame_cancelButtonLabel"];
         },{"change":true},[bindings[6]],null);
         watchers[10] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_createOrJoinGame_cancelButton_tooltip"];
         },{"change":true},[bindings[7]],null);
         watchers[14] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_createOrJoinGame_findGamesButtonLabel"];
         },{"change":true},[bindings[10]],null);
         watchers[15] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_createOrJoinGame_findGamesButton_tooltip"];
         },{"change":true},[bindings[11]],null);
         watchers[31] = new StaticPropertyWatcher("instance",null,[bindings[30]],null);
         watchers[11] = new PropertyWatcher("btnJoinGame",{"propertyChange":true},[bindings[8],bindings[9]],propertyGetter);
         watchers[13] = new PropertyWatcher("height",{"heightChanged":true},[bindings[9]],null);
         watchers[12] = new PropertyWatcher("width",{"widthChanged":true},[bindings[8]],null);
         watchers[4] = new PropertyWatcher("joinGameController",{"propertyChange":true},[bindings[4]],propertyGetter);
         watchers[5] = new PropertyWatcher("practiceGames",{"propertyChange":true},[bindings[4]],null);
         watchers[1] = new PropertyWatcher("lobbyTitleColor",{"propertyChange":true},[bindings[1]],propertyGetter);
         watchers[16] = new PropertyWatcher("refreshAllowed",{"propertyChange":true},[bindings[12]],propertyGetter);
         watchers[34] = new PropertyWatcher("htmlMapDescription",{"propertyChange":true},[bindings[32]],propertyGetter);
         watchers[29] = new PropertyWatcher("mapInfoLabel",{"propertyChange":true},[bindings[29]],propertyGetter);
         watchers[30] = new PropertyWatcher("x",{"xChanged":true},[bindings[29]],null);
         watchers[17] = new PropertyWatcher("quit_btn",{"propertyChange":true},[bindings[21],bindings[20],bindings[25],bindings[24],bindings[13],bindings[14]],propertyGetter);
         watchers[19] = new PropertyWatcher("height",{"heightChanged":true},[bindings[21],bindings[25],bindings[14]],null);
         watchers[18] = new PropertyWatcher("width",{"widthChanged":true},[bindings[20],bindings[24],bindings[13]],null);
         watchers[6] = new PropertyWatcher("clientConfig",{"propertyChange":true},[bindings[19],bindings[5]],propertyGetter);
         watchers[7] = new PropertyWatcher("observerModeEnabled",{"propertyChange":true},[bindings[19],bindings[5]],null);
         watchers[28] = new PropertyWatcher("canJoinGame",{"propertyChange":true},[bindings[28]],propertyGetter);
         watchers[0] = new PropertyWatcher("lobbyTitle",{"propertyChange":true},[bindings[0]],propertyGetter);
         watchers[23].updateParent(target);
         watchers[8].updateParent(target);
         watchers[25].parentWatcher = watchers[8];
         watchers[8].addChild(watchers[25]);
         watchers[24].parentWatcher = watchers[8];
         watchers[8].addChild(watchers[24]);
         watchers[9].parentWatcher = watchers[8];
         watchers[8].addChild(watchers[9]);
         watchers[10].parentWatcher = watchers[8];
         watchers[8].addChild(watchers[10]);
         watchers[14].parentWatcher = watchers[8];
         watchers[8].addChild(watchers[14]);
         watchers[15].parentWatcher = watchers[8];
         watchers[8].addChild(watchers[15]);
         watchers[31].updateParent(ImagePackLookup);
         watchers[11].updateParent(target);
         watchers[11].addChild(watchers[13]);
         watchers[11].addChild(watchers[12]);
         watchers[4].updateParent(target);
         watchers[4].addChild(watchers[5]);
         watchers[1].updateParent(target);
         watchers[16].updateParent(target);
         watchers[34].updateParent(target);
         watchers[29].updateParent(target);
         watchers[29].addChild(watchers[30]);
         watchers[17].updateParent(target);
         watchers[17].addChild(watchers[19]);
         watchers[17].addChild(watchers[18]);
         watchers[6].updateParent(target);
         watchers[6].addChild(watchers[7]);
         watchers[28].updateParent(target);
         watchers[0].updateParent(target);
      }
   }
}

