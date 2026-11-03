package spark.skins.spark
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.IBitmapDrawable;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Rectangle;
   import mx.core.UIComponent;
   import mx.events.FlexEvent;
   import spark.components.supportClasses.SkinnableComponent;
   import spark.skins.IHighlightBitmapCaptureClient;
   
   public class HighlightBitmapCaptureSkin extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var capturingBitmap:Boolean = false;
      
      private static var colorTransform:ColorTransform = new ColorTransform(1.01,1.01,1.01,2);
      
      private static var rect:Rectangle = new Rectangle();
      
      protected var bitmap:Bitmap;
      
      private var _target:SkinnableComponent;
      
      public function HighlightBitmapCaptureSkin()
      {
         super();
      }
      
      public function get target() : SkinnableComponent
      {
         return this._target;
      }
      
      public function set target(value:SkinnableComponent) : void
      {
         this._target = value;
         if(Boolean(this._target.skin))
         {
            this._target.skin.addEventListener(FlexEvent.UPDATE_COMPLETE,this.skin_updateCompleteHandler,false,0,true);
         }
      }
      
      protected function get borderWeight() : Number
      {
         return 1;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var m:Matrix;
         var transform3D:Matrix3D;
         var bitmapCaptureClient:IHighlightBitmapCaptureClient;
         var bitmapData:BitmapData = null;
         var needUpdate:Boolean = false;
         var fillRect:Rectangle = null;
         var skin:DisplayObject = null;
         if(!this.target)
         {
            return;
         }
         bitmapData = new BitmapData(this.target.width + this.borderWeight * 2,this.target.height + this.borderWeight * 2,true,0);
         m = new Matrix();
         capturingBitmap = true;
         transform3D = null;
         if(Boolean(this.target.$transform.matrix3D))
         {
            transform3D = this.target.$transform.matrix3D;
            this.target.$transform.matrix3D = null;
         }
         if(Boolean(this.target.focusObj))
         {
            this.target.focusObj.visible = false;
         }
         bitmapCaptureClient = this.target.skin as IHighlightBitmapCaptureClient;
         if(Boolean(bitmapCaptureClient))
         {
            needUpdate = bitmapCaptureClient.beginHighlightBitmapCapture();
            if(needUpdate)
            {
               bitmapCaptureClient.validateNow();
            }
         }
         m.tx = this.borderWeight;
         m.ty = this.borderWeight;
         try
         {
            bitmapData.draw(this.target as IBitmapDrawable,m);
         }
         catch(e:SecurityError)
         {
            skin = target.skin;
            if(Boolean(skin))
            {
               fillRect = new Rectangle(skin.x,skin.y,skin.width,skin.height);
            }
            else
            {
               fillRect = new Rectangle(target.x,target.y,target.width,target.height);
            }
            bitmapData.fillRect(fillRect,0);
         }
         if(Boolean(bitmapCaptureClient))
         {
            needUpdate = bitmapCaptureClient.endHighlightBitmapCapture();
            if(needUpdate)
            {
               bitmapCaptureClient.validateNow();
            }
         }
         if(Boolean(this.target.focusObj))
         {
            this.target.focusObj.visible = true;
         }
         rect.x = rect.y = this.borderWeight;
         rect.width = this.target.width;
         rect.height = this.target.height;
         bitmapData.colorTransform(rect,colorTransform);
         if(!this.bitmap)
         {
            this.bitmap = new Bitmap();
            addChild(this.bitmap);
         }
         this.bitmap.x = this.bitmap.y = -this.borderWeight;
         this.bitmap.bitmapData = bitmapData;
         this.processBitmap();
         if(Boolean(transform3D))
         {
            this.target.$transform.matrix3D = transform3D;
         }
         capturingBitmap = false;
      }
      
      protected function processBitmap() : void
      {
      }
      
      private function skin_updateCompleteHandler(event:Event) : void
      {
         if(!capturingBitmap)
         {
            invalidateDisplayList();
         }
      }
   }
}

