package
{
   import com.riotgames.platform.gameclient.views.game.common.endofgame.EndOfGamePlayerTooltip;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGamePlayerTooltipWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGamePlayerTooltipWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         EndOfGamePlayerTooltip.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGamePlayerTooltipWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[7] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[4],bindings[6]],propertyGetter);
         watchers[8] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","BuddyListTooltip_summonerLevel",[target.data.level]];
         },{"change":true},[bindings[4]],null);
         watchers[11] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","endofgame_player_tooltip_clicktofriend"];
         },{"change":true},[bindings[6]],null);
         watchers[2] = new PropertyWatcher("profileIcon",{"propertyChange":true},[bindings[1]],propertyGetter);
         watchers[3] = new PropertyWatcher("height",{"heightChanged":true},[bindings[1]],null);
         watchers[4] = new PropertyWatcher("profileIconSource",{"propertyChange":true},[bindings[2]],propertyGetter);
         watchers[5] = new PropertyWatcher("data",{"dataChange":true},[bindings[3],bindings[4]],propertyGetter);
         watchers[9] = new PropertyWatcher("level",null,[bindings[4]],null);
         watchers[6] = new PropertyWatcher("summonerName",null,[bindings[3]],null);
         watchers[10] = new PropertyWatcher("winsHTMLText",{"propertyChange":true},[bindings[5]],propertyGetter);
         watchers[0] = new PropertyWatcher("colImage",{"propertyChange":true},[bindings[0]],propertyGetter);
         watchers[1] = new PropertyWatcher("width",{"widthChanged":true},[bindings[0]],null);
         watchers[7].updateParent(target);
         watchers[8].parentWatcher = watchers[7];
         watchers[7].addChild(watchers[8]);
         watchers[11].parentWatcher = watchers[7];
         watchers[7].addChild(watchers[11]);
         watchers[2].updateParent(target);
         watchers[2].addChild(watchers[3]);
         watchers[4].updateParent(target);
         watchers[5].updateParent(target);
         watchers[5].addChild(watchers[9]);
         watchers[5].addChild(watchers[6]);
         watchers[10].updateParent(target);
         watchers[0].updateParent(target);
         watchers[0].addChild(watchers[1]);
      }
   }
}

