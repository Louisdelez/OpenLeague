package blix.layout
{
   import blix.view.ILayoutElement;
   import blix.view.IView;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public function bindLayoutContainerToSizer(param1:ILayoutElement, param2:IView) : void
   {
      var layoutContainer:ILayoutElement = param1;
      var sizer:IView = param2;
      sizer.getUnscaledBoundsChanged().add(function(param1:IView, param2:Rectangle, param3:Rectangle):void
      {
         var _loc4_:Rectangle = sizer.getScaledBounds();
         layoutContainer.setExplicitSize(_loc4_.width,_loc4_.height);
      });
      sizer.getActualPositionChanged().add(function(param1:IView, param2:Point, param3:Point):void
      {
         layoutContainer.setExplicitPosition(param3.x,param3.y);
      });
   }
}

