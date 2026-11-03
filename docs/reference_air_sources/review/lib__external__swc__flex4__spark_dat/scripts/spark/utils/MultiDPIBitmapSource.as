package spark.utils
{
   import mx.core.DPIClassification;
   
   public class MultiDPIBitmapSource
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public var source160dpi:Object;
      
      public var source240dpi:Object;
      
      public var source320dpi:Object;
      
      public function MultiDPIBitmapSource()
      {
         super();
      }
      
      public function getSource(desiredDPI:Number) : Object
      {
         var source:Object = this.source160dpi;
         switch(desiredDPI)
         {
            case DPIClassification.DPI_160:
               source = this.source160dpi;
               if(!source || source == "")
               {
                  source = this.source240dpi;
               }
               if(!source || source == "")
               {
                  source = this.source320dpi;
               }
               break;
            case DPIClassification.DPI_240:
               source = this.source240dpi;
               if(!source || source == "")
               {
                  source = this.source320dpi;
               }
               if(!source || source == "")
               {
                  source = this.source160dpi;
               }
               break;
            case DPIClassification.DPI_320:
               source = this.source320dpi;
               if(!source || source == "")
               {
                  source = this.source240dpi;
               }
               if(!source || source == "")
               {
                  source = this.source160dpi;
               }
         }
         return source;
      }
   }
}

