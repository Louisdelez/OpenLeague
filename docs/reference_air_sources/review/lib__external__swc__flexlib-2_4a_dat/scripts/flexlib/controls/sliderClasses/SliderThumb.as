package flexlib.controls.sliderClasses
{
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flexlib.baseClasses.SliderBase;
   import mx.controls.Button;
   import mx.controls.ButtonPhase;
   import mx.controls.sliderClasses.SliderDirection;
   
   [ExcludeClass]
   public class SliderThumb extends Button
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var thumbIndex:int;
      
      private var xOffset:Number;
      
      public function SliderThumb()
      {
         super();
         stickyHighlighting = true;
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var multiThumbs:Boolean = false;
         var currentVal:Number = NaN;
         var moveInterval:Number = NaN;
         var isHorizontal:Boolean = false;
         var newVal:Number = NaN;
         multiThumbs = SliderBase(owner).thumbCount > 1;
         currentVal = xPosition;
         moveInterval = SliderBase(owner).snapInterval > 0 ? SliderBase(owner).getSnapIntervalWidth() : 1;
         isHorizontal = SliderBase(owner).direction == SliderDirection.HORIZONTAL;
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
            newVal = SliderBase(owner).getXFromValue(SliderBase(owner).minimum);
         }
         else if(event.keyCode == Keyboard.PAGE_UP && !isHorizontal || event.keyCode == Keyboard.END && isHorizontal)
         {
            newVal = SliderBase(owner).getXFromValue(SliderBase(owner).maximum);
         }
         if(!isNaN(newVal))
         {
            event.stopPropagation();
            SliderBase(owner).keyInteraction = true;
            moveXPos(newVal);
         }
      }
      
      private function mouseMoveHandler(event:MouseEvent) : void
      {
         var pt:Point = null;
         if(enabled)
         {
            pt = new Point(event.stageX,event.stageY);
            pt = SliderBase(owner).innerSlider.globalToLocal(pt);
            moveXPos(pt.x - xOffset + width / 2,false,true);
            SliderBase(owner).onThumbMove(this);
         }
      }
      
      override public function set x(value:Number) : void
      {
         var result:Number = NaN;
         result = moveXPos(value);
         updateValue();
         super.x = result;
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredWidth = 12;
         measuredHeight = 12;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onTweenEnd(value:Number) : void
      {
         moveXPos(value);
      }
      
      public function get xPosition() : Number
      {
         return $x + width / 2;
      }
      
      override public function drawFocus(isFocused:Boolean) : void
      {
         phase = isFocused ? ButtonPhase.DOWN : ButtonPhase.UP;
      }
      
      private function updateValue() : void
      {
         SliderBase(owner).updateThumbValue(thumbIndex);
      }
      
      private function moveXPos(value:Number, overrideSnap:Boolean = false, noUpdate:Boolean = false) : Number
      {
         var result:Number = NaN;
         result = calculateXPos(value,overrideSnap);
         xPosition = result;
         if(!noUpdate)
         {
            updateValue();
         }
         return result;
      }
      
      override protected function mouseDownHandler(event:MouseEvent) : void
      {
         super.mouseDownHandler(event);
         if(enabled)
         {
            xOffset = event.localX;
            systemManager.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler,true);
            stage.addEventListener(MouseEvent.MOUSE_MOVE,stage_mouseMoveHandler);
            SliderBase(owner).onThumbPress(this);
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function buttonReleased() : void
      {
         super.buttonReleased();
         if(enabled)
         {
            systemManager.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler,true);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,stage_mouseMoveHandler);
            SliderBase(owner).onThumbRelease(this);
         }
      }
      
      public function set xPosition(value:Number) : void
      {
         $x = value - width / 2;
         SliderBase(owner).drawTrackHighlight();
      }
      
      private function calculateXPos(value:Number, overrideSnap:Boolean = false) : Number
      {
         var bounds:Object = null;
         var result:Number = NaN;
         bounds = SliderBase(owner).getXBounds(thumbIndex);
         result = Math.min(Math.max(value,bounds.min),bounds.max);
         if(!overrideSnap)
         {
            result = SliderBase(owner).getSnapValue(result,this);
         }
         return result;
      }
      
      private function stage_mouseMoveHandler(event:MouseEvent) : void
      {
         if(event.target != stage)
         {
            return;
         }
         mouseMoveHandler(event);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onTweenUpdate(value:Number) : void
      {
         moveXPos(value,true,true);
      }
   }
}

