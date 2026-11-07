package com.riotgames.pvpnet.invite.legacy.event
{
   import flash.events.Event;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class InviteBayEvent extends Event
   {
      
      public static const ADD_PLAYER:String = "INVITE_BAY_ADD_PLAYER";
      
      public static const REMOVE_PLAYER:String = "INVITE_BAY_REMOVE_PLAYER";
      
      private var _rosterItem:RosterItemVO;
      
      public function InviteBayEvent(param1:String, param2:RosterItemVO)
      {
         super(param1,true,true);
         this._rosterItem = param2;
      }
      
      public function get rosterItem() : RosterItemVO
      {
         return this._rosterItem;
      }
   }
}

