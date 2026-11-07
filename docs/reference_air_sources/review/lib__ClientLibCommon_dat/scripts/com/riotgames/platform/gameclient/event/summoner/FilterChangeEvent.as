package com.riotgames.platform.gameclient.event.summoner
{
   import flash.events.Event;
   
   public class FilterChangeEvent extends Event
   {
      
      public var filterValue:Boolean;
      
      public function FilterChangeEvent(param1:String, param2:Boolean)
      {
         super(param1,false,false);
         this.filterValue = param2;
      }
      
      override public function clone() : Event
      {
         return new FilterChangeEvent(type,this.filterValue);
      }
   }
}

