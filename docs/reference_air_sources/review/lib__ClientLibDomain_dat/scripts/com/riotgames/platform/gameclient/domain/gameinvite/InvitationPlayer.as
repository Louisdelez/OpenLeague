package com.riotgames.platform.gameclient.domain.gameinvite
{
   [RemoteClass(alias="com.riotgames.platform.gameinvite.contract.Player")]
   public class InvitationPlayer
   {
      
      private var _summonerId:Number;
      
      private var _summonerName:String;
      
      public function InvitationPlayer()
      {
         super();
      }
      
      public function get summonerName() : String
      {
         return this._summonerName;
      }
      
      public function set summonerId(param1:Number) : void
      {
         this._summonerId = param1;
      }
      
      public function get summonerId() : Number
      {
         return this._summonerId;
      }
      
      public function set summonerName(param1:String) : void
      {
         this._summonerName = param1;
      }
   }
}

