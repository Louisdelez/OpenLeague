package com.riotgames.platform.gameclient.event.summoner
{
   import flash.events.Event;
   
   public class FilterStringChangeEvent extends Event
   {
      
      public var filterValue:String;
      
      public function FilterStringChangeEvent(param1:String, param2:String, param3:Boolean = false)
      {
         super(param1,param3,false);
         this.filterValue = param2;
      }
      
      override public function clone() : Event
      {
         return new FilterStringChangeEvent(type,this.filterValue);
      }
   }
}

