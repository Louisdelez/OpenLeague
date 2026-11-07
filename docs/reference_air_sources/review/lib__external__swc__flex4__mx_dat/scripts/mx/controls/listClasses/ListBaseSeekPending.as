package mx.controls.listClasses
{
   import mx.collections.CursorBookmark;
   
   public class ListBaseSeekPending
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public var bookmark:CursorBookmark;
      
      public var offset:int;
      
      public function ListBaseSeekPending(bookmark:CursorBookmark, offset:int)
      {
         super();
         this.bookmark = bookmark;
         this.offset = offset;
      }
   }
}

