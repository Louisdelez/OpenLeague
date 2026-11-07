package mx.events
{
   import flash.events.Event;
   import flash.filesystem.File;
   
   public class FileEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.6.0.12937";
      
      public static const DIRECTORY_CHANGE:String = "directoryChange";
      
      public static const DIRECTORY_CHANGING:String = "directoryChanging";
      
      public static const DIRECTORY_OPENING:String = "directoryOpening";
      
      public static const DIRECTORY_CLOSING:String = "directoryClosing";
      
      public static const FILE_CHOOSE:String = "fileChoose";
      
      public var file:File;
      
      public function FileEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, file:File = null)
      {
         super(type,bubbles,cancelable);
         this.file = file;
      }
      
      override public function clone() : Event
      {
         return new FileEvent(type,bubbles,cancelable,file);
      }
   }
}

