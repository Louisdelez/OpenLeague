package com.riotgames.platform.gameclient.module.rt.view.manage
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.Manage_Team_Tab.InviteBuddyRenderer;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.resource.RTResource;
   import com.riotgames.rust.components.FlashFlexComponent;
   import flash.events.MouseEvent;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.IToolTip;
   import mx.managers.ToolTipManager;
   
   public class InviteBuddyRenderer extends FlashFlexComponent implements IListItemRenderer
   {
      
      private var labelText:TextFieldProxy;
      
      private var _tooltip:String;
      
      private var _data:InviteRendererData;
      
      private var groupText:TextFieldProxy;
      
      private var _tip:IToolTip;
      
      private var inviteItemBg:DisplayObjectProxy;
      
      private var inviteButton:ButtonX;
      
      private var separator:DisplayObjectProxy;
      
      private var icon:StatefulView;
      
      public function InviteBuddyRenderer()
      {
         super(RTFacade.context,"rt.InviteBuddyRenderer");
         var _loc1_:blix.assets.proxy.Manage_Team_Tab.InviteBuddyRenderer = new blix.assets.proxy.Manage_Team_Tab.InviteBuddyRenderer();
         this.labelText = _loc1_.labelText.create(this.view);
         this.groupText = _loc1_.groupText.create(this.view);
         this.icon = new StatefulView(this.view);
         this.view.setTimelineChild(_loc1_.icon,this.icon);
         this.icon.addEventListener(MouseEvent.ROLL_OVER,this.onButtonRollOver);
         this.icon.addEventListener(MouseEvent.ROLL_OUT,this.onButtonRollOut);
         this.inviteButton = RTFacade.context.viewUtil.wireButton(this.view,_loc1_.inviteButton,this.onInviteClicked);
         this.inviteButton.addEventListener(MouseEvent.ROLL_OVER,this.onButtonRollOver);
         this.inviteButton.addEventListener(MouseEvent.ROLL_OUT,this.onButtonRollOut);
         this.separator = _loc1_.separator.create(this.view);
         this.inviteItemBg = _loc1_.inviteItemBg.create(this.view);
      }
      
      override protected function createView() : DisplayObjectProxy
      {
         return new StatefulView(_context);
      }
      
      override protected function commitProperties() : void
      {
         if(this._data)
         {
            this.view.setVisible(true);
            if(this._data.buddy)
            {
               this.labelText.setText(this._data.buddy.getName());
               this.groupText.setText("");
               this.separator.setVisible(false);
               this.inviteItemBg.setVisible(true);
               this.icon.setVisible(true);
               if(this._data.eligible)
               {
                  if(this._data.buddy.getStatus() == 1)
                  {
                     this._tooltip = RTResource.getString("inviteTooltipEligible");
                     this.icon.setCurrentState("eligible");
                     this.inviteButton.setVisible(true);
                  }
                  else
                  {
                     this._tooltip = RTResource.getString("inviteTooltipOffline");
                     this.icon.setCurrentState("offline");
                     this.inviteButton.setVisible(true);
                  }
               }
               else
               {
                  this.icon.setCurrentState("ineligible");
                  this._tooltip = this._data.ineligibleReason;
                  this.inviteButton.setVisible(false);
               }
            }
            else
            {
               this.icon.setVisible(false);
               this.labelText.setText("");
               this.groupText.setText(this._data.header);
               this.inviteButton.setVisible(false);
               this.separator.setVisible(true);
               this.inviteItemBg.setVisible(false);
            }
         }
         else
         {
            this.view.setVisible(false);
         }
         var _loc1_:Team = RTFacade.profileTeamProxy.team;
         if(Boolean(_loc1_) && _loc1_.calculateInvitesAvailable() <= 0)
         {
            this.view.setVisible(false);
         }
      }
      
      private function onButtonRollOver(param1:MouseEvent) : void
      {
         this._tip = ToolTipManager.createToolTip(this._tooltip,stage.mouseX + 10,stage.mouseY - 5,null,this);
      }
      
      public function set data(param1:Object) : void
      {
         this._data = InviteRendererData(param1);
         invalidateProperties();
      }
      
      private function onButtonRollOut(param1:MouseEvent) : void
      {
         if(this._tip)
         {
            ToolTipManager.destroyToolTip(this._tip);
         }
      }
      
      public function get view() : StatefulView
      {
         return _view as StatefulView;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      private function onInviteClicked(param1:MouseEvent) : void
      {
         var _loc2_:Team = null;
         if(!RTFacade.serviceStateProxy.isBusy)
         {
            _loc2_ = RTFacade.profileTeamProxy.team;
            RTFacade.playerProxy.invitePlayer(this._data.buddy.getSummonerId(),_loc2_.teamId,_loc2_.name);
         }
      }
   }
}

