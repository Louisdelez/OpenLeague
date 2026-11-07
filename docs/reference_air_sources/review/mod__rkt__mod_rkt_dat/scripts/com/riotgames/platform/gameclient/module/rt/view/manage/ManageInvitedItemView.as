package com.riotgames.platform.gameclient.module.rt.view.manage
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.Manage_Team_Tab.ManageInvitedRenderer;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberInfo;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberStatus;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.utils.DateUtil;
   import com.riotgames.rust.components.FlashFlexComponent;
   import flash.events.MouseEvent;
   import mx.controls.listClasses.IListItemRenderer;
   
   public class ManageInvitedItemView extends FlashFlexComponent implements IListItemRenderer
   {
      
      private var labelText:TextFieldProxy;
      
      private var _data:Object;
      
      private var cancelButton:ButtonX;
      
      private var teamMember:TeamMemberInfo;
      
      private var detailText:TextFieldProxy;
      
      private var teamId:TeamId;
      
      public function ManageInvitedItemView()
      {
         super(RTFacade.context,"rt.ManageInvitedRenderer");
         var _loc1_:ManageInvitedRenderer = new ManageInvitedRenderer();
         this.labelText = _loc1_.labelText.create(this.view);
         this.detailText = _loc1_.detailText.create(this.view);
         this.cancelButton = RTFacade.context.viewUtil.wireButton(this.view,_loc1_.cancelButton,this.onKickClicked);
      }
      
      private function setTeamMember(param1:TeamMemberInfo, param2:TeamId) : void
      {
         this.teamMember = param1;
         this.teamId = param2;
         if(this.teamMember)
         {
            this.view.setVisible(true);
            this.labelText.setText(param1.playerName);
            if(param1.status == TeamMemberStatus.INVITED)
            {
               this.view.setCurrentState("pending");
            }
            else
            {
               this.view.setCurrentState("declined");
            }
            if(param1.inviteDate)
            {
               this.detailText.setText(DateUtil.getDateString(param1.inviteDate));
            }
            else
            {
               this.detailText.setText("");
            }
         }
         else
         {
            this.view.setVisible(false);
         }
      }
      
      public function get view() : StatefulView
      {
         return _view as StatefulView;
      }
      
      override protected function createView() : DisplayObjectProxy
      {
         return new StatefulView(_context);
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         if(this.data != null)
         {
            this.setTeamMember(this.data.info,this.data.teamId);
         }
         else
         {
            this.setTeamMember(null,null);
         }
      }
      
      private function onKickClicked(param1:MouseEvent) : void
      {
         RTFacade.modalMediator.showCancelInviteModal(this.teamMember.playerName,this.teamMember.playerId,this.teamId);
      }
   }
}

