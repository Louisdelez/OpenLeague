package hr.binaria.asx3m.converters.extended
{
   import hr.binaria.asx3m.converters.basic.AbstractSingleValueConverter;
   
   public class DateConverter extends AbstractSingleValueConverter
   {
      
      public function DateConverter()
      {
         super();
      }
      
      override public function canConvert(param1:Class) : Boolean
      {
         return new param1() is Date;
      }
      
      private function addLeadingZero(param1:Number) : String
      {
         return param1.toString().length == 2 ? param1.toString() : "0" + param1.toString();
      }
      
      override public function fromString(param1:String) : Object
      {
         var _loc2_:Date = new Date();
         _loc2_.setFullYear(Number(param1.substr(0,4)),Number(param1.substr(5,2)) - 1,Number(param1.substr(8,2)));
         _loc2_.setHours(Number(param1.substr(11,2)),Number(param1.substr(14,2)),Number(param1.substr(17,2)),Number(param1.substr(20,3)));
         return _loc2_;
      }
      
      override public function toString(param1:Object) : String
      {
         var _loc2_:Date = null;
         if(param1 != null)
         {
            _loc2_ = param1 as Date;
            return String(_loc2_.fullYear + "-" + addLeadingZero(_loc2_.month + 1) + "-" + addLeadingZero(_loc2_.date) + " " + addLeadingZero(_loc2_.hours) + ":" + addLeadingZero(_loc2_.minutes) + ":" + addLeadingZero(_loc2_.seconds) + "." + _loc2_.milliseconds);
         }
         return null;
      }
   }
}

