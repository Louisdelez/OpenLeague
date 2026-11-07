package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.views.game.common.invite.InviteePanel;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_common_invite_InviteePanelWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_common_invite_InviteePanelWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         InviteePanel.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_common_invite_InviteePanelWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[16] = new PropertyWatcher("_showSuggestedPlayersPanel",{"propertyChange":true},[bindings[17],bindings[16],bindings[19],bindings[18],bindings[14],bindings[15]],propertyGetter);
         watchers[3] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[2],bindings[4],bindings[5],bindings[13]],propertyGetter);
         watchers[4] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","inviteePanel_inviteBuddies_label"];
         },{"change":true},[bindings[2]],null);
         watchers[5] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","inviteePanel_inviteBuddies_label"];
         },{"change":true},[bindings[4]],null);
         watchers[8] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","inviteePanel_inviteBuddies_tooltip"];
         },{"change":true},[bindings[5]],null);
         watchers[9] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","inviteePanel_inviteBuddiesDisconnected_tooltip"];
         },{"change":true},[bindings[5]],null);
         watchers[15] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","normalGame_arrangedTeam_suggestedPlayers_header"];
         },{"change":true},[bindings[13]],null);
         watchers[17] = new PropertyWatcher("_suggestedPlayersDataProvider",{"propertyChange":true},[bindings[21],bindings[20]],propertyGetter);
         watchers[18] = new PropertyWatcher("length",{"collectionChange":true},[bindings[21]],null);
         watchers[6] = new PropertyWatcher("_inviteGroup",{"propertyChange":true},[bindings[5],bindings[7],bindings[10],bindings[11]],propertyGetter);
         watchers[12] = new PropertyWatcher("allParticipants",{"propertyChange":true},[bindings[10],bindings[11]],null);
         watchers[13] = new PropertyWatcher("length",{"collectionChange":true},[bindings[11]],null);
         watchers[7] = new PropertyWatcher("isInviteActive",{"isInviteActiveChanged":true},[bindings[5],bindings[7]],null);
         watchers[0] = new StaticPropertyWatcher("instance",null,[bindings[0]],null);
         watchers[2] = new PropertyWatcher("allowedtoInvite",{"propertyChange":true},[bindings[1],bindings[3],bindings[6]],propertyGetter);
         watchers[16].updateParent(target);
         watchers[3].updateParent(target);
         watchers[4].parentWatcher = watchers[3];
         watchers[3].addChild(watchers[4]);
         watchers[5].parentWatcher = watchers[3];
         watchers[3].addChild(watchers[5]);
         watchers[8].parentWatcher = watchers[3];
         watchers[3].addChild(watchers[8]);
         watchers[9].parentWatcher = watchers[3];
         watchers[3].addChild(watchers[9]);
         watchers[15].parentWatcher = watchers[3];
         watchers[3].addChild(watchers[15]);
         watchers[17].updateParent(target);
         watchers[17].addChild(watchers[18]);
         watchers[6].updateParent(target);
         watchers[6].addChild(watchers[12]);
         watchers[12].addChild(watchers[13]);
         watchers[6].addChild(watchers[7]);
         watchers[0].updateParent(ImagePackLookup);
         watchers[2].updateParent(target);
      }
   }
}

