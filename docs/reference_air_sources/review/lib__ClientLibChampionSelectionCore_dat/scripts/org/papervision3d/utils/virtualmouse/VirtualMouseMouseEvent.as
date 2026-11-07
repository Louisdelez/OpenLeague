package org.papervision3d.utils.virtualmouse
{
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   
   public class VirtualMouseMouseEvent extends MouseEvent implements IVirtualMouseEvent
   {
      
      public function VirtualMouseMouseEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, localX:Number = NaN, localY:Number = NaN, relatedObject:InteractiveObject = null, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false, buttonDown:Boolean = false, delta:int = 0)
      {
         super(type,bubbles,cancelable,localX,localY,relatedObject,ctrlKey,altKey,shiftKey,buttonDown,delta);
      }
   }
}

