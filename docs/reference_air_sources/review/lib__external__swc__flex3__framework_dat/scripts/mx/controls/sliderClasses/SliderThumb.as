package mx.controls.sliderClasses
{
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import mx.controls.Button;
   import mx.controls.ButtonPhase;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class SliderThumb extends Button
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var xOffset:Number;
      
      mx_internal var thumbIndex:int;
      
      public function SliderThumb()
      {
         super();
         stickyHighlighting = true;
      }
      
      public function get xPosition() : Number
      {
         return $x + width / 2;
      }
      
      public function set xPosition(value:Number) : void
      {
         $x = value - width / 2;
         Slider(owner).drawTrackHighlight();
      }
      
      override protected function mouseDownHandler(event:MouseEvent) : void
      {
         super.mouseDownHandler(event);
         if(enabled)
         {
            xOffset = event.localX;
            systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler,true);
            systemManager.deployMouseShields(true);
            Slider(owner).onThumbPress(this);
         }
      }
      
      mx_internal function onTweenEnd(value:Number) : void
      {
         moveXPos(value);
      }
      
      private function updateValue() : void
      {
         Slider(owner).updateThumbValue(thumbIndex);
      }
      
      private function calculateXPos(value:Number, overrideSnap:Boolean = false) : Number
      {
         var bounds:Object = Slider(owner).getXBounds(thumbIndex);
         var result:Number = Math.min(Math.max(value,bounds.min),bounds.max);
         if(!overrideSnap)
         {
            result = Slider(owner).getSnapValue(result,this);
         }
         return result;
      }
      
      private function mouseMoveHandler(event:MouseEvent) : void
      {
         var pt:Point = null;
         if(enabled)
         {
            pt = new Point(event.stageX,event.stageY);
            pt = Slider(owner).innerSlider.globalToLocal(pt);
            moveXPos(pt.x - xOffset + width / 2,false,true);
            Slider(owner).onThumbMove(this);
         }
      }
      
      private function moveXPos(value:Number, overrideSnap:Boolean = false, noUpdate:Boolean = false) : Number
      {
         var result:Number = calculateXPos(value,overrideSnap);
         xPosition = result;
         if(!noUpdate)
         {
            updateValue();
         }
         return result;
      }
      
      override mx_internal function buttonReleased() : void
      {
         super.mx_internal::buttonReleased();
         if(enabled)
         {
            systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler,true);
            systemManager.deployMouseShields(false);
            Slider(owner).onThumbRelease(this);
         }
      }
      
      override public function set x(value:Number) : void
      {
         var result:Number = moveXPos(value);
         updateValue();
         super.x = result;
      }
      
      override public function drawFocus(isFocused:Boolean) : void
      {
         phase = isFocused ? ButtonPhase.DOWN : ButtonPhase.UP;
      }
      
      mx_internal function onTweenUpdate(value:Number) : void
      {
         moveXPos(value,true,true);
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var newVal:Number = NaN;
         var multiThumbs:Boolean = Slider(owner).thumbCount > 1;
         var currentVal:Number = xPosition;
         var moveInterval:Number = Slider(owner).snapInterval > 0 ? Slider(owner).getSnapIntervalWidth() : 1;
         var isHorizontal:Boolean = Slider(owner).direction == SliderDirection.HORIZONTAL;
         if(event.keyCode == Keyboard.DOWN && !isHorizontal || event.keyCode == Keyboard.LEFT && isHorizontal)
         {
            newVal = currentVal - moveInterval;
         }
         else if(event.keyCode == Keyboard.UP && !isHorizontal || event.keyCode == Keyboard.RIGHT && isHorizontal)
         {
            newVal = currentVal + moveInterval;
         }
         else if(event.keyCode == Keyboard.PAGE_DOWN && !isHorizontal || event.keyCode == Keyboard.HOME && isHorizontal)
         {
            newVal = Slider(owner).getXFromValue(Slider(owner).minimum);
         }
         else if(event.keyCode == Keyboard.PAGE_UP && !isHorizontal || event.keyCode == Keyboard.END && isHorizontal)
         {
            newVal = Slider(owner).getXFromValue(Slider(owner).maximum);
         }
         if(!isNaN(newVal))
         {
            event.stopPropagation();
            Slider(owner).keyInteraction = true;
            moveXPos(newVal);
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredWidth = 12;
         measuredHeight = 12;
      }
   }
}

