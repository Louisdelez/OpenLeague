package com.riotgames.pvpnet.cap.model
{
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   
   public class CapEstimatedWaitTimes
   {
      
      public static const UNKNOWN:CapEstimatedWaitTime = createEstimatedWaitTimeUnknown();
      
      public static const VERY_SHORT:CapEstimatedWaitTime = createEstimatedWaitTimeVeryShort();
      
      public static const SHORT:CapEstimatedWaitTime = createEstimatedWaitTimeShort();
      
      public static const AVERAGE:CapEstimatedWaitTime = createEstimatedWaitTimeAverage();
      
      public static const LONG:CapEstimatedWaitTime = createEstimatedWaitTimeLong();
      
      public static const VERY_LONG:CapEstimatedWaitTime = createEstimatedWaitTimeVeryLong();
      
      public function CapEstimatedWaitTimes()
      {
         super();
      }
      
      private static function createEstimatedWaitTimeShort() : CapEstimatedWaitTime
      {
         var _loc1_:CapEstimatedWaitTime = new CapEstimatedWaitTime();
         _loc1_.id = 1;
         _loc1_.name = CapLocaleUtil.getResourceString("gf_estimated_wait_time_short","Short");
         return _loc1_;
      }
      
      private static function createEstimatedWaitTimeVeryShort() : CapEstimatedWaitTime
      {
         var _loc1_:CapEstimatedWaitTime = new CapEstimatedWaitTime();
         _loc1_.id = 0;
         _loc1_.name = CapLocaleUtil.getResourceString("gf_estimated_wait_time_very_short","Very Short");
         return _loc1_;
      }
      
      private static function createEstimatedWaitTimeUnknown() : CapEstimatedWaitTime
      {
         var _loc1_:CapEstimatedWaitTime = new CapEstimatedWaitTime();
         _loc1_.id = -1;
         _loc1_.name = CapLocaleUtil.getResourceString("gf_estimated_wait_time_unknown","Unknown");
         return _loc1_;
      }
      
      private static function createEstimatedWaitTimeVeryLong() : CapEstimatedWaitTime
      {
         var _loc1_:CapEstimatedWaitTime = new CapEstimatedWaitTime();
         _loc1_.id = 4;
         _loc1_.name = CapLocaleUtil.getResourceString("gf_estimated_wait_time_very_long","Very Long");
         return _loc1_;
      }
      
      private static function createEstimatedWaitTimeAverage() : CapEstimatedWaitTime
      {
         var _loc1_:CapEstimatedWaitTime = new CapEstimatedWaitTime();
         _loc1_.id = 2;
         _loc1_.name = CapLocaleUtil.getResourceString("gf_estimated_wait_time_average","Average");
         return _loc1_;
      }
      
      private static function createEstimatedWaitTimeLong() : CapEstimatedWaitTime
      {
         var _loc1_:CapEstimatedWaitTime = new CapEstimatedWaitTime();
         _loc1_.id = 3;
         _loc1_.name = CapLocaleUtil.getResourceString("gf_estimated_wait_time_long","Long");
         return _loc1_;
      }
   }
}

