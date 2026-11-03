package com.riotgames.binding
{
   import flash.events.Event;
   
   public class BindingEvent extends Event
   {
      
      public static const EVENT:String = "event";
      
      private var _data:Object;
      
      public function BindingEvent(param1:String, param2:Object)
      {
         super(param1);
         this._data = param2;
      }
      
      public function get Data() : Object
      {
         return this._data;
      }
      
      override public function clone() : Event
      {
         return new BindingEvent(type,this._data);
      }
   }
}

