package com.riotgames.platform.gameclient.controllers.game.event
{
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import flash.events.Event;
   
   public class RunePageSelectEvent extends Event
   {
      
      public static const PAGE_SELECTED:String = "pageSelected";
      
      private var _runePage:SpellBookPageDTO = null;
      
      public function RunePageSelectEvent(param1:String, param2:SpellBookPageDTO, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._runePage = param2;
      }
      
      public function get runePage() : SpellBookPageDTO
      {
         return this._runePage;
      }
      
      override public function clone() : Event
      {
         return new RunePageSelectEvent(type,this.runePage,bubbles,cancelable);
      }
   }
}

