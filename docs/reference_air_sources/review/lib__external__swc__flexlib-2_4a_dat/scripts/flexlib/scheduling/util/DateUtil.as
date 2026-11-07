package flexlib.scheduling.util
{
   public class DateUtil
   {
      
      public static const MINUTE_IN_MILLISECONDS:Number = 60 * 1000;
      
      public static const HOUR_IN_MILLISECONDS:Number = 60 * 60 * 1000;
      
      public static const DAY_IN_MILLISECONDS:Number = 24 * 60 * 60 * 1000;
      
      public static const WEEK_IN_MILLISECONDS:Number = 7 * 24 * 60 * 60 * 1000;
      
      public static const MONTH_IN_MILLISECONDS:Number = 30 * 24 * 60 * 60 * 1000;
      
      public static const YEAR_IN_MILLISECONDS:Number = 12 * 30 * 24 * 60 * 60 * 1000;
      
      public static const CENTURY_IN_MILLISECONDS:Number = 100 * 12 * 30 * 24 * 60 * 60 * 1000;
      
      public static const MILLENIUM_IN_MILLISECONDS:Number = 1000 * 100 * 12 * 30 * 24 * 60 * 60 * 1000;
      
      public function DateUtil()
      {
         super();
      }
      
      public static function addTime(date:Date, time:Number) : Date
      {
         date.milliseconds += time;
         return date;
      }
      
      public static function setTime(date:Date, time:Number) : Date
      {
         date.hours = Math.floor(time / (1000 * 60 * 60) % 24);
         date.minutes = Math.floor(time / (1000 * 60) % 60);
         date.seconds = Math.floor(time / 1000 % 60);
         date.milliseconds = Math.floor(time % 1000);
         return date;
      }
      
      public static function copyDate(date:Date) : Date
      {
         return new Date(date.getTime());
      }
      
      public static function clearTime(date:Date) : Date
      {
         date.hours = 0;
         date.minutes = 0;
         date.seconds = 0;
         date.milliseconds = 0;
         return date;
      }
   }
}

