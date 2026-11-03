package
{
   import com.riotgames.platform.gameclient.module.rt.view.modal.PromoteCaptainModal;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import mx.resources.ResourceManager;
   
   public class _com_riotgames_platform_gameclient_module_rt_view_modal_PromoteCaptainModalWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_module_rt_view_modal_PromoteCaptainModalWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         PromoteCaptainModal.watcherSetupUtil = new _com_riotgames_platform_gameclient_module_rt_view_modal_PromoteCaptainModalWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[2] = new PropertyWatcher("messageText",{"propertyChange":true},[bindings[3]],propertyGetter);
         watchers[4] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[5]],null);
         watchers[5] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","common_button_cancel"];
         },{"change":true},[bindings[5]],null);
         watchers[1] = new PropertyWatcher("width",{"widthChanged":true},[bindings[1],bindings[2]],propertyGetter);
         watchers[3] = new PropertyWatcher("canidates",{"propertyChange":true},[bindings[4]],propertyGetter);
         watchers[6] = new PropertyWatcher("confirmButtonText",{"propertyChange":true},[bindings[6]],propertyGetter);
         watchers[2].updateParent(target);
         watchers[4].updateParent(ResourceManager);
         watchers[5].parentWatcher = watchers[4];
         watchers[4].addChild(watchers[5]);
         watchers[1].updateParent(target);
         watchers[3].updateParent(target);
         watchers[6].updateParent(target);
      }
   }
}

