package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.views.game.normal.CreateNormalArrangedGame;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_normal_CreateNormalArrangedGameWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_normal_CreateNormalArrangedGameWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         CreateNormalArrangedGame.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_normal_CreateNormalArrangedGameWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[4] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[17],bindings[2],bindings[7],bindings[13],bindings[14]],propertyGetter);
         watchers[5] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","normalGame_arrangedTeam_yourTeamHeaderLabel"];
         },{"change":true},[bindings[2]],null);
         watchers[25] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","normalGame_arrangedTeam_cancelButtonLabel"];
         },{"change":true},[bindings[13]],null);
         watchers[26] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","normalGame_arrangedTeam_cancelButton_tooltip"];
         },{"change":true},[bindings[14]],null);
         watchers[29] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","normalGame_arrangedTeam_startGameButtonLabel"];
         },{"change":true},[bindings[17]],null);
         watchers[12] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","normalGame_arrangedTeam_mapOptionsHeaderLabel"];
         },{"change":true},[bindings[7]],null);
         watchers[8] = new PropertyWatcher("isExpandedLayout",{"propertyChange":true},[bindings[4]],propertyGetter);
         watchers[2] = new StaticPropertyWatcher("instance",null,[bindings[1],bindings[6],bindings[8]],null);
         watchers[14] = new PropertyWatcher("masterGameController",{"propertyChange":true},[bindings[8]],propertyGetter);
         watchers[15] = new PropertyWatcher("gameModel",{"propertyChange":true},[bindings[8]],null);
         watchers[16] = new PropertyWatcher("gameMap",{"propertyChange":true},[bindings[8]],null);
         watchers[21] = new PropertyWatcher("inviteGroup",{"propertyChange":true},[bindings[18],bindings[11]],propertyGetter);
         watchers[23] = new PropertyWatcher("allowedToInvite",{"allowedToInviteChanged":true},[bindings[11]],null);
         watchers[22] = new PropertyWatcher("isOwner",{"isOwnerChanged":true},[bindings[18],bindings[11]],null);
         watchers[20] = new PropertyWatcher("htmlMapDescription",{"propertyChange":true},[bindings[10]],propertyGetter);
         watchers[6] = new PropertyWatcher("leftContent_c",{"propertyChange":true},[bindings[3]],propertyGetter);
         watchers[7] = new PropertyWatcher("height",{"heightChanged":true},[bindings[3]],null);
         watchers[24] = new PropertyWatcher("_showSuggestedPlayersPanel",{"propertyChange":true},[bindings[16],bindings[19],bindings[20],bindings[22],bindings[12]],propertyGetter);
         watchers[0] = new PropertyWatcher("statDetails",{"propertyChange":true},[bindings[0]],propertyGetter);
         watchers[1] = new PropertyWatcher("x",{"xChanged":true},[bindings[0]],null);
         watchers[9] = new PropertyWatcher("mapDetails",{"propertyChange":true},[bindings[5]],propertyGetter);
         watchers[10] = new PropertyWatcher("x",{"xChanged":true},[bindings[5]],null);
         watchers[17] = new PropertyWatcher("map_holder",{"propertyChange":true},[bindings[9]],propertyGetter);
         watchers[19] = new PropertyWatcher("height",{"heightChanged":true},[bindings[9]],null);
         watchers[18] = new PropertyWatcher("y",{"yChanged":true},[bindings[9]],null);
         watchers[27] = new PropertyWatcher("masterGameViewController",{"propertyChange":true},[bindings[15]],propertyGetter);
         watchers[28] = new PropertyWatcher("isBusy",{"propertyChange":true},[bindings[15]],null);
         watchers[4].updateParent(target);
         watchers[5].parentWatcher = watchers[4];
         watchers[4].addChild(watchers[5]);
         watchers[25].parentWatcher = watchers[4];
         watchers[4].addChild(watchers[25]);
         watchers[26].parentWatcher = watchers[4];
         watchers[4].addChild(watchers[26]);
         watchers[29].parentWatcher = watchers[4];
         watchers[4].addChild(watchers[29]);
         watchers[12].parentWatcher = watchers[4];
         watchers[4].addChild(watchers[12]);
         watchers[8].updateParent(target);
         watchers[2].updateParent(ImagePackLookup);
         watchers[14].updateParent(target);
         watchers[14].addChild(watchers[15]);
         watchers[15].addChild(watchers[16]);
         watchers[21].updateParent(target);
         watchers[21].addChild(watchers[23]);
         watchers[21].addChild(watchers[22]);
         watchers[20].updateParent(target);
         watchers[6].updateParent(target);
         watchers[6].addChild(watchers[7]);
         watchers[24].updateParent(target);
         watchers[0].updateParent(target);
         watchers[0].addChild(watchers[1]);
         watchers[9].updateParent(target);
         watchers[9].addChild(watchers[10]);
         watchers[17].updateParent(target);
         watchers[17].addChild(watchers[19]);
         watchers[17].addChild(watchers[18]);
         watchers[27].updateParent(target);
         watchers[27].addChild(watchers[28]);
      }
   }
}

