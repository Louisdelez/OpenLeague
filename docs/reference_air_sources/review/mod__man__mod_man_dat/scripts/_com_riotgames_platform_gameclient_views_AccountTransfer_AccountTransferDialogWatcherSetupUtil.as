package
{
   import com.riotgames.platform.gameclient.views.AccountTransfer.AccountTransferDialog;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_AccountTransfer_AccountTransferDialogWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_AccountTransfer_AccountTransferDialogWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         AccountTransferDialog.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_AccountTransfer_AccountTransferDialogWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[0] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[0],bindings[1]],propertyGetter);
         watchers[1] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","transfer_service_dialog_title"];
         },{"change":true},[bindings[0]],null);
         watchers[2] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","transfer_service_description"];
         },{"change":true},[bindings[1]],null);
         watchers[0].updateParent(target);
         watchers[1].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[1]);
         watchers[2].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[2]);
      }
   }
}

