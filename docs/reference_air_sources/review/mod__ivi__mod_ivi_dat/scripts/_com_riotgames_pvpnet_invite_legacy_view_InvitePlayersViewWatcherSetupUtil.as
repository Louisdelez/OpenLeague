package
{
   import com.riotgames.pvpnet.invite.legacy.controller.InviteBayController;
   import com.riotgames.pvpnet.invite.legacy.view.InvitePlayersView;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_pvpnet_invite_legacy_view_InvitePlayersViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_pvpnet_invite_legacy_view_InvitePlayersViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         InvitePlayersView.watcherSetupUtil = new _com_riotgames_pvpnet_invite_legacy_view_InvitePlayersViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[47] = new PropertyWatcher("inviteColumn",{"propertyChange":true},[bindings[42]],propertyGetter);
         watchers[48] = new PropertyWatcher("width",{"widthChanged":true},[bindings[42]],null);
         watchers[31] = new PropertyWatcher("invitePlayers_lst",{"propertyChange":true},[bindings[28]],propertyGetter);
         watchers[32] = new PropertyWatcher("x",{"xChanged":true},[bindings[28]],null);
         watchers[3] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[34],bindings[17],bindings[50],bindings[49],bindings[48],bindings[33],bindings[18],bindings[4],bindings[39],bindings[20],bindings[23]],propertyGetter);
         watchers[51] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","invitePlayers_invitePlayersButton_label"];
         },{"change":true},[bindings[49]],null);
         watchers[50] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","invitePlayers_closeWindowButton_tooltip"];
         },{"change":true},[bindings[48]],null);
         watchers[16] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","invitePlayers_guestSlots",[target._numGuestSlotsUsed,target._numGuestSlots]];
         },{"change":true},[bindings[17]],null);
         watchers[18] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","invitePlayers_title_label"];
         },{"change":true},[bindings[18]],null);
         watchers[4] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","invitePlayers_playerFilterPrompt"];
         },{"change":true},[bindings[4]],null);
         watchers[20] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","invitePlayers_subtitle_label"];
         },{"change":true},[bindings[20]],null);
         watchers[36] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","invitePlayers_invitePlayerByNameButton_label"];
         },{"change":true},[bindings[33]],null);
         watchers[52] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","invitePlayers_invitePlayersButton_tooltip"];
         },{"change":true},[bindings[50]],null);
         watchers[37] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","invitePlayers_invitePlayerByNameButton_tooltip"];
         },{"change":true},[bindings[34]],null);
         watchers[43] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","invitePlayers_inviteListHeader_label",["(" + target._inviteRules.availableInviteBay.length + "/" + InviteBayController.MAX_NUM_INVITE_BAY_PLAYERS + ")"]];
         },{"change":true},[bindings[39]],null);
         watchers[24] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","invitePlayers_availablePlayersHeader_label"];
         },{"change":true},[bindings[23]],null);
         watchers[0] = new PropertyWatcher("playerLists_vs",{"propertyChange":true},[bindings[2],bindings[6],bindings[13]],propertyGetter);
         watchers[1] = new PropertyWatcher("x",{"xChanged":true},[bindings[2],bindings[6],bindings[13]],null);
         watchers[40] = new PropertyWatcher("isBusy",{"propertyChange":true},[bindings[51],bindings[35]],propertyGetter);
         watchers[8] = new PropertyWatcher("selectionIndex",{"propertyChange":true},[bindings[8],bindings[44]],propertyGetter);
         watchers[12] = new PropertyWatcher("teamGuestSlotsEnabled",{"propertyChange":true},[bindings[15]],propertyGetter);
         watchers[17] = new PropertyWatcher("_numGuestSlotsUsed",{"propertyChange":true},[bindings[17]],propertyGetter);
         watchers[2] = new PropertyWatcher("height",{"heightChanged":true},[bindings[32],bindings[3],bindings[22],bindings[7],bindings[25],bindings[41],bindings[29],bindings[14]],propertyGetter);
         watchers[22] = new PropertyWatcher("filter_ti",{"propertyChange":true},[bindings[22],bindings[24],bindings[40]],propertyGetter);
         watchers[25] = new PropertyWatcher("height",{"heightChanged":true},[bindings[24],bindings[40]],null);
         watchers[23] = new PropertyWatcher("y",{"yChanged":true},[bindings[22],bindings[24],bindings[40]],null);
         watchers[34] = new PropertyWatcher("invitePlayerByName_ti",{"propertyChange":true},[bindings[35],bindings[31]],propertyGetter);
         watchers[38] = new PropertyWatcher("text",{
            "change":false,
            "textChanged":true
         },[bindings[35]],null);
         watchers[35] = new PropertyWatcher("x",{"xChanged":true},[bindings[31]],null);
         watchers[15] = new PropertyWatcher("_numGuestSlots",{"propertyChange":true},[bindings[17],bindings[16]],propertyGetter);
         watchers[5] = new PropertyWatcher("_inviteRules",{"propertyChange":true},[bindings[5],bindings[39],bindings[36],bindings[9],bindings[43],bindings[10],bindings[11],bindings[46],bindings[12],bindings[47],bindings[15],bindings[45],bindings[51],bindings[27],bindings[30]],propertyGetter);
         watchers[44] = new PropertyWatcher("availableInviteBay",{"propertyChange":true},[bindings[51],bindings[39],bindings[43]],null);
         watchers[45] = new PropertyWatcher("length",{"collectionChange":true},[bindings[51],bindings[39]],null);
         watchers[6] = new PropertyWatcher("sectionType",{"propertyChange":true},[bindings[5],bindings[9],bindings[45],bindings[15]],null);
         watchers[33] = new PropertyWatcher("allowInviteByName",{"propertyChange":true},[bindings[36],bindings[30]],null);
         watchers[30] = new PropertyWatcher("availableInvitees",{"propertyChange":true},[bindings[27]],null);
         watchers[10] = new PropertyWatcher("sectionNames",{"propertyChange":true},[bindings[11],bindings[47]],null);
         watchers[11] = new PropertyWatcher("sectionLockedTooltip",{"propertyChange":true},[bindings[12]],null);
         watchers[9] = new PropertyWatcher("sectionLocked",{"propertyChange":true},[bindings[10],bindings[46],bindings[12]],null);
         watchers[13] = new StaticPropertyWatcher("instance",null,[bindings[15]],null);
         watchers[14] = new PropertyWatcher("leagueServiceEnabled",{"propertyChange":true},[bindings[15]],null);
         watchers[41] = new PropertyWatcher("availPlayers_lbl",{"propertyChange":true},[bindings[37]],propertyGetter);
         watchers[42] = new PropertyWatcher("y",{"yChanged":true},[bindings[37]],null);
         watchers[28] = new PropertyWatcher("availableColumn",{"propertyChange":true},[bindings[26]],propertyGetter);
         watchers[29] = new PropertyWatcher("width",{"widthChanged":true},[bindings[26]],null);
         watchers[26] = new PropertyWatcher("chooseAvailPlayersLst_btnbar",{"propertyChange":true},[bindings[25],bindings[41]],propertyGetter);
         watchers[27] = new PropertyWatcher("y",{"yChanged":true},[bindings[25],bindings[41]],null);
         watchers[47].updateParent(target);
         watchers[47].addChild(watchers[48]);
         watchers[31].updateParent(target);
         watchers[31].addChild(watchers[32]);
         watchers[3].updateParent(target);
         watchers[51].parentWatcher = watchers[3];
         watchers[3].addChild(watchers[51]);
         watchers[50].parentWatcher = watchers[3];
         watchers[3].addChild(watchers[50]);
         watchers[16].parentWatcher = watchers[3];
         watchers[3].addChild(watchers[16]);
         watchers[18].parentWatcher = watchers[3];
         watchers[3].addChild(watchers[18]);
         watchers[4].parentWatcher = watchers[3];
         watchers[3].addChild(watchers[4]);
         watchers[20].parentWatcher = watchers[3];
         watchers[3].addChild(watchers[20]);
         watchers[36].parentWatcher = watchers[3];
         watchers[3].addChild(watchers[36]);
         watchers[52].parentWatcher = watchers[3];
         watchers[3].addChild(watchers[52]);
         watchers[37].parentWatcher = watchers[3];
         watchers[3].addChild(watchers[37]);
         watchers[43].parentWatcher = watchers[3];
         watchers[3].addChild(watchers[43]);
         watchers[24].parentWatcher = watchers[3];
         watchers[3].addChild(watchers[24]);
         watchers[0].updateParent(target);
         watchers[0].addChild(watchers[1]);
         watchers[40].updateParent(target);
         watchers[8].updateParent(target);
         watchers[12].updateParent(target);
         watchers[17].updateParent(target);
         watchers[2].updateParent(target);
         watchers[22].updateParent(target);
         watchers[22].addChild(watchers[25]);
         watchers[22].addChild(watchers[23]);
         watchers[34].updateParent(target);
         watchers[34].addChild(watchers[38]);
         watchers[34].addChild(watchers[35]);
         watchers[15].updateParent(target);
         watchers[5].updateParent(target);
         watchers[5].addChild(watchers[44]);
         watchers[44].addChild(watchers[45]);
         watchers[5].addChild(watchers[6]);
         watchers[5].addChild(watchers[33]);
         watchers[5].addChild(watchers[30]);
         watchers[5].addChild(watchers[10]);
         watchers[5].addChild(watchers[11]);
         watchers[5].addChild(watchers[9]);
         watchers[13].updateParent(ClientConfig);
         watchers[13].addChild(watchers[14]);
         watchers[41].updateParent(target);
         watchers[41].addChild(watchers[42]);
         watchers[28].updateParent(target);
         watchers[28].addChild(watchers[29]);
         watchers[26].updateParent(target);
         watchers[26].addChild(watchers[27]);
      }
   }
}

