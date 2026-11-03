package
{
   import com.riotgames.platform.gameclient.controllers.game.views.ChampionSelectPlayerList;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_controllers_game_views_ChampionSelectPlayerListWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_controllers_game_views_ChampionSelectPlayerListWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ChampionSelectPlayerList.watcherSetupUtil = new _com_riotgames_platform_gameclient_controllers_game_views_ChampionSelectPlayerListWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[3] = new PropertyWatcher("playerHeight",{"propertyChange":true},[param3[1],param3[3],param3[5],param3[7],param3[9]],param2);
         param4[1] = new PropertyWatcher("player0",{"propertyChange":true},[param3[1]],param2);
         param4[2] = new PropertyWatcher("y",{"yChanged":true},[param3[1]],null);
         param4[4] = new PropertyWatcher("player1",{"propertyChange":true},[param3[3]],param2);
         param4[5] = new PropertyWatcher("y",{"yChanged":true},[param3[3]],null);
         param4[6] = new PropertyWatcher("player2",{"propertyChange":true},[param3[5]],param2);
         param4[7] = new PropertyWatcher("y",{"yChanged":true},[param3[5]],null);
         param4[8] = new PropertyWatcher("player3",{"propertyChange":true},[param3[7]],param2);
         param4[9] = new PropertyWatcher("y",{"yChanged":true},[param3[7]],null);
         param4[10] = new PropertyWatcher("player4",{"propertyChange":true},[param3[9]],param2);
         param4[11] = new PropertyWatcher("y",{"yChanged":true},[param3[9]],null);
         param4[0] = new PropertyWatcher("isSpectating",{"propertyChange":true},[param3[0],param3[2],param3[4],param3[6],param3[8],param3[10]],param2);
         param4[3].updateParent(param1);
         param4[1].updateParent(param1);
         param4[1].addChild(param4[2]);
         param4[4].updateParent(param1);
         param4[4].addChild(param4[5]);
         param4[6].updateParent(param1);
         param4[6].addChild(param4[7]);
         param4[8].updateParent(param1);
         param4[8].addChild(param4[9]);
         param4[10].updateParent(param1);
         param4[10].addChild(param4[11]);
         param4[0].updateParent(param1);
      }
   }
}

