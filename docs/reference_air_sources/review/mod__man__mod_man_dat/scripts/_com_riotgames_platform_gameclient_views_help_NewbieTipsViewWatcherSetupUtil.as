package
{
   import com.riotgames.platform.gameclient.views.help.NewbieTipsView;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_help_NewbieTipsViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_help_NewbieTipsViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         NewbieTipsView.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_help_NewbieTipsViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[8] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[6]],propertyGetter);
         watchers[9] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","newbieTip_footer_toggleOff"];
         },{"change":true},[bindings[6]],null);
         watchers[10] = new StaticPropertyWatcher("userPrefs",null,[bindings[7]],null);
         watchers[11] = new PropertyWatcher("newbieTipsEnabled",{"propertyChange":true},[bindings[7]],null);
         watchers[6] = new PropertyWatcher("toggleOff_chk",{"propertyChange":true},[bindings[5]],propertyGetter);
         watchers[7] = new PropertyWatcher("width",{"widthChanged":true},[bindings[5]],null);
         watchers[0] = new PropertyWatcher("newbieTipsController",{"propertyChange":true},[bindings[0],bindings[1],bindings[2],bindings[3],bindings[4]],propertyGetter);
         watchers[5] = new PropertyWatcher("tipContent",{"propertyChange":true},[bindings[4]],null);
         watchers[3] = new PropertyWatcher("yPos",{"propertyChange":true},[bindings[2]],null);
         watchers[2] = new PropertyWatcher("xPos",{"propertyChange":true},[bindings[1]],null);
         watchers[4] = new PropertyWatcher("tipHeader",{"propertyChange":true},[bindings[3]],null);
         watchers[1] = new PropertyWatcher("isOpen",{"propertyChange":true},[bindings[0]],null);
         watchers[8].updateParent(target);
         watchers[9].parentWatcher = watchers[8];
         watchers[8].addChild(watchers[9]);
         watchers[10].updateParent(UserPreferencesManager);
         watchers[10].addChild(watchers[11]);
         watchers[6].updateParent(target);
         watchers[6].addChild(watchers[7]);
         watchers[0].updateParent(target);
         watchers[0].addChild(watchers[5]);
         watchers[0].addChild(watchers[3]);
         watchers[0].addChild(watchers[2]);
         watchers[0].addChild(watchers[4]);
         watchers[0].addChild(watchers[1]);
      }
   }
}

