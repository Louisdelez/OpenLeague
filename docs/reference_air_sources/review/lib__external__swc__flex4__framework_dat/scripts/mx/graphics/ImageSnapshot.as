package mx.graphics
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.IBitmapDrawable;
   import flash.display.Stage;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   import mx.core.IFlexDisplayObject;
   import mx.core.IUIComponent;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.graphics.codec.IImageEncoder;
   import mx.graphics.codec.PNGEncoder;
   import mx.utils.Base64Encoder;
   
   use namespace mx_internal;
   
   [RemoteClass(alias="flex.graphics.ImageSnapshot")]
   public dynamic class ImageSnapshot
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public static const MAX_BITMAP_DIMENSION:int = 2880;
      
      public static var defaultEncoder:Class = PNGEncoder;
      
      private var _contentType:String;
      
      private var _data:ByteArray;
      
      private var _height:int;
      
      private var _properties:Object = {};
      
      private var _width:int;
      
      public function ImageSnapshot(width:int = 0, height:int = 0, data:ByteArray = null, contentType:String = null)
      {
         super();
         this.contentType = contentType;
         this.width = width;
         this.height = height;
         this.data = data;
      }
      
      public static function captureBitmapData(source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode:String = null, clipRect:Rectangle = null, smoothing:Boolean = false) : BitmapData
      {
         var data:BitmapData = null;
         var width:int = 0;
         var height:int = 0;
         var normalState:Array = null;
         var scaledWidth:Number = NaN;
         var scaledHeight:Number = NaN;
         var reductionScale:Number = NaN;
         if(source is IUIComponent)
         {
            normalState = prepareToPrintObject(IUIComponent(source));
         }
         try
         {
            if(source != null)
            {
               if(source is DisplayObject)
               {
                  width = DisplayObject(source).width;
                  height = DisplayObject(source).height;
               }
               else if(source is BitmapData)
               {
                  width = BitmapData(source).width;
                  height = BitmapData(source).height;
               }
               else if(source is IFlexDisplayObject)
               {
                  width = IFlexDisplayObject(source).width;
                  height = IFlexDisplayObject(source).height;
               }
            }
            if(!matrix)
            {
               matrix = new Matrix(1,0,0,1);
            }
            scaledWidth = width * matrix.a;
            scaledHeight = height * matrix.d;
            reductionScale = 1;
            if(scaledWidth > MAX_BITMAP_DIMENSION)
            {
               reductionScale = scaledWidth / MAX_BITMAP_DIMENSION;
               scaledWidth = MAX_BITMAP_DIMENSION;
               scaledHeight /= reductionScale;
               matrix.a = scaledWidth / width;
               matrix.d = scaledHeight / height;
            }
            if(scaledHeight > MAX_BITMAP_DIMENSION)
            {
               reductionScale = scaledHeight / MAX_BITMAP_DIMENSION;
               scaledHeight = MAX_BITMAP_DIMENSION;
               scaledWidth /= reductionScale;
               matrix.a = scaledWidth / width;
               matrix.d = scaledHeight / height;
            }
            data = new BitmapData(scaledWidth,scaledHeight,true,0);
            data.draw(source,matrix,colorTransform,blendMode,clipRect,smoothing);
         }
         catch(e:Error)
         {
            data = null;
         }
         finally
         {
            if(source is IUIComponent)
            {
               finishPrintObject(IUIComponent(source),normalState);
            }
         }
         return data;
      }
      
      public static function captureImage(source:IBitmapDrawable, dpi:Number = 0, encoder:IImageEncoder = null, scaleLimited:Boolean = true) : ImageSnapshot
      {
         var scale:Number;
         var matrix:Matrix;
         var snapshot:ImageSnapshot = null;
         var width:int = 0;
         var height:int = 0;
         var normalState:Array = null;
         var bytes:ByteArray = null;
         var data:BitmapData = null;
         var bitmap:Bitmap = null;
         var bounds:Rectangle = null;
         var screenDPI:Number = Capabilities.screenDPI;
         if(dpi <= 0)
         {
            dpi = screenDPI;
         }
         scale = dpi / screenDPI;
         matrix = new Matrix(scale,0,0,scale);
         if(source is IUIComponent)
         {
            normalState = prepareToPrintObject(IUIComponent(source));
         }
         try
         {
            if(source != null)
            {
               if(source is DisplayObject)
               {
                  width = DisplayObject(source).width;
                  height = DisplayObject(source).height;
               }
               else if(source is BitmapData)
               {
                  width = BitmapData(source).width;
                  height = BitmapData(source).height;
               }
               else if(source is IFlexDisplayObject)
               {
                  width = IFlexDisplayObject(source).width;
                  height = IFlexDisplayObject(source).height;
               }
            }
            if(!encoder)
            {
               encoder = new defaultEncoder();
            }
            width *= matrix.a;
            height *= matrix.d;
            if(scaleLimited || width <= MAX_BITMAP_DIMENSION && height <= MAX_BITMAP_DIMENSION)
            {
               data = captureBitmapData(source,matrix);
               bitmap = new Bitmap(data);
               width = bitmap.width;
               height = bitmap.height;
               bytes = encoder.encode(data);
            }
            else
            {
               bounds = new Rectangle(0,0,width,height);
               bytes = captureAll(source,bounds,matrix);
               bytes = encoder.encodeByteArray(bytes,width,height);
            }
            snapshot = new ImageSnapshot(width,height,bytes,encoder.contentType);
         }
         finally
         {
            if(source is IUIComponent)
            {
               finishPrintObject(IUIComponent(source),normalState);
            }
         }
         return snapshot;
      }
      
      public static function encodeImageAsBase64(snapshot:ImageSnapshot) : String
      {
         var bytes:ByteArray = snapshot.data;
         var base64:Base64Encoder = new Base64Encoder();
         base64.encodeBytes(bytes);
         return base64.drain();
      }
      
      private static function captureAll(source:IBitmapDrawable, bounds:Rectangle, matrix:Matrix, colorTransform:ColorTransform = null, blendMode:String = null, clipRect:Rectangle = null, smoothing:Boolean = false) : ByteArray
      {
         var topRight:Rectangle = null;
         var bottomLeft:Rectangle = null;
         var bottomRight:Rectangle = null;
         var topRightPixels:ByteArray = null;
         var bottomLeftPixels:ByteArray = null;
         var bottomRightPixels:ByteArray = null;
         var currentMatrix:Matrix = matrix.clone();
         var topLeft:Rectangle = bounds.clone();
         if(bounds.width > MAX_BITMAP_DIMENSION)
         {
            topLeft.width = MAX_BITMAP_DIMENSION;
            topRight = new Rectangle();
            topRight.x = topLeft.width;
            topRight.y = bounds.y;
            topRight.width = bounds.width - topLeft.width;
            topRight.height = bounds.height;
         }
         if(bounds.height > MAX_BITMAP_DIMENSION)
         {
            topLeft.height = MAX_BITMAP_DIMENSION;
            if(topRight != null)
            {
               topRight.height = topLeft.height;
            }
            bottomLeft = new Rectangle();
            bottomLeft.x = bounds.x;
            bottomLeft.y = topLeft.height;
            bottomLeft.width = topLeft.width;
            bottomLeft.height = bounds.height - topLeft.height;
            if(bounds.width > MAX_BITMAP_DIMENSION)
            {
               bottomRight = new Rectangle();
               bottomRight.x = topLeft.width;
               bottomRight.y = topLeft.height;
               bottomRight.width = bounds.width - topLeft.width;
               bottomRight.height = bounds.height - topLeft.height;
            }
         }
         currentMatrix.translate(-topLeft.x,-topLeft.y);
         topLeft.x = 0;
         topLeft.y = 0;
         var data:BitmapData = new BitmapData(topLeft.width,topLeft.height,true,0);
         data.draw(source,currentMatrix,colorTransform,blendMode,clipRect,smoothing);
         var pixels:ByteArray = data.getPixels(topLeft);
         pixels.position = 0;
         if(topRight != null)
         {
            currentMatrix = matrix.clone();
            currentMatrix.translate(-topRight.x,-topRight.y);
            topRight.x = 0;
            topRight.y = 0;
            topRightPixels = captureAll(source,topRight,currentMatrix);
            pixels = mergePixelRows(pixels,topLeft.width,topRightPixels,topRight.width,topRight.height);
         }
         if(bottomLeft != null)
         {
            currentMatrix = matrix.clone();
            currentMatrix.translate(-bottomLeft.x,-bottomLeft.y);
            bottomLeft.x = 0;
            bottomLeft.y = 0;
            bottomLeftPixels = captureAll(source,bottomLeft,currentMatrix);
            if(bottomRight != null)
            {
               currentMatrix = matrix.clone();
               currentMatrix.translate(-bottomRight.x,-bottomRight.y);
               bottomRight.x = 0;
               bottomRight.y = 0;
               bottomRightPixels = captureAll(source,bottomRight,currentMatrix);
               bottomLeftPixels = mergePixelRows(bottomLeftPixels,bottomLeft.width,bottomRightPixels,bottomRight.width,bottomRight.height);
            }
            pixels.position = pixels.length;
            pixels.writeBytes(bottomLeftPixels);
         }
         pixels.position = 0;
         return pixels;
      }
      
      private static function mergePixelRows(left:ByteArray, leftWidth:int, right:ByteArray, rightWidth:int, rightHeight:int) : ByteArray
      {
         var merged:ByteArray = new ByteArray();
         var leftByteWidth:int = leftWidth * 4;
         var rightByteWidth:int = rightWidth * 4;
         for(var i:int = 0; i < rightHeight; i++)
         {
            merged.writeBytes(left,i * leftByteWidth,leftByteWidth);
            merged.writeBytes(right,i * rightByteWidth,rightByteWidth);
         }
         merged.position = 0;
         return merged;
      }
      
      private static function prepareToPrintObject(target:IUIComponent) : Array
      {
         var normalStates:Array = [];
         var obj:DisplayObject = target is DisplayObject ? DisplayObject(target) : null;
         var index:Number = 0;
         while(obj != null)
         {
            if(obj is UIComponent)
            {
               normalStates[index++] = UIComponent(obj).prepareToPrint(UIComponent(target));
            }
            else if(obj is DisplayObject && !(obj is Stage))
            {
               normalStates[index++] = DisplayObject(obj).mask;
               DisplayObject(obj).mask = null;
            }
            obj = obj.parent is DisplayObject ? DisplayObject(obj.parent) : null;
         }
         return normalStates;
      }
      
      private static function finishPrintObject(target:IUIComponent, normalStates:Array) : void
      {
         var obj:DisplayObject = target is DisplayObject ? DisplayObject(target) : null;
         var index:Number = 0;
         while(obj != null)
         {
            if(obj is UIComponent)
            {
               UIComponent(obj).finishPrint(normalStates[index++],UIComponent(target));
            }
            else if(obj is DisplayObject && !(obj is Stage))
            {
               DisplayObject(obj).mask = normalStates[index++];
            }
            obj = obj.parent is DisplayObject ? DisplayObject(obj.parent) : null;
         }
      }
      
      [Inspectable(category="General")]
      public function get contentType() : String
      {
         return this._contentType;
      }
      
      public function set contentType(value:String) : void
      {
         this._contentType = value;
      }
      
      [Inspectable(category="General")]
      public function get data() : ByteArray
      {
         return this._data;
      }
      
      public function set data(value:ByteArray) : void
      {
         this._data = value;
      }
      
      [Inspectable(category="General")]
      public function get height() : int
      {
         return this._height;
      }
      
      public function set height(value:int) : void
      {
         this._height = value;
      }
      
      public function get properties() : Object
      {
         return this._properties;
      }
      
      public function set properties(value:Object) : void
      {
         this._properties = value;
      }
      
      [Inspectable(category="General")]
      public function get width() : int
      {
         return this._width;
      }
      
      public function set width(value:int) : void
      {
         this._width = value;
      }
   }
}

