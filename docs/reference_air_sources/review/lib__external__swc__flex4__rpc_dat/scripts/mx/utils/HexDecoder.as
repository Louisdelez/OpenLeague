package mx.utils
{
   import flash.utils.ByteArray;
   
   [ExcludeClass]
   public class HexDecoder
   {
      
      private var _output:ByteArray;
      
      private var _work:Array = [0,0];
      
      public function HexDecoder()
      {
         super();
         this._output = new ByteArray();
      }
      
      public function decode(encoded:String) : void
      {
         for(var i:int = 0; i < encoded.length; i++)
         {
            this._work[0] = this.digit(encoded.charAt(i));
            i++;
            this._work[1] = this.digit(encoded.charAt(i));
            this._output.writeByte((this._work[0] << 4 | this._work[1]) & 0xFF);
         }
      }
      
      public function digit(char:String) : int
      {
         switch(char)
         {
            case "A":
            case "a":
               return 10;
            case "B":
            case "b":
               return 11;
            case "C":
            case "c":
               return 12;
            case "D":
            case "d":
               return 13;
            case "E":
            case "e":
               return 14;
            case "F":
            case "f":
               return 15;
            default:
               return new Number(char);
         }
      }
      
      public function drain() : ByteArray
      {
         var result:ByteArray = this._output;
         this._output = new ByteArray();
         result.position = 0;
         return result;
      }
      
      public function flush() : ByteArray
      {
         return this.drain();
      }
   }
}

