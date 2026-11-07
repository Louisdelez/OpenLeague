package flash.events
{
   import flash.desktop.Clipboard;
   import flash.desktop.NativeDragOptions;
   import flash.display.InteractiveObject;
   
   public class NativeDragEvent extends MouseEvent
   {
      
      public static const NATIVE_DRAG_ENTER:String = "nativeDragEnter";
      
      public static const NATIVE_DRAG_OVER:String = "nativeDragOver";
      
      public static const NATIVE_DRAG_DROP:String = "nativeDragDrop";
      
      public static const NATIVE_DRAG_EXIT:String = "nativeDragExit";
      
      public static const NATIVE_DRAG_START:String = "nativeDragStart";
      
      public static const NATIVE_DRAG_UPDATE:String = "nativeDragUpdate";
      
      public static const NATIVE_DRAG_COMPLETE:String = "nativeDragComplete";
      
      public var clipboard:Clipboard;
      
      public var allowedActions:NativeDragOptions;
      
      public var dropAction:String;
      
      public function NativeDragEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true, localX:Number = undefined, localY:Number = undefined, relatedObject:InteractiveObject = null, clipboard:Clipboard = null, allowedActions:NativeDragOptions = null, dropAction:String = null, controlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false, commandKey:Boolean = false)
      {
         super(type,bubbles,cancelable,localX,localY,relatedObject);
         if(type == NATIVE_DRAG_DROP || type == NATIVE_DRAG_COMPLETE)
         {
            buttonDown = false;
         }
         else
         {
            buttonDown = true;
         }
         this.clipboard = clipboard;
         this.allowedActions = allowedActions;
         this.dropAction = dropAction;
         this.controlKey = controlKey;
         this.altKey = altKey;
         this.shiftKey = shiftKey;
         this.commandKey = commandKey;
      }
      
      override public function clone() : Event
      {
         return new NativeDragEvent(type,bubbles,cancelable,localX,localY,relatedObject,this.clipboard,this.allowedActions,this.dropAction,controlKey,altKey,shiftKey,commandKey);
      }
      
      override public function toString() : String
      {
         return formatToString("NativeDragEvent","type","bubbles","cancelable","localX","localY","stageX","stageY","relatedObject","clipboard","allowedActions","dropAction","controlKey","altKey","shiftKey","commandKey");
      }
   }
}

