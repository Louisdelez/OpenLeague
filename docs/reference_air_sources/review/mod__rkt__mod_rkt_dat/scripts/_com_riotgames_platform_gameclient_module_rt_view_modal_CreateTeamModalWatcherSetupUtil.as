package
{
   import com.riotgames.platform.gameclient.module.rt.view.modal.CreateTeamModal;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_module_rt_view_modal_CreateTeamModalWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_module_rt_view_modal_CreateTeamModalWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         CreateTeamModal.watcherSetupUtil = new _com_riotgames_platform_gameclient_module_rt_view_modal_CreateTeamModalWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
      }
   }
}

