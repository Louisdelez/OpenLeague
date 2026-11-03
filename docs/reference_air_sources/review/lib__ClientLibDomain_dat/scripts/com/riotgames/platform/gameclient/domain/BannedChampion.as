package com.riotgames.platform.gameclient.domain
{
   [RemoteClass(alias="com.riotgames.platform.game.BannedChampion")]
   public class BannedChampion extends AbstractDomainObject
   {
      
      private var _championId:int;
      
      private var _teamId:int;
      
      private var _pickTurn:int;
      
      public function BannedChampion()
      {
         super();
      }
      
      public function get championId() : int
      {
         return this._championId;
      }
      
      public function set championId(param1:int) : void
      {
         this._championId = param1;
      }
      
      public function set teamId(param1:int) : void
      {
         this._teamId = param1;
      }
      
      public function get teamId() : int
      {
         return this._teamId;
      }
      
      public function set pickTurn(param1:int) : void
      {
         this._pickTurn = param1;
      }
      
      public function get pickTurn() : int
      {
         return this._pickTurn;
      }
   }
}

