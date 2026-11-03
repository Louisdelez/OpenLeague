package
{
   import com.riotgames.platform.gameclient.views.store.StoreHtmlView;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_store_StoreHtmlViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_store_StoreHtmlViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         StoreHtmlView.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_store_StoreHtmlViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[0] = new PropertyWatcher("parentApplication",{"initialize":true},[param3[0],param3[1],param3[2],param3[3]],param2);
         param4[1] = new PropertyWatcher("scaleX",null,[param3[0],param3[2]],null);
         param4[2] = new PropertyWatcher("scaleY",null,[param3[1],param3[3]],null);
         param4[0].updateParent(param1);
         param4[0].addChild(param4[1]);
         param4[0].addChild(param4[2]);
      }
   }
}

