package flash.utils
{
   public interface IDataInput
   {
      
      function readBytes(param1:ByteArray, param2:uint = 0, param3:uint = 0) : void;
      
      function readBoolean() : Boolean;
      
      function readByte() : int;
      
      function readUnsignedByte() : uint;
      
      function readShort() : int;
      
      function readUnsignedShort() : uint;
      
      function readInt() : int;
      
      function readUnsignedInt() : uint;
      
      function readFloat() : Number;
      
      function readDouble() : Number;
      
      function readMultiByte(param1:uint, param2:String) : String;
      
      function readUTF() : String;
      
      function readUTFBytes(param1:uint) : String;
      
      function get bytesAvailable() : uint;
      
      function readObject() : *;
      
      function get objectEncoding() : uint;
      
      function set objectEncoding(param1:uint) : void;
      
      function get endian() : String;
      
      function set endian(param1:String) : void;
   }
}

