package blix.validation
{
   public function validateAllValidators(param1:Vector.<IValidator>) : Vector.<ValidationError>
   {
      var _loc3_:IValidator = null;
      var _loc2_:Vector.<ValidationError> = new Vector.<ValidationError>();
      for each(_loc3_ in param1)
      {
         _loc2_ = _loc2_.concat(_loc3_.validate());
      }
      return _loc2_;
   }
}

