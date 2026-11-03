package com.riotgames.pvpnet.docked.friendlist.view
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.LabelButtonX;
   import blix.components.text.Text;
   import blix.components.text.TextScroller;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.chat.domain.Buddy;
   import com.riotgames.platform.gameclient.chat.views.ChatViewMediator;
   import com.riotgames.rust.focus.RiotFocusManager;
   import com.riotgames.rust.popup.PopUpManager;
   import flash.display.Stage;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class BuddyNotePopup extends SpriteProxy
   {
      
      private var _buddy:Buddy;
      
      private var _summonerNameText:Text;
      
      private var _noteText:TextScroller;
      
      private var _dismissed:Signal = new Signal();
      
      private var _viewMediator:ChatViewMediator;
      
      public function BuddyNotePopup(param1:IContext, param2:Buddy, param3:ChatViewMediator)
      {
         super(param1,null);
         setLinkage("chat.BuddyNotesDialogue");
         this._viewMediator = param3;
         this.setBuddy(param2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._summonerNameText = new Text(this);
         setTimelineChildByName("summonerNameText",this._summonerNameText);
         var _loc1_:LabelButtonX = new LabelButtonX(this);
         setTimelineChildByName("cancelButton",_loc1_);
         _loc1_.setText(RiotResourceLoader.getString("buddyNoteCancelButtonLabel"));
         _loc1_.addEventListener(MouseEvent.CLICK,this.onCloseButtonClicked);
         var _loc2_:LabelButtonX = new LabelButtonX(this);
         setTimelineChildByName("updateButton",_loc2_);
         _loc2_.setText(RiotResourceLoader.getString("buddyNoteUpdateButtonLabel"));
         _loc2_.addEventListener(MouseEvent.CLICK,this.onUpdateButtonClicked);
         this._noteText = new TextScroller(this);
         this._noteText.getLayoutInvalidated().add(invalidateLayout);
         this._noteText.getTextView().setMaxChars(140);
         setTimelineChildByName("textScrollArea",this._noteText);
         RiotFocusManager.setFocus(this._noteText.getTextView());
         getIsOnStageChanged().add(this.handleOnStageChanged);
      }
      
      private function handleOnStageChanged() : void
      {
         var _loc1_:Stage = getStage();
         if(_isOnStage)
         {
            _loc1_.addEventListener(MouseEvent.MOUSE_DOWN,this.onStageMouseDown);
            _loc1_.addEventListener(KeyboardEvent.KEY_DOWN,this.onStageKeyDown);
         }
         else
         {
            _loc1_.removeEventListener(MouseEvent.MOUSE_DOWN,this.onStageMouseDown);
            _loc1_.removeEventListener(KeyboardEvent.KEY_DOWN,this.onStageKeyDown);
         }
      }
      
      private function onStageMouseDown(param1:MouseEvent) : void
      {
         if(!this.hitTestPoint(param1.stageX,param1.stageY,true))
         {
            this.closePopup();
         }
      }
      
      private function onStageKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            this.closePopup();
         }
      }
      
      private function onCloseButtonClicked(param1:MouseEvent) : void
      {
         this.closePopup();
      }
      
      private function onUpdateButtonClicked(param1:MouseEvent) : void
      {
         this.updateNote();
      }
      
      private function updateNote() : void
      {
         this._viewMediator.updateRosterNoteOnBuddy(this._buddy,this._noteText.getText());
         this.closePopup();
      }
      
      public function getDismissed() : ISignal
      {
         return this._dismissed;
      }
      
      private function closePopup() : void
      {
         PopUpManager.instance.removePopUp(this);
         this._dismissed.dispatch();
         destroy();
      }
      
      private function setBuddy(param1:Buddy) : void
      {
         if(this._buddy != param1)
         {
            this._buddy = param1;
            this._summonerNameText.setText(this._buddy.getName());
            this._noteText.setText(this._buddy.getNote());
            this._noteText.getTextView().setSelection(int.MAX_VALUE,int.MAX_VALUE);
         }
      }
   }
}

