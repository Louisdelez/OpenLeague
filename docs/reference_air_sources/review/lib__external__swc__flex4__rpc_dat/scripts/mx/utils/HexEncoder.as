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
      
      public var encodingStyle:String;
      
      private var _buffers:Array;
      
      private var _work:int = 0;
      
      public function HexEncoder()
      {
         super();
         this._buffers = [];
         this._buffers.push([]);
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
            this.encodeBlock(data.readByte(),digits);
         }
      }
      
      public function drain() : String
      {
         var buffer:Array = null;
         var result:String = "";
         for(var i:uint = 0; i < this._buffers.length; i++)
         {
            buffer = this._buffers[i] as Array;
            result += String.fromCharCode.apply(null,buffer);
         }
         this._buffers = [];
         this._buffers.push([]);
         return result;
      }
      
      public function flush() : String
      {
         return this.drain();
      }
      
      private function encodeBlock(_work:int, digits:Array) : void
      {
         var currentBuffer:Array = this._buffers[this._buffers.length - 1] as Array;
         if(currentBuffer.length >= MAX_BUFFER_SIZE)
         {
            currentBuffer = [];
            this._buffers.push(currentBuffer);
         }
         currentBuffer.push(digits[(_work & 0xF0) >>> 4]);
         currentBuffer.push(digits[_work & 0x0F]);
      }
   }
}

