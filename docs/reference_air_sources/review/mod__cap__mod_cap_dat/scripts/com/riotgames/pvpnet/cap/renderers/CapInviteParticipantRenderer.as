package com.riotgames.pvpnet.cap.renderers
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.renderer.IItemRenderer;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipant;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipantState;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   
   public class CapInviteParticipantRenderer extends StatefulView implements IItemRenderer
   {
      
      private var nameTextField:TextFieldProxy;
      
      private var _data:*;
      
      private var statusTextField:TextFieldProxy;
      
      private var rendererIndex:uint;
      
      private var sizer:SpriteProxy;
      
      private var _inviteParticipant:InviteParticipant;
      
      private var inviteGroup:InviteGroup;
      
      public function CapInviteParticipantRenderer(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setLinkage("InviteRenderer");
         this.inviteGroup = getDependency(InviteGroup);
         this.inviteGroup.isAcceptingInvitesChanged.add(this.updateState);
      }
      
      override public function destroy() : void
      {
         this.inviteGroup.isAcceptingInvitesChanged.remove(this.updateState);
         this.nameTextField.destroy();
         this.statusTextField.destroy();
         super.destroy();
      }
      
      protected function updateState() : void
      {
         if(!this._inviteParticipant)
         {
            return;
         }
         var _loc1_:String = null;
         switch(this._inviteParticipant.status)
         {
            case InviteParticipantState.PENDING:
               if(this.inviteGroup.isAcceptingInvites)
               {
                  _loc1_ = "pending";
               }
               else
               {
                  _loc1_ = "declined";
               }
               break;
            case InviteParticipantState.JOINED:
            case InviteParticipantState.OWNER:
            case InviteParticipantState.ACCEPTED:
            case InviteParticipantState.CREATOR:
               _loc1_ = "accepted";
               break;
            default:
               _loc1_ = "declined";
         }
         setCurrentState(_loc1_);
      }
      
      public function setIndex(param1:uint) : void
      {
         this.rendererIndex = param1;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         return new Rectangle(0,0,this.sizer.getWidth(),this.sizer.getHeight());
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.nameTextField = new TextFieldProxy(this);
         setTimelineChildByName("summonerNameTextField",this.nameTextField);
         this.statusTextField = new TextFieldProxy(this);
         setTimelineChildByName("statusTextField",this.statusTextField);
         this.sizer = new SpriteProxy(this);
         setTimelineChildByName("sizer",this.sizer);
      }
      
      public function getData() : *
      {
         return this._data;
      }
      
      public function getIndex() : uint
      {
         return this.rendererIndex;
      }
      
      protected function updateTextFields() : void
      {
         if(!this._inviteParticipant)
         {
            this.nameTextField.setText("");
            this.statusTextField.setText("");
         }
         else
         {
            this.nameTextField.setText(this._inviteParticipant.name);
            this.statusTextField.setText(this._inviteParticipant.displayStatus);
            this.statusTextField.setTextColor(uint(this._inviteParticipant.getColor()));
         }
      }
      
      public function setData(param1:*) : void
      {
         if(this._inviteParticipant)
         {
            this._inviteParticipant.statusChanged.remove(this.updateTextFields);
            this._inviteParticipant.statusChanged.remove(this.updateState);
         }
         this._data = param1;
         this._inviteParticipant = param1 as InviteParticipant;
         this.updateTextFields();
         if(this._inviteParticipant)
         {
            this._inviteParticipant.statusChanged.add(this.updateTextFields);
            this._inviteParticipant.statusChanged.add(this.updateState);
         }
         this.updateState();
      }
   }
}

