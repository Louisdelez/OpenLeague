package com.riotgames.pvpnet.docked.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.pvpnet.docked.chat.view.DockedChatRootView;
   import com.riotgames.pvpnet.docked.chat.view.buddypanel.BuddyPanelView;
   
   public class DockedChatViewModel
   {
      
      private var _buddyPanelState:String = BuddyPanelView.VIEW_STATE_MINIMIZED;
      
      private var _buddyPanelStateChanged:Signal = new Signal();
      
      private var _topLevelViewState:String = DockedChatRootView.STATE_CHAT_DISABLED;
      
      private var _topLevelViewStateChanged:Signal = new Signal();
      
      public function DockedChatViewModel()
      {
         super();
      }
      
      public function getBuddyPanelState() : String
      {
         return this._buddyPanelState;
      }
      
      public function setBuddyPanelState(param1:String) : void
      {
         var _loc2_:String = null;
         if(this._buddyPanelState != param1)
         {
            _loc2_ = this._buddyPanelState;
            this._buddyPanelState = param1;
            this._buddyPanelStateChanged.dispatch(_loc2_,param1);
         }
      }
      
      public function getBuddyPanelStateChanged() : ISignal
      {
         return this._buddyPanelStateChanged;
      }
      
      public function getTopLevelViewState() : String
      {
         return this._topLevelViewState;
      }
      
      public function setTopLevelViewState(param1:String) : void
      {
         var _loc2_:String = null;
         if(this._topLevelViewState != param1)
         {
            _loc2_ = this._topLevelViewState;
            this._topLevelViewState = param1;
            this._topLevelViewStateChanged.dispatch(_loc2_,param1);
         }
      }
      
      public function getTopLevelViewStateChanged() : ISignal
      {
         return this._topLevelViewStateChanged;
      }
   }
}

