package com.riotgames.platform.gameclient.chat
{
   import blix.signals.ISignal;
   import com.riotgames.platform.provider.proxy.ProviderProxyNoop;
   import flash.events.Event;
   import mx.collections.ListCollectionView;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class ChatRosterProviderProxy extends ProviderProxyNoop implements IChatRosterProvider
   {
      
      private static var _instance:IChatRosterProvider;
      
      public function ChatRosterProviderProxy()
      {
         super(IChatRosterProvider);
      }
      
      public static function get instance() : IChatRosterProvider
      {
         if(_instance == null)
         {
            _instance = new ChatRosterProviderProxy();
         }
         return _instance;
      }
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") static function setInstance(param1:IChatRosterProvider) : void
      {
         _instance = param1;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return _invoke("dispatchEvent",[param1]);
      }
      
      public function getBuddyGroups() : ListCollectionView
      {
         return _invoke("getBuddyGroups");
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return _invoke("willTrigger",[param1]);
      }
      
      public function getRosterPresenceUpdatedSignal() : ISignal
      {
         return _invoke("getRosterPresenceUpdatedSignal");
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         _invoke("addEventListener",[param1,param2,param3,param4,param5]);
      }
      
      public function getAllRosterItems() : Array
      {
         return _invoke("getAllRosterItems");
      }
      
      public function isSummonerBuddy(param1:String, param2:Boolean = false) : Boolean
      {
         return _invoke("isSummonerBuddy",[param1,param2]);
      }
      
      public function findBuddyRosterItemByName(param1:String) : RosterItemVO
      {
         return _invoke("findBuddyRosterItemByName",[param1]);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         _invoke("removeEventListener",[param1,param2,param3]);
      }
      
      public function addBuddy(param1:String, param2:String = null) : void
      {
         _invoke("addBuddy",[param1,param2]);
      }
      
      public function getBuddyBySummonerId(param1:Number) : RosterItemVO
      {
         return _invoke("getBuddyBySummonerId",[param1]);
      }
      
      public function getAllRosterBuddies() : Array
      {
         return _invoke("getAllRosterBuddies");
      }
      
      public function getBuddyRemovedSignal() : ISignal
      {
         return _invoke("getBuddyRemovedSignal");
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return _invoke("hasEventListener",[param1]);
      }
   }
}

