package
{
   import com.riotgames.platform.gameclient.views.game.common.endofgame.EndOfGameTeamMemberRenderer;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameTeamMemberRendererWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameTeamMemberRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         EndOfGameTeamMemberRenderer.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameTeamMemberRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[8] = new PropertyWatcher("_giftButtonIsVisible",{"propertyChange":true},[bindings[4]],propertyGetter);
         watchers[10] = new PropertyWatcher("reportButton_visible",{"propertyChange":true},[bindings[6]],propertyGetter);
         watchers[17] = new PropertyWatcher("player",{"propertyChange":true},[bindings[16],bindings[11],bindings[12],bindings[14]],propertyGetter);
         watchers[18] = new PropertyWatcher("skinName",{"propertyChange":true},[bindings[11],bindings[12]],null);
         watchers[23] = new PropertyWatcher("summonerName",{"propertyChange":true},[bindings[14]],null);
         watchers[24] = new PropertyWatcher("leaver",{"propertyChange":true},[bindings[16]],null);
         watchers[25] = new PropertyWatcher("inChat",{"propertyChange":true},[bindings[16]],null);
         watchers[22] = new PropertyWatcher("teamTagText",null,[bindings[14]],null);
         watchers[3] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[2],bindings[8]],propertyGetter);
         watchers[4] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","cantAddBuddy_eog_ignoredUser"];
         },{"change":true},[bindings[2]],null);
         watchers[5] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","addBuddyWindow_infoLabel"];
         },{"change":true},[bindings[2]],null);
         watchers[6] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","cantAddBuddy_eog_alreadyFriends"];
         },{"change":true},[bindings[2]],null);
         watchers[12] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","summonerContext_reportPlayer_label"];
         },{"change":true},[bindings[8]],null);
         watchers[31] = new PropertyWatcher("showHandCursorOnPlayer",{"propertyChange":true},[bindings[22]],propertyGetter);
         watchers[1] = new PropertyWatcher("addBuddy_img_visible",{"propertyChange":true},[bindings[1]],propertyGetter);
         watchers[9] = new PropertyWatcher("_giftButtonToolTipText",{"propertyChange":true},[bindings[5]],propertyGetter);
         watchers[26] = new PropertyWatcher("isMe",{"propertyChange":true},[bindings[17]],propertyGetter);
         watchers[11] = new PropertyWatcher("reportEnabled",{"propertyChange":true},[bindings[7]],propertyGetter);
         watchers[13] = new PropertyWatcher("height",{"heightChanged":true},[bindings[9]],propertyGetter);
         watchers[28] = new PropertyWatcher("playerName_txt",{"propertyChange":true},[bindings[21],bindings[20]],propertyGetter);
         watchers[30] = new PropertyWatcher("height",{"heightChanged":true},[bindings[21]],null);
         watchers[29] = new PropertyWatcher("width",{"widthChanged":true},[bindings[20]],null);
         watchers[2] = new PropertyWatcher("isUserBlocked",{"propertyChange":true},[bindings[17],bindings[2]],propertyGetter);
         watchers[0] = new PropertyWatcher("enableAddFriend",{"propertyChange":true},[bindings[0],bindings[2]],propertyGetter);
         watchers[7] = new PropertyWatcher("_canEnableGiftButton",{"propertyChange":true},[bindings[3]],propertyGetter);
         watchers[14] = new PropertyWatcher("champ_img",{"propertyChange":true},[bindings[19],bindings[18],bindings[20],bindings[10],bindings[13],bindings[15]],propertyGetter);
         watchers[15] = new PropertyWatcher("height",{"heightChanged":true},[bindings[10]],null);
         watchers[21] = new PropertyWatcher("width",{"widthChanged":true},[bindings[20],bindings[13],bindings[15]],null);
         watchers[27] = new PropertyWatcher("y",{"yChanged":true},[bindings[19]],null);
         watchers[20] = new PropertyWatcher("x",{"xChanged":true},[bindings[18],bindings[13],bindings[15]],null);
         watchers[8].updateParent(target);
         watchers[10].updateParent(target);
         watchers[17].updateParent(target);
         watchers[17].addChild(watchers[18]);
         watchers[17].addChild(watchers[23]);
         watchers[17].addChild(watchers[24]);
         watchers[17].addChild(watchers[25]);
         watchers[17].addChild(watchers[22]);
         watchers[3].updateParent(target);
         watchers[4].parentWatcher = watchers[3];
         watchers[3].addChild(watchers[4]);
         watchers[5].parentWatcher = watchers[3];
         watchers[3].addChild(watchers[5]);
         watchers[6].parentWatcher = watchers[3];
         watchers[3].addChild(watchers[6]);
         watchers[12].parentWatcher = watchers[3];
         watchers[3].addChild(watchers[12]);
         watchers[31].updateParent(target);
         watchers[1].updateParent(target);
         watchers[9].updateParent(target);
         watchers[26].updateParent(target);
         watchers[11].updateParent(target);
         watchers[13].updateParent(target);
         watchers[28].updateParent(target);
         watchers[28].addChild(watchers[30]);
         watchers[28].addChild(watchers[29]);
         watchers[2].updateParent(target);
         watchers[0].updateParent(target);
         watchers[7].updateParent(target);
         watchers[14].updateParent(target);
         watchers[14].addChild(watchers[15]);
         watchers[14].addChild(watchers[21]);
         watchers[14].addChild(watchers[27]);
         watchers[14].addChild(watchers[20]);
      }
   }
}

