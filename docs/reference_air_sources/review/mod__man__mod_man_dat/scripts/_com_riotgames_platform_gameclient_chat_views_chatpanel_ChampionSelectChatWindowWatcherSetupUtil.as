package
{
   import com.riotgames.platform.gameclient.chat.views.chatpanel.ChampionSelectChatWindow;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_chat_views_chatpanel_ChampionSelectChatWindowWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_chat_views_chatpanel_ChampionSelectChatWindowWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ChampionSelectChatWindow.watcherSetupUtil = new _com_riotgames_platform_gameclient_chat_views_chatpanel_ChampionSelectChatWindowWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[8] = new PropertyWatcher("chatInput",{"propertyChange":true},[param3[5]],param2);
         param4[9] = new PropertyWatcher("width",{"widthChanged":true},[param3[5]],null);
         param4[1] = new PropertyWatcher("_chatRoom",{"propertyChange":true},[param3[1]],param2);
         param4[11] = new PropertyWatcher("textAreaContainer_c",{"propertyChange":true},[param3[6]],param2);
         param4[12] = new PropertyWatcher("chatRoomDisconnected",{"propertyChange":true},[param3[6]],null);
         param4[2] = new PropertyWatcher("sendChatMessage_btn",{"propertyChange":true},[param3[2],param3[3]],param2);
         param4[3] = new PropertyWatcher("height",{"heightChanged":true},[param3[2]],null);
         param4[6] = new PropertyWatcher("width",{"widthChanged":true},[param3[3]],null);
         param4[0] = new PropertyWatcher("_chatTitle",{"propertyChange":true},[param3[0]],param2);
         param4[4] = new PropertyWatcher("textEntry",{"propertyChange":true},[param3[3]],param2);
         param4[5] = new PropertyWatcher("width",{"widthChanged":true},[param3[3]],null);
         param4[10] = new PropertyWatcher("disabled",{"propertyChange":true},[param3[6]],param2);
         param4[8].updateParent(param1);
         param4[8].addChild(param4[9]);
         param4[1].updateParent(param1);
         param4[11].updateParent(param1);
         param4[11].addChild(param4[12]);
         param4[2].updateParent(param1);
         param4[2].addChild(param4[3]);
         param4[2].addChild(param4[6]);
         param4[0].updateParent(param1);
         param4[4].updateParent(param1);
         param4[4].addChild(param4[5]);
         param4[10].updateParent(param1);
      }
   }
}

