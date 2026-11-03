package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.views.game.common.endofgame.EndOfTutorialGameView;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfTutorialGameViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfTutorialGameViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         EndOfTutorialGameView.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfTutorialGameViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[7] = new PropertyWatcher("labelText",{"propertyChange":true},[bindings[6]],propertyGetter);
         watchers[2] = new PropertyWatcher("intructionsText",{"propertyChange":true},[bindings[1]],propertyGetter);
         watchers[13] = new PropertyWatcher("yes_btn",{"propertyChange":true},[bindings[10]],propertyGetter);
         watchers[14] = new PropertyWatcher("y",{"yChanged":true},[bindings[10]],null);
         watchers[10] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[8],bindings[9]],propertyGetter);
         watchers[11] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","common_button_yes"];
         },{"change":true},[bindings[8]],null);
         watchers[12] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","common_button_no"];
         },{"change":true},[bindings[9]],null);
         watchers[8] = new PropertyWatcher("buttonsCanvas",{"propertyChange":true},[bindings[7]],propertyGetter);
         watchers[9] = new PropertyWatcher("width",{"widthChanged":true},[bindings[7]],null);
         watchers[3] = new PropertyWatcher("width",{"widthChanged":true},[bindings[2],bindings[3],bindings[4]],propertyGetter);
         watchers[0] = new StaticPropertyWatcher("instance",null,[bindings[0]],null);
         watchers[4] = new PropertyWatcher("endTutorialInstructions",{"propertyChange":true},[bindings[5]],propertyGetter);
         watchers[6] = new PropertyWatcher("height",{"heightChanged":true},[bindings[5]],null);
         watchers[5] = new PropertyWatcher("y",{"yChanged":true},[bindings[5]],null);
         watchers[7].updateParent(target);
         watchers[2].updateParent(target);
         watchers[13].updateParent(target);
         watchers[13].addChild(watchers[14]);
         watchers[10].updateParent(target);
         watchers[11].parentWatcher = watchers[10];
         watchers[10].addChild(watchers[11]);
         watchers[12].parentWatcher = watchers[10];
         watchers[10].addChild(watchers[12]);
         watchers[8].updateParent(target);
         watchers[8].addChild(watchers[9]);
         watchers[3].updateParent(target);
         watchers[0].updateParent(ImagePackLookup);
         watchers[4].updateParent(target);
         watchers[4].addChild(watchers[6]);
         watchers[4].addChild(watchers[5]);
      }
   }
}

