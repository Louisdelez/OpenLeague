package
{
   import com.riotgames.platform.gameclient.controllers.game.views.TradeRequestPanel;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import mx.resources.ResourceManager;
   
   public class _com_riotgames_platform_gameclient_controllers_game_views_TradeRequestPanelWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_controllers_game_views_TradeRequestPanelWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         TradeRequestPanel.watcherSetupUtil = new _com_riotgames_platform_gameclient_controllers_game_views_TradeRequestPanelWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[10] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[9]],null);
         watchers[11] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","champion_trading_trade_giving"];
         },{"change":true},[bindings[9]],null);
         watchers[8] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[8]],null);
         watchers[9] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","champion_trading_trade_recieving"];
         },{"change":true},[bindings[8]],null);
         watchers[12] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[10]],null);
         watchers[13] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","champion_trading_pending_trade_title"];
         },{"change":true},[bindings[10]],null);
         watchers[5] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[4]],null);
         watchers[6] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","common_button_no"];
         },{"change":true},[bindings[4]],null);
         watchers[14] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[10]],null);
         watchers[15] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","champion_trading_requested_trade_title"];
         },{"change":true},[bindings[10]],null);
         watchers[4] = new PropertyWatcher("currentState",{"currentStateChange":true},[bindings[3],bindings[5],bindings[6],bindings[7],bindings[10]],propertyGetter);
         watchers[16] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[11]],null);
         watchers[17] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","common_button_cancel"];
         },{"change":true},[bindings[11]],null);
         watchers[2] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[2]],null);
         watchers[3] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","common_button_yes"];
         },{"change":true},[bindings[2]],null);
         watchers[10].updateParent(ResourceManager);
         watchers[11].parentWatcher = watchers[10];
         watchers[10].addChild(watchers[11]);
         watchers[8].updateParent(ResourceManager);
         watchers[9].parentWatcher = watchers[8];
         watchers[8].addChild(watchers[9]);
         watchers[12].updateParent(ResourceManager);
         watchers[13].parentWatcher = watchers[12];
         watchers[12].addChild(watchers[13]);
         watchers[5].updateParent(ResourceManager);
         watchers[6].parentWatcher = watchers[5];
         watchers[5].addChild(watchers[6]);
         watchers[14].updateParent(ResourceManager);
         watchers[15].parentWatcher = watchers[14];
         watchers[14].addChild(watchers[15]);
         watchers[4].updateParent(target);
         watchers[16].updateParent(ResourceManager);
         watchers[17].parentWatcher = watchers[16];
         watchers[16].addChild(watchers[17]);
         watchers[2].updateParent(ResourceManager);
         watchers[3].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[3]);
      }
   }
}

