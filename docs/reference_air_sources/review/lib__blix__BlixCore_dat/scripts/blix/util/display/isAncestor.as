package blix.util.display
{
   import flash.display.DisplayObject;
   
   public function isAncestor(param1:DisplayObject, param2:DisplayObject) : Boolean
   {
      if(param1 == null || param2 == null)
      {
         return false;
      }
      var _loc3_:DisplayObject = param2;
      while(_loc3_ != null)
      {
         if(_loc3_ == param1)
         {
            return true;
         }
         _loc3_ = _loc3_.parent;
      }
      return false;
   }
}

