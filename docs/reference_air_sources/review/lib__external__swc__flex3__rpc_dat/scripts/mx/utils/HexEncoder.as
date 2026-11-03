package mx.utils
{
   import flash.utils.ByteArray;
   
   [ExcludeClass]
   public class HexEncoder
   {
      
      public static const UPPER_CASE:String = "upper";
      
      public static const LOWER_CASE:String = "lower";
      
      public static var encodingStyle:String = UPPER_CASE;
      
      public static const MAX_BUFFER_SIZE:uint = 32767;
      
      private static const UPPER_CHAR_CODES:Array = [48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70];
      
      private static const LOWER_CHAR_CODES:Array = [48,49,50,51,52,53,54,55,56,57,97,98,99,100,101,102];
      
      private var _work:int = 0;
      
      private var _buffers:Array;
      
      public var encodingStyle:String;
      
      public function HexEncoder()
      {
         super();
         _buffers = [];
         _buffers.push([]);
      }
      
      public function flush() : String
      {
         return drain();
      }
      
      public function encode(data:ByteArray, offset:uint = 0, length:uint = 0) : void
      {
         if(length == 0)
         {
            length = data.length;
         }
         if(offset < length)
         {
            data.position = offset;
         }
         var style:String = this.encodingStyle != null ? this.encodingStyle : HexEncoder.encodingStyle;
         if(style != UPPER_CASE && style != LOWER_CASE)
         {
            style = UPPER_CASE;
         }
         var digits:Array = style == UPPER_CASE ? UPPER_CHAR_CODES : LOWER_CHAR_CODES;
         while(data.bytesAvailable > 0)
         {
            encodeBlock(data.readByte(),digits);
         }
      }
      
      private function encodeBlock(_work:int, digits:Array) : void
      {
         var currentBuffer:Array = _buffers[_buffers.length - 1] as Array;
         if(currentBuffer.length >= MAX_BUFFER_SIZE)
         {
            currentBuffer = [];
            _buffers.push(currentBuffer);
         }
         currentBuffer.push(digits[(_work & 0xF0) >>> 4]);
         currentBuffer.push(digits[_work & 0x0F]);
      }
      
      public function drain() : String
      {
         var buffer:Array = null;
         var result:String = "";
         for(var i:uint = 0; i < _buffers.length; i++)
         {
            buffer = _buffers[i] as Array;
            result += String.fromCharCode.apply(null,buffer);
         }
         _buffers = [];
         _buffers.push([]);
         return result;
      }
   }
}

