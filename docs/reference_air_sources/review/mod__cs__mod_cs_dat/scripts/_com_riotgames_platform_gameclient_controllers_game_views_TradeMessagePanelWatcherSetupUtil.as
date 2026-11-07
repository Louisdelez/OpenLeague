package
{
   import com.riotgames.platform.gameclient.controllers.game.views.TradeMessagePanel;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_controllers_game_views_TradeMessagePanelWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_controllers_game_views_TradeMessagePanelWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         TradeMessagePanel.watcherSetupUtil = new _com_riotgames_platform_gameclient_controllers_game_views_TradeMessagePanelWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[1] = new PropertyWatcher("message",{"propertyChange":true},[param3[1]],param2);
         param4[0] = new PropertyWatcher("title",{"propertyChange":true},[param3[0]],param2);
         param4[1].updateParent(param1);
         param4[0].updateParent(param1);
      }
   }
}

