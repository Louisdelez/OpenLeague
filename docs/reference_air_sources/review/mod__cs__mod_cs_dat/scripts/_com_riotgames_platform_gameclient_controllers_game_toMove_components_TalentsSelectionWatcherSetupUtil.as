package
{
   import com.riotgames.platform.gameclient.controllers.game.toMove.components.TalentsSelection;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.Application;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_controllers_game_toMove_components_TalentsSelectionWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_controllers_game_toMove_components_TalentsSelectionWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         TalentsSelection.watcherSetupUtil = new _com_riotgames_platform_gameclient_controllers_game_toMove_components_TalentsSelectionWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[1] = new PropertyWatcher("scaleX",null,[param3[0]],param2);
         param4[2] = new PropertyWatcher("scaleY",null,[param3[1]],param2);
         param4[3] = new PropertyWatcher("deactivated",{"propertyChange":true},[param3[2],param3[3]],param2);
         param4[0] = new StaticPropertyWatcher("application",null,[param3[0],param3[1]],null);
         param4[1].updateParent(param1);
         param4[2].updateParent(param1);
         param4[3].updateParent(param1);
         param4[0].updateParent(Application);
      }
   }
}

