package
{
   import com.riotgames.platform.gameclient.module.rt.view.modal.DisbandTeamModal;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import mx.resources.ResourceManager;
   
   public class _com_riotgames_platform_gameclient_module_rt_view_modal_DisbandTeamModalWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_module_rt_view_modal_DisbandTeamModalWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         DisbandTeamModal.watcherSetupUtil = new _com_riotgames_platform_gameclient_module_rt_view_modal_DisbandTeamModalWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[3] = new PropertyWatcher("teamName",{"propertyChange":true},[bindings[3]],propertyGetter);
         watchers[5] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[4]],null);
         watchers[6] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","common_button_cancel"];
         },{"change":true},[bindings[4]],null);
         watchers[1] = new PropertyWatcher("width",{"widthChanged":true},[bindings[1],bindings[2]],propertyGetter);
         watchers[3].updateParent(target);
         watchers[5].updateParent(ResourceManager);
         watchers[6].parentWatcher = watchers[5];
         watchers[5].addChild(watchers[6]);
         watchers[1].updateParent(target);
      }
   }
}

