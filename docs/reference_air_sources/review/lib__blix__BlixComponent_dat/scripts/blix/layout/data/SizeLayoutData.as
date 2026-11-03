package blix.layout.data
{
   import blix.layout.vo.Size;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   
   public class SizeLayoutData implements ISizeLayoutData
   {
      
      protected var _changed:Signal = new Signal();
      
      protected var _width:Number;
      
      protected var _widthPercent:Number;
      
      protected var _widthMin:Number = 0;
      
      protected var _widthMax:Number = 10000;
      
      protected var _widthMaxPercent:Number;
      
      protected var _widthMinPercent:Number;
      
      protected var _height:Number;
      
      protected var _heightPercent:Number;
      
      protected var _heightMin:Number = 0;
      
      protected var _heightMinPercent:Number;
      
      protected var _heightMax:Number = 10000;
      
      protected var _heightMaxPercent:Number;
      
      protected var _horizontalAlign:uint;
      
      protected var _verticalAlign:uint;
      
      protected var widthInfo:Size = new Size();
      
      protected var heightInfo:Size = new Size();
      
      public function SizeLayoutData()
      {
         super();
      }
      
      public function getLayoutDataChanged() : ISignal
      {
         return this._changed;
      }
      
      public function getWidth() : Number
      {
         return this._width;
      }
      
      public function setWidth(param1:Number) : void
      {
         if(this._width == param1)
         {
            return;
         }
         this._width = param1;
         this._widthPercent = NaN;
         if(!isNaN(param1))
         {
            this.widthInfo.setIsFlexible(false);
         }
         this._changed.dispatch(this);
      }
      
      public function getWidthPercent() : Number
      {
         return this._widthPercent;
      }
      
      public function setWidthPercent(param1:Number) : void
      {
         if(param1 == this._widthPercent)
         {
            return;
         }
         this._widthPercent = param1;
         this._width = NaN;
         if(!isNaN(param1))
         {
            this.widthInfo.setIsFlexible(true);
         }
         this._changed.dispatch(this);
      }
      
      public function setWidthMin(param1:Number) : void
      {
         if(param1 == this._widthMin)
         {
            return;
         }
         this._widthMin = param1;
         this._widthMinPercent = NaN;
         this._changed.dispatch(this);
      }
      
      public function getWidthMin() : Number
      {
         return this._widthMin;
      }
      
      public function getWidthMinPercent() : Number
      {
         return this._widthMinPercent;
      }
      
      public function setWidthMinPercent(param1:Number) : void
      {
         if(param1 == this._widthMinPercent)
         {
            return;
         }
         this._widthMinPercent = param1;
         this._widthMin = NaN;
         this._changed.dispatch(this);
      }
      
      public function getWidthMax() : Number
      {
         return this._widthMax;
      }
      
      public function setWidthMax(param1:Number) : void
      {
         if(this._widthMax == param1)
         {
            return;
         }
         this._widthMax = param1;
         this._widthMaxPercent = NaN;
         this._changed.dispatch(this);
      }
      
      public function getWidthMaxPercent() : Number
      {
         return this._widthMaxPercent;
      }
      
      public function setWidthMaxPercent(param1:Number) : void
      {
         if(this._widthMaxPercent == param1)
         {
            return;
         }
         this._widthMaxPercent = param1;
         this._widthMax = NaN;
         this._changed.dispatch(this);
      }
      
      public function getHeight() : Number
      {
         return this._height;
      }
      
      public function setHeight(param1:Number) : void
      {
         if(this._height == param1)
         {
            return;
         }
         this._height = param1;
         this._heightPercent = NaN;
         this.heightInfo.setIsFlexible(false);
         this._changed.dispatch(this);
      }
      
      public function getHeightPercent() : Number
      {
         return this._heightPercent;
      }
      
      public function setHeightPercent(param1:Number) : void
      {
         if(this._heightPercent == param1)
         {
            return;
         }
         this._heightPercent = param1;
         this._height = NaN;
         this.heightInfo.setIsFlexible(true);
         this._changed.dispatch(this);
      }
      
      public function getHeightMin() : Number
      {
         return this._heightMin;
      }
      
      public function setHeightMin(param1:Number) : void
      {
         if(param1 == this._heightMin)
         {
            return;
         }
         this._heightMin = param1;
         this._heightMinPercent = NaN;
         this._changed.dispatch(this);
      }
      
      public function getHeightMinPercent() : Number
      {
         return this._heightMinPercent;
      }
      
      public function setHeightMinPercent(param1:Number) : void
      {
         if(this._heightMinPercent == param1)
         {
            return;
         }
         this._heightMinPercent = param1;
         this._heightMin = NaN;
         this._changed.dispatch(this);
      }
      
      public function getHeightMax() : Number
      {
         return this._heightMax;
      }
      
      public function setHeightMax(param1:Number) : void
      {
         this._heightMax = param1;
         this._widthMaxPercent = NaN;
         this._changed.dispatch(this);
      }
      
      public function getHeightMaxPercent() : Number
      {
         return this._heightMaxPercent;
      }
      
      public function setHeightMaxPercent(param1:Number) : void
      {
         this._heightMaxPercent = param1;
         this._heightMax = NaN;
         this._changed.dispatch(this);
      }
      
      public function getHorizontalAlign() : uint
      {
         return this._horizontalAlign;
      }
      
      public function setHorizontalAlign(param1:uint) : void
      {
         if(this._horizontalAlign == param1)
         {
            return;
         }
         this._horizontalAlign = param1;
         this._changed.dispatch(this);
      }
      
      public function getVerticalAlign() : uint
      {
         return this._verticalAlign;
      }
      
      public function setVerticalAlign(param1:uint) : void
      {
         if(this._verticalAlign == param1)
         {
            return;
         }
         this._verticalAlign = param1;
         this._changed.dispatch(this);
      }
      
      public function getWidthInfo(param1:Number) : Size
      {
         if(!isNaN(this._widthPercent))
         {
            this.widthInfo.setValue(param1 * this._widthPercent);
         }
         else
         {
            this.widthInfo.setValue(this._width);
         }
         if(isNaN(this._widthMinPercent))
         {
            this.widthInfo.setMin(this._widthMin);
         }
         else
         {
            this.widthInfo.setMin(param1 * this._widthMinPercent);
         }
         if(isNaN(this._widthMaxPercent))
         {
            this.widthInfo.setMax(this._widthMax);
         }
         else
         {
            this.widthInfo.setMax(param1 * this._widthMaxPercent);
         }
         return this.widthInfo;
      }
      
      public function getHeightInfo(param1:Number) : Size
      {
         if(!isNaN(this._heightPercent))
         {
            this.heightInfo.setValue(param1 * this._heightPercent);
         }
         else
         {
            this.heightInfo.setValue(this._height);
         }
         if(isNaN(this._heightMinPercent))
         {
            this.heightInfo.setMin(this._heightMin);
         }
         else
         {
            this.heightInfo.setMin(param1 * this._heightMinPercent);
         }
         if(isNaN(this._heightMaxPercent))
         {
            this.heightInfo.setMax(this._heightMax);
         }
         else
         {
            this.heightInfo.setMax(param1 * this._heightMaxPercent);
         }
         return this.heightInfo;
      }
   }
}

