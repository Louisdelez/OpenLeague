package spark.globalization
{
   import flash.globalization.CollatorMode;
   import spark.globalization.supportClasses.CollatorBase;
   
   public class SortingCollator extends CollatorBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function SortingCollator()
      {
         super(CollatorMode.SORTING);
      }
   }
}

