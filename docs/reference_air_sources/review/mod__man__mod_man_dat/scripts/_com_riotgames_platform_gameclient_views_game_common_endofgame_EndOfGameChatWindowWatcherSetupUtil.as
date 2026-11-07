package
{
   import com.riotgames.platform.gameclient.views.game.common.endofgame.EndOfGameChatWindow;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameChatWindowWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameChatWindowWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         EndOfGameChatWindow.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameChatWindowWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[7] = new PropertyWatcher("chatInput",{"propertyChange":true},[bindings[4]],propertyGetter);
         watchers[8] = new PropertyWatcher("width",{"widthChanged":true},[bindings[4]],null);
         watchers[9] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[5],bindings[6],bindings[9]],propertyGetter);
         watchers[10] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","chat_groupChatWindow_sendButton_label"];
         },{"change":true},[bindings[5]],null);
         watchers[11] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","chat_groupChatWindow_sendButton_tooltip"];
         },{"change":true},[bindings[6]],null);
         watchers[15] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","chat_groupChatWindow_disconnectedUnknown"];
         },{"change":true},[bindings[9]],null);
         watchers[0] = new PropertyWatcher("_chatRoom",{"propertyChange":true},[bindings[0]],propertyGetter);
         watchers[13] = new PropertyWatcher("textAreaContainer_c",{"propertyChange":true},[bindings[7],bindings[8]],propertyGetter);
         watchers[14] = new PropertyWatcher("chatRoomDisconnected",{"propertyChange":true},[bindings[7],bindings[8]],null);
         watchers[1] = new PropertyWatcher("sendChatMessage_btn",{"propertyChange":true},[bindings[1],bindings[2]],propertyGetter);
         watchers[2] = new PropertyWatcher("height",{"heightChanged":true},[bindings[1]],null);
         watchers[5] = new PropertyWatcher("width",{"widthChanged":true},[bindings[2]],null);
         watchers[3] = new PropertyWatcher("textEntry",{"propertyChange":true},[bindings[2]],propertyGetter);
         watchers[4] = new PropertyWatcher("width",{"widthChanged":true},[bindings[2]],null);
         watchers[12] = new PropertyWatcher("disabled",{"propertyChange":true},[bindings[7]],propertyGetter);
         watchers[7].updateParent(target);
         watchers[7].addChild(watchers[8]);
         watchers[9].updateParent(target);
         watchers[10].parentWatcher = watchers[9];
         watchers[9].addChild(watchers[10]);
         watchers[11].parentWatcher = watchers[9];
         watchers[9].addChild(watchers[11]);
         watchers[15].parentWatcher = watchers[9];
         watchers[9].addChild(watchers[15]);
         watchers[0].updateParent(target);
         watchers[13].updateParent(target);
         watchers[13].addChild(watchers[14]);
         watchers[1].updateParent(target);
         watchers[1].addChild(watchers[2]);
         watchers[1].addChild(watchers[5]);
         watchers[3].updateParent(target);
         watchers[3].addChild(watchers[4]);
         watchers[12].updateParent(target);
      }
   }
}

