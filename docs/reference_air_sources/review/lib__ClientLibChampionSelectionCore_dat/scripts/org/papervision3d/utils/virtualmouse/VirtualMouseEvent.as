package org.papervision3d.utils.virtualmouse
{
   import flash.events.Event;
   
   public class VirtualMouseEvent extends Event implements IVirtualMouseEvent
   {
      
      public function VirtualMouseEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

