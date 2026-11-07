package blix.util.date
{
   public class DateParser
   {
      
      public function DateParser()
      {
         super();
      }
      
      public static function parseDate(param1:String, param2:String = "Ymdhis") : Date
      {
         var _loc4_:Object = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         if(param1 == null)
         {
            return null;
         }
         var _loc3_:RegExp = /[0-9]+|am|pm|(GMT|UTC)([\+\-0-9]+)/gi;
         var _loc5_:Object = {
            "Y":"",
            "m":"",
            "d":"",
            "h":"",
            "i":"",
            "s":"",
            "a":"",
            "O":""
         };
         var _loc6_:int = -1;
         while(Boolean(_loc4_ = _loc3_.exec(param1)))
         {
            _loc7_ = _loc4_[0];
            _loc8_ = param2.charAt(++_loc6_);
            _loc5_[_loc8_] = _loc7_;
         }
         return new Date(_loc5_.Y + "/" + _loc5_.m + "/" + _loc5_.d + " " + _loc5_.h + ":" + _loc5_.i + ":" + _loc5_.s + " " + _loc5_.a + " " + _loc5_.O);
      }
   }
}

