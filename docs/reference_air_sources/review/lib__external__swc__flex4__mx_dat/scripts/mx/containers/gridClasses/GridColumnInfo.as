package mx.containers.gridClasses
{
   import mx.containers.utilityClasses.FlexChildInfo;
   import mx.core.UIComponent;
   
   [ExcludeClass]
   public class GridColumnInfo extends FlexChildInfo
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public var x:Number;
      
      public function GridColumnInfo()
      {
         super();
         min = 0;
         preferred = 0;
         max = UIComponent.DEFAULT_MAX_WIDTH;
         flex = 0;
         percent = 0;
      }
   }
}

