package mx.controls.listClasses
{
   import mx.collections.CursorBookmark;
   
   [ExcludeClass]
   public class ListBaseSelectionPending
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public var bookmark:CursorBookmark;
      
      public var incrementing:Boolean;
      
      public var index:int;
      
      public var offset:int;
      
      public var placeHolder:CursorBookmark;
      
      public var stopData:Object;
      
      public var transition:Boolean;
      
      public function ListBaseSelectionPending(incrementing:Boolean, index:int, stopData:Object, transition:Boolean, placeHolder:CursorBookmark, bookmark:CursorBookmark, offset:int)
      {
         super();
         this.incrementing = incrementing;
         this.index = index;
         this.stopData = stopData;
         this.transition = transition;
         this.placeHolder = placeHolder;
         this.bookmark = bookmark;
         this.offset = offset;
      }
   }
}

