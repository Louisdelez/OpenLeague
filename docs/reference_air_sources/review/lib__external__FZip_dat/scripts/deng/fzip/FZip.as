package deng.fzip
{
   import flash.events.*;
   import flash.net.URLRequest;
   import flash.net.URLStream;
   import flash.text.*;
   import flash.utils.*;
   
   [Event(name="securityError",type="flash.events.SecurityErrorEvent")]
   [Event(name="progress",type="flash.events.ProgressEvent")]
   [Event(name="open",type="flash.events.Event")]
   [Event(name="ioError",type="flash.events.IOErrorEvent")]
   [Event(name="httpStatus",type="flash.events.HTTPStatusEvent")]
   [Event(name="complete",type="flash.events.Event")]
   [Event(name="parseError",type="deng.fzip.FZipErrorEvent")]
   [Event(name="fileLoaded",type="deng.fzip.FZipEvent")]
   public class FZip extends EventDispatcher
   {
      
      private var filesList:Array;
      
      private var filesDict:Dictionary;
      
      private var urlStream:URLStream;
      
      private var charEncoding:String;
      
      private var parseFunc:Function;
      
      private var currentFile:FZipFile;
      
      public function FZip(param1:String = "utf-8")
      {
         super();
         this.charEncoding = param1;
         this.parseFunc = this.parseIdle;
      }
      
      public function get active() : Boolean
      {
         return this.parseFunc !== this.parseIdle;
      }
      
      public function load(param1:URLRequest) : void
      {
         if(!this.urlStream && this.parseFunc == this.parseIdle)
         {
            this.urlStream = new URLStream();
            this.urlStream.endian = Endian.LITTLE_ENDIAN;
            this.addEventHandlers();
            this.filesList = [];
            this.filesDict = new Dictionary();
            this.parseFunc = this.parseSignature;
            this.urlStream.load(param1);
         }
      }
      
      public function loadBytes(param1:ByteArray) : void
      {
         if(!this.urlStream && this.parseFunc == this.parseIdle)
         {
            this.filesList = [];
            this.filesDict = new Dictionary();
            param1.position = 0;
            param1.endian = Endian.LITTLE_ENDIAN;
            this.parseFunc = this.parseSignature;
            if(this.parse(param1))
            {
               this.parseFunc = this.parseIdle;
               dispatchEvent(new Event(Event.COMPLETE));
            }
            else
            {
               dispatchEvent(new FZipErrorEvent(FZipErrorEvent.PARSE_ERROR,"EOF"));
            }
         }
      }
      
      public function close() : void
      {
         if(Boolean(this.urlStream))
         {
            this.parseFunc = this.parseIdle;
            this.removeEventHandlers();
            this.urlStream.close();
            this.urlStream = null;
         }
      }
      
      public function serialize(param1:IDataOutput, param2:Boolean = false) : void
      {
         var _loc3_:String = null;
         var _loc4_:ByteArray = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         var _loc8_:FZipFile = null;
         if(param1 != null && this.filesList.length > 0)
         {
            _loc3_ = param1.endian;
            _loc4_ = new ByteArray();
            param1.endian = _loc4_.endian = Endian.LITTLE_ENDIAN;
            _loc5_ = 0;
            _loc6_ = 0;
            _loc7_ = 0;
            while(_loc7_ < this.filesList.length)
            {
               _loc8_ = this.filesList[_loc7_] as FZipFile;
               if(_loc8_ != null)
               {
                  _loc8_.serialize(_loc4_,param2,true,_loc5_);
                  _loc5_ += _loc8_.serialize(param1,param2);
                  _loc6_++;
               }
               _loc7_++;
            }
            if(_loc4_.length > 0)
            {
               param1.writeBytes(_loc4_);
            }
            param1.writeUnsignedInt(101010256);
            param1.writeShort(0);
            param1.writeShort(0);
            param1.writeShort(_loc6_);
            param1.writeShort(_loc6_);
            param1.writeUnsignedInt(_loc4_.length);
            param1.writeUnsignedInt(_loc5_);
            param1.writeShort(0);
            param1.endian = _loc3_;
         }
      }
      
      public function getFileCount() : uint
      {
         return Boolean(this.filesList) ? this.filesList.length : 0;
      }
      
      public function getFileAt(param1:uint) : FZipFile
      {
         return Boolean(this.filesList) ? this.filesList[param1] as FZipFile : null;
      }
      
      public function getFileByName(param1:String) : FZipFile
      {
         return Boolean(this.filesDict[param1]) ? this.filesDict[param1] as FZipFile : null;
      }
      
      public function addFile(param1:String, param2:ByteArray = null) : FZipFile
      {
         return this.addFileAt(Boolean(this.filesList) ? this.filesList.length : 0,param1,param2);
      }
      
      public function addFileFromString(param1:String, param2:String, param3:String = "utf-8") : FZipFile
      {
         return this.addFileFromStringAt(Boolean(this.filesList) ? this.filesList.length : 0,param1,param2,param3);
      }
      
      public function addFileAt(param1:uint, param2:String, param3:ByteArray = null) : FZipFile
      {
         if(this.filesList == null)
         {
            this.filesList = [];
         }
         if(this.filesDict == null)
         {
            this.filesDict = new Dictionary();
         }
         else if(Boolean(this.filesDict[param2]))
         {
            throw new Error("File already exists: " + param2 + ". Please remove first.");
         }
         var _loc4_:FZipFile = new FZipFile();
         _loc4_.filename = param2;
         _loc4_.content = param3;
         if(param1 >= this.filesList.length)
         {
            this.filesList.push(_loc4_);
         }
         else
         {
            this.filesList.splice(param1,0,_loc4_);
         }
         this.filesDict[param2] = _loc4_;
         return _loc4_;
      }
      
      public function addFileFromStringAt(param1:uint, param2:String, param3:String, param4:String = "utf-8") : FZipFile
      {
         if(this.filesList == null)
         {
            this.filesList = [];
         }
         if(this.filesDict == null)
         {
            this.filesDict = new Dictionary();
         }
         else if(Boolean(this.filesDict[param2]))
         {
            throw new Error("File already exists: " + param2 + ". Please remove first.");
         }
         var _loc5_:FZipFile = new FZipFile();
         _loc5_.filename = param2;
         _loc5_.setContentAsString(param3,param4);
         if(param1 >= this.filesList.length)
         {
            this.filesList.push(_loc5_);
         }
         else
         {
            this.filesList.splice(param1,0,_loc5_);
         }
         this.filesDict[param2] = _loc5_;
         return _loc5_;
      }
      
      public function removeFileAt(param1:uint) : FZipFile
      {
         var _loc2_:FZipFile = null;
         if(this.filesList != null && this.filesDict != null && param1 < this.filesList.length)
         {
            _loc2_ = this.filesList[param1] as FZipFile;
            if(_loc2_ != null)
            {
               this.filesList.splice(param1,1);
               delete this.filesDict[_loc2_.filename];
               return _loc2_;
            }
         }
         return null;
      }
      
      protected function parse(param1:IDataInput) : Boolean
      {
         while(Boolean(this.parseFunc(param1)))
         {
         }
         return this.parseFunc === this.parseIdle;
      }
      
      private function parseIdle(param1:IDataInput) : Boolean
      {
         return false;
      }
      
      private function parseSignature(param1:IDataInput) : Boolean
      {
         var _loc2_:uint = 0;
         if(param1.bytesAvailable >= 4)
         {
            _loc2_ = param1.readUnsignedInt();
            switch(_loc2_)
            {
               case 67324752:
                  this.parseFunc = this.parseLocalfile;
                  this.currentFile = new FZipFile(this.charEncoding);
                  break;
               case 33639248:
               case 101010256:
                  this.parseFunc = this.parseIdle;
                  break;
               default:
                  throw new Error("Unknown record signature.");
            }
            return true;
         }
         return false;
      }
      
      private function parseLocalfile(param1:IDataInput) : Boolean
      {
         if(this.currentFile.parse(param1))
         {
            this.filesList.push(this.currentFile);
            if(Boolean(this.currentFile.filename))
            {
               this.filesDict[this.currentFile.filename] = this.currentFile;
            }
            dispatchEvent(new FZipEvent(FZipEvent.FILE_LOADED,this.currentFile));
            this.currentFile = null;
            if(this.parseFunc != this.parseIdle)
            {
               this.parseFunc = this.parseSignature;
               return true;
            }
         }
         return false;
      }
      
      protected function progressHandler(param1:Event) : void
      {
         var evt:Event = param1;
         dispatchEvent(evt.clone());
         try
         {
            if(this.parse(this.urlStream))
            {
               this.close();
               dispatchEvent(new Event(Event.COMPLETE));
            }
         }
         catch(e:Error)
         {
            close();
            if(!hasEventListener(FZipErrorEvent.PARSE_ERROR))
            {
               throw e;
            }
            dispatchEvent(new FZipErrorEvent(FZipErrorEvent.PARSE_ERROR,e.message));
         }
      }
      
      protected function defaultHandler(param1:Event) : void
      {
         dispatchEvent(param1.clone());
      }
      
      protected function defaultErrorHandler(param1:Event) : void
      {
         this.close();
         dispatchEvent(param1.clone());
      }
      
      protected function addEventHandlers() : void
      {
         this.urlStream.addEventListener(Event.COMPLETE,this.defaultHandler);
         this.urlStream.addEventListener(Event.OPEN,this.defaultHandler);
         this.urlStream.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.defaultHandler);
         this.urlStream.addEventListener(IOErrorEvent.IO_ERROR,this.defaultErrorHandler);
         this.urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.defaultErrorHandler);
         this.urlStream.addEventListener(ProgressEvent.PROGRESS,this.progressHandler);
      }
      
      protected function removeEventHandlers() : void
      {
         this.urlStream.removeEventListener(Event.COMPLETE,this.defaultHandler);
         this.urlStream.removeEventListener(Event.OPEN,this.defaultHandler);
         this.urlStream.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.defaultHandler);
         this.urlStream.removeEventListener(IOErrorEvent.IO_ERROR,this.defaultErrorHandler);
         this.urlStream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.defaultErrorHandler);
         this.urlStream.removeEventListener(ProgressEvent.PROGRESS,this.progressHandler);
      }
   }
}

