package com.riotgames.platform.gameclient.domain.game.matched
{
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.matchmaking.QueueThrottled")]
   public class QueueThrottled extends FailedJoinPlayer
   {
      
      private var _655172108queueId:Number;
      
      private var _954925063message:String;
      
      public function QueueThrottled()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get message() : String
      {
         return this._954925063message;
      }
      
      [Bindable(event="propertyChange")]
      public function get queueId() : Number
      {
         return this._655172108queueId;
      }
      
      public function set message(param1:String) : void
      {
         var _loc2_:Object = this._954925063message;
         if(_loc2_ !== param1)
         {
            this._954925063message = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"message",_loc2_,param1));
         }
      }
      
      public function set queueId(param1:Number) : void
      {
         var _loc2_:Object = this._655172108queueId;
         if(_loc2_ !== param1)
         {
            this._655172108queueId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"queueId",_loc2_,param1));
         }
      }
   }
}

