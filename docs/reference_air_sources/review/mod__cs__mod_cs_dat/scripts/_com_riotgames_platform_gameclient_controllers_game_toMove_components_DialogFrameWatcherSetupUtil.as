package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.controllers.game.toMove.components.DialogFrame;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_controllers_game_toMove_components_DialogFrameWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_controllers_game_toMove_components_DialogFrameWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         DialogFrame.watcherSetupUtil = new _com_riotgames_platform_gameclient_controllers_game_toMove_components_DialogFrameWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[5] = new PropertyWatcher("dialogFrame",{"propertyChange":true},[param3[32],param3[18],param3[4],param3[36],param3[23],param3[37],param3[22],param3[7],param3[9],param3[28],param3[13],param3[15]],param2);
         param4[9] = new PropertyWatcher("height",{"heightChanged":true},[param3[32],param3[18],param3[23],param3[37],param3[7],param3[13]],null);
         param4[6] = new PropertyWatcher("width",{"widthChanged":true},[param3[4],param3[36],param3[22],param3[9],param3[28],param3[15]],null);
         param4[0] = new PropertyWatcher("xOffset",{"propertyChange":true},[param3[0]],param2);
         param4[3] = new PropertyWatcher("bl",{"propertyChange":true},[param3[2],param3[33],param3[4],param3[20],param3[6],param3[22],param3[25],param3[9],param3[12]],param2);
         param4[19] = new PropertyWatcher("showGripper",{"propertyChange":true},[param3[41]],param2);
         param4[1] = new StaticPropertyWatcher("instance",null,[param3[35],param3[1],param3[19],param3[5],param3[24],param3[40],param3[27],param3[10],param3[31],param3[14]],null);
         param4[10] = new PropertyWatcher("bb",{"propertyChange":true},[param3[34],param3[32],param3[18],param3[39],param3[23],param3[37],param3[7],param3[8],param3[13]],param2);
         param4[7] = new PropertyWatcher("br",{"propertyChange":true},[param3[17],param3[38],param3[4],param3[36],param3[22],param3[9],param3[29],param3[28],param3[15]],param2);
         param4[4] = new PropertyWatcher("bt",{"propertyChange":true},[param3[16],param3[18],param3[3],param3[21],param3[23],param3[26],param3[11],param3[13],param3[30]],param2);
         param4[5].updateParent(param1);
         param4[5].addChild(param4[9]);
         param4[5].addChild(param4[6]);
         param4[0].updateParent(param1);
         param4[3].updateParent(param1);
         param4[19].updateParent(param1);
         param4[1].updateParent(ImagePackLookup);
         param4[10].updateParent(param1);
         param4[7].updateParent(param1);
         param4[4].updateParent(param1);
      }
   }
}

