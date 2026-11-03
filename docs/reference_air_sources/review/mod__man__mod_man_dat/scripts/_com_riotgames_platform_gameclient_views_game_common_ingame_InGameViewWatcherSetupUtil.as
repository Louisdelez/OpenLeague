package
{
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.gameclient.views.game.common.ingame.InGameView;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_common_ingame_InGameViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_common_ingame_InGameViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         InGameView.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_common_ingame_InGameViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[8] = new StaticPropertyWatcher("instance",null,[bindings[7],bindings[8],bindings[11],bindings[12]],null);
         watchers[9] = new PropertyWatcher("otherGameInProgress",{"propertyChange":true},[bindings[7],bindings[8],bindings[11],bindings[12]],null);
         watchers[10] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[16],bindings[7],bindings[8],bindings[11],bindings[12],bindings[15]],propertyGetter);
         watchers[19] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_inGame_reconnectButtonLabel"];
         },{"change":true},[bindings[11]],null);
         watchers[18] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_inGame_otherAccount_reconnectButtonLabel"];
         },{"change":true},[bindings[11]],null);
         watchers[21] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_inGame_reconnectButton_tooltip"];
         },{"change":true},[bindings[12]],null);
         watchers[20] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_inGame_otherAccount_reconnectButton_tooltip"];
         },{"change":true},[bindings[12]],null);
         watchers[23] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_inGame_reconnectCancelButtonTooltip"];
         },{"change":true},[bindings[16]],null);
         watchers[22] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_inGame_reconnectCancelButtonLabel"];
         },{"change":true},[bindings[15]],null);
         watchers[11] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_inGame_otherAccount_reconnectButtonLabel"];
         },{"change":true},[bindings[7]],null);
         watchers[12] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_inGame_reconnectButtonLabel"];
         },{"change":true},[bindings[7]],null);
         watchers[13] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_inGame_otherAccount_reconnectButton_tooltip"];
         },{"change":true},[bindings[8]],null);
         watchers[14] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_inGame_reconnectButton_tooltip"];
         },{"change":true},[bindings[8]],null);
         watchers[0] = new PropertyWatcher("inGameController",{"propertyChange":true},[bindings[0],bindings[9],bindings[13]],propertyGetter);
         watchers[1] = new PropertyWatcher("currentState",{"propertyChange":true},[bindings[0]],null);
         watchers[15] = new PropertyWatcher("isBusy",{"propertyChange":true},[bindings[9],bindings[13]],null);
         watchers[16] = new PropertyWatcher("showReconnect",{"propertyChange":true},[bindings[10]],propertyGetter);
         watchers[7] = new PropertyWatcher("bodyText",{"propertyChange":true},[bindings[6]],propertyGetter);
         watchers[17] = new PropertyWatcher("allowCancel",{"propertyChange":true},[bindings[17],bindings[10],bindings[14]],propertyGetter);
         watchers[6] = new PropertyWatcher("headerText",{"propertyChange":true},[bindings[5]],propertyGetter);
         watchers[8].updateParent(AppConfig);
         watchers[8].addChild(watchers[9]);
         watchers[10].updateParent(target);
         watchers[19].parentWatcher = watchers[10];
         watchers[10].addChild(watchers[19]);
         watchers[18].parentWatcher = watchers[10];
         watchers[10].addChild(watchers[18]);
         watchers[21].parentWatcher = watchers[10];
         watchers[10].addChild(watchers[21]);
         watchers[20].parentWatcher = watchers[10];
         watchers[10].addChild(watchers[20]);
         watchers[23].parentWatcher = watchers[10];
         watchers[10].addChild(watchers[23]);
         watchers[22].parentWatcher = watchers[10];
         watchers[10].addChild(watchers[22]);
         watchers[11].parentWatcher = watchers[10];
         watchers[10].addChild(watchers[11]);
         watchers[12].parentWatcher = watchers[10];
         watchers[10].addChild(watchers[12]);
         watchers[13].parentWatcher = watchers[10];
         watchers[10].addChild(watchers[13]);
         watchers[14].parentWatcher = watchers[10];
         watchers[10].addChild(watchers[14]);
         watchers[0].updateParent(target);
         watchers[0].addChild(watchers[1]);
         watchers[0].addChild(watchers[15]);
         watchers[16].updateParent(target);
         watchers[7].updateParent(target);
         watchers[17].updateParent(target);
         watchers[6].updateParent(target);
      }
   }
}

