package com.riotgames.platform.gameclient.chat.mediator
{
   import com.riotgames.platform.gameclient.chat.*;
   import com.riotgames.platform.gameclient.chat.domain.Buddy;
   import com.riotgames.platform.gameclient.chat.domain.ChatPersonalMessageVO;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.chat.model.ChatWindowModel;
   import com.riotgames.pvpnet.tracking.ICrossModuleTrackerProvider;
   import com.riotgames.pvpnet.tracking.trackers.chat.IChatBehaviorTracker;
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.Message;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class IronPersonalMessageHandler implements IPersonalMessageHandler
   {
      
      private var _conversationCache:Dictionary = new Dictionary();
      
      private var _chatTracker:IChatBehaviorTracker;
      
      private var _chatWindows:ArrayCollection;
      
      private var _totalChatViews:ArrayCollection;
      
      public function IronPersonalMessageHandler(param1:ArrayCollection, param2:ArrayCollection)
      {
         super();
         this._chatWindows = param1;
         this._totalChatViews = param2;
         ProviderLookup.getProvider(ICrossModuleTrackerProvider,this.onGotTrackerProvider);
      }
      
      public function closePersonalPopupWindow(param1:UnescapedJID) : void
      {
         this.closePersonalPopupWindowByName(param1.node);
         if(this._chatTracker)
         {
            this._chatTracker.incrementChatWindowClosed_InASession(param1.bareJID);
         }
      }
      
      public function closePersonalPopupWindowByName(param1:String) : void
      {
         var _loc2_:ChatWindowModel = null;
         var _loc3_:int = 0;
         for each(_loc2_ in this._chatWindows)
         {
            if(_loc2_.getBuddy().getJidNode() == param1)
            {
               _loc3_ = int(this._chatWindows.getItemIndex(_loc2_));
               this._chatWindows.removeItemAt(_loc3_);
               _loc3_ = int(this._totalChatViews.getItemIndex(_loc2_));
               this._totalChatViews.removeItemAt(_loc3_);
               return;
            }
         }
      }
      
      private function createModel(param1:RosterItemVO) : ChatWindowModel
      {
         var _loc3_:ChatWindowModel = null;
         var _loc2_:Buddy = RosterUtility.getBuddy(param1);
         for each(_loc3_ in this._chatWindows)
         {
            if(_loc3_.getBuddy() == _loc2_)
            {
               return _loc3_;
            }
         }
         _loc3_ = this._conversationCache[_loc2_.getSummonerId()];
         if(!_loc3_)
         {
            _loc3_ = new ChatWindowModel(_loc2_);
            this._conversationCache[_loc2_.getSummonerId()] = _loc3_;
         }
         if(!this._chatWindows.contains(_loc3_))
         {
            this._chatWindows.addItem(_loc3_);
         }
         if(!this._totalChatViews.contains(_loc3_))
         {
            this._totalChatViews.addItem(_loc3_);
         }
         return _loc3_;
      }
      
      public function personalChatMessageReceived(param1:RosterItemVO, param2:Message) : void
      {
         var _loc3_:ChatWindowModel = this.createModel(param1);
         var _loc4_:ChatPersonalMessageVO = new ChatPersonalMessageVO(_loc3_.getBuddy().getName(),null,param2.body);
         _loc3_.addMessage(_loc4_);
      }
      
      private function onGotTrackerProvider(param1:ICrossModuleTrackerProvider) : void
      {
         this._chatTracker = param1.getChatTracker();
      }
      
      public function createPersonalPopUp(param1:RosterItemVO, param2:Boolean = false) : void
      {
         var _loc3_:ChatWindowModel = this.createModel(param1);
         if(param2)
         {
            _loc3_.activate();
         }
      }
   }
}

