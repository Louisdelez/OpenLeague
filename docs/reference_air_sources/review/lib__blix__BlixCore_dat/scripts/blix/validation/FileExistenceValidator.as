package blix.validation
{
   import blix.model.TextModel;
   import flash.filesystem.File;
   
   public class FileExistenceValidator extends ValidatorBase
   {
      
      public var relativePath:File;
      
      public var fileLocation:String;
      
      public var required:Boolean;
      
      public var requiredErrorText:TextModel;
      
      public var invalidFileErrorText:TextModel;
      
      public function FileExistenceValidator()
      {
         super();
      }
      
      override protected function doValidation() : void
      {
         var _loc1_:File = null;
         if(!this.fileLocation)
         {
            if(this.required)
            {
               addError(this.requiredErrorText);
            }
            return;
         }
         if(this.relativePath == null)
         {
            _loc1_ = File.applicationDirectory.resolvePath(this.fileLocation);
         }
         else
         {
            _loc1_ = this.relativePath.resolvePath(this.fileLocation);
         }
         if(!_loc1_.exists)
         {
            addError(this.invalidFileErrorText);
         }
      }
   }
}

