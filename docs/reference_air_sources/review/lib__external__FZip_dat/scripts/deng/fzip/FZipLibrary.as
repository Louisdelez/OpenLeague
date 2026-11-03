package deng.fzip
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.events.*;
   import flash.utils.ByteArray;
   
   [Event(name="complete",type="flash.events.Event")]
   public class FZipLibrary extends EventDispatcher
   {
      
      private static const FORMAT_BITMAPDATA:uint = 1 << 0;
      
      private static const FORMAT_DISPLAYOBJECT:uint = 1 << 1;
      
      private var pendingFiles:Array = [];
      
      private var pendingZips:Array = [];
      
      private var currentState:uint = 0;
      
      private var currentFilename:String;
      
      private var currentZip:FZip;
      
      private var currentLoader:Loader;
      
      private var bitmapDataFormat:RegExp = /[]/;
      
      private var displayObjectFormat:RegExp = /[]/;
      
      private var bitmapDataList:Object = {};
      
      private var displayObjectList:Object = {};
      
      public function FZipLibrary()
      {
         super();
      }
      
      public function addZip(param1:FZip) : void
      {
         this.pendingZips.unshift(param1);
         this.processNext();
      }
      
      public function formatAsBitmapData(param1:String) : void
      {
         this.bitmapDataFormat = this.addExtension(this.bitmapDataFormat,param1);
      }
      
      public function formatAsDisplayObject(param1:String) : void
      {
         this.displayObjectFormat = this.addExtension(this.displayObjectFormat,param1);
      }
      
      private function addExtension(param1:RegExp, param2:String) : RegExp
      {
         return new RegExp(param2.replace(/[^A-Za-z0-9]/,"\\$&") + "$|" + param1.source);
      }
      
      public function getBitmapData(param1:String) : BitmapData
      {
         if(!this.bitmapDataList[param1] is BitmapData)
         {
            throw new Error("File \"" + param1 + "\" was not found as a BitmapData");
         }
         return this.bitmapDataList[param1] as BitmapData;
      }
      
      public function getDisplayObject(param1:String) : DisplayObject
      {
         if(!this.displayObjectList.hasOwnProperty(param1))
         {
            throw new ReferenceError("File \"" + param1 + "\" was not found as a DisplayObject");
         }
         return this.displayObjectList[param1] as DisplayObject;
      }
      
      public function getDefinition(param1:String, param2:String) : Object
      {
         var disp:DisplayObject;
         var filename:String = param1;
         var definition:String = param2;
         if(!this.displayObjectList.hasOwnProperty(filename))
         {
            throw new ReferenceError("File \"" + filename + "\" was not found as a DisplayObject, ");
         }
         disp = this.displayObjectList[filename] as DisplayObject;
         try
         {
            return disp.loaderInfo.applicationDomain.getDefinition(definition);
         }
         catch(e:ReferenceError)
         {
            throw new ReferenceError("Definition \"" + definition + "\" in file \"" + filename + "\" could not be retrieved: " + e.message);
         }
      }
      
      private function processNext(param1:Event = null) : void
      {
         var _loc2_:FZipFile = null;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         while(this.currentState === 0)
         {
            if(this.pendingFiles.length > 0)
            {
               _loc2_ = this.pendingFiles.pop();
               if(this.bitmapDataFormat.test(_loc2_.filename))
               {
                  this.currentState |= FORMAT_BITMAPDATA;
               }
               if(this.displayObjectFormat.test(_loc2_.filename))
               {
                  this.currentState |= FORMAT_DISPLAYOBJECT;
               }
               if((this.currentState & (FORMAT_BITMAPDATA | FORMAT_DISPLAYOBJECT)) !== 0)
               {
                  this.currentFilename = _loc2_.filename;
                  this.currentLoader = new Loader();
                  this.currentLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loaderCompleteHandler);
                  this.currentLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.loaderCompleteHandler);
                  _loc3_ = _loc2_.content;
                  _loc3_.position = 0;
                  this.currentLoader.loadBytes(_loc3_);
                  break;
               }
            }
            else
            {
               if(this.currentZip != null)
               {
                  break;
               }
               if(this.pendingZips.length <= 0)
               {
                  dispatchEvent(new Event(Event.COMPLETE));
                  break;
               }
               this.currentZip = this.pendingZips.pop();
               _loc4_ = this.currentZip.getFileCount();
               while(_loc4_ > 0)
               {
                  this.pendingFiles.push(this.currentZip.getFileAt(--_loc4_));
               }
               if(this.currentZip.active)
               {
                  this.currentZip.addEventListener(Event.COMPLETE,this.zipCompleteHandler);
                  this.currentZip.addEventListener(FZipEvent.FILE_LOADED,this.fileCompleteHandler);
                  this.currentZip.addEventListener(FZipErrorEvent.PARSE_ERROR,this.zipCompleteHandler);
                  break;
               }
               this.currentZip = null;
            }
         }
      }
      
      private function loaderCompleteHandler(param1:Event) : void
      {
         var _loc2_:BitmapData = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:BitmapData = null;
         if((this.currentState & FORMAT_BITMAPDATA) === FORMAT_BITMAPDATA)
         {
            if(this.currentLoader.content is Bitmap && (this.currentLoader.content as Bitmap).bitmapData is BitmapData)
            {
               _loc2_ = (this.currentLoader.content as Bitmap).bitmapData;
               this.bitmapDataList[this.currentFilename] = _loc2_.clone();
            }
            else if(this.currentLoader.content is DisplayObject)
            {
               _loc3_ = uint(this.currentLoader.content.width);
               _loc4_ = uint(this.currentLoader.content.height);
               if(Boolean(_loc3_) && Boolean(_loc4_))
               {
                  _loc5_ = new BitmapData(_loc3_,_loc4_,true,0);
                  _loc5_.draw(this.currentLoader);
                  this.bitmapDataList[this.currentFilename] = _loc5_;
               }
            }
         }
         if((this.currentState & FORMAT_DISPLAYOBJECT) === FORMAT_DISPLAYOBJECT)
         {
            if(this.currentLoader.content is DisplayObject)
            {
               this.displayObjectList[this.currentFilename] = this.currentLoader.content;
            }
            else
            {
               this.currentLoader.unload();
            }
         }
         else
         {
            this.currentLoader.unload();
         }
         this.currentLoader = null;
         this.currentFilename = "";
         this.currentState &= ~(FORMAT_BITMAPDATA | FORMAT_DISPLAYOBJECT);
         this.processNext();
      }
      
      private function fileCompleteHandler(param1:FZipEvent) : void
      {
         this.pendingFiles.unshift(param1.file);
         this.processNext();
      }
      
      private function zipCompleteHandler(param1:Event) : void
      {
         this.currentZip.removeEventListener(Event.COMPLETE,this.zipCompleteHandler);
         this.currentZip.removeEventListener(FZipEvent.FILE_LOADED,this.fileCompleteHandler);
         this.currentZip.removeEventListener(FZipErrorEvent.PARSE_ERROR,this.zipCompleteHandler);
         this.currentZip = null;
         this.processNext();
      }
   }
}

