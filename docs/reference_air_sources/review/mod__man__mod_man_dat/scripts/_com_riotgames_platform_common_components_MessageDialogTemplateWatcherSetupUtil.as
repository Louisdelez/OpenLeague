package
{
   import com.riotgames.platform.common.components.MessageDialogTemplate;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_common_components_MessageDialogTemplateWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_common_components_MessageDialogTemplateWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         MessageDialogTemplate.watcherSetupUtil = new _com_riotgames_platform_common_components_MessageDialogTemplateWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[3] = new PropertyWatcher("headerText",{"propertyChange":true},[param3[6]],param2);
         param4[3].updateParent(param1);
      }
   }
}

