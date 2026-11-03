package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.views.store.StoreView;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_store_StoreViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_store_StoreViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         StoreView.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_store_StoreViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[4] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[3]],propertyGetter);
         watchers[5] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","store_loading_message"];
         },{"change":true},[bindings[3]],null);
         watchers[0] = new PropertyWatcher("location",{"locationChange":true},[bindings[0]],propertyGetter);
         watchers[1] = new PropertyWatcher("loadingStoreUrl",{"propertyChange":true},[bindings[1]],propertyGetter);
         watchers[2] = new StaticPropertyWatcher("instance",null,[bindings[2]],null);
         watchers[4].updateParent(target);
         watchers[5].parentWatcher = watchers[4];
         watchers[4].addChild(watchers[5]);
         watchers[0].updateParent(target);
         watchers[1].updateParent(target);
         watchers[2].updateParent(ImagePackLookup);
      }
   }
}

