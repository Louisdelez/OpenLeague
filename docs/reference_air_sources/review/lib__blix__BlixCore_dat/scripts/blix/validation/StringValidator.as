package blix.validation
{
   import blix.model.TextModel;
   import blix.model.TextModelTokenizer;
   
   public class StringValidator extends ValidatorBase
   {
      
      public var value:String;
      
      public var required:Boolean = true;
      
      public var minLength:int = -1;
      
      public var maxLength:int = 2147483647;
      
      public var requiredErrorText:TextModel;
      
      public var minLengthErrorText:TextModel;
      
      public var maxLengthErrorText:TextModel;
      
      public function StringValidator()
      {
         super();
      }
      
      override protected function doValidation() : void
      {
         var _loc1_:Vector.<String> = null;
         if(this.required && !this.value)
         {
            addError(this.requiredErrorText);
         }
         if(this.value != null && this.value.length < this.minLength)
         {
            _loc1_ = new Vector.<String>(2,true);
            _loc1_[0] = this.minLength.toString();
            _loc1_[1] = this.value.length.toString();
            addError(new TextModelTokenizer(this.minLengthErrorText,_loc1_));
         }
         if(this.value != null && this.value.length > this.maxLength)
         {
            _loc1_ = new Vector.<String>(2,true);
            _loc1_[0] = this.maxLength.toString();
            _loc1_[1] = this.value.length.toString();
            addError(new TextModelTokenizer(this.maxLengthErrorText,_loc1_));
         }
      }
   }
}

