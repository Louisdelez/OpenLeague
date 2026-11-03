package system.data.collections
{
   import system.data.Collection;
   import system.formatters.Formattable;
   
   public class CollectionFormatter implements Formattable
   {
      
      public function CollectionFormatter()
      {
         super();
      }
      
      public function format(param1:* = null) : String
      {
         var _loc2_:String = null;
         var _loc3_:Collection = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(param1 != null && param1 is Collection)
         {
            _loc2_ = "{";
            _loc3_ = param1 as Collection;
            if(_loc3_.size() > 0)
            {
               _loc4_ = _loc3_.toArray();
               _loc5_ = int(_loc4_.length);
               while(_loc6_ < _loc5_)
               {
                  _loc2_ += _loc4_[_loc6_];
                  if(_loc6_ < _loc5_ - 1)
                  {
                     _loc2_ += ",";
                  }
                  _loc6_++;
               }
            }
            return _loc2_ + "}";
         }
         return "";
      }
   }
}

