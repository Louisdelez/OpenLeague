package spark.effects.animation
{
   import flash.utils.getTimer;
   
   internal class Timeline
   {
      
      private static var startTime:int = -1;
      
      private static var _currentTime:int = -1;
      
      public function Timeline()
      {
         super();
      }
      
      public static function pulse() : int
      {
         if(startTime < 0)
         {
            startTime = getTimer();
            _currentTime = 0;
            return _currentTime;
         }
         _currentTime = getTimer() - startTime;
         return _currentTime;
      }
      
      public static function get currentTime() : int
      {
         var retVal:int = 0;
         if(_currentTime < 0)
         {
            retVal = pulse();
            return pulse();
         }
         return _currentTime;
      }
   }
}

