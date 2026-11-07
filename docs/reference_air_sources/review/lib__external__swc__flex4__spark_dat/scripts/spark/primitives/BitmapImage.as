package spark.primitives
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import mx.core.FlexGlobals;
   import mx.core.IInvalidating;
   import mx.events.FlexEvent;
   import mx.graphics.BitmapFillMode;
   import mx.graphics.BitmapScaleMode;
   import mx.graphics.BitmapSmoothingQuality;
   import mx.utils.DensityUtil;
   import mx.utils.LoaderUtil;
   import spark.core.ContentRequest;
   import spark.core.DisplayObjectSharingMode;
   import spark.core.IContentLoader;
   import spark.layouts.HorizontalAlign;
   import spark.layouts.VerticalAlign;
   import spark.primitives.supportClasses.GraphicElement;
   import spark.utils.MultiDPIBitmapSource;
   
   [Event(name="securityError",type="flash.events.SecurityErrorEvent")]
   [Event(name="ready",type="mx.events.FlexEvent")]
   [Event(name="progress",type="flash.events.ProgressEvent")]
   [Event(name="ioError",type="flash.events.IOErrorEvent")]
   [Event(name="httpStatus",type="flash.events.HTTPStatusEvent")]
   [Event(name="complete",type="flash.events.Event")]
   public class BitmapImage extends GraphicElement
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var matrix:Matrix = new Matrix();
      
      private var _scaleGridBottom:Number;
      
      private var _scaleGridLeft:Number;
      
      private var _scaleGridRight:Number;
      
      private var _scaleGridTop:Number;
      
      private var bitmapDataCreated:Boolean;
      
      private var cachedSourceGrid:Array;
      
      private var cachedDestGrid:Array;
      
      private var imageWidth:Number = NaN;
      
      private var imageHeight:Number = NaN;
      
      private var loadedContent:DisplayObject;
      
      private var loadingContent:Object;
      
      private var previousUnscaledWidth:Number;
      
      private var previousUnscaledHeight:Number;
      
      private var sourceInvalid:Boolean;
      
      private var loadFailed:Boolean;
      
      private var _bitmapData:BitmapData;
      
      private var _bytesLoaded:Number = NaN;
      
      private var _bytesTotal:Number = NaN;
      
      private var _clearOnLoad:Boolean = true;
      
      private var _contentLoaderGrouping:String;
      
      private var _contentLoader:IContentLoader;
      
      private var contentLoaderInvalid:Boolean;
      
      protected var _fillMode:String = "scale";
      
      private var _horizontalAlign:String = "center";
      
      private var _preliminaryHeight:Number = NaN;
      
      private var _preliminaryWidth:Number = NaN;
      
      private var _scaleMode:String = "stretch";
      
      private var _smooth:Boolean = false;
      
      private var _smoothingQuality:String = "default";
      
      private var _source:Object;
      
      private var _trustedSource:Boolean = true;
      
      private var _verticalAlign:String = "middle";
      
      public function BitmapImage()
      {
         super();
         layoutDirection = "ltr";
      }
      
      protected static function resample(bitmapData:BitmapData, newWidth:uint, newHeight:uint) : BitmapData
      {
         var finalScale:Number = Math.max(newWidth / bitmapData.width,newHeight / bitmapData.height);
         var finalData:BitmapData = bitmapData;
         if(finalScale > 1)
         {
            finalData = new BitmapData(bitmapData.width * finalScale,bitmapData.height * finalScale,true,0);
            finalData.draw(bitmapData,new Matrix(finalScale,0,0,finalScale),null,null,null,true);
            return finalData;
         }
         var drop:Number = 0.5;
         var initialScale:Number = finalScale;
         while(initialScale / drop < 1)
         {
            initialScale /= drop;
         }
         var w:Number = Math.floor(bitmapData.width * initialScale);
         var h:Number = Math.floor(bitmapData.height * initialScale);
         var bd:BitmapData = new BitmapData(w,h,bitmapData.transparent,0);
         bd.draw(finalData,new Matrix(initialScale,0,0,initialScale),null,null,null,true);
         finalData = bd;
         var scale:Number = initialScale * drop;
         while(Math.round(scale * 1000) >= Math.round(finalScale * 1000))
         {
            w = Math.floor(bitmapData.width * scale);
            h = Math.floor(bitmapData.height * scale);
            bd = new BitmapData(w,h,bitmapData.transparent,0);
            bd.draw(finalData,new Matrix(drop,0,0,drop),null,null,null,true);
            finalData.dispose();
            finalData = bd;
            scale *= drop;
         }
         return finalData;
      }
      
      public function get bitmapData() : BitmapData
      {
         return Boolean(this._bitmapData) ? this._bitmapData.clone() : this._bitmapData;
      }
      
      public function get bytesLoaded() : Number
      {
         return this._bytesLoaded;
      }
      
      public function get bytesTotal() : Number
      {
         return this._bytesTotal;
      }
      
      public function get clearOnLoad() : Boolean
      {
         return this._clearOnLoad;
      }
      
      public function set clearOnLoad(value:Boolean) : void
      {
         this._clearOnLoad = value;
      }
      
      public function get contentLoaderGrouping() : String
      {
         return this._contentLoaderGrouping;
      }
      
      public function set contentLoaderGrouping(value:String) : void
      {
         if(value != this._contentLoaderGrouping)
         {
            this._contentLoaderGrouping = value;
            invalidateProperties();
         }
      }
      
      public function get contentLoader() : IContentLoader
      {
         return this._contentLoader;
      }
      
      public function set contentLoader(value:IContentLoader) : void
      {
         if(value != this._contentLoader)
         {
            this._contentLoader = value;
            this.contentLoaderInvalid = true;
            invalidateProperties();
         }
      }
      
      [Inspectable(category="General",enumeration="clip,repeat,scale",defaultValue="scale")]
      public function get fillMode() : String
      {
         return this._fillMode;
      }
      
      public function set fillMode(value:String) : void
      {
         if(value != this._fillMode)
         {
            this._fillMode = value;
            invalidateDisplayList();
         }
      }
      
      [Inspectable(category="General",enumeration="left,right,center",defaultValue="center")]
      public function get horizontalAlign() : String
      {
         return this._horizontalAlign;
      }
      
      public function set horizontalAlign(value:String) : void
      {
         if(value == this._horizontalAlign)
         {
            return;
         }
         this._horizontalAlign = value;
         invalidateDisplayList();
      }
      
      private function getHorizontalAlignValue() : Number
      {
         if(this._horizontalAlign == HorizontalAlign.LEFT)
         {
            return 0;
         }
         if(this._horizontalAlign == HorizontalAlign.RIGHT)
         {
            return 1;
         }
         return 0.5;
      }
      
      public function get preliminaryHeight() : Number
      {
         return this._preliminaryHeight;
      }
      
      public function set preliminaryHeight(value:Number) : void
      {
         if(value != this._preliminaryHeight)
         {
            this._preliminaryHeight = value;
            invalidateSize();
         }
      }
      
      public function get preliminaryWidth() : Number
      {
         return this._preliminaryWidth;
      }
      
      public function set preliminaryWidth(value:Number) : void
      {
         if(value != this._preliminaryWidth)
         {
            this._preliminaryWidth = value;
            invalidateSize();
         }
      }
      
      [Inspectable(category="General",enumeration="stretch,letterbox,zoom",defaultValue="stretch")]
      public function get scaleMode() : String
      {
         return this._scaleMode;
      }
      
      public function set scaleMode(value:String) : void
      {
         if(value == this._scaleMode)
         {
            return;
         }
         this._scaleMode = value;
         invalidateDisplayList();
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="false")]
      public function set smooth(value:Boolean) : void
      {
         if(value != this._smooth)
         {
            this._smooth = value;
            invalidateDisplayList();
         }
      }
      
      public function get smooth() : Boolean
      {
         return this._smooth;
      }
      
      [Inspectable(category="General",enumeration="default,high",defaultValue="default")]
      public function set smoothingQuality(value:String) : void
      {
         if(value != this._smoothingQuality)
         {
            this._smoothingQuality = value;
            invalidateDisplayList();
         }
      }
      
      public function get smoothingQuality() : String
      {
         return this._smoothingQuality;
      }
      
      [Inspectable(category="General")]
      [Bindable("sourceChanged")]
      public function get source() : Object
      {
         return this._source;
      }
      
      public function set source(value:Object) : void
      {
         if(value != this._source)
         {
            this.clearLoadingContent();
            this.removeAddedToStageHandler(this._source);
            this._source = value;
            this.sourceInvalid = true;
            this.loadFailed = false;
            invalidateProperties();
            dispatchEvent(new Event("sourceChanged"));
         }
      }
      
      public function get sourceHeight() : Number
      {
         return this.imageHeight;
      }
      
      public function get sourceWidth() : Number
      {
         return this.imageWidth;
      }
      
      public function get trustedSource() : Boolean
      {
         return this._trustedSource;
      }
      
      [Inspectable(category="General",enumeration="top,bottom,middle",defaultValue="middle")]
      public function get verticalAlign() : String
      {
         return this._verticalAlign;
      }
      
      public function set verticalAlign(value:String) : void
      {
         if(value == this._verticalAlign)
         {
            return;
         }
         this._verticalAlign = value;
         invalidateDisplayList();
      }
      
      private function getVerticalAlignValue() : Number
      {
         if(this._verticalAlign == VerticalAlign.TOP)
         {
            return 0;
         }
         if(this._verticalAlign == VerticalAlign.BOTTOM)
         {
            return 1;
         }
         return 0.5;
      }
      
      override protected function commitProperties() : void
      {
         this.validateSource();
         super.commitProperties();
      }
      
      override protected function measure() : void
      {
         var usePreviousSize:Boolean = false;
         var previousWidth:Number = NaN;
         var previousHeight:Number = NaN;
         var dpiScale:Number = 1;
         var app:Object = FlexGlobals.topLevelApplication;
         if("applicationDPI" in app && "runtimeDPI" in app && this.source is MultiDPIBitmapSource)
         {
            dpiScale = app.runtimeDPI / app.applicationDPI;
         }
         if(Boolean(this.loadedContent))
         {
            measuredWidth = this.imageWidth;
            measuredHeight = this.imageHeight;
            if(dpiScale != 1)
            {
               measuredWidth /= dpiScale;
               measuredHeight /= dpiScale;
            }
         }
         else
         {
            if(!Boolean(this._bitmapData))
            {
               usePreviousSize = !(this._source == null || this._source == "" || this.loadFailed);
               previousWidth = usePreviousSize ? measuredWidth : 0;
               previousHeight = usePreviousSize ? measuredHeight : 0;
               measuredWidth = !isNaN(this._preliminaryWidth) && previousWidth == 0 ? this._preliminaryWidth : previousWidth;
               measuredHeight = !isNaN(this._preliminaryHeight) && previousHeight == 0 ? this._preliminaryHeight : previousHeight;
               return;
            }
            measuredWidth = this._bitmapData.width;
            measuredHeight = this._bitmapData.height;
            if(dpiScale != 1)
            {
               measuredWidth /= dpiScale;
               measuredHeight /= dpiScale;
            }
         }
         if(this.maintainAspectRatio && measuredWidth > 0 && measuredHeight > 0)
         {
            if(!isNaN(explicitWidth) && isNaN(explicitHeight) && isNaN(percentHeight))
            {
               measuredHeight = explicitWidth / measuredWidth * measuredHeight;
            }
            else if(!isNaN(explicitHeight) && isNaN(explicitWidth) && isNaN(percentWidth))
            {
               measuredWidth = explicitHeight / measuredHeight * measuredWidth;
            }
            else if(!isNaN(percentWidth) && isNaN(explicitHeight) && isNaN(percentHeight) && width > 0)
            {
               measuredHeight = width / measuredWidth * measuredHeight;
            }
            else if(!isNaN(percentHeight) && isNaN(explicitWidth) && isNaN(percentWidth) && height > 0)
            {
               measuredWidth = height / measuredHeight * measuredWidth;
            }
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var contentWidth:Number = NaN;
         var contentHeight:Number = NaN;
         var widthRatio:Number = NaN;
         var heightRatio:Number = NaN;
         var sampledScale:Boolean = false;
         var sampleWidth:Number = NaN;
         var sampleHeight:Number = NaN;
         var b:BitmapData = null;
         var cHeight:Number = NaN;
         var cWidth:Number = NaN;
         var translateX:Number = NaN;
         var translateY:Number = NaN;
         var sourceSection:Rectangle = null;
         var destSection:Rectangle = null;
         var rowIndex:int = 0;
         var destScaleGridBottom:Number = NaN;
         var destScaleGridRight:Number = NaN;
         var colIndex:int = 0;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var adjustedHeight:Number = unscaledHeight;
         var adjustedWidth:Number = unscaledWidth;
         var isZoom:Boolean = this._fillMode == BitmapFillMode.SCALE && this._scaleMode == BitmapScaleMode.ZOOM;
         var aspectRatio:Number = unscaledWidth / unscaledHeight;
         var imageAspectRatio:Number = this.imageWidth / this.imageHeight;
         if(this.maintainAspectRatio)
         {
            if(!isNaN(imageAspectRatio))
            {
               if(imageAspectRatio > aspectRatio)
               {
                  adjustedHeight = unscaledWidth / imageAspectRatio;
               }
               else
               {
                  adjustedWidth = unscaledHeight * imageAspectRatio;
               }
               if(!isNaN(percentWidth) && isNaN(percentHeight) && isNaN(explicitHeight) || !isNaN(percentHeight) && isNaN(percentWidth) && isNaN(explicitWidth))
               {
                  if(aspectRatio != imageAspectRatio)
                  {
                     invalidateSize();
                     return;
                  }
               }
            }
         }
         if(!this._bitmapData || !drawnDisplayObject || !(drawnDisplayObject is Sprite))
         {
            if(Boolean(this.loadedContent))
            {
               if(this._fillMode == BitmapFillMode.SCALE)
               {
                  this.loadedContent.width = adjustedWidth;
                  this.loadedContent.height = adjustedHeight;
               }
               this.loadedContent.y = this.loadedContent.x = 0;
               if(this.maintainAspectRatio || this._fillMode == BitmapFillMode.CLIP || isZoom)
               {
                  contentWidth = this._fillMode == BitmapFillMode.CLIP || isZoom ? this.imageWidth : adjustedWidth;
                  contentHeight = this._fillMode == BitmapFillMode.CLIP || isZoom ? this.imageHeight : adjustedHeight;
                  if(unscaledHeight > contentHeight)
                  {
                     this.loadedContent.y = Math.floor((unscaledHeight - contentHeight) * this.getVerticalAlignValue());
                  }
                  if(unscaledWidth > contentWidth)
                  {
                     this.loadedContent.x = Math.floor((unscaledWidth - contentWidth) * this.getHorizontalAlignValue());
                  }
               }
               this.loadedContent.scrollRect = this._fillMode == BitmapFillMode.CLIP || isZoom ? new Rectangle(0,0,unscaledWidth,unscaledHeight) : null;
            }
            return;
         }
         var g:Graphics = Sprite(drawnDisplayObject).graphics;
         g.lineStyle();
         var repeatBitmap:Boolean = false;
         var fillScaleX:Number = 1;
         var fillScaleY:Number = 1;
         var roundedDrawX:Number = Math.round(drawX);
         var roundedDrawY:Number = Math.round(drawY);
         var fillWidth:Number = adjustedWidth;
         var fillHeight:Number = adjustedHeight;
         if(Boolean(this._bitmapData))
         {
            switch(this._fillMode)
            {
               case BitmapFillMode.REPEAT:
                  repeatBitmap = true;
                  break;
               case BitmapFillMode.SCALE:
                  if(isZoom)
                  {
                     widthRatio = adjustedWidth / this._bitmapData.width;
                     heightRatio = adjustedHeight / this._bitmapData.height;
                     if(widthRatio < heightRatio)
                     {
                        fillScaleX = fillScaleY = adjustedHeight / this._bitmapData.height;
                     }
                     else
                     {
                        fillScaleX = fillScaleY = adjustedWidth / this._bitmapData.width;
                     }
                  }
                  else
                  {
                     fillScaleX = adjustedWidth / this._bitmapData.width;
                     fillScaleY = adjustedHeight / this._bitmapData.height;
                  }
                  break;
               case BitmapFillMode.CLIP:
                  fillWidth = Math.min(adjustedWidth,this._bitmapData.width);
                  fillHeight = Math.min(adjustedHeight,this._bitmapData.height);
            }
         }
         if(this._fillMode != BitmapFillMode.SCALE || isNaN(this._scaleGridTop) || isNaN(this._scaleGridBottom) || isNaN(this._scaleGridLeft) || isNaN(this._scaleGridRight))
         {
            sampledScale = this._smooth && this._smoothingQuality == BitmapSmoothingQuality.HIGH && this._fillMode == BitmapFillMode.SCALE;
            sampleWidth = fillWidth;
            sampleHeight = fillHeight;
            if(isZoom)
            {
               sampleWidth = this._bitmapData.width * fillScaleX;
               sampleHeight = this._bitmapData.height * fillScaleY;
            }
            b = sampledScale ? resample(this._bitmapData,sampleWidth,sampleHeight) : this._bitmapData;
            if(sampledScale && this._fillMode == BitmapFillMode.SCALE)
            {
               if(isZoom)
               {
                  fillScaleX = fillScaleY = 1;
               }
               else if(this._fillMode == BitmapFillMode.SCALE)
               {
                  fillScaleX = adjustedWidth / b.width;
                  fillScaleY = adjustedHeight / b.height;
               }
            }
            cHeight = b.height * fillScaleX;
            cWidth = b.width * fillScaleY;
            if(this.maintainAspectRatio || this._fillMode == BitmapFillMode.CLIP || isZoom)
            {
               if(unscaledHeight > cHeight)
               {
                  roundedDrawY += Math.floor((unscaledHeight - cHeight) * this.getVerticalAlignValue());
               }
               if(unscaledWidth > cWidth)
               {
                  roundedDrawX += Math.floor((unscaledWidth - cWidth) * this.getHorizontalAlignValue());
               }
            }
            translateX = roundedDrawX;
            translateY = roundedDrawY;
            if(isZoom)
            {
               if(cWidth > unscaledWidth)
               {
                  translateX += (unscaledWidth - cWidth) * this.getHorizontalAlignValue();
               }
               else if(cHeight > unscaledHeight)
               {
                  translateY += (unscaledHeight - cHeight) * this.getVerticalAlignValue();
               }
            }
            matrix.identity();
            if(!(sampledScale && (this.maintainAspectRatio || isZoom)))
            {
               matrix.scale(fillScaleX,fillScaleY);
            }
            matrix.translate(translateX,translateY);
            g.beginBitmapFill(b,matrix,repeatBitmap,this._smooth);
            g.drawRect(roundedDrawX,roundedDrawY,fillWidth,fillHeight);
            g.endFill();
         }
         else
         {
            if(this.cachedSourceGrid == null)
            {
               this.cachedSourceGrid = [];
               this.cachedSourceGrid.push([new Point(0,0),new Point(this._scaleGridLeft,0),new Point(this._scaleGridRight,0),new Point(this._bitmapData.width,0)]);
               this.cachedSourceGrid.push([new Point(0,this._scaleGridTop),new Point(this._scaleGridLeft,this._scaleGridTop),new Point(this._scaleGridRight,this._scaleGridTop),new Point(this._bitmapData.width,this._scaleGridTop)]);
               this.cachedSourceGrid.push([new Point(0,this._scaleGridBottom),new Point(this._scaleGridLeft,this._scaleGridBottom),new Point(this._scaleGridRight,this._scaleGridBottom),new Point(this._bitmapData.width,this._scaleGridBottom)]);
               this.cachedSourceGrid.push([new Point(0,this._bitmapData.height),new Point(this._scaleGridLeft,this._bitmapData.height),new Point(this._scaleGridRight,this._bitmapData.height),new Point(this._bitmapData.width,this._bitmapData.height)]);
            }
            if(this.cachedDestGrid == null || this.previousUnscaledWidth != unscaledWidth || this.previousUnscaledHeight != unscaledHeight)
            {
               destScaleGridBottom = unscaledHeight - (this._bitmapData.height - this._scaleGridBottom);
               destScaleGridRight = unscaledWidth - (this._bitmapData.width - this._scaleGridRight);
               this.cachedDestGrid = [];
               this.cachedDestGrid.push([new Point(0,0),new Point(this._scaleGridLeft,0),new Point(destScaleGridRight,0),new Point(unscaledWidth,0)]);
               this.cachedDestGrid.push([new Point(0,this._scaleGridTop),new Point(this._scaleGridLeft,this._scaleGridTop),new Point(destScaleGridRight,this._scaleGridTop),new Point(unscaledWidth,this._scaleGridTop)]);
               this.cachedDestGrid.push([new Point(0,destScaleGridBottom),new Point(this._scaleGridLeft,destScaleGridBottom),new Point(destScaleGridRight,destScaleGridBottom),new Point(unscaledWidth,destScaleGridBottom)]);
               this.cachedDestGrid.push([new Point(0,unscaledHeight),new Point(this._scaleGridLeft,unscaledHeight),new Point(destScaleGridRight,unscaledHeight),new Point(unscaledWidth,unscaledHeight)]);
            }
            sourceSection = new Rectangle();
            destSection = new Rectangle();
            for(rowIndex = 0; rowIndex < 3; rowIndex++)
            {
               for(colIndex = 0; colIndex < 3; colIndex++)
               {
                  sourceSection.topLeft = this.cachedSourceGrid[rowIndex][colIndex];
                  sourceSection.bottomRight = this.cachedSourceGrid[rowIndex + 1][colIndex + 1];
                  destSection.topLeft = this.cachedDestGrid[rowIndex][colIndex];
                  destSection.bottomRight = this.cachedDestGrid[rowIndex + 1][colIndex + 1];
                  matrix.identity();
                  matrix.scale(destSection.width / sourceSection.width,destSection.height / sourceSection.height);
                  matrix.translate(destSection.x - sourceSection.x * matrix.a,destSection.y - sourceSection.y * matrix.d);
                  matrix.translate(roundedDrawX,roundedDrawY);
                  g.beginBitmapFill(this._bitmapData,matrix);
                  g.drawRect(destSection.x + roundedDrawX,destSection.y + roundedDrawY,destSection.width,destSection.height);
                  g.endFill();
               }
            }
         }
         this.previousUnscaledWidth = unscaledWidth;
         this.previousUnscaledHeight = unscaledHeight;
      }
      
      override protected function get needsDisplayObject() : Boolean
      {
         return !this.trustedSource || super.needsDisplayObject;
      }
      
      protected function setBitmapData(bitmapData:BitmapData, internallyCreated:Boolean = false) : void
      {
         this.clearBitmapData();
         this.imageWidth = this.imageHeight = NaN;
         this.clearLoadingContent();
         if(Boolean(bitmapData))
         {
            this.bitmapDataCreated = internallyCreated;
            this._bitmapData = bitmapData;
            this.imageWidth = bitmapData.width;
            this.imageHeight = bitmapData.height;
            this.cachedSourceGrid = null;
            this.cachedDestGrid = null;
            dispatchEvent(new FlexEvent(FlexEvent.READY));
         }
         if(!explicitHeight || !explicitWidth)
         {
            invalidateSize();
         }
         invalidateDisplayList();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function applySource() : void
      {
         var bitmapData:BitmapData = null;
         var tmpSprite:DisplayObject = null;
         var cls:Class = null;
         var value:Object = this._source;
         if(value is MultiDPIBitmapSource)
         {
            value = this.getActualValue(value as MultiDPIBitmapSource);
         }
         this._scaleGridLeft = NaN;
         this._scaleGridRight = NaN;
         this._scaleGridTop = NaN;
         this._scaleGridBottom = NaN;
         var currentBitmapCreated:Boolean = false;
         this._bytesLoaded = NaN;
         this._bytesTotal = NaN;
         this._trustedSource = true;
         invalidateDisplayObjectSharing();
         invalidateDisplayList();
         if(this._clearOnLoad)
         {
            this.removePreviousContent();
         }
         if(value is Class)
         {
            cls = Class(value);
            value = new cls();
            currentBitmapCreated = true;
         }
         else if(value is String || value is URLRequest)
         {
            this.loadExternal(value);
         }
         else if(value is ByteArray)
         {
            this.loadFromBytes(value as ByteArray);
         }
         if(value is BitmapData)
         {
            bitmapData = value as BitmapData;
         }
         else if(value is Bitmap)
         {
            bitmapData = value.bitmapData;
         }
         else if(value is DisplayObject)
         {
            tmpSprite = value as DisplayObject;
            if((tmpSprite.width == 0 || tmpSprite.height == 0) && !tmpSprite.stage)
            {
               tmpSprite.addEventListener(Event.ADDED_TO_STAGE,this.source_addedToStageHandler);
               return;
            }
         }
         else if(value != null)
         {
            return;
         }
         if(!bitmapData && Boolean(tmpSprite))
         {
            if(tmpSprite is IInvalidating)
            {
               IInvalidating(tmpSprite).validateNow();
            }
            if(tmpSprite.width == 0 || tmpSprite.height == 0)
            {
               return;
            }
            bitmapData = new BitmapData(tmpSprite.width,tmpSprite.height,true,0);
            bitmapData.draw(tmpSprite,new Matrix(),tmpSprite.transform.colorTransform);
            currentBitmapCreated = true;
            if(Boolean(tmpSprite.scale9Grid))
            {
               this._scaleGridLeft = tmpSprite.scale9Grid.left;
               this._scaleGridRight = tmpSprite.scale9Grid.right;
               this._scaleGridTop = tmpSprite.scale9Grid.top;
               this._scaleGridBottom = tmpSprite.scale9Grid.bottom;
            }
         }
         if(!this._clearOnLoad)
         {
            this.removePreviousContent();
         }
         this.setBitmapData(bitmapData,currentBitmapCreated);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getActualValue(values:MultiDPIBitmapSource) : Object
      {
         var dpi:Number = NaN;
         var app:Object = FlexGlobals.topLevelApplication;
         if("runtimeDPI" in app)
         {
            dpi = Number(app["runtimeDPI"]);
         }
         else
         {
            dpi = Number(DensityUtil.getRuntimeDPI());
         }
         return values.getSource(dpi);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function loadExternal(source:Object) : void
      {
         var url:String = null;
         var contentRequest:ContentRequest = null;
         var loader:Loader = null;
         var loaderContext:LoaderContext = null;
         var urlRequest:URLRequest = null;
         if(source is String)
         {
            url = source as String;
            source = LoaderUtil.OSToPlayerURI(url,LoaderUtil.isLocal(url));
         }
         if(Boolean(this.contentLoader))
         {
            contentRequest = this.contentLoader.load(source,this.contentLoaderGrouping);
            if(contentRequest.complete)
            {
               this.contentComplete(contentRequest.content);
            }
            else
            {
               this.loadingContent = contentRequest;
               this.attachLoadingListeners();
            }
         }
         else
         {
            loader = new Loader();
            loaderContext = new LoaderContext();
            this.loadingContent = loader.contentLoaderInfo;
            this.attachLoadingListeners();
            try
            {
               loaderContext.checkPolicyFile = true;
               urlRequest = source is URLRequest ? source as URLRequest : new URLRequest(source as String);
               loader.load(urlRequest,loaderContext);
            }
            catch(error:SecurityError)
            {
               handleSecurityError(error);
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function loadFromBytes(source:ByteArray) : void
      {
         var loader:Loader = new Loader();
         var loaderContext:LoaderContext = new LoaderContext();
         this.loadingContent = loader.contentLoaderInfo;
         this.attachLoadingListeners();
         try
         {
            loader.loadBytes(source as ByteArray,loaderContext);
         }
         catch(error:SecurityError)
         {
            handleSecurityError(error);
         }
      }
      
      protected function contentComplete(content:Object) : void
      {
         var loaderInfo:LoaderInfo = null;
         var image:Bitmap = null;
         var contentHolder:Sprite = null;
         if(content is LoaderInfo)
         {
            this.setBitmapData(null);
            this.removePreviousContent();
            loaderInfo = content as LoaderInfo;
            if(loaderInfo.childAllowsParent)
            {
               image = Bitmap(loaderInfo.content);
               this.setBitmapData(image.bitmapData);
            }
            else
            {
               displayObjectSharingMode = DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT;
               invalidateDisplayObjectSharing();
               contentHolder = new Sprite();
               setDisplayObject(contentHolder);
               this.loadedContent = loaderInfo.loader;
               contentHolder.addChild(this.loadedContent);
               this.imageWidth = loaderInfo.width;
               this.imageHeight = loaderInfo.height;
               if(!explicitHeight || !explicitWidth)
               {
                  invalidateSize();
               }
               invalidateDisplayList();
               this._trustedSource = false;
               dispatchEvent(new FlexEvent(FlexEvent.READY));
            }
         }
         else if(content is BitmapData)
         {
            this.setBitmapData(content as BitmapData);
         }
      }
      
      private function get maintainAspectRatio() : Boolean
      {
         return this._scaleMode == BitmapScaleMode.LETTERBOX && this._fillMode == BitmapFillMode.SCALE;
      }
      
      private function removePreviousContent() : void
      {
         if(Boolean(this.loadedContent) && Boolean(this.loadedContent.parent))
         {
            displayObjectSharingMode = DisplayObjectSharingMode.USES_SHARED_OBJECT;
            invalidateDisplayObjectSharing();
            this.loadedContent.parent.removeChild(this.loadedContent);
            this.loadedContent = null;
            setDisplayObject(null);
            this.imageWidth = this.imageHeight = NaN;
         }
         else if(Boolean(drawnDisplayObject))
         {
            Sprite(drawnDisplayObject).graphics.clear();
            this.clearBitmapData();
         }
      }
      
      private function clearLoadingContent() : void
      {
         if(this.loadingContent is LoaderInfo && Boolean(LoaderInfo(this.loadingContent).loader))
         {
            try
            {
               LoaderInfo(this.loadingContent).loader.close();
            }
            catch(e:Error)
            {
            }
         }
         this.removeLoadingListeners();
         this.loadingContent = null;
      }
      
      private function clearBitmapData() : void
      {
         if(Boolean(this._bitmapData))
         {
            if(this.bitmapDataCreated)
            {
               this._bitmapData.dispose();
            }
            this._bitmapData = null;
         }
      }
      
      private function attachLoadingListeners() : void
      {
         if(Boolean(this.loadingContent))
         {
            this.loadingContent.addEventListener(Event.COMPLETE,this.loader_completeHandler,false,0,true);
            this.loadingContent.addEventListener(IOErrorEvent.IO_ERROR,this.loader_ioErrorHandler,false,0,true);
            this.loadingContent.addEventListener(ProgressEvent.PROGRESS,this.loader_progressHandler,false,0,true);
            this.loadingContent.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loader_securityErrorHandler,false,0,true);
            this.loadingContent.addEventListener(HTTPStatusEvent.HTTP_STATUS,dispatchEvent,false,0,true);
         }
      }
      
      private function removeLoadingListeners() : void
      {
         if(Boolean(this.loadingContent))
         {
            this.loadingContent.removeEventListener(Event.COMPLETE,this.loader_completeHandler);
            this.loadingContent.removeEventListener(IOErrorEvent.IO_ERROR,this.loader_ioErrorHandler);
            this.loadingContent.removeEventListener(ProgressEvent.PROGRESS,this.loader_progressHandler);
            this.loadingContent.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loader_securityErrorHandler);
            this.loadingContent.removeEventListener(HTTPStatusEvent.HTTP_STATUS,dispatchEvent);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function validateSource() : void
      {
         if(this.sourceInvalid || this.contentLoaderInvalid)
         {
            this.applySource();
            this.sourceInvalid = false;
            this.contentLoaderInvalid = false;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function loader_completeHandler(event:Event) : void
      {
         var loaderInfo:LoaderInfo = null;
         try
         {
            loaderInfo = event.target is ContentRequest ? event.target.content as LoaderInfo : event.target as LoaderInfo;
            if(Boolean(loaderInfo.bytesLoaded))
            {
               this._bytesLoaded = this._bytesTotal;
               this.contentComplete(loaderInfo);
            }
         }
         catch(error:SecurityError)
         {
            handleSecurityError(error);
         }
         dispatchEvent(event);
         this.clearLoadingContent();
      }
      
      private function loader_ioErrorHandler(error:IOErrorEvent) : void
      {
         if(hasEventListener(error.type))
         {
            dispatchEvent(error);
         }
         this.setBitmapData(null);
         this.loadFailed = true;
      }
      
      private function loader_securityErrorHandler(error:SecurityErrorEvent) : void
      {
         dispatchEvent(error);
         this.setBitmapData(null);
         this.loadFailed = true;
      }
      
      private function loader_progressHandler(progressEvent:ProgressEvent) : void
      {
         this._bytesLoaded = progressEvent.bytesLoaded;
         this._bytesTotal = progressEvent.bytesTotal;
         dispatchEvent(progressEvent);
      }
      
      private function handleSecurityError(error:SecurityError) : void
      {
         dispatchEvent(new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR,false,false,error.message));
         this.setBitmapData(null);
         this.loadFailed = true;
      }
      
      private function source_addedToStageHandler(event:Event) : void
      {
         this.removeAddedToStageHandler(event.target);
         this.applySource();
      }
      
      private function removeAddedToStageHandler(target:Object) : void
      {
         if(Boolean(target) && target is DisplayObject)
         {
            target.removeEventListener(Event.ADDED_TO_STAGE,this.source_addedToStageHandler);
         }
      }
   }
}

