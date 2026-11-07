package org.papervision3d.core.proto
{
   import org.papervision3d.core.Matrix3D;
   import org.papervision3d.core.Number3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class CameraObject3D extends DisplayObject3D
   {
      
      public static var DEFAULT_POS:Number3D = new Number3D(0,0,-1000);
      
      private static var _flipY:Matrix3D = Matrix3D.scaleMatrix(1,-1,1);
      
      public var sort:Boolean;
      
      public var zoom:Number;
      
      public var focus:Number;
      
      public function CameraObject3D(zoom:Number = 3, focus:Number = 500, initObject:Object = null)
      {
         super();
         this.x = Boolean(initObject) ? Number(initObject.x) || DEFAULT_POS.x : DEFAULT_POS.x;
         this.y = Boolean(initObject) ? Number(initObject.y) || DEFAULT_POS.y : DEFAULT_POS.y;
         this.z = Boolean(initObject) ? Number(initObject.z) || DEFAULT_POS.z : DEFAULT_POS.z;
         this.zoom = zoom;
         this.focus = focus;
         this.sort = Boolean(initObject) ? initObject.sort != false : true;
      }
      
      public function transformView(transform:Matrix3D = null) : void
      {
         this.view = Matrix3D.inverse(Matrix3D.multiply(transform || this.transform,_flipY));
      }
      
      public function pan(angle:Number) : void
      {
         super.yaw(angle);
      }
      
      public function tilt(angle:Number) : void
      {
         super.pitch(angle);
      }
   }
}

