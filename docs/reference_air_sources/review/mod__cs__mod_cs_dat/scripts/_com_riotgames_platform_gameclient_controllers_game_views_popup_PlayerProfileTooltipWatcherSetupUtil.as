package
{
   import com.riotgames.platform.gameclient.controllers.game.views.popup.PlayerProfileTooltip;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_controllers_game_views_popup_PlayerProfileTooltipWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_controllers_game_views_popup_PlayerProfileTooltipWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         PlayerProfileTooltip.watcherSetupUtil = new _com_riotgames_platform_gameclient_controllers_game_views_popup_PlayerProfileTooltipWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[3] = new PropertyWatcher("playerParticipant",{"propertyChange":true},[bindings[2],bindings[5]],propertyGetter);
         watchers[4] = new PropertyWatcher("summonerName",{"propertyChange":true},[bindings[2]],null);
         watchers[11] = new PropertyWatcher("summonerLevel",{"propertyChange":true},[bindings[5]],null);
         watchers[9] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[5],bindings[9],bindings[10]],propertyGetter);
         watchers[17] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","playerProfile_winsLabel"];
         },{"change":true},[bindings[9]],null);
         watchers[19] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","playerProfile_lossesLabel"];
         },{"change":true},[bindings[10]],null);
         watchers[10] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","playerProfile_levelLabel"];
         },{"change":true},[bindings[5]],null);
         watchers[20] = new PropertyWatcher("playerLosses",{"propertyChange":true},[bindings[10]],propertyGetter);
         watchers[13] = new PropertyWatcher("summonerLevel_txt",{"propertyChange":true},[bindings[7],bindings[8]],propertyGetter);
         watchers[15] = new PropertyWatcher("height",{"heightChanged":true},[bindings[7]],null);
         watchers[16] = new PropertyWatcher("width",{"widthChanged":true},[bindings[8]],null);
         watchers[14] = new PropertyWatcher("y",{"yChanged":true},[bindings[7]],null);
         watchers[18] = new PropertyWatcher("playerWins",{"propertyChange":true},[bindings[9]],propertyGetter);
         watchers[0] = new PropertyWatcher("frame_c",{"propertyChange":true},[bindings[0],bindings[1],bindings[3],bindings[6]],propertyGetter);
         watchers[1] = new PropertyWatcher("innerLeft",{"propertyChange":true},[bindings[0]],null);
         watchers[5] = new PropertyWatcher("innerWidth",{"propertyChange":true},[bindings[3]],null);
         watchers[12] = new PropertyWatcher("width",{"widthChanged":true},[bindings[6]],null);
         watchers[2] = new PropertyWatcher("innerTop",{"propertyChange":true},[bindings[1]],null);
         watchers[6] = new PropertyWatcher("summonerName_txt",{"propertyChange":true},[bindings[4]],propertyGetter);
         watchers[8] = new PropertyWatcher("height",{"heightChanged":true},[bindings[4]],null);
         watchers[7] = new PropertyWatcher("y",{"yChanged":true},[bindings[4]],null);
         watchers[3].updateParent(target);
         watchers[3].addChild(watchers[4]);
         watchers[3].addChild(watchers[11]);
         watchers[9].updateParent(target);
         watchers[17].parentWatcher = watchers[9];
         watchers[9].addChild(watchers[17]);
         watchers[19].parentWatcher = watchers[9];
         watchers[9].addChild(watchers[19]);
         watchers[10].parentWatcher = watchers[9];
         watchers[9].addChild(watchers[10]);
         watchers[20].updateParent(target);
         watchers[13].updateParent(target);
         watchers[13].addChild(watchers[15]);
         watchers[13].addChild(watchers[16]);
         watchers[13].addChild(watchers[14]);
         watchers[18].updateParent(target);
         watchers[0].updateParent(target);
         watchers[0].addChild(watchers[1]);
         watchers[0].addChild(watchers[5]);
         watchers[0].addChild(watchers[12]);
         watchers[0].addChild(watchers[2]);
         watchers[6].updateParent(target);
         watchers[6].addChild(watchers[8]);
         watchers[6].addChild(watchers[7]);
      }
   }
}

