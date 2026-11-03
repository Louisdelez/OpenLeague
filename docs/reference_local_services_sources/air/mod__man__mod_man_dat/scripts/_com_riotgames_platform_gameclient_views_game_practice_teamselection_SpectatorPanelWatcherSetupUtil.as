package
{
   import com.riotgames.platform.gameclient.views.game.practice.teamselection.SpectatorPanel;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_practice_teamselection_SpectatorPanelWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_practice_teamselection_SpectatorPanelWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         SpectatorPanel.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_practice_teamselection_SpectatorPanelWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[0] = new PropertyWatcher("teamLabel",{"propertyChange":true},[param3[0]],param2);
         param4[1] = new PropertyWatcher("teamMembers",{"propertyChange":true},[param3[1]],param2);
         param4[0].updateParent(param1);
         param4[1].updateParent(param1);
      }
   }
}

