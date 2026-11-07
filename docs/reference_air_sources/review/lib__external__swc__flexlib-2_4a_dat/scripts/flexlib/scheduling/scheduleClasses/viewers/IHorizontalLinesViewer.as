package flexlib.scheduling.scheduleClasses.viewers
{
   import flexlib.scheduling.scheduleClasses.layout.LayoutUpdateEvent;
   import mx.core.IUIComponent;
   
   public interface IHorizontalLinesViewer extends IUIComponent
   {
      
      function set dottedGridLines(param1:Boolean) : void;
      
      function set horizontalGridLineThickness(param1:Number) : void;
      
      function get horizontalGridLineColor() : uint;
      
      function update(param1:LayoutUpdateEvent) : void;
      
      function get dottedGridLines() : Boolean;
      
      function set horizontalGridLineColor(param1:uint) : void;
      
      function set horizontalGridLineAlpha(param1:Number) : void;
      
      function get horizontalGridLineAlpha() : Number;
      
      function get horizontalGridLineThickness() : Number;
   }
}

