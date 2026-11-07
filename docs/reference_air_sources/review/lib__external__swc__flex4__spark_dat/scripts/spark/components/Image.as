package spark.components
{
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import mx.events.FlexEvent;
   import mx.graphics.BitmapScaleMode;
   import mx.utils.BitFlagUtil;
   import spark.components.supportClasses.Range;
   import spark.components.supportClasses.SkinnableComponent;
   import spark.core.IContentLoader;
   import spark.primitives.BitmapImage;
   
   [IconFile("Image.png")]
   [Style(name="smoothingQuality",type="String",inherit="no",enumeration="default,high")]
   [Style(name="enableLoadingState",type="Boolean",inherit="no")]
   [Style(name="backgroundColor",type="uint",format="Color",inherit="no",theme="spark, mobile")]
   [Style(name="backgroundAlpha",type="Number",inherit="no",theme="spark, mobile",minValue="0.0",maxValue="1.0")]
   [Event(name="securityError",type="flash.events.SecurityErrorEvent")]
   [Event(name="ready",type="mx.events.FlexEvent")]
   [Event(name="progress",type="flash.events.ProgressEvent")]
   [Event(name="ioError",type="flash.events.IOErrorEvent")]
   [Event(name="httpStatus",type="flash.events.HTTPStatusEvent")]
   [Event(name="complete",type="flash.events.Event")]
   [SkinState("disabled")]
   [SkinState("invalid")]
   [SkinState("ready")]
   [SkinState("loading")]
   [SkinState("uninitialized")]
   public class Image extends SkinnableComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const CLEAR_ON_LOAD_PROPERTY_FLAG:uint = 1 << 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const CONTENT_LOADER_PROPERTY_FLAG:uint = 1 << 1;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const CONTENT_LOADER_GROUPING_PROPERTY_FLAG:uint = 1 << 2;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const FILL_MODE_PROPERTY_FLAG:uint = 1 << 3;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const PRELIMINARY_WIDTH_PROPERTY_FLAG:uint = 1 << 4;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const PRELIMINARY_HEIGHT_PROPERTY_FLAG:uint = 1 << 5;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const HORIZONTAL_ALIGN_PROPERTY_FLAG:uint = 1 << 6;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const SCALE_MODE_PROPERTY_FLAG:uint = 1 << 7;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const SMOOTH_PROPERTY_FLAG:uint = 1 << 8;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const SMOOTHING_QUALITY_PROPERTY_FLAG:uint = 1 << 9;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const SOURCE_PROPERTY_FLAG:uint = 1 << 10;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const SOURCE_WIDTH_PROPERTY_FLAG:uint = 1 << 11;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const SOURCE_HEIGHT_PROPERTY_FLAG:uint = 1 << 12;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const TRUSTED_SOURCE_PROPERTY_FLAG:uint = 1 << 13;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERTICAL_ALIGN_PROPERTY_FLAG:uint = 1 << 14;
      
      private static var _skinParts:Object = {
         "imageDisplay":true,
         "progressIndicator":false
      };
      
      protected var _loading:Boolean = false;
      
      protected var _ready:Boolean = false;
      
      protected var _invalid:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var imageDisplayProperties:Object = {
         "visible":true,
         "scaleMode":BitmapScaleMode.LETTERBOX,
         "trustedSource":true
      };
      
      [SkinPart(required="true")]
      public var imageDisplay:BitmapImage;
      
      [SkinPart(required="false")]
      public var progressIndicator:Range;
      
      public function Image()
      {
         super();
      }
      
      public function get bitmapData() : BitmapData
      {
         return Boolean(this.imageDisplay) ? this.imageDisplay.bitmapData : null;
      }
      
      public function get bytesLoaded() : Number
      {
         return Boolean(this.imageDisplay) ? this.imageDisplay.bytesLoaded : NaN;
      }
      
      public function get bytesTotal() : Number
      {
         return Boolean(this.imageDisplay) ? this.imageDisplay.bytesTotal : NaN;
      }
      
      public function get clearOnLoad() : Boolean
      {
         if(Boolean(this.imageDisplay))
         {
            return this.imageDisplay.clearOnLoad;
         }
         return this.imageDisplayProperties.clearOnLoad;
      }
      
      public function set clearOnLoad(value:Boolean) : void
      {
         if(Boolean(this.imageDisplay))
         {
            this.imageDisplay.clearOnLoad = value;
            this.imageDisplayProperties = BitFlagUtil.update(this.imageDisplayProperties as uint,CLEAR_ON_LOAD_PROPERTY_FLAG,true);
         }
         else
         {
            this.imageDisplayProperties.clearOnLoad = value;
         }
      }
      
      public function get contentLoader() : IContentLoader
      {
         if(Boolean(this.imageDisplay))
         {
            return this.imageDisplay.contentLoader;
         }
         return this.imageDisplayProperties.contentLoader;
      }
      
      public function set contentLoader(value:IContentLoader) : void
      {
         if(Boolean(this.imageDisplay))
         {
            this.imageDisplay.contentLoader = value;
            this.imageDisplayProperties = BitFlagUtil.update(this.imageDisplayProperties as uint,CONTENT_LOADER_PROPERTY_FLAG,true);
         }
         else
         {
            this.imageDisplayProperties.contentLoader = value;
         }
      }
      
      public function get contentLoaderGrouping() : String
      {
         if(Boolean(this.imageDisplay))
         {
            return this.imageDisplay.contentLoaderGrouping;
         }
         return this.imageDisplayProperties.contentLoaderGrouping;
      }
      
      public function set contentLoaderGrouping(value:String) : void
      {
         if(Boolean(this.imageDisplay))
         {
            this.imageDisplay.contentLoaderGrouping = value;
            this.imageDisplayProperties = BitFlagUtil.update(this.imageDisplayProperties as uint,CONTENT_LOADER_GROUPING_PROPERTY_FLAG,true);
         }
         else
         {
            this.imageDisplayProperties.contentLoaderGrouping = value;
         }
      }
      
      [Inspectable(category="General",enumeration="clip,repeat,scale",defaultValue="scale")]
      public function get fillMode() : String
      {
         if(Boolean(this.imageDisplay))
         {
            return this.imageDisplay.fillMode;
         }
         return this.imageDisplayProperties.fillMode;
      }
      
      public function set fillMode(value:String) : void
      {
         if(Boolean(this.imageDisplay))
         {
            this.imageDisplay.fillMode = value;
            this.imageDisplayProperties = BitFlagUtil.update(this.imageDisplayProperties as uint,FILL_MODE_PROPERTY_FLAG,true);
         }
         else
         {
            this.imageDisplayProperties.fillMode = value;
         }
      }
      
      [Inspectable(category="General",enumeration="left,right,center",defaultValue="center")]
      public function get horizontalAlign() : String
      {
         if(Boolean(this.imageDisplay))
         {
            return this.imageDisplay.horizontalAlign;
         }
         return this.imageDisplayProperties.horizontalAlign;
      }
      
      public function set horizontalAlign(value:String) : void
      {
         if(Boolean(this.imageDisplay))
         {
            this.imageDisplay.horizontalAlign = value;
            this.imageDisplayProperties = BitFlagUtil.update(this.imageDisplayProperties as uint,HORIZONTAL_ALIGN_PROPERTY_FLAG,value != null);
         }
         else
         {
            this.imageDisplayProperties.horizontalAlign = value;
         }
      }
      
      [Inspectable(category="General",defaultValue="NaN")]
      public function get preliminaryHeight() : Number
      {
         if(Boolean(this.imageDisplay))
         {
            return this.imageDisplay.preliminaryHeight;
         }
         return this.imageDisplayProperties.preliminaryHeight;
      }
      
      public function set preliminaryHeight(value:Number) : void
      {
         if(Boolean(this.imageDisplay))
         {
            this.imageDisplay.preliminaryHeight = value;
            this.imageDisplayProperties = BitFlagUtil.update(this.imageDisplayProperties as uint,PRELIMINARY_HEIGHT_PROPERTY_FLAG,true);
         }
         else
         {
            this.imageDisplayProperties.preliminaryHeight = value;
         }
      }
      
      [Inspectable(category="General",defaultValue="NaN")]
      public function get preliminaryWidth() : Number
      {
         if(Boolean(this.imageDisplay))
         {
            return this.imageDisplay.preliminaryWidth;
         }
         return this.imageDisplayProperties.preliminaryWidth;
      }
      
      public function set preliminaryWidth(value:Number) : void
      {
         if(Boolean(this.imageDisplay))
         {
            this.imageDisplay.preliminaryWidth = value;
            this.imageDisplayProperties = BitFlagUtil.update(this.imageDisplayProperties as uint,PRELIMINARY_WIDTH_PROPERTY_FLAG,true);
         }
         else
         {
            this.imageDisplayProperties.preliminaryWidth = value;
         }
      }
      
      [Inspectable(category="General",enumeration="stretch,letterbox,zoom",defaultValue="letterbox")]
      public function get scaleMode() : String
      {
         if(Boolean(this.imageDisplay))
         {
            return this.imageDisplay.scaleMode;
         }
         return this.imageDisplayProperties.scaleMode;
      }
      
      public function set scaleMode(value:String) : void
      {
         if(Boolean(this.imageDisplay))
         {
            this.imageDisplay.scaleMode = value;
            this.imageDisplayProperties = BitFlagUtil.update(this.imageDisplayProperties as uint,SCALE_MODE_PROPERTY_FLAG,true);
         }
         else
         {
            this.imageDisplayProperties.scaleMode = value;
         }
      }
      
      [Inspectable(category="General",defaultValue="false")]
      public function set smooth(value:Boolean) : void
      {
         if(Boolean(this.imageDisplay))
         {
            this.imageDisplay.smooth = value;
            this.imageDisplayProperties = BitFlagUtil.update(this.imageDisplayProperties as uint,SMOOTH_PROPERTY_FLAG,true);
         }
         else
         {
            this.imageDisplayProperties.smooth = value;
         }
      }
      
      public function get smooth() : Boolean
      {
         if(Boolean(this.imageDisplay))
         {
            return this.imageDisplay.smooth;
         }
         return this.imageDisplayProperties.smooth;
      }
      
      [Inspectable(category="General")]
      [Bindable("sourceChanged")]
      public function get source() : Object
      {
         if(Boolean(this.imageDisplay))
         {
            return this.imageDisplay.source;
         }
         return this.imageDisplayProperties.source;
      }
      
      public function set source(value:Object) : void
      {
         if(this.source == value)
         {
            return;
         }
         this._loading = false;
         this._invalid = false;
         this._ready = false;
         if(Boolean(this.imageDisplay))
         {
            this.imageDisplay.source = value;
            this.imageDisplayProperties = BitFlagUtil.update(this.imageDisplayProperties as uint,SOURCE_PROPERTY_FLAG,value != null);
         }
         else
         {
            this.imageDisplayProperties.source = value;
         }
         invalidateSkinState();
         dispatchEvent(new Event("sourceChanged"));
      }
      
      public function get sourceHeight() : Number
      {
         if(Boolean(this.imageDisplay))
         {
            return this.imageDisplay.sourceHeight;
         }
         return NaN;
      }
      
      public function get sourceWidth() : Number
      {
         if(Boolean(this.imageDisplay))
         {
            return this.imageDisplay.sourceWidth;
         }
         return NaN;
      }
      
      public function get trustedSource() : Boolean
      {
         if(Boolean(this.imageDisplay))
         {
            return this.imageDisplay.trustedSource;
         }
         return this.imageDisplayProperties.trustedSource;
      }
      
      [Inspectable(category="General",enumeration="top,bottom,middle",defaultValue="middle")]
      public function get verticalAlign() : String
      {
         if(Boolean(this.imageDisplay))
         {
            return this.imageDisplay.verticalAlign;
         }
         return this.imageDisplayProperties.verticalAlign;
      }
      
      public function set verticalAlign(value:String) : void
      {
         if(Boolean(this.imageDisplay))
         {
            this.imageDisplay.verticalAlign = value;
            this.imageDisplayProperties = BitFlagUtil.update(this.imageDisplayProperties as uint,VERTICAL_ALIGN_PROPERTY_FLAG,value != null);
         }
         else
         {
            this.imageDisplayProperties.verticalAlign = value;
         }
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         var newImageDisplayProperties:uint = 0;
         super.partAdded(partName,instance);
         if(instance == this.imageDisplay)
         {
            this.imageDisplay.addEventListener(IOErrorEvent.IO_ERROR,this.imageDisplay_ioErrorHandler,false,0,true);
            this.imageDisplay.addEventListener(ProgressEvent.PROGRESS,this.imageDisplay_progressHandler,false,0,true);
            this.imageDisplay.addEventListener(FlexEvent.READY,this.imageDisplay_readyHandler,false,0,true);
            this.imageDisplay.addEventListener(Event.COMPLETE,dispatchEvent,false,0,true);
            this.imageDisplay.addEventListener(SecurityErrorEvent.SECURITY_ERROR,dispatchEvent,false,0,true);
            this.imageDisplay.addEventListener(HTTPStatusEvent.HTTP_STATUS,dispatchEvent,false,0,true);
            newImageDisplayProperties = 0;
            if(this.imageDisplayProperties.clearOnLoad !== undefined)
            {
               this.imageDisplay.clearOnLoad = this.imageDisplayProperties.clearOnLoad;
               newImageDisplayProperties = uint(BitFlagUtil.update(newImageDisplayProperties,CLEAR_ON_LOAD_PROPERTY_FLAG,true));
            }
            if(this.imageDisplayProperties.contentLoader !== undefined)
            {
               this.imageDisplay.contentLoader = this.imageDisplayProperties.contentLoader;
               newImageDisplayProperties = uint(BitFlagUtil.update(newImageDisplayProperties,CONTENT_LOADER_PROPERTY_FLAG,true));
            }
            if(this.imageDisplayProperties.contentLoaderGrouping !== undefined)
            {
               this.imageDisplay.contentLoaderGrouping = this.imageDisplayProperties.contentLoaderGrouping;
               newImageDisplayProperties = uint(BitFlagUtil.update(newImageDisplayProperties,CONTENT_LOADER_GROUPING_PROPERTY_FLAG,true));
            }
            if(this.imageDisplayProperties.fillMode !== undefined)
            {
               this.imageDisplay.fillMode = this.imageDisplayProperties.fillMode;
               newImageDisplayProperties = uint(BitFlagUtil.update(newImageDisplayProperties,FILL_MODE_PROPERTY_FLAG,true));
            }
            if(this.imageDisplayProperties.preliminaryHeight !== undefined)
            {
               this.imageDisplay.preliminaryHeight = this.imageDisplayProperties.preliminaryHeight;
               newImageDisplayProperties = uint(BitFlagUtil.update(newImageDisplayProperties,PRELIMINARY_HEIGHT_PROPERTY_FLAG,true));
            }
            if(this.imageDisplayProperties.preliminaryWidth !== undefined)
            {
               this.imageDisplay.preliminaryWidth = this.imageDisplayProperties.preliminaryWidth;
               newImageDisplayProperties = uint(BitFlagUtil.update(newImageDisplayProperties,PRELIMINARY_WIDTH_PROPERTY_FLAG,true));
            }
            if(this.imageDisplayProperties.smooth !== undefined)
            {
               this.imageDisplay.smooth = this.imageDisplayProperties.smooth;
               newImageDisplayProperties = uint(BitFlagUtil.update(newImageDisplayProperties,SMOOTH_PROPERTY_FLAG,true));
            }
            if(this.imageDisplayProperties.source !== undefined)
            {
               this.imageDisplay.source = this.imageDisplayProperties.source;
               newImageDisplayProperties = uint(BitFlagUtil.update(newImageDisplayProperties,SOURCE_PROPERTY_FLAG,true));
            }
            if(this.imageDisplayProperties.smoothingQuality !== undefined)
            {
               this.imageDisplay.smoothingQuality = this.imageDisplayProperties.smoothingQuality;
               newImageDisplayProperties = uint(BitFlagUtil.update(newImageDisplayProperties,SMOOTHING_QUALITY_PROPERTY_FLAG,true));
            }
            if(this.imageDisplayProperties.scaleMode !== undefined)
            {
               this.imageDisplay.scaleMode = this.imageDisplayProperties.scaleMode;
               newImageDisplayProperties = uint(BitFlagUtil.update(newImageDisplayProperties,SCALE_MODE_PROPERTY_FLAG,true));
            }
            if(this.imageDisplayProperties.verticalAlign !== undefined)
            {
               this.imageDisplay.verticalAlign = this.imageDisplayProperties.verticalAlign;
               newImageDisplayProperties = uint(BitFlagUtil.update(newImageDisplayProperties,VERTICAL_ALIGN_PROPERTY_FLAG,true));
            }
            if(this.imageDisplayProperties.horizontalAlign !== undefined)
            {
               this.imageDisplay.horizontalAlign = this.imageDisplayProperties.horizontalAlign;
               newImageDisplayProperties = uint(BitFlagUtil.update(newImageDisplayProperties,HORIZONTAL_ALIGN_PROPERTY_FLAG,true));
            }
            this.imageDisplayProperties = newImageDisplayProperties;
            this.imageDisplay.validateSource();
         }
         else if(instance == this.progressIndicator)
         {
            if(Boolean(this._loading) && Boolean(this.progressIndicator) && Boolean(this.imageDisplay))
            {
               this.progressIndicator.value = this.percentComplete(this.imageDisplay.bytesLoaded,this.imageDisplay.bytesTotal);
            }
         }
      }
      
      override protected function partRemoved(partName:String, instance:Object) : void
      {
         var newImageDisplayProperties:Object = null;
         super.partRemoved(partName,instance);
         if(instance == this.imageDisplay)
         {
            this.imageDisplay.removeEventListener(IOErrorEvent.IO_ERROR,this.imageDisplay_ioErrorHandler);
            this.imageDisplay.removeEventListener(ProgressEvent.PROGRESS,this.imageDisplay_progressHandler);
            this.imageDisplay.removeEventListener(FlexEvent.READY,this.imageDisplay_readyHandler);
            this.imageDisplay.removeEventListener(Event.COMPLETE,dispatchEvent);
            this.imageDisplay.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,dispatchEvent);
            this.imageDisplay.removeEventListener(HTTPStatusEvent.HTTP_STATUS,dispatchEvent);
            newImageDisplayProperties = {};
            if(BitFlagUtil.isSet(this.imageDisplayProperties as uint,CLEAR_ON_LOAD_PROPERTY_FLAG))
            {
               newImageDisplayProperties.clearOnLoad = this.imageDisplay.clearOnLoad;
            }
            if(BitFlagUtil.isSet(this.imageDisplayProperties as uint,CONTENT_LOADER_PROPERTY_FLAG))
            {
               newImageDisplayProperties.contentLoader = this.imageDisplay.contentLoader;
            }
            if(BitFlagUtil.isSet(this.imageDisplayProperties as uint,CONTENT_LOADER_GROUPING_PROPERTY_FLAG))
            {
               newImageDisplayProperties.contentLoaderGrouping = this.imageDisplay.contentLoaderGrouping;
            }
            if(BitFlagUtil.isSet(this.imageDisplayProperties as uint,FILL_MODE_PROPERTY_FLAG))
            {
               newImageDisplayProperties.fillMode = this.imageDisplay.fillMode;
            }
            if(BitFlagUtil.isSet(this.imageDisplayProperties as uint,PRELIMINARY_HEIGHT_PROPERTY_FLAG))
            {
               newImageDisplayProperties.preliminaryHeight = this.imageDisplay.preliminaryHeight;
            }
            if(BitFlagUtil.isSet(this.imageDisplayProperties as uint,PRELIMINARY_WIDTH_PROPERTY_FLAG))
            {
               newImageDisplayProperties.preliminaryWidth = this.imageDisplay.preliminaryWidth;
            }
            if(BitFlagUtil.isSet(this.imageDisplayProperties as uint,SOURCE_PROPERTY_FLAG))
            {
               newImageDisplayProperties.source = this.imageDisplay.source;
            }
            if(BitFlagUtil.isSet(this.imageDisplayProperties as uint,SMOOTH_PROPERTY_FLAG))
            {
               newImageDisplayProperties.smooth = this.imageDisplay.smooth;
            }
            if(BitFlagUtil.isSet(this.imageDisplayProperties as uint,SMOOTHING_QUALITY_PROPERTY_FLAG))
            {
               newImageDisplayProperties.smoothingQuality = this.imageDisplay.smoothingQuality;
            }
            if(BitFlagUtil.isSet(this.imageDisplayProperties as uint,SCALE_MODE_PROPERTY_FLAG))
            {
               newImageDisplayProperties.scaleMode = this.imageDisplay.scaleMode;
            }
            if(BitFlagUtil.isSet(this.imageDisplayProperties as uint,TRUSTED_SOURCE_PROPERTY_FLAG))
            {
               newImageDisplayProperties.trustedSource = this.imageDisplay.trustedSource;
            }
            if(BitFlagUtil.isSet(this.imageDisplayProperties as uint,VERTICAL_ALIGN_PROPERTY_FLAG))
            {
               newImageDisplayProperties.verticalAlign = this.imageDisplay.verticalAlign;
            }
            if(BitFlagUtil.isSet(this.imageDisplayProperties as uint,HORIZONTAL_ALIGN_PROPERTY_FLAG))
            {
               newImageDisplayProperties.horizontalAlign = this.imageDisplay.horizontalAlign;
            }
            this.imageDisplay.source = null;
            this.imageDisplayProperties = newImageDisplayProperties;
         }
      }
      
      override protected function getCurrentSkinState() : String
      {
         var enableLoadingState:Boolean = Boolean(getStyle("enableLoadingState"));
         if(this._invalid)
         {
            return "invalid";
         }
         if(!enabled)
         {
            return "disabled";
         }
         if(this._loading && enableLoadingState)
         {
            return "loading";
         }
         if(Boolean(this.imageDisplay) && Boolean(this.imageDisplay.source) && this._ready)
         {
            return "ready";
         }
         return "uninitialized";
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var allStyles:Boolean = styleProp == null || styleProp == "styleName";
         super.styleChanged(styleProp);
         if(allStyles || styleProp == "enableLoadingState")
         {
            invalidateSkinState();
         }
         if(allStyles || styleProp == "smoothingQuality")
         {
            this.smoothQuality = getStyle("smoothingQuality");
         }
      }
      
      private function set smoothQuality(value:String) : void
      {
         if(Boolean(this.imageDisplay))
         {
            this.imageDisplay.smoothingQuality = value;
            this.imageDisplayProperties = BitFlagUtil.update(this.imageDisplayProperties as uint,SMOOTHING_QUALITY_PROPERTY_FLAG,value != null);
         }
         else
         {
            this.imageDisplayProperties.smoothingQuality = value;
         }
      }
      
      private function percentComplete(bytesLoaded:Number, bytesTotal:Number) : Number
      {
         var value:Number = Math.ceil(bytesLoaded / bytesTotal * 100);
         return isNaN(value) ? 0 : value;
      }
      
      private function imageDisplay_ioErrorHandler(error:IOErrorEvent) : void
      {
         this._invalid = true;
         this._loading = false;
         invalidateSkinState();
         if(hasEventListener(error.type))
         {
            dispatchEvent(error);
         }
      }
      
      private function imageDisplay_progressHandler(event:ProgressEvent) : void
      {
         if(!this._loading)
         {
            invalidateSkinState();
         }
         if(Boolean(this.progressIndicator))
         {
            this.progressIndicator.value = this.percentComplete(event.bytesLoaded,event.bytesTotal);
         }
         this._loading = true;
         dispatchEvent(event);
      }
      
      private function imageDisplay_readyHandler(event:Event) : void
      {
         invalidateSkinState();
         this._loading = false;
         this._ready = true;
         dispatchEvent(event);
      }
   }
}

