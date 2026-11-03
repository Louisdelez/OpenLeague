package flash.html
{
   import flash.display.BitmapData;
   
   [native(cls="HTMLBitmapClass",instance="HTMLBitmapObject",methods="IHTMLBitmapObject<HTMLBitmapObject>",construct="native")]
   internal class HTMLBitmap
   {
      
      public function HTMLBitmap(bitmap:BitmapData)
      {
         super();
         this.nativeInit(bitmap);
      }
      
      private native function nativeInit(param1:BitmapData) : void;
   }
}

