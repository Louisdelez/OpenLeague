package flexlib.scheduling.scheduleClasses.layout
{
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   [Event(name="update",type="flexlib.scheduling.scheduleClasses.layout.LayoutUpdateEvent")]
   public class HorizontalLinesLayout extends Layout implements IHorizontalLinesLayout
   {
      
      private var _rowHeight:Number;
      
      public function HorizontalLinesLayout()
      {
         super();
      }
      
      public function get rowHeight() : Number
      {
         return _rowHeight;
      }
      
      public function set rowHeight(value:Number) : void
      {
         _rowHeight = value;
      }
      
      public function update(event:LayoutUpdateEvent) : void
      {
         entryLayout = IEntryLayout(event.layout);
         contentWidth = entryLayout.contentWidth;
         startDate = entryLayout.startDate;
         endDate = entryLayout.endDate;
         viewportWidth = entryLayout.viewportWidth;
         viewportHeight = entryLayout.viewportHeight;
         rowHeight = entryLayout.rowHeight;
         xPosition = entryLayout.xPosition;
         yPosition = entryLayout.yPosition;
         calculateItems(entryLayout);
         dispatchEvent(new LayoutUpdateEvent(this));
      }
      
      protected function calculateItems(entryLayout:IEntryLayout) : void
      {
         var result:IList = null;
         var firstRow:Number = NaN;
         var lastRow:Number = NaN;
         var i:Number = NaN;
         var item:HorizontalLinesLayoutItem = null;
         result = new ArrayCollection();
         firstRow = Math.floor(yPosition / rowHeight);
         lastRow = Math.ceil((yPosition + viewportHeight) / rowHeight);
         for(i = firstRow; i <= lastRow; i++)
         {
            item = new HorizontalLinesLayoutItem();
            item.x = 0;
            item.y = i * rowHeight;
            item.width = viewportWidth;
            result.addItem(item);
         }
         _items = result;
      }
   }
}

