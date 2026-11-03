package
{
   import com.riotgames.platform.gameclient.views.game.practice.teamselection.SpectatorMemberRenderer;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import mx.resources.ResourceManager;
   
   public class _com_riotgames_platform_gameclient_views_game_practice_teamselection_SpectatorMemberRendererWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_practice_teamselection_SpectatorMemberRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         SpectatorMemberRenderer.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_practice_teamselection_SpectatorMemberRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[10] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[7]],null);
         watchers[11] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_teamMemberRenderer_tooltip_addFriend"];
         },{"change":true},[bindings[7]],null);
         watchers[4] = new PropertyWatcher("teamSelectionController",{"propertyChange":true},[bindings[2],bindings[12]],propertyGetter);
         watchers[16] = new PropertyWatcher("isBusy",{"propertyChange":true},[bindings[12]],null);
         watchers[5] = new PropertyWatcher("isOwner",{"propertyChange":true},[bindings[2]],null);
         watchers[9] = new PropertyWatcher("isBuddy",{"propertyChange":true},[bindings[6]],propertyGetter);
         watchers[8] = new PropertyWatcher("playerImagePath",{"propertyChange":true},[bindings[5]],propertyGetter);
         watchers[6] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[3]],null);
         watchers[7] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_teamMemberRenderer_tooltip_owner"];
         },{"change":true},[bindings[3]],null);
         watchers[13] = new PropertyWatcher("summonerData",{"propertyChange":true},[bindings[9]],propertyGetter);
         watchers[14] = new PropertyWatcher("summonerName",{"propertyChange":true},[bindings[9]],null);
         watchers[1] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[1]],null);
         watchers[2] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_teamMemberRenderer_tooltip_kick"];
         },{"change":true},[bindings[1]],null);
         watchers[0] = new PropertyWatcher("participant",{"propertyChange":true},[bindings[0],bindings[2],bindings[4],bindings[10]],propertyGetter);
         watchers[3] = new PropertyWatcher("isGameOwner",{"propertyChange":true},[bindings[2],bindings[4]],null);
         watchers[10].updateParent(ResourceManager);
         watchers[11].parentWatcher = watchers[10];
         watchers[10].addChild(watchers[11]);
         watchers[4].updateParent(target);
         watchers[4].addChild(watchers[16]);
         watchers[4].addChild(watchers[5]);
         watchers[9].updateParent(target);
         watchers[8].updateParent(target);
         watchers[6].updateParent(ResourceManager);
         watchers[7].parentWatcher = watchers[6];
         watchers[6].addChild(watchers[7]);
         watchers[13].updateParent(target);
         watchers[13].addChild(watchers[14]);
         watchers[1].updateParent(ResourceManager);
         watchers[2].parentWatcher = watchers[1];
         watchers[1].addChild(watchers[2]);
         watchers[0].updateParent(target);
         watchers[0].addChild(watchers[3]);
      }
   }
}

