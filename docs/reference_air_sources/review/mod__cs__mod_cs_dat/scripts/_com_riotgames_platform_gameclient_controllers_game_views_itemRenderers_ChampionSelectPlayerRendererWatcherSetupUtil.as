package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.controllers.game.views.itemRenderers.ChampionSelectPlayerRenderer;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_controllers_game_views_itemRenderers_ChampionSelectPlayerRendererWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_controllers_game_views_itemRenderers_ChampionSelectPlayerRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ChampionSelectPlayerRenderer.watcherSetupUtil = new _com_riotgames_platform_gameclient_controllers_game_views_itemRenderers_ChampionSelectPlayerRendererWatcherSetupUtil();
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
            return ["resources","championSelection_clientOutOfSyncTooltipDisplay"];
         },{"change":true},[bindings[1]],null);
         watchers[0] = new StaticPropertyWatcher("instance",null,[bindings[0]],null);
         watchers[2].updateParent(target);
         watchers[3].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[3]);
         watchers[0].updateParent(ImagePackLookup);
      }
   }
}

