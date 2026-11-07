package
{
   import com.riotgames.platform.gameclient.module.rt.view.modal.TwoButtonGenericModal;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_module_rt_view_modal_TwoButtonGenericModalWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_module_rt_view_modal_TwoButtonGenericModalWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         TwoButtonGenericModal.watcherSetupUtil = new _com_riotgames_platform_gameclient_module_rt_view_modal_TwoButtonGenericModalWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[2] = new PropertyWatcher("width",{"widthChanged":true},[param3[1]],param2);
         param4[0] = new PropertyWatcher("parameters",{"propertyChange":true},[param3[0],param3[2],param3[3],param3[4],param3[5],param3[6]],param2);
         param4[4] = new PropertyWatcher("leftButtonLabel",{"propertyChange":true},[param3[3],param3[4]],null);
         param4[3] = new PropertyWatcher("message",{"propertyChange":true},[param3[2]],null);
         param4[1] = new PropertyWatcher("title",{"propertyChange":true},[param3[0]],null);
         param4[5] = new PropertyWatcher("rightButtonLabel",{"propertyChange":true},[param3[5],param3[6]],null);
         param4[2].updateParent(param1);
         param4[0].updateParent(param1);
         param4[0].addChild(param4[4]);
         param4[0].addChild(param4[3]);
         param4[0].addChild(param4[1]);
         param4[0].addChild(param4[5]);
      }
   }
}

