package flexlib.controls
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.utils.ByteArray;
   import mx.controls.Image;
   import mx.utils.Base64Decoder;
   
   public class Base64Image extends Image
   {
      
      private var _base64String:String;
      
      private var _source:Object;
      
      public function Base64Image()
      {
         super();
      }
      
      override public function get source() : Object
      {
         return _source;
      }
      
      override public function set source(value:Object) : void
      {
         var decoder:Base64Decoder = null;
         var byteArray:ByteArray = null;
         var loader:Loader = null;
         _source = value;
         decoder = new Base64Decoder();
         try
         {
            decoder.decode(value as String);
            byteArray = decoder.flush();
            loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onBytesLoaded);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
            loader.loadBytes(byteArray);
         }
         catch(error:Error)
         {
            super.source = value;
         }
      }
      
      private function onBytesLoaded(event:Event) : void
      {
         var content:DisplayObject = null;
         var bitmapData:BitmapData = null;
         content = LoaderInfo(event.target).content;
         bitmapData = new BitmapData(content.width,content.height);
         bitmapData.draw(content);
         super.source = new Bitmap(bitmapData);
      }
      
      public function get value() : String
      {
         return _base64String;
      }
      
      private function onIOError(event:IOErrorEvent) : void
      {
         super.source = _source;
      }
      
      public function set value(value:String) : void
      {
         _base64String = value;
         source = value;
      }
   }
}

