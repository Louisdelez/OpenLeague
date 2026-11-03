package com.riotgames.pvpnet.docked.chat.view.accordion
{
   import blix.assets.proxy.DisplayObjectProxy;
   
   public class AccordionEntry
   {
      
      public var headerData:*;
      
      public var content:DisplayObjectProxy;
      
      public function AccordionEntry(param1:* = null, param2:* = null)
      {
         super();
         this.headerData = param1;
         this.content = param2;
      }
   }
}

