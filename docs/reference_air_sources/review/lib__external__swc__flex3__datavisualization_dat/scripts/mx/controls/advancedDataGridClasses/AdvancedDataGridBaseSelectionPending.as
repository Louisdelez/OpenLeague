package mx.controls.advancedDataGridClasses
{
   import mx.collections.CursorBookmark;
   
   [ExcludeClass]
   public class AdvancedDataGridBaseSelectionPending
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public var placeHolder:CursorBookmark;
      
      public var anchorColumnIndex:int;
      
      public var index:int;
      
      public var transition:Boolean;
      
      public var bookmark:CursorBookmark;
      
      public var offset:int;
      
      public var stopData:Object;
      
      public var columnIndex:int;
      
      public var anchorIndex:int;
      
      public function AdvancedDataGridBaseSelectionPending(index:int, anchorIndex:int, columnIndex:int, anchorColumnIndex:int, stopData:Object, transition:Boolean, placeHolder:CursorBookmark, bookmark:CursorBookmark, offset:int)
      {
         super();
         this.index = index;
         this.anchorIndex = anchorIndex;
         this.columnIndex = columnIndex;
         this.stopData = stopData;
         this.transition = transition;
         this.placeHolder = placeHolder;
         this.bookmark = bookmark;
         this.offset = offset;
      }
   }
}

