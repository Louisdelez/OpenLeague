package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.controllers.game.toMove.GreenProgressBar;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_controllers_game_toMove_GreenProgressBarWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_controllers_game_toMove_GreenProgressBarWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         GreenProgressBar.watcherSetupUtil = new _com_riotgames_platform_gameclient_controllers_game_toMove_GreenProgressBarWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[4] = new PropertyWatcher("currentPercentage",{"propertyChange":true},[param3[2]],param2);
         param4[3] = new PropertyWatcher("width",{"widthChanged":true},[param3[2]],param2);
         param4[0] = new StaticPropertyWatcher("instance",null,[param3[0],param3[1],param3[3]],null);
         param4[4].updateParent(param1);
         param4[3].updateParent(param1);
         param4[0].updateParent(ImagePackLookup);
      }
   }
}

