package flexlib.scheduling.scheduleClasses.viewers
{
   import flexlib.scheduling.scheduleClasses.layout.LayoutUpdateEvent;
   import mx.core.IUIComponent;
   
   public interface IVerticalLinesViewer extends IUIComponent
   {
      
      function get verticalGridLineThickness() : Number;
      
      function set dottedGridLines(param1:Boolean) : void;
      
      function set verticalGridLineColor(param1:uint) : void;
      
      function set verticalGridLineAlpha(param1:Number) : void;
      
      function set verticalGridLineThickness(param1:Number) : void;
      
      function update(param1:LayoutUpdateEvent) : void;
      
      function get verticalGridLineColor() : uint;
      
      function get dottedGridLines() : Boolean;
      
      function get verticalGridLineAlpha() : Number;
   }
}

