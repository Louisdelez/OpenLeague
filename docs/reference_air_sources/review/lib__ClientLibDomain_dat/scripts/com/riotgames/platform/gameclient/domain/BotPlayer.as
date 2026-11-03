package com.riotgames.platform.gameclient.domain
{
   import mx.events.PropertyChangeEvent;
   
   public class BotPlayer extends Player
   {
      
      private var _767422259participant:BotParticipant;
      
      public function BotPlayer(param1:GameParticipant)
      {
         super(param1);
         this.participant = param1 as BotParticipant;
      }
      
      public function set participant(param1:BotParticipant) : void
      {
         var _loc2_:Object = this._767422259participant;
         if(_loc2_ !== param1)
         {
            this._767422259participant = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"participant",_loc2_,param1));
         }
      }
      
      override public function get summonerName() : String
      {
         return this.participant.summonerName;
      }
      
      [Bindable(event="propertyChange")]
      public function get participant() : BotParticipant
      {
         return this._767422259participant;
      }
      
      override public function toString() : String
      {
         return this.participant.summonerInternalName;
      }
      
      override public function get accountId() : Number
      {
         return -1;
      }
   }
}

