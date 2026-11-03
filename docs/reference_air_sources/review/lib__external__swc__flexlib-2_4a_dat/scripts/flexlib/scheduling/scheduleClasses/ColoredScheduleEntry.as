package flexlib.scheduling.scheduleClasses
{
   public class ColoredScheduleEntry extends SimpleScheduleEntry implements IScheduleEntry
   {
      
      public var backgroundColor:int = 13421772;
      
      public function ColoredScheduleEntry()
      {
         super();
      }
      
      override public function toString() : String
      {
         return "[object ColoredScheduleEntry startDate:" + startDate + " endDate:" + endDate + "]";
      }
   }
}

