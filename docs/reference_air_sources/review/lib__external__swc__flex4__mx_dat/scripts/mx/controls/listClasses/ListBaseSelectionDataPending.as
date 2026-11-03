package mx.controls.listClasses
{
   import mx.collections.CursorBookmark;
   
   [ExcludeClass]
   public class ListBaseSelectionDataPending
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public var bookmark:CursorBookmark;
      
      public var index:int;
      
      public var items:Array;
      
      public var offset:int;
      
      public var useFind:Boolean;
      
      public function ListBaseSelectionDataPending(useFind:Boolean, index:int, items:Array, bookmark:CursorBookmark, offset:int)
      {
         super();
         this.useFind = useFind;
         this.index = index;
         this.items = items;
         this.bookmark = bookmark;
         this.offset = offset;
      }
   }
}

