package com.riotgames.platform.gameclient.domain.game.matched
{
   import com.riotgames.platform.gameclient.domain.Summoner;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.game.FailedJoinPlayer")]
   public class FailedJoinPlayer implements IEventDispatcher
   {
      
      public static const REASON_FAILED_ALREADY_IN_GAME:String = "ALREADY_IN_GAME";
      
      public static const REASON_FAILED_QUEUE_DODGER:String = "QUEUE_DODGER";
      
      public static const REASON_FAILED_QUEUE_DISABLED:String = "QUEUE_DISABLED";
      
      public static const REASON_FAILED_RANKED_MIN_LEVEL:String = "RANKED_MIN_LEVEL";
      
      public static const REASON_FAILED_RANKED_MAX_LEVEL:String = "RANKED_MAX_LEVEL";
      
      public static const REASON_FAILED_RANKED_NUM_CHAMPS:String = "RANKED_NUM_CHAMPS";
      
      public static const REASON_FAILED_QUEUE_THROTTLED:String = "QUEUE_THROTTLED";
      
      public static const REASON_FAILED_BINGE_PREVENTION:String = "BINGE_PREVENTION";
      
      public static const REASON_FAILED_MINOR_RESTRICTED:String = "MINOR_RESTRICTED";
      
      public static const REASON_FAILED_RANKED_NUM_CHAMPS_NO_FREE:String = "RANKED_NUM_CHAMPS_NO_FREE";
      
      public static const REASON_FAILED_QUEUE_PARTICIPANTS:String = "QUEUE_PARTICIPANTS";
      
      public static const REASON_FAILED_QUEUE_RESTRICTED:String = "QUEUE_RESTRICTED";
      
      public static const REASON_FAILED_RANKED_RESTRICTED:String = "RANKED_RESTRICTED";
      
      public static const REASON_FAILED_LEAVER_BUSTER_TAINTED_WARNING:String = "LEAVER_BUSTER_TAINTED_WARNING";
      
      public static const REASON_FAILED_LEAVER_BUSTED:String = "LEAVER_BUSTED";
      
      private var _1751869106summoner:Summoner;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1737273439reasonFailed:String;
      
      public function FailedJoinPlayer()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get reasonFailed() : String
      {
         return this._1737273439reasonFailed;
      }
      
      public function set reasonFailed(param1:String) : void
      {
         var _loc2_:Object = this._1737273439reasonFailed;
         if(_loc2_ !== param1)
         {
            this._1737273439reasonFailed = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"reasonFailed",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function toString() : String
      {
         return "[" + this.summoner.name + " (" + this.summoner.sumId + "): " + this.reasonFailed + "]";
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get summoner() : Summoner
      {
         return this._1751869106summoner;
      }
      
      public function set summoner(param1:Summoner) : void
      {
         var _loc2_:Object = this._1751869106summoner;
         if(_loc2_ !== param1)
         {
            this._1751869106summoner = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summoner",_loc2_,param1));
         }
      }
   }
}

