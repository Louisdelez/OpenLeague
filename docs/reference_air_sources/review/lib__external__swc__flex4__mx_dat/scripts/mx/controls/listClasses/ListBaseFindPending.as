package mx.controls.listClasses
{
   import mx.collections.CursorBookmark;
   
   [ExcludeClass]
   public class ListBaseFindPending
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public var bookmark:CursorBookmark;
      
      public var currentIndex:int;
      
      public var offset:int;
      
      public var searchString:String;
      
      public var startingBookmark:CursorBookmark;
      
      public var stopIndex:int;
      
      public function ListBaseFindPending(searchString:String, startingBookmark:CursorBookmark, bookmark:CursorBookmark, offset:int, currentIndex:int, stopIndex:int)
      {
         super();
         this.searchString = searchString;
         this.startingBookmark = startingBookmark;
         this.bookmark = bookmark;
         this.offset = offset;
         this.currentIndex = currentIndex;
         this.stopIndex = stopIndex;
      }
   }
}

