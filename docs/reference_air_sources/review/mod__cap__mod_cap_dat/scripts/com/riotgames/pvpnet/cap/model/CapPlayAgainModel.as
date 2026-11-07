package com.riotgames.pvpnet.cap.model
{
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipant;
   import mx.collections.ArrayCollection;
   
   public class CapPlayAgainModel
   {
      
      private var _suggestionList:ArrayCollection;
      
      public var isVictorious:Boolean = false;
      
      private var _reinviteList:ArrayCollection;
      
      public var playAgainClicked:Boolean = false;
      
      public function CapPlayAgainModel()
      {
         super();
         this._reinviteList = new ArrayCollection();
         this._reinviteList.filterFunction = this.reinviteFilterFunction;
         this._reinviteList.refresh();
         this._suggestionList = new ArrayCollection();
      }
      
      public function get suggestionList() : ArrayCollection
      {
         return this._suggestionList;
      }
      
      private function reinviteFilterFunction(param1:InviteParticipant) : Boolean
      {
         if(param1.isOwner)
         {
            return false;
         }
         return true;
      }
      
      public function clear() : void
      {
         this._reinviteList.source = [];
         this._suggestionList.source = [];
      }
      
      public function get reinviteList() : ArrayCollection
      {
         return this._reinviteList;
      }
   }
}

