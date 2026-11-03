package flash.media
{
   import flash.events.EventDispatcher;
   import flash.utils.*;
   
   [API("671")]
   [native(cls="InputMediaStreamClass",instance="InputMediaStreamObject",methods="auto")]
   [Event(name="complete",type="flash.events.Event")]
   [Event(name="progress",type="flash.events.ProgressEvent")]
   [Event(name="ioError",type="flash.events.IOErrorEvent")]
   [Event(name="close",type="flash.events.Event")]
   internal class InputMediaStream extends EventDispatcher implements IDataInput
   {
      
      public function InputMediaStream()
      {
         super();
      }
      
      public native function get bytesAvailable() : uint;
      
      public native function get endian() : String;
      
      public native function set endian(param1:String) : void;
      
      public native function get objectEncoding() : uint;
      
      public native function set objectEncoding(param1:uint) : void;
      
      public native function readBoolean() : Boolean;
      
      public native function readByte() : int;
      
      public native function readBytes(param1:ByteArray, param2:uint = 0, param3:uint = 0) : void;
      
      public native function readDouble() : Number;
      
      public native function readFloat() : Number;
      
      public native function readInt() : int;
      
      public native function readMultiByte(param1:uint, param2:String) : String;
      
      public native function readObject() : *;
      
      public native function readShort() : int;
      
      public native function readUnsignedByte() : uint;
      
      public native function readUnsignedInt() : uint;
      
      public native function readUnsignedShort() : uint;
      
      public native function readUTF() : String;
      
      public native function readUTFBytes(param1:uint) : String;
      
      public native function open() : *;
      
      public native function close() : *;
   }
}

