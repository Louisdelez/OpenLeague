package flash.printing
{
   public class PrintJobOptions
   {
      
      public var printAsBitmap:Boolean = false;
      
      private var _printMethod:String = null;
      
      [Version("air2.0")]
      public var pixelsPerInch:Number = NaN;
      
      public function PrintJobOptions(printAsBitmap:Boolean = false)
      {
         super();
         this.printAsBitmap = printAsBitmap;
      }
      
      [Version("air2.0")]
      public function set printMethod(pm:String) : void
      {
         this._printMethod = pm;
         if(pm != PrintMethod.AUTO && pm != PrintMethod.BITMAP && pm != PrintMethod.VECTOR)
         {
            Error.throwError(ArgumentError,2008,"printMethod");
         }
      }
      
      [Version("air2.0")]
      public function get printMethod() : String
      {
         return this._printMethod;
      }
   }
}

