package
{
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.gameclient.views.application.ApplicationContentView;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_application_ApplicationContentViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_application_ApplicationContentViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ApplicationContentView.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_application_ApplicationContentViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[0] = new StaticPropertyWatcher("instance",null,[param3[0]],null);
         param4[1] = new PropertyWatcher("currentAppState",{"propertyChange":true},[param3[0]],null);
         param4[12] = new PropertyWatcher("currentState",{"currentStateChange":true},[param3[11],param3[12],param3[13],param3[14]],param2);
         param4[0].updateParent(AppConfig);
         param4[0].addChild(param4[1]);
         param4[12].updateParent(param1);
      }
   }
}

