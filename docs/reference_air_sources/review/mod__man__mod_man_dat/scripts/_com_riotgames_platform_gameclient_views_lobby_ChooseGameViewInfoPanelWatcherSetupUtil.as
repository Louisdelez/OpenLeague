package
{
   import com.riotgames.platform.gameclient.views.lobby.ChooseGameViewInfoPanel;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_lobby_ChooseGameViewInfoPanelWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_lobby_ChooseGameViewInfoPanelWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ChooseGameViewInfoPanel.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_lobby_ChooseGameViewInfoPanelWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[8] = new PropertyWatcher("modeDescriptionLabel",{"propertyChange":true},[param3[6]],param2);
         param4[10] = new PropertyWatcher("height",{"heightChanged":true},[param3[6]],null);
         param4[9] = new PropertyWatcher("y",{"yChanged":true},[param3[6]],null);
         param4[1] = new PropertyWatcher("chooseGameFlowViewController",{"propertyChange":true},[param3[1],param3[2],param3[5],param3[7]],param2);
         param4[3] = new PropertyWatcher("gameMapDisplayName",{"propertyChange":true},[param3[2]],null);
         param4[11] = new PropertyWatcher("gameMapDisplayDescription",{"propertyChange":true},[param3[7]],null);
         param4[7] = new PropertyWatcher("gameModeDisplayDescription",{"propertyChange":true},[param3[5]],null);
         param4[2] = new PropertyWatcher("gameModeDisplayName",{"propertyChange":true},[param3[1]],null);
         param4[5] = new PropertyWatcher("modeLabel",{"propertyChange":true},[param3[4]],param2);
         param4[6] = new PropertyWatcher("text",{"valueCommit":true},[param3[4]],null);
         param4[8].updateParent(param1);
         param4[8].addChild(param4[10]);
         param4[8].addChild(param4[9]);
         param4[1].updateParent(param1);
         param4[1].addChild(param4[3]);
         param4[1].addChild(param4[11]);
         param4[1].addChild(param4[7]);
         param4[1].addChild(param4[2]);
         param4[5].updateParent(param1);
         param4[5].addChild(param4[6]);
      }
   }
}

