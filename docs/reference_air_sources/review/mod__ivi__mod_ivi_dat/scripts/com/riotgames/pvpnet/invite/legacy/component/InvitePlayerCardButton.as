package com.riotgames.pvpnet.invite.legacy.component
{
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.IToolTipManager;
   import blix.components.tooltip.assignToolTip;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.IContext;
   import blix.signals.Signal;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.pvpnet.invite.rules.IInviteBayRules;
   import com.riotgames.pvpnet.tips.TipsProviderProxy;
   import flash.events.MouseEvent;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class InvitePlayerCardButton extends StatefulView
   {
      
      private var inviteButton:ButtonX;
      
      public var inviteRules:IInviteBayRules;
      
      public var isAddBuddy:Boolean = true;
      
      private var _actionSignal:Signal = new Signal();
      
      public function InvitePlayerCardButton(param1:IContext)
      {
         super(param1);
      }
      
      public function set actionSignal(param1:Signal) : void
      {
         this._actionSignal = param1;
      }
      
      public function get actionSignal() : Signal
      {
         return this._actionSignal;
      }
      
      public function set data(param1:RosterItemVO) : void
      {
         var _loc2_:RosterItemVO = param1;
         unassignToolTip(this);
         if(this.isAddBuddy)
         {
            this.setCurrentState("addPlayer");
            assignToolTip(this.inviteButton,RiotResourceLoader.getString("invitePlayers_addPlayerButton_tooltip","**invitePlayers_addPlayerButton_tooltip",[param1.displayName]));
         }
         else
         {
            this.setCurrentState("kickPlayer");
            assignToolTip(this.inviteButton,RiotResourceLoader.getString("invitePlayers_removePlayerButton_tooltip","**invitePlayers_removePlayerButton_tooltip",[param1.displayName]));
         }
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         this.actionSignal.dispatch();
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         registerDependency(IToolTipManager,TipsProviderProxy.instance.createWindowToolTipManager(this));
      }
      
      override protected function createChildren() : void
      {
         this.inviteButton = new ButtonX(this);
         setTimelineChildByName("playerButton",this.inviteButton);
         this.inviteButton.addEventListener(MouseEvent.CLICK,this.onButtonClick);
      }
   }
}

