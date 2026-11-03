package flexlib.scheduling.scheduleClasses.layout
{
   import flexlib.scheduling.scheduleClasses.IScheduleEntry;
   
   public class EntryLayoutItem
   {
      
      public var width:Number;
      
      public var data:IScheduleEntry;
      
      public var height:Number;
      
      public var zoom:Number;
      
      public var x:Number;
      
      public var y:Number;
      
      public var row:Number;
      
      public function EntryLayoutItem()
      {
         super();
      }
      
      public function toString() : String
      {
         return "[object EntryLayoutItem" + " row:" + row + " x:" + x + " y:" + y + " width:" + width + " height:" + height + "]";
      }
   }
}

