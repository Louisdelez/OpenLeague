package com.riotgames.platform.gameclient.domain
{
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.game.GameObserver")]
   public class GameObserver extends GameParticipant
   {
      
      private var _1359356291profileIconId:int = -1;
      
      private var _80971529summonerId:Number;
      
      private var _1827029976accountId:Number;
      
      public function GameObserver()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerId() : Number
      {
         return this._80971529summonerId;
      }
      
      [Bindable(event="propertyChange")]
      public function get accountId() : Number
      {
         return this._1827029976accountId;
      }
      
      [Bindable(event="propertyChange")]
      override public function set isMe(param1:Boolean) : void
      {
         var _loc2_:Object = this.isMe;
         if(_loc2_ !== param1)
         {
            this._3241058isMe = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isMe",_loc2_,param1));
         }
      }
      
      public function set accountId(param1:Number) : void
      {
         var _loc2_:Object = this._1827029976accountId;
         if(_loc2_ !== param1)
         {
            this._1827029976accountId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"accountId",_loc2_,param1));
         }
      }
      
      public function set _3241058isMe(param1:Boolean) : void
      {
         this._isMe = param1;
      }
      
      public function set summonerId(param1:Number) : void
      {
         var _loc2_:Object = this._80971529summonerId;
         if(_loc2_ !== param1)
         {
            this._80971529summonerId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerId",_loc2_,param1));
         }
      }
      
      public function set profileIconId(param1:int) : void
      {
         var _loc2_:Object = this._1359356291profileIconId;
         if(_loc2_ !== param1)
         {
            this._1359356291profileIconId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"profileIconId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get profileIconId() : int
      {
         return this._1359356291profileIconId;
      }
      
      public function equals(param1:GameObserver) : Boolean
      {
         return param1 == this || param1 != null && param1.accountId == this.accountId && param1.summonerId == this.summonerId;
      }
   }
}

