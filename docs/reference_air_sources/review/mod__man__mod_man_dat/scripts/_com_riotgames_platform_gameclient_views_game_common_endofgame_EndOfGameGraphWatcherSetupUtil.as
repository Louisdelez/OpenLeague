package
{
   import com.riotgames.platform.gameclient.views.game.common.endofgame.EndOfGameGraph;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameGraphWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameGraphWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         EndOfGameGraph.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameGraphWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[4] = new PropertyWatcher("maximumStatDisplay",{"propertyChange":true},[param3[2],param3[3],param3[5],param3[7],param3[8],param3[10],param3[12],param3[13],param3[15],param3[17],param3[18],param3[20],param3[22],param3[25],param3[28],param3[31]],param2);
         param4[1] = new PropertyWatcher("friendlyGraphCanvas",{"propertyChange":true},[param3[34],param3[35],param3[1],param3[33],param3[4],param3[6],param3[9],param3[21],param3[23],param3[24],param3[27],param3[29],param3[30]],param2);
         param4[5] = new PropertyWatcher("width",{"widthChanged":true},[param3[33],param3[21],param3[4],param3[23],param3[6],param3[24],param3[9],param3[27],param3[29],param3[30]],null);
         param4[15] = new PropertyWatcher("y",{"yChanged":true},[param3[35]],null);
         param4[2] = new PropertyWatcher("x",{"xChanged":true},[param3[34],param3[1],param3[4],param3[6],param3[9]],null);
         param4[8] = new PropertyWatcher("enemyGraphCanvas",{"propertyChange":true},[param3[16],param3[19],param3[11],param3[14]],param2);
         param4[11] = new PropertyWatcher("width",{"widthChanged":true},[param3[16],param3[19],param3[14]],null);
         param4[9] = new PropertyWatcher("x",{"xChanged":true},[param3[16],param3[19],param3[11],param3[14]],null);
         param4[4].updateParent(param1);
         param4[1].updateParent(param1);
         param4[1].addChild(param4[5]);
         param4[1].addChild(param4[15]);
         param4[1].addChild(param4[2]);
         param4[8].updateParent(param1);
         param4[8].addChild(param4[11]);
         param4[8].addChild(param4[9]);
      }
   }
}

