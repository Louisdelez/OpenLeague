package com.riotgames.platform.gameclient.views.game.common.renderers.teamlobby
{
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.rust.context.RustContext;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.UIComponent;
   
   public class TeamLobbyMemberRenderer extends UIComponent implements IListItemRenderer
   {
      
      public var inviteController:IInviteController;
      
      private var _data:Object;
      
      private var mainView:TeamLobbyMemberImpl;
      
      public var context:RustContext;
      
      [Inject]
      public var lobbyController:ILobbyViewController;
      
      [Inject]
      public var chatController:ChatController;
      
      public var inviteGroup:InviteGroup;
      
      public function TeamLobbyMemberRenderer(param1:RustContext = null, param2:IInviteController = null, param3:ChatController = null, param4:ILobbyViewController = null)
      {
         super();
         if(param1 != null)
         {
            this.context = param1;
         }
         if(param2 != null)
         {
            this.inviteController = param2;
         }
         if(param3 != null)
         {
            this.chatController = param3;
         }
         if(param4 != null)
         {
            this.lobbyController = param4;
         }
      }
      
      public function set data(param1:Object) : void
      {
         if(this._data == param1)
         {
            return;
         }
         this._data = param1;
         this.mainView.createSummonerData(this._data);
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      override protected function createChildren() : void
      {
         this.mainView = new TeamLobbyMemberImpl(this.context,this.inviteGroup,this.inviteController,this.chatController,this.lobbyController);
         this.mainView.setCurrentState("teamInvitationLobby");
         this.mainView.setLinkage("teamMemberRenderer");
         this.addChild(this.mainView.getAsset());
         super.createChildren();
      }
   }
}

