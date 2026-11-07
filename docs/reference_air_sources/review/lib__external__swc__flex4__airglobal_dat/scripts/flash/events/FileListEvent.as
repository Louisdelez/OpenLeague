package flash.events
{
   [API("661")]
   public class FileListEvent extends Event
   {
      
      public static const DIRECTORY_LISTING:String = "directoryListing";
      
      public static const SELECT_MULTIPLE:String = "selectMultiple";
      
      [ArrayElementType("flash.filesystem.File")]
      public var files:Array;
      
      public function FileListEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, files:Array = null)
      {
         super(type,bubbles,cancelable);
         this.files = files;
      }
   }
}

