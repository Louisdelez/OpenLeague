package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.views.summoner.wizard.PlayTutorialGame;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_summoner_wizard_PlayTutorialGameWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_summoner_wizard_PlayTutorialGameWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         PlayTutorialGame.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_summoner_wizard_PlayTutorialGameWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[4] = new PropertyWatcher("tutorialMessage",{"propertyChange":true},[bindings[2]],propertyGetter);
         watchers[2] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[1],bindings[3],bindings[4]],propertyGetter);
         watchers[3] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","playTutorial_header"];
         },{"change":true},[bindings[1]],null);
         watchers[5] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","common_button_yes"];
         },{"change":true},[bindings[3]],null);
         watchers[6] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","common_button_no"];
         },{"change":true},[bindings[4]],null);
         watchers[0] = new StaticPropertyWatcher("instance",null,[bindings[0]],null);
         watchers[4].updateParent(target);
         watchers[2].updateParent(target);
         watchers[3].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[3]);
         watchers[5].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[5]);
         watchers[6].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[6]);
         watchers[0].updateParent(ImagePackLookup);
      }
   }
}

