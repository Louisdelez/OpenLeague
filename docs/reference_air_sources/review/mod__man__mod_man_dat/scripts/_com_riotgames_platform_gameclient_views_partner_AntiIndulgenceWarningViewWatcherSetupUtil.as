package
{
   import com.riotgames.platform.gameclient.views.partner.AntiIndulgenceWarningView;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_partner_AntiIndulgenceWarningViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_partner_AntiIndulgenceWarningViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         AntiIndulgenceWarningView.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_partner_AntiIndulgenceWarningViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[1] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[1]],propertyGetter);
         watchers[2] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources",target.antiIndulgenceMessage.messageKey,[target.antiIndulgenceMessage.messageArgument]];
         },{"change":true},[bindings[1]],null);
         watchers[0] = new PropertyWatcher("antiIndulgenceMessage",{"propertyChange":true},[bindings[0],bindings[1]],propertyGetter);
         watchers[4] = new PropertyWatcher("messageArgument",{"propertyChange":true},[bindings[1]],null);
         watchers[3] = new PropertyWatcher("messageKey",{"propertyChange":true},[bindings[1]],null);
         watchers[1].updateParent(target);
         watchers[2].parentWatcher = watchers[1];
         watchers[1].addChild(watchers[2]);
         watchers[0].updateParent(target);
         watchers[0].addChild(watchers[4]);
         watchers[0].addChild(watchers[3]);
      }
   }
}

