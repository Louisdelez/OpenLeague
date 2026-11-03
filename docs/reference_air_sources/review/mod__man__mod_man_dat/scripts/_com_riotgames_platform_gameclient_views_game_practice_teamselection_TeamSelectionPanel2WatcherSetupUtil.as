package
{
   import com.riotgames.platform.gameclient.views.game.practice.teamselection.TeamSelectionPanel2;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_practice_teamselection_TeamSelectionPanel2WatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_practice_teamselection_TeamSelectionPanel2WatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         TeamSelectionPanel2.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_practice_teamselection_TeamSelectionPanel2WatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[1] = new PropertyWatcher("teamSelectionController",{"propertyChange":true},[param3[1],param3[3],param3[4],param3[6],param3[7],param3[9]],param2);
         param4[9] = new PropertyWatcher("spectatorTeamSlots",{"propertyChange":true},[param3[9]],null);
         param4[7] = new PropertyWatcher("chatRoom",{"propertyChange":true},[param3[6]],null);
         param4[2] = new PropertyWatcher("blueTeamSlots",{"propertyChange":true},[param3[1]],null);
         param4[5] = new PropertyWatcher("currentGameSpectatable",{"propertyChange":true},[param3[4],param3[7]],null);
         param4[4] = new PropertyWatcher("purpleTeamSlots",{"propertyChange":true},[param3[3]],null);
         param4[1].updateParent(param1);
         param4[1].addChild(param4[9]);
         param4[1].addChild(param4[7]);
         param4[1].addChild(param4[2]);
         param4[1].addChild(param4[5]);
         param4[1].addChild(param4[4]);
      }
   }
}

