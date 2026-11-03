package
{
   import com.riotgames.platform.gameclient.views.lobby.landing.StoryView;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_lobby_landing_StoryViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_lobby_landing_StoryViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         StoryView.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_lobby_landing_StoryViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[1] = new PropertyWatcher("htmlLandingPanel",{"propertyChange":true},[bindings[1]],propertyGetter);
         watchers[2] = new PropertyWatcher("alpha",{"alphaChanged":true},[bindings[1]],null);
         watchers[5] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[2]],propertyGetter);
         watchers[6] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","storyPageURL",target.clientConfig.localetarget.substr(0,2) == "en"[""][target.clientConfig.localetarget.substr(0,2)]];
         },{"change":true},[bindings[2]],null);
         watchers[3] = new PropertyWatcher("clientConfig",{"propertyChange":true},[bindings[2]],propertyGetter);
         watchers[4] = new PropertyWatcher("storyPageURL",{"propertyChange":true},[bindings[2]],null);
         watchers[7] = new PropertyWatcher("locale",{"propertyChange":true},[bindings[2]],null);
         watchers[10] = new PropertyWatcher("parentApplication",{"initialize":true},[bindings[3],bindings[4]],propertyGetter);
         watchers[11] = new PropertyWatcher("scaleX",null,[bindings[3]],null);
         watchers[12] = new PropertyWatcher("scaleY",null,[bindings[4]],null);
         watchers[1].updateParent(target);
         watchers[1].addChild(watchers[2]);
         watchers[5].updateParent(target);
         watchers[6].parentWatcher = watchers[5];
         watchers[5].addChild(watchers[6]);
         watchers[3].updateParent(target);
         watchers[3].addChild(watchers[4]);
         watchers[3].addChild(watchers[7]);
         watchers[10].updateParent(target);
         watchers[10].addChild(watchers[11]);
         watchers[10].addChild(watchers[12]);
      }
   }
}

