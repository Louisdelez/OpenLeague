package mx.containers.gridClasses
{
   import mx.core.UIComponent;
   
   [ExcludeClass]
   public class GridRowInfo
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public var flex:Number;
      
      public var height:Number;
      
      public var max:Number;
      
      public var min:Number;
      
      public var preferred:Number;
      
      public var y:Number;
      
      public function GridRowInfo()
      {
         super();
         this.min = 0;
         this.preferred = 0;
         this.max = UIComponent.DEFAULT_MAX_HEIGHT;
         this.flex = 0;
      }
   }
}

