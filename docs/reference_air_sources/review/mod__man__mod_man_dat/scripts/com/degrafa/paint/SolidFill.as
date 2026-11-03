package com.degrafa.paint
{
   import com.degrafa.IGeometryComposition;
   import com.degrafa.core.DegrafaObject;
   import com.degrafa.core.IGraphicsFill;
   import com.degrafa.core.utils.ColorUtil;
   import com.degrafa.geometry.command.CommandStack;
   import com.degrafa.paint.palette.PaletteEntry;
   import flash.display.Graphics;
   import flash.geom.Rectangle;
   import mx.events.PropertyChangeEvent;
   
   [Bindable(event="propertyChange")]
   public class SolidFill extends DegrafaObject implements IGraphicsFill
   {
      
      private var _lastContext:Graphics;
      
      private var _lastArgs:Array = [];
      
      private var _lastRect:Rectangle;
      
      private var _paletteEntry:PaletteEntry;
      
      protected var _colorFunction:Function;
      
      protected var _alpha:Number;
      
      protected var _color:Object;
      
      private var _requester:IGeometryComposition;
      
      public function SolidFill(param1:Object = null, param2:Number = NaN)
      {
         super();
         this.alpha = param2;
         this.color = param1;
      }
      
      public function set color(param1:Object) : void
      {
         var _loc2_:uint = 0;
         if(param1 is PaletteEntry)
         {
            paletteEntry = param1 as PaletteEntry;
         }
         else
         {
            paletteEntry = null;
         }
         param1 = ColorUtil.resolveColor(param1);
         if(_color != param1)
         {
            _loc2_ = _color as uint;
            _color = param1 as uint;
            initChange("color",_loc2_,_color,this);
         }
      }
      
      private function onPaletteEntryChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "value" && param1.kind == "update")
         {
            color = param1.source;
         }
      }
      
      public function get restartFunction() : Function
      {
         var copy:Array = null;
         var last:Graphics = null;
         copy = _lastArgs.concat();
         last = _lastContext;
         return function(param1:Graphics = null):void
         {
            if(param1)
            {
               param1.beginFill(copy[0],copy[1]);
            }
            else if(last)
            {
               last.beginFill(copy[0],copy[1]);
            }
         };
      }
      
      public function get lastArgs() : Array
      {
         return _lastArgs;
      }
      
      public function set derive(param1:SolidFill) : void
      {
         if(!_color)
         {
            _color = uint(param1.color);
         }
         if(isNaN(_alpha))
         {
            _alpha = param1.alpha;
         }
      }
      
      public function get colorFunction() : Function
      {
         return _colorFunction;
      }
      
      public function get alpha() : Number
      {
         if(isNaN(_alpha))
         {
            return 1;
         }
         return _alpha;
      }
      
      public function end(param1:Graphics) : void
      {
         param1.endFill();
      }
      
      public function get color() : Object
      {
         if(colorFunction != null)
         {
            return ColorUtil.resolveColor(colorFunction());
         }
         if(!_color)
         {
            return 0;
         }
         return _color;
      }
      
      private function set paletteEntry(param1:PaletteEntry) : void
      {
         if(param1)
         {
            if(_paletteEntry !== param1)
            {
               if(_paletteEntry)
               {
                  if(_paletteEntry.hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
                  {
                     _paletteEntry.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,onPaletteEntryChange);
                  }
               }
               _paletteEntry = param1;
               if(_paletteEntry.enableEvents)
               {
                  _paletteEntry.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,onPaletteEntryChange);
               }
            }
         }
         else if(_paletteEntry)
         {
            if(_paletteEntry.hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
            {
               _paletteEntry.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,onPaletteEntryChange);
            }
            _paletteEntry = null;
         }
      }
      
      public function begin(param1:Graphics, param2:Rectangle) : void
      {
         if(isNaN(_alpha))
         {
            _alpha = 1;
         }
         var _loc3_:Number = CommandStack.currentAlpha;
         var _loc4_:Number = this.alpha;
         if(_loc3_ != 1)
         {
            _loc4_ *= _loc3_;
         }
         _lastArgs.length = 0;
         _lastArgs[0] = color as uint;
         _lastArgs[1] = _loc4_;
         _lastContext = param1;
         _lastRect = param2;
         param1.beginFill(color as uint,_loc4_);
      }
      
      public function set colorFunction(param1:Function) : void
      {
         var _loc2_:Function = null;
         if(_colorFunction != param1)
         {
            _loc2_ = _colorFunction as Function;
            _colorFunction = param1 as Function;
            initChange("colorFunction",_loc2_,_colorFunction,this);
         }
      }
      
      public function set requester(param1:IGeometryComposition) : void
      {
         _requester = param1;
      }
      
      public function get lastRectangle() : Rectangle
      {
         return _lastRect.clone();
      }
      
      public function set alpha(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         if(_alpha != param1)
         {
            _loc2_ = _alpha;
            _alpha = param1;
            initChange("alpha",_loc2_,_alpha,this);
         }
      }
   }
}

