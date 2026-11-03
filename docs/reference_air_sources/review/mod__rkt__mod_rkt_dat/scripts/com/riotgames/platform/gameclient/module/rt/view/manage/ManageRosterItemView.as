package com.riotgames.platform.gameclient.module.rt.view.manage
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.Manage_Team_Tab.ManageInvitedRenderer;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberInfo;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.resource.RTContext;
   import com.riotgames.platform.gameclient.utils.DateUtil;
   import com.riotgames.rust.components.FlashFlexComponent;
   import flash.events.MouseEvent;
   import mx.controls.listClasses.IListItemRenderer;
   
   public class ManageRosterItemView extends FlashFlexComponent implements IListItemRenderer
   {
      
      private static var context:RTContext;
      
      private var labelText:TextFieldProxy;
      
      private var _data:Object;
      
      private var cancelButton:ButtonX;
      
      private var teamMember:TeamMemberInfo;
      
      private var detailText:TextFieldProxy;
      
      private var teamId:TeamId;
      
      public function ManageRosterItemView()
      {
         super(context,"rt.ManageInvitedRenderer");
         var _loc1_:ManageInvitedRenderer = new ManageInvitedRenderer();
         this.labelText = _loc1_.labelText.create(this.view);
         this.detailText = _loc1_.detailText.create(this.view);
         this.cancelButton = context.viewUtil.wireButton(this.view,_loc1_.cancelButton,this.onKickClicked);
      }
      
      public static function setContext(param1:RTContext) : void
      {
         context = param1;
      }
      
      private function setTeamMember(param1:TeamMemberInfo, param2:TeamId) : void
      {
         this.teamMember = param1;
         this.teamId = param2;
         if(this.teamMember)
         {
            this.view.setVisible(true);
            this.labelText.setText(param1.playerName);
            if(param1.joinDate)
            {
               this.detailText.setText(DateUtil.getDateString(param1.joinDate));
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
         RTFacade.modalMediator.showRemoveTeamMemberModal(this.teamMember.playerName,this.teamMember.playerId,this.teamId);
      }
   }
}

