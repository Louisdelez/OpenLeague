package blix.logger
{
   public class LogLevelsEnum
   {
      
      public static const FATAL:uint = 1;
      
      public static const ERROR:uint = 2;
      
      public static const WARN:uint = 3;
      
      public static const INFO:uint = 4;
      
      public static const DEBUG:uint = 5;
      
      public function LogLevelsEnum()
      {
         super();
      }
      
      public static function levelToString(param1:uint) : String
      {
         switch(param1)
         {
            case FATAL:
               return "FATAL";
            case ERROR:
               return "ERROR";
            case WARN:
               return " WARN";
            case INFO:
               return " INFO";
            case DEBUG:
               return "DEBUG";
            default:
               return "Unknown";
         }
      }
   }
}

