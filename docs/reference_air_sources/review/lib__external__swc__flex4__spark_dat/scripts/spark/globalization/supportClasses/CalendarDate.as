package spark.globalization.supportClasses
{
   [ExcludeClass]
   [ResourceBundle("core")]
   public class CalendarDate
   {
      
      private static const MILLISECONDS_PER_DAY:int = 1000 * 60 * 60 * 24;
      
      private var _date:Date;
      
      public function CalendarDate(date:Date = null)
      {
         super();
         if(!date)
         {
            date = new Date();
         }
         this.date = date;
      }
      
      private static function getBeginingOfMonth(date:Date) : Date
      {
         var d:Date = new Date(date);
         d.date = 1;
         return d;
      }
      
      private static function getBeginingOfNextMonth(date:Date) : Date
      {
         var d:Date = new Date(date);
         d.date = 28;
         while(d.month == date.month)
         {
            d.time += MILLISECONDS_PER_DAY;
         }
         return d;
      }
      
      private static function getEndOfMonth(date:Date) : Date
      {
         var d:Date = getBeginingOfNextMonth(date);
         d.time -= MILLISECONDS_PER_DAY;
         return d;
      }
      
      public function get date() : Date
      {
         return this._date;
      }
      
      public function set date(value:Date) : void
      {
         this._date = value;
      }
      
      public function get numDaysInMonth() : int
      {
         return getEndOfMonth(this.date).date - getBeginingOfMonth(this.date).date + 1;
      }
   }
}

