package mx.controls.scrollClasses
{
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.controls.Button;
   import mx.events.ScrollEventDetail;
   
   public class ScrollThumb extends Button
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var ymin:Number;
      
      private var ymax:Number;
      
      private var datamin:Number;
      
      private var datamax:Number;
      
      private var lastY:Number;
      
      public function ScrollThumb()
      {
         super();
         explicitMinHeight = 10;
         stickyHighlighting = true;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function buttonReleased() : void
      {
         super.buttonReleased();
         this.stopDragThumb();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setRange(ymin:Number, ymax:Number, datamin:Number, datamax:Number) : void
      {
         this.ymin = ymin;
         this.ymax = ymax;
         this.datamin = datamin;
         this.datamax = datamax;
      }
      
      private function stopDragThumb() : void
      {
         var scrollBar:ScrollBar = ScrollBar(parent);
         scrollBar.isScrolling = false;
         scrollBar.dispatchScrollEvent(scrollBar.oldPosition,ScrollEventDetail.THUMB_POSITION);
         scrollBar.oldPosition = NaN;
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler,true);
      }
      
      override protected function mouseDownHandler(event:MouseEvent) : void
      {
         super.mouseDownHandler(event);
         var scrollBar:ScrollBar = ScrollBar(parent);
         scrollBar.oldPosition = scrollBar.scrollPosition;
         this.lastY = event.localY;
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler,true);
      }
      
      private function mouseMoveHandler(event:MouseEvent) : void
      {
         if(this.ymin == this.ymax)
         {
            return;
         }
         var pt:Point = new Point(event.stageX,event.stageY);
         pt = globalToLocal(pt);
         var scrollMove:Number = pt.y - this.lastY;
         scrollMove += y;
         if(scrollMove < this.ymin)
         {
            scrollMove = this.ymin;
         }
         else if(scrollMove > this.ymax)
         {
            scrollMove = this.ymax;
         }
         var scrollBar:ScrollBar = ScrollBar(parent);
         scrollBar.isScrolling = true;
         $y = scrollMove;
         var oldPosition:Number = scrollBar.scrollPosition;
         var pos:Number = Math.round((this.datamax - this.datamin) * (y - this.ymin) / (this.ymax - this.ymin)) + this.datamin;
         scrollBar.scrollPosition = pos;
         scrollBar.dispatchScrollEvent(oldPosition,ScrollEventDetail.THUMB_TRACK);
         event.updateAfterEvent();
      }
   }
}

