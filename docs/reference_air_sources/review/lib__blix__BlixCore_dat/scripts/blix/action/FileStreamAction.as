package blix.action
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.ByteArray;
   
   public class FileStreamAction extends BasicAction
   {
      
      public var unmarshallDataFunction:Function;
      
      public var unmarshalledData:*;
      
      public var data:ByteArray;
      
      public var file:File;
      
      protected var fileStream:FileStream;
      
      public function FileStreamAction(param1:File = null, param2:Boolean = false)
      {
         super(param2);
         this.fileStream = new FileStream();
         this.fileStream.addEventListener(Event.COMPLETE,this.completedHandler);
         this.fileStream.addEventListener(IOErrorEvent.IO_ERROR,this.erredHandler);
         this.file = param1;
      }
      
      override protected function doInvocation() : void
      {
         if(this.file == null)
         {
            err(new Error("file not set."));
            return;
         }
         if(this.file.exists)
         {
            this.fileStream.openAsync(this.file,FileMode.READ);
         }
         else
         {
            this.data = null;
            complete();
         }
      }
      
      protected function completedHandler(param1:Event) : void
      {
         var event:Event = param1;
         this.data = new ByteArray();
         this.fileStream.readBytes(this.data);
         this.fileStream.close();
         if(this.unmarshallDataFunction != null)
         {
            try
            {
               this.unmarshalledData = this.unmarshallDataFunction(this.data);
            }
            catch(error:Error)
            {
               err(error);
               return;
            }
         }
         complete();
      }
      
      protected function erredHandler(param1:ErrorEvent) : void
      {
         err(new Error(param1.text));
      }
      
      override public function abort() : void
      {
         if(getIsFinished())
         {
            return;
         }
         if(_hasBeenInvoked)
         {
            this.fileStream.close();
         }
         super.abort();
      }
   }
}

