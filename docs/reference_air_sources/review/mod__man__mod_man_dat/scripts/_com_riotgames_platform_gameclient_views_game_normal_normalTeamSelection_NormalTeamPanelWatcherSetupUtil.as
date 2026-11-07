package
{
   import com.riotgames.platform.gameclient.views.game.normal.normalTeamSelection.NormalTeamPanel;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_normal_normalTeamSelection_NormalTeamPanelWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_normal_normalTeamSelection_NormalTeamPanelWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         NormalTeamPanel.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_normal_normalTeamSelection_NormalTeamPanelWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[2] = new PropertyWatcher("isExpandedLayout",{"propertyChange":true},[param3[1],param3[2],param3[3]],param2);
         param4[1] = new PropertyWatcher("acceptedParticipants",{"propertyChange":true},[param3[0]],null);
         param4[2].updateParent(param1);
         param4[1].updateParent(param2.apply(param1,["_inviteGroup"]));
      }
   }
}

