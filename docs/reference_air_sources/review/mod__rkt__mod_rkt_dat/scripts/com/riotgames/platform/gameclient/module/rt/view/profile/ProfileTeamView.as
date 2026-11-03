package com.riotgames.platform.gameclient.module.rt.view.profile
{
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.resource.RTContext;
   import com.riotgames.platform.gameclient.module.rt.view.common.IActivatableView;
   import mx.core.UIComponent;
   import mx.events.FlexEvent;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   
   public class ProfileTeamView extends UIComponent implements IActivatableView
   {
      
      private var isCreationComplete:Boolean = false;
      
      public var profileStatusInfo:ProfileStatusInfo;
      
      public var profileContent:ProfileTeamContent;
      
      private var _mediator:IMediator;
      
      private var cvInvite:ProfileInvitedControl;
      
      public var btnInvitedAccept:Signal = new Signal();
      
      private var context:RTContext;
      
      private var _isInvited:Boolean;
      
      public var btnInvitedDecline:Signal = new Signal();
      
      public function ProfileTeamView(param1:RTContext)
      {
         super();
         this.context = param1;
         addEventListener(FlexEvent.CREATION_COMPLETE,this.onCreationComplete);
      }
      
      override protected function commitProperties() : void
      {
         this.cvInvite.visible = this._isInvited;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.profileContent = new ProfileTeamContent(this.context);
         addChild(this.profileContent);
         this.profileStatusInfo = new ProfileStatusInfo(this.context);
         addChild(this.profileStatusInfo);
         this.cvInvite = new ProfileInvitedControl(this.context);
         addChild(this.cvInvite);
         this.cvInvite.setVisible(false);
         this.cvInvite.acceptClicked.add(function():void
         {
            btnInvitedAccept.dispatch();
         });
         this.cvInvite.declineClicked.add(function():void
         {
            btnInvitedDecline.dispatch();
         });
      }
      
      public function set isInvited(param1:Boolean) : void
      {
         this._isInvited = param1;
         invalidateProperties();
      }
      
      public function activate() : void
      {
         this.joinActivate();
      }
      
      public function deactivate() : void
      {
         RTFacade.instance.removeMediator(ProfileTeamMediator.NAME);
      }
      
      private function onCreationComplete(param1:FlexEvent) : void
      {
         this.isCreationComplete = true;
         this.joinActivate();
      }
      
      private function joinActivate() : void
      {
         if(this.isCreationComplete)
         {
            if(!this._mediator)
            {
               this._mediator = new ProfileTeamMediator(ProfileTeamMediator.NAME,this);
            }
            RTFacade.instance.registerMediator(this._mediator);
         }
      }
   }
}

