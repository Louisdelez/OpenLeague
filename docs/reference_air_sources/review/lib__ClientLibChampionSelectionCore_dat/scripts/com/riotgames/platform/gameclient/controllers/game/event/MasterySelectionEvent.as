package com.riotgames.platform.gameclient.controllers.game.event
{
   import com.riotgames.platform.masteries.objects.MasteryPageInfoSummary;
   import flash.events.Event;
   
   public class MasterySelectionEvent extends Event
   {
      
      public static const PAGE_SELECTED:String = "masteryPageSelected";
      
      public static const OPEN_MASTERIES:String = "openMasteries";
      
      private var _masteryPageInfoSummary:MasteryPageInfoSummary;
      
      public function MasterySelectionEvent(param1:String, param2:MasteryPageInfoSummary, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._masteryPageInfoSummary = param2;
      }
      
      public function get masteryPageInfoSummary() : MasteryPageInfoSummary
      {
         return this._masteryPageInfoSummary;
      }
      
      override public function clone() : Event
      {
         return new MasterySelectionEvent(type,this.masteryPageInfoSummary,bubbles,cancelable);
      }
   }
}

