package com.riotgames.pvpnet.cap.observers.group
{
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class PenaltyTimeObserver extends BaseGroupObserver
   {
      
      private var timerToPlayerSelectionDictionary:Dictionary = new Dictionary();
      
      private var TIME_TICK_DELTA:int = 1000;
      
      private var playerSelectionToTimerDictionary:Dictionary = new Dictionary();
      
      public function PenaltyTimeObserver(param1:CapModel)
      {
         super(param1);
         this.setupSignals();
      }
      
      private function onTimerTick(param1:TimerEvent) : void
      {
         var _loc2_:Timer = param1.target as Timer;
         var _loc3_:CapPlayerSelection = this.timerToPlayerSelectionDictionary[_loc2_];
         if(_loc3_)
         {
            _loc3_.penaltyTimeInSeconds -= int(this.TIME_TICK_DELTA / 1000);
            if(_loc3_.penaltyTimeInSeconds <= 0)
            {
               _loc2_.removeEventListener(TimerEvent.TIMER,this.onTimerTick);
               if(_loc3_.currentState == CapPlayerSelection.PENALTY_STATE)
               {
                  _loc3_.currentState = CapPlayerSelection.SEARCHING_STATE;
               }
            }
            return;
         }
         throw new Error("Untracked player timer running.");
      }
      
      override protected function onPropertyChange(param1:CapPlayerSelection) : void
      {
         var _loc3_:Timer = null;
         var _loc2_:Timer = this.playerSelectionToTimerDictionary[param1];
         if(_loc2_)
         {
            _loc2_.removeEventListener(TimerEvent.TIMER,this.onTimerTick);
            _loc2_.stop();
         }
         if(param1.penaltyTimeInSeconds > 0)
         {
            _loc3_ = new Timer(this.TIME_TICK_DELTA,param1.penaltyTimeInSeconds);
            this.playerSelectionToTimerDictionary[param1] = _loc3_;
            this.timerToPlayerSelectionDictionary[_loc3_] = param1;
            _loc3_.addEventListener(TimerEvent.TIMER,this.onTimerTick);
            _loc3_.start();
         }
      }
      
      public function hasTimer(param1:CapPlayerSelection) : Boolean
      {
         return this.playerSelectionToTimerDictionary[param1] != null;
      }
      
      override public function destroy() : void
      {
         var _loc1_:Timer = null;
         super.destroy();
         for each(_loc1_ in this.playerSelectionToTimerDictionary)
         {
            _loc1_.removeEventListener(TimerEvent.TIMER,this.onTimerTick);
            _loc1_.stop();
         }
      }
      
      override public function setupSignals() : void
      {
         var _loc1_:CapPlayerSelection = null;
         var _loc2_:Array = null;
         for each(_loc1_ in CapModelUtil.getAllAvailablePlayerSelections(_model))
         {
            _loc2_ = [];
            _loc2_.push(_loc1_.penaltyTimeInSecondsChanged);
            createSignalHandler(_loc1_,_loc2_);
         }
      }
   }
}

