package
{
   import com.riotgames.platform.gameclient.controllers.game.views.RuneStatsTooltip;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_controllers_game_views_RuneStatsTooltipWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_controllers_game_views_RuneStatsTooltipWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         RuneStatsTooltip.watcherSetupUtil = new _com_riotgames_platform_gameclient_controllers_game_views_RuneStatsTooltipWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[2] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[1]],propertyGetter);
         watchers[3] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","runebook_book_statsHeaderLabel"];
         },{"change":true},[bindings[1]],null);
         watchers[4] = new PropertyWatcher("statsArray",{"propertyChange":true},[bindings[2],bindings[3]],propertyGetter);
         watchers[5] = new PropertyWatcher("length",{"collectionChange":true},[bindings[2]],null);
         watchers[0] = new PropertyWatcher("data",{"dataChange":true},[bindings[0]],propertyGetter);
         watchers[1] = new PropertyWatcher("displayName",null,[bindings[0]],null);
         watchers[2].updateParent(target);
         watchers[3].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[3]);
         watchers[4].updateParent(target);
         watchers[4].addChild(watchers[5]);
         watchers[0].updateParent(target);
         watchers[0].addChild(watchers[1]);
      }
   }
}

