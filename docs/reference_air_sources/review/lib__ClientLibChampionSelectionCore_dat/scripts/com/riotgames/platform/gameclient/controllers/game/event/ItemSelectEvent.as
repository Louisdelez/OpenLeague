package com.riotgames.platform.gameclient.controllers.game.event
{
   import flash.events.Event;
   
   public class ItemSelectEvent extends Event
   {
      
      public static const SELECT:String = "itemSelect";
      
      public static const ROLL_OVER:String = "itemRollOver";
      
      public static const ROLL_OUT:String = "itemRollOut";
      
      public var data:Object;
      
      public function ItemSelectEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Object = null)
      {
         super(param1,param2,param3);
         this.data = param4;
      }
      
      override public function clone() : Event
      {
         return new ItemSelectEvent(type,bubbles,cancelable,this.data);
      }
   }
}

