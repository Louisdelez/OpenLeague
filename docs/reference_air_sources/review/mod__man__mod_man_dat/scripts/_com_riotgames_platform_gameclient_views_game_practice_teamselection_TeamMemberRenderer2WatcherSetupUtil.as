package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.views.game.practice.teamselection.TeamMemberRenderer2;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import mx.resources.ResourceManager;
   
   public class _com_riotgames_platform_gameclient_views_game_practice_teamselection_TeamMemberRenderer2WatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_practice_teamselection_TeamMemberRenderer2WatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         TeamMemberRenderer2.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_practice_teamselection_TeamMemberRenderer2WatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[6] = new PropertyWatcher("teamSelectionController",{"propertyChange":true},[bindings[36],bindings[6],bindings[26],bindings[28],bindings[31],bindings[30]],propertyGetter);
         watchers[31] = new PropertyWatcher("canAddBotsToGame",{"canAddBotsChanged":true},[bindings[28]],null);
         watchers[29] = new PropertyWatcher("isBusy",{"propertyChange":true},[bindings[26],bindings[30]],null);
         watchers[7] = new PropertyWatcher("isOwner",{"propertyChange":true},[bindings[6],bindings[31]],null);
         watchers[36] = new PropertyWatcher("availableBotDifficulties",{"propertyChange":true},[bindings[36]],null);
         watchers[34] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[34],bindings[37]],propertyGetter);
         watchers[35] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_champion_prompt"];
         },{"change":true},[bindings[34]],null);
         watchers[37] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_botDifficulty_prompt"];
         },{"change":true},[bindings[37]],null);
         watchers[30] = new PropertyWatcher("canTakeSlot",{"propertyChange":true},[bindings[27]],propertyGetter);
         watchers[26] = new PropertyWatcher("_canDelegateInvitePower",{"propertyChange":true},[bindings[21],bindings[22]],propertyGetter);
         watchers[5] = new PropertyWatcher("isBot",{"propertyChange":true},[bindings[6],bindings[31]],propertyGetter);
         watchers[8] = new StaticPropertyWatcher("instance",null,[bindings[7]],null);
         watchers[23] = new PropertyWatcher("_canViewProfile",{"propertyChange":true},[bindings[17],bindings[18]],propertyGetter);
         watchers[18] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[13]],null);
         watchers[19] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_teamMemberRenderer_tooltip_kick"];
         },{"change":true},[bindings[13]],null);
         watchers[1] = new PropertyWatcher("isLastSlot",{"propertyChange":true},[bindings[1]],propertyGetter);
         watchers[2] = new PropertyWatcher("playerImageSource",{"propertyChange":true},[bindings[3]],propertyGetter);
         watchers[17] = new PropertyWatcher("_canKick",{"propertyChange":true},[bindings[11],bindings[12]],propertyGetter);
         watchers[20] = new PropertyWatcher("_canAddBuddy",{"propertyChange":true},[bindings[14],bindings[15]],propertyGetter);
         watchers[33] = new PropertyWatcher("championSelections",{"propertyChange":true},[bindings[33]],propertyGetter);
         watchers[10] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[8]],null);
         watchers[11] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_teamMemberRenderer_tooltip_owner"];
         },{"change":true},[bindings[8]],null);
         watchers[13] = new PropertyWatcher("gameOwner_img",{"propertyChange":true},[bindings[10]],propertyGetter);
         watchers[14] = new PropertyWatcher("visible",{
            "hide":true,
            "show":true
         },[bindings[10]],null);
         watchers[16] = new PropertyWatcher("width",{"widthChanged":true},[bindings[10]],null);
         watchers[15] = new PropertyWatcher("x",{"xChanged":true},[bindings[10]],null);
         watchers[27] = new PropertyWatcher("participantStats",{"propertyChange":true},[bindings[23]],propertyGetter);
         watchers[3] = new PropertyWatcher("summonerData",{"propertyChange":true},[bindings[4],bindings[5],bindings[9]],propertyGetter);
         watchers[4] = new PropertyWatcher("level",{"propertyChange":true},[bindings[4],bindings[5]],null);
         watchers[12] = new PropertyWatcher("summonerName",{"propertyChange":true},[bindings[9]],null);
         watchers[0] = new PropertyWatcher("participant",{"propertyChange":true},[bindings[0],bindings[1],bindings[2],bindings[6],bindings[24]],propertyGetter);
         watchers[21] = new FunctionReturnWatcher("getInstance",target,function():Array
         {
            return [];
         },null,[bindings[16]],null);
         watchers[22] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","practiceGame_teamMemberRenderer_tooltip_addFriend"];
         },{"change":true},[bindings[16]],null);
         watchers[6].updateParent(target);
         watchers[6].addChild(watchers[31]);
         watchers[6].addChild(watchers[29]);
         watchers[6].addChild(watchers[7]);
         watchers[6].addChild(watchers[36]);
         watchers[34].updateParent(target);
         watchers[35].parentWatcher = watchers[34];
         watchers[34].addChild(watchers[35]);
         watchers[37].parentWatcher = watchers[34];
         watchers[34].addChild(watchers[37]);
         watchers[30].updateParent(target);
         watchers[26].updateParent(target);
         watchers[5].updateParent(target);
         watchers[8].updateParent(ImagePackLookup);
         watchers[23].updateParent(target);
         watchers[18].updateParent(ResourceManager);
         watchers[19].parentWatcher = watchers[18];
         watchers[18].addChild(watchers[19]);
         watchers[1].updateParent(target);
         watchers[2].updateParent(target);
         watchers[17].updateParent(target);
         watchers[20].updateParent(target);
         watchers[33].updateParent(target);
         watchers[10].updateParent(ResourceManager);
         watchers[11].parentWatcher = watchers[10];
         watchers[10].addChild(watchers[11]);
         watchers[13].updateParent(target);
         watchers[13].addChild(watchers[14]);
         watchers[13].addChild(watchers[16]);
         watchers[13].addChild(watchers[15]);
         watchers[27].updateParent(target);
         watchers[3].updateParent(target);
         watchers[3].addChild(watchers[4]);
         watchers[3].addChild(watchers[12]);
         watchers[0].updateParent(target);
         watchers[21].updateParent(ResourceManager);
         watchers[22].parentWatcher = watchers[21];
         watchers[21].addChild(watchers[22]);
      }
   }
}

