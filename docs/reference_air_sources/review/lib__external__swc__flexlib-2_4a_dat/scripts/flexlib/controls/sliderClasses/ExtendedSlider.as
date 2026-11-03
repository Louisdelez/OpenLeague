package flexlib.controls.sliderClasses
{
   import flash.display.Graphics;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flexlib.baseClasses.SliderBase;
   import mx.controls.sliderClasses.SliderDataTip;
   import mx.controls.sliderClasses.SliderDirection;
   import mx.core.UIComponent;
   import mx.events.SliderEvent;
   import mx.events.SliderEventClickTarget;
   
   public class ExtendedSlider extends SliderBase
   {
      
      private var draggingRegion:Boolean = false;
      
      private var dataTips:Array;
      
      private var counter:Number = 0;
      
      protected var highlightHitArea:UIComponent;
      
      public var lockRegionsWhileDragging:Boolean = false;
      
      public function ExtendedSlider()
      {
         super();
      }
      
      private function regionDraggingStopped(event:MouseEvent) : void
      {
         draggingRegion = false;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onThumbRelease(thumb:Object) : void
      {
         var localDataTip:SliderDataTip = null;
         var mythumb:SliderThumb = null;
         var dispatch:Boolean = false;
         var event:SliderEvent = null;
         localDataTip = dataTips[thumb.thumbIndex];
         if(Boolean(localDataTip))
         {
            systemManager.toolTipChildren.removeChild(localDataTip);
            localDataTip = null;
            dataTips[thumb.thumbIndex] = null;
         }
         --counter;
         interactionClickTarget = SliderEventClickTarget.THUMB;
         mythumb = SliderThumb(thumbs.getChildAt(thumb.thumbIndex));
         dispatch = counter == 0;
         setValueAt(getValueFromX(mythumb.xPosition),thumb.thumbIndex,!dispatch);
         if(dispatch)
         {
            event = new SliderEvent(SliderEvent.THUMB_RELEASE);
            event.thumbIndex = thumb.thumbIndex;
            dispatchEvent(event);
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getXBounds(selectedThumbIndex:int) : Object
      {
         var minThumbValue:Number = NaN;
         var maxThumbValue:Number = NaN;
         var value:Number = NaN;
         var minValue:Number = NaN;
         var maxValue:Number = NaN;
         var minX:Number = NaN;
         var maxX:Number = NaN;
         if(!draggingRegion || !lockRegionsWhileDragging)
         {
            return super.getXBounds(selectedThumbIndex);
         }
         for each(value in values)
         {
            if(isNaN(minThumbValue) || value < minThumbValue)
            {
               minThumbValue = value;
            }
            if(isNaN(maxThumbValue) || value > maxThumbValue)
            {
               maxThumbValue = value;
            }
         }
         minValue = values[selectedThumbIndex] - minThumbValue + minimum;
         maxValue = maximum - (maxThumbValue - values[selectedThumbIndex]);
         minX = getXFromValue(minValue);
         maxX = getXFromValue(maxValue);
         return {
            "min":minX,
            "max":maxX
         };
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function drawTrackHighlight() : void
      {
         var firstThumb:SliderThumb = null;
         var lastThumb:SliderThumb = null;
         var i:int = 0;
         var xPos:Number = NaN;
         var tWidth:Number = NaN;
         var fullThumbHeight:Number = NaN;
         var highlightSkinHeight:Number = NaN;
         var curThumb:SliderThumb = null;
         var g:Graphics = null;
         firstThumb = SliderThumb(this.getThumbAt(0));
         lastThumb = firstThumb;
         for(i = 0; i < this.thumbCount; i++)
         {
            curThumb = SliderThumb(this.getThumbAt(i));
            if(curThumb.xPosition < firstThumb.xPosition)
            {
               firstThumb = curThumb;
            }
            if(curThumb.xPosition > lastThumb.xPosition)
            {
               lastThumb = curThumb;
            }
         }
         xPos = firstThumb.xPosition;
         tWidth = lastThumb.xPosition - firstThumb.xPosition;
         fullThumbHeight = Number(firstThumb.getExplicitOrMeasuredHeight());
         highlightSkinHeight = fullThumbHeight - 2;
         if(Boolean(highlightTrack))
         {
            highlightTrack.move(xPos,track.y - highlightTrack.height / 2 + 2);
            highlightTrack.setActualSize(tWidth > 0 ? tWidth : 0,highlightTrack.height);
         }
         if(Boolean(highlightHitArea))
         {
            g = highlightHitArea.graphics;
            g.clear();
            g.beginFill(16711680,0);
            g.drawRect(xPos,track.y + track.height / 2 - highlightSkinHeight / 2,tWidth > 0 ? tWidth : 0,highlightSkinHeight);
            g.endFill();
         }
      }
      
      private function highlight_mouseDownHandler(event:MouseEvent) : void
      {
         var x:Number = NaN;
         var y:Number = NaN;
         var i:int = 0;
         var curThumb:SliderThumb = null;
         x = event.stageX;
         y = event.stageY;
         draggingRegion = true;
         systemManager.addEventListener(MouseEvent.MOUSE_UP,regionDraggingStopped,false,0,true);
         for(i = 0; i < thumbCount; i++)
         {
            curThumb = SliderThumb(thumbs.getChildAt(i));
            event.localX = curThumb.globalToLocal(new Point(x,y)).x;
            event.localY = curThumb.globalToLocal(new Point(x,y)).y;
            curThumb.focusEnabled = false;
            curThumb.dispatchEvent(event);
         }
      }
      
      public function get dragHitArea() : UIComponent
      {
         return highlightHitArea;
      }
      
      override protected function createChildren() : void
      {
         var thumbSkin:* = undefined;
         super.createChildren();
         if(!highlightHitArea)
         {
            highlightHitArea = new UIComponent();
            innerSlider.addChild(highlightHitArea);
            highlightHitArea.addEventListener(MouseEvent.MOUSE_DOWN,highlight_mouseDownHandler);
         }
         dataTips = new Array();
         this.sliderThumbClass = SliderThumb;
         thumbSkin = getStyle("thumbSkin");
         if(thumbSkin != null)
         {
            setStyle("thumbUpSkin",thumbSkin);
            setStyle("thumbDownSkin",thumbSkin);
            setStyle("thumbOverSkin",thumbSkin);
            setStyle("thumbDisabledSkin",thumbSkin);
         }
      }
      
      override protected function positionDataTip(thumb:Object) : void
      {
         var dataTip:SliderDataTip = null;
         var relX:Number = NaN;
         var relY:Number = NaN;
         var tX:Number = NaN;
         var tY:Number = NaN;
         var tPlacement:String = null;
         var tOffset:Number = NaN;
         var o:Point = null;
         var r:Point = null;
         dataTip = dataTips[thumb.thumbIndex];
         tX = Number(thumb.x);
         tY = Number(thumb.y);
         tPlacement = getStyle("dataTipPlacement");
         tOffset = Number(getStyle("dataTipOffset"));
         if(_direction == SliderDirection.HORIZONTAL)
         {
            relX = tX;
            relY = tY;
            if(tPlacement == "left")
            {
               relX -= tOffset + dataTip.width;
               relY += (thumb.height - dataTip.height) / 2;
            }
            else if(tPlacement == "right")
            {
               relX += tOffset + thumb.width;
               relY += (thumb.height - dataTip.height) / 2;
            }
            else if(tPlacement == "top")
            {
               relY -= tOffset + dataTip.height;
               relX -= (dataTip.width - thumb.width) / 2;
            }
            else if(tPlacement == "bottom")
            {
               relY += tOffset + thumb.height;
               relX -= (dataTip.width - thumb.width) / 2;
            }
         }
         else
         {
            relX = tY;
            relY = unscaledHeight - tX - (dataTip.height + thumb.width) / 2;
            if(tPlacement == "left")
            {
               relX -= tOffset + dataTip.width;
            }
            else if(tPlacement == "right")
            {
               relX += tOffset + thumb.height;
            }
            else if(tPlacement == "top")
            {
               relY -= tOffset + (dataTip.height + thumb.width) / 2;
               relX -= (dataTip.width - thumb.height) / 2;
            }
            else if(tPlacement == "bottom")
            {
               relY += tOffset + (dataTip.height + thumb.width) / 2;
               relX -= (dataTip.width - thumb.height) / 2;
            }
         }
         o = new Point(relX,relY);
         r = localToGlobal(o);
         dataTip.x = r.x < 0 ? 0 : r.x;
         dataTip.y = r.y < 0 ? 0 : r.y;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onThumbPress(thumb:Object) : void
      {
         var event:SliderEvent = null;
         var dataTip:SliderDataTip = null;
         var formattedVal:String = null;
         var dataTipStyleName:String = null;
         ++counter;
         if(showDataTip)
         {
            dataTip = dataTips[thumb.thumbIndex];
            if(!dataTip)
            {
               dataTip = SliderDataTip(new sliderDataTipClass());
               dataTips[thumb.thumbIndex] = dataTip;
               systemManager.toolTipChildren.addChild(dataTip);
               dataTipStyleName = getStyle("dataTipStyleName");
               if(Boolean(dataTipStyleName))
               {
                  dataTip.styleName = dataTipStyleName;
               }
            }
            if(_dataTipFormatFunction != null)
            {
               formattedVal = this._dataTipFormatFunction(getValueFromX(thumb.xPosition));
            }
            else
            {
               formattedVal = dataFormatter.formatPrecision(String(getValueFromX(thumb.xPosition)),getStyle("dataTipPrecision"));
            }
            dataTip.text = formattedVal;
            dataTip.validateNow();
            dataTip.setActualSize(dataTip.getExplicitOrMeasuredWidth(),dataTip.getExplicitOrMeasuredHeight());
            positionDataTip(thumb);
         }
         keyInteraction = false;
         event = new SliderEvent(SliderEvent.THUMB_PRESS);
         event.thumbIndex = thumb.thumbIndex;
         dispatchEvent(event);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onThumbMove(thumb:Object) : void
      {
         var value:Number = NaN;
         var dataTip:SliderDataTip = null;
         var event:SliderEvent = null;
         value = getValueFromX(thumb.xPosition);
         dataTip = dataTips[thumb.thumbIndex];
         if(showDataTip)
         {
            dataTip.text = _dataTipFormatFunction != null ? _dataTipFormatFunction(value) : dataFormatter.formatPrecision(String(value),getStyle("dataTipPrecision"));
            dataTip.setActualSize(dataTip.getExplicitOrMeasuredWidth(),dataTip.getExplicitOrMeasuredHeight());
            positionDataTip(thumb);
         }
         if(liveDragging)
         {
            interactionClickTarget = SliderEventClickTarget.THUMB;
            setValueAt(value,thumb.thumbIndex);
         }
         event = new SliderEvent(SliderEvent.THUMB_DRAG);
         event.thumbIndex = thumb.thumbIndex;
         dispatchEvent(event);
      }
   }
}

