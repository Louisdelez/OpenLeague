package com.riotgames.platform.gameclient.chat
{
   import blix.signals.ISignal;
   import flash.events.IEventDispatcher;
   import mx.collections.ListCollectionView;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public interface IChatRosterProvider extends IEventDispatcher
   {
      
      function getBuddyBySummonerId(param1:Number) : RosterItemVO;
      
      function getBuddyGroups() : ListCollectionView;
      
      function getAllRosterBuddies() : Array;
      
      function getRosterPresenceUpdatedSignal() : ISignal;
      
      function getBuddyRemovedSignal() : ISignal;
      
      function getAllRosterItems() : Array;
      
      function addBuddy(param1:String, param2:String = null) : void;
      
      function findBuddyRosterItemByName(param1:String) : RosterItemVO;
      
      function isSummonerBuddy(param1:String, param2:Boolean = false) : Boolean;
   }
}

