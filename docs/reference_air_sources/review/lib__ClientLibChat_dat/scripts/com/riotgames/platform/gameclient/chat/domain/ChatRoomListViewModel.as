package com.riotgames.platform.gameclient.chat.domain
{
   import com.riotgames.platform.common.RiotServiceConfig;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.QueryRoomInformationHandler;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   public class ChatRoomListViewModel implements IEventDispatcher
   {
      
      private var _838599784publicChatRoomInfoList:ArrayCollection = new ArrayCollection();
      
      private var _1937376130privateChatRoomInfoList:ArrayCollection = new ArrayCollection();
      
      private var _serviceProxy:ServiceProxy;
      
      private var _servicesConfig:RiotServiceConfig;
      
      private var roomInfosPendingCountUpdates:ArrayCollection = new ArrayCollection();
      
      private var _chatController:ChatController;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function ChatRoomListViewModel(param1:ChatController, param2:RiotServiceConfig, param3:ServiceProxy)
      {
         super();
         this._chatController = param1;
         this._servicesConfig = param2;
         this._serviceProxy = param3;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get privateChatRoomInfoList() : ArrayCollection
      {
         return this._1937376130privateChatRoomInfoList;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set privateChatRoomInfoList(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1937376130privateChatRoomInfoList;
         if(_loc2_ !== param1)
         {
            this._1937376130privateChatRoomInfoList = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"privateChatRoomInfoList",_loc2_,param1));
         }
      }
      
      public function updateChatRoomOccupantCounts() : void
      {
         var _loc1_:ChatRoomInfo = null;
         for each(_loc1_ in this.publicChatRoomInfoList)
         {
            this.roomInfosPendingCountUpdates.addItem(_loc1_);
            this.requestChatRoomCount(_loc1_.obfuscatedName,this.updateRoomInfoCount,true);
         }
         for each(_loc1_ in this.privateChatRoomInfoList)
         {
            this.roomInfosPendingCountUpdates.addItem(_loc1_);
            this.requestChatRoomCount(_loc1_.obfuscatedName,this.updateRoomInfoCount,false);
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set publicChatRoomInfoList(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._838599784publicChatRoomInfoList;
         if(_loc2_ !== param1)
         {
            this._838599784publicChatRoomInfoList = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"publicChatRoomInfoList",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addPersonalChatRoomToPublicList(param1:ChatRoomInfo) : void
      {
         this.publicChatRoomInfoList.addItem(param1);
      }
      
      private function updateRoomInfoCount(param1:String, param2:int) : void
      {
         var _loc3_:ChatRoomInfo = null;
         for each(_loc3_ in this.roomInfosPendingCountUpdates)
         {
            if(_loc3_.obfuscatedName == param1)
            {
               _loc3_.occupantCount = param2;
               this.roomInfosPendingCountUpdates.removeItemAt(this.roomInfosPendingCountUpdates.getItemIndex(_loc3_));
               return;
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get publicChatRoomInfoList() : ArrayCollection
      {
         return this._838599784publicChatRoomInfoList;
      }
      
      private function requestChatRoomCount(param1:String, param2:Function, param3:Boolean) : void
      {
         var _loc4_:QueryRoomInformationHandler = new QueryRoomInformationHandler();
         if(param2 != null)
         {
            _loc4_.queryCompletedSignal.add(param2);
         }
         _loc4_.queryChatRoomInformationForJID(param1,ChatRoom.createRoomJID(param1,null,null,param3,true,this._servicesConfig),this._serviceProxy.chatService);
      }
      
      public function addPersonalChatRoomToPrivateList(param1:ChatRoomInfo) : void
      {
         this.privateChatRoomInfoList.addItem(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
   }
}

