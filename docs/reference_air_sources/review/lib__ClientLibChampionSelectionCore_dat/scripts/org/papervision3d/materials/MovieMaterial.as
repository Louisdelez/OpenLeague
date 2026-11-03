package org.papervision3d.materials
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;
   import org.papervision3d.Papervision3D;
   import org.papervision3d.core.render.draw.ITriangleDrawer;
   
   public class MovieMaterial extends BitmapMaterial implements ITriangleDrawer
   {
      
      private static var animatedMaterials:Dictionary = new Dictionary(false);
      
      public var movieTransparent:Boolean;
      
      public var allowAutoResize:Boolean = true;
      
      public var movie:DisplayObject;
      
      public function MovieMaterial(movieAsset:DisplayObject = null, transparent:Boolean = false, animated:Boolean = false)
      {
         super();
         movieTransparent = transparent;
         this.animated = animated;
         if(Boolean(movieAsset))
         {
            texture = movieAsset;
         }
      }
      
      public static function updateAnimatedBitmaps() : void
      {
         var material:Object = null;
         for(material in animatedMaterials)
         {
            if(Boolean(animatedMaterials[material]))
            {
               material.updateBitmap();
            }
         }
      }
      
      override public function get texture() : Object
      {
         return this._texture;
      }
      
      public function drawBitmap() : void
      {
         var mtx:Matrix = null;
         bitmap.fillRect(bitmap.rect,this.fillColor);
         mtx = new Matrix();
         mtx.scale(movie.scaleX,movie.scaleY);
         bitmap.draw(movie,mtx,movie.transform.colorTransform);
      }
      
      public function get animated() : Boolean
      {
         return animatedMaterials[this];
      }
      
      override public function set texture(asset:Object) : void
      {
         if(asset is DisplayObject == false)
         {
            Papervision3D.log("Error: MovieMaterial.texture requires a Sprite to be passed as the object");
            return;
         }
         bitmap = createBitmapFromSprite(DisplayObject(asset));
         _texture = asset;
      }
      
      protected function createBitmapFromSprite(asset:DisplayObject) : BitmapData
      {
         movie = asset;
         initBitmap(movie);
         drawBitmap();
         bitmap = super.createBitmap(bitmap);
         return bitmap;
      }
      
      public function set animated(status:Boolean) : void
      {
         animatedMaterials[this] = status;
      }
      
      override public function updateBitmap() : void
      {
         var mWidth:int = 0;
         var mHeight:int = 0;
         mWidth = int(movie.width);
         mHeight = int(movie.height);
         if(allowAutoResize && (mWidth != bitmap.width || mHeight != bitmap.height))
         {
            initBitmap(movie);
         }
         drawBitmap();
      }
      
      protected function initBitmap(asset:DisplayObject) : void
      {
         if(Boolean(bitmap))
         {
            bitmap.dispose();
         }
         bitmap = new BitmapData(asset.width,asset.height,this.movieTransparent);
      }
   }
}

