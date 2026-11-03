package flexlib.scheduling.scheduleClasses
{
   public class SimpleScheduleEntry implements IScheduleEntry
   {
      
      private var _endDate:Date;
      
      private var _startDate:Date;
      
      public var label:String;
      
      public function SimpleScheduleEntry()
      {
         super();
      }
      
      public function set startDate(value:Date) : void
      {
         _startDate = value;
      }
      
      public function get endDate() : Date
      {
         return _endDate;
      }
      
      public function toString() : String
      {
         return "[object SimpleScheduleEntry startDate:" + startDate + " endDate:" + endDate + "]";
      }
      
      public function set endDate(value:Date) : void
      {
         _endDate = value;
      }
      
      public function get startDate() : Date
      {
         return _startDate;
      }
   }
}

