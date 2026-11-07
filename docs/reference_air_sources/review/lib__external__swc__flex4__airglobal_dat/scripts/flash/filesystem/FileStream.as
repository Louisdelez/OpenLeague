package flash.filesystem
{
   import flash.events.*;
   import flash.utils.*;
   
   [API("661")]
   [native(cls="FileStreamClass",instance="FileStreamObject",methods="auto",construct="check")]
   [Event(name="complete",type="flash.events.Event")]
   [Event(name="outputProgress",type="flash.events.OutputProgressEvent")]
   [Event(name="progress",type="flash.events.ProgressEvent")]
   [Event(name="ioError",type="flash.events.IOErrorEvent")]
   [Event(name="close",type="flash.events.Event")]
   public class FileStream extends EventDispatcher implements IDataInput, IDataOutput
   {
      
      public function FileStream()
      {
         super();
      }
      
      public native function open(param1:File, param2:String) : void;
      
      public native function openAsync(param1:File, param2:String) : void;
      
      public native function truncate() : void;
      
      public native function get position() : Number;
      
      public native function set position(param1:Number) : void;
      
      public native function close() : void;
      
      public native function get readAhead() : Number;
      
      public native function set readAhead(param1:Number) : void;
      
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
      
      public native function writeBoolean(param1:Boolean) : void;
      
      public native function writeByte(param1:int) : void;
      
      public native function writeBytes(param1:ByteArray, param2:uint = 0, param3:uint = 0) : void;
      
      public native function writeDouble(param1:Number) : void;
      
      public native function writeFloat(param1:Number) : void;
      
      public native function writeInt(param1:int) : void;
      
      public native function writeMultiByte(param1:String, param2:String) : void;
      
      public native function writeObject(param1:*) : void;
      
      public native function writeShort(param1:int) : void;
      
      public native function writeUnsignedInt(param1:uint) : void;
      
      public native function writeUTF(param1:String) : void;
      
      public native function writeUTFBytes(param1:String) : void;
   }
}

