package org.papervision3d.utils
{
   import org.papervision3d.core.Matrix3D;
   import org.papervision3d.core.Number3D;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.render.hit.RenderHitData;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class Mouse3D extends DisplayObject3D
   {
      
      private static var UP:Number3D = new Number3D(0,1,0);
      
      public static var enabled:Boolean = false;
      
      public function Mouse3D(initObject:Object = null)
      {
         super();
      }
      
      public function updatePosition(rhd:RenderHitData) : void
      {
         var face3d:Triangle3D = null;
         var position:Number3D = null;
         var target:Number3D = null;
         var zAxis:Number3D = null;
         var m:Matrix3D = null;
         var xAxis:Number3D = null;
         var yAxis:Number3D = null;
         var look:Matrix3D = null;
         face3d = rhd.renderable as Triangle3D;
         position = new Number3D(0,0,0);
         target = new Number3D(face3d.faceNormal.x,face3d.faceNormal.y,face3d.faceNormal.z);
         zAxis = Number3D.sub(target,position);
         zAxis.normalize();
         if(zAxis.modulo > 0.1)
         {
            xAxis = Number3D.cross(zAxis,UP);
            xAxis.normalize();
            yAxis = Number3D.cross(zAxis,xAxis);
            yAxis.normalize();
            look = this.transform;
            look.n11 = xAxis.x;
            look.n21 = xAxis.y;
            look.n31 = xAxis.z;
            look.n12 = -yAxis.x;
            look.n22 = -yAxis.y;
            look.n32 = -yAxis.z;
            look.n13 = zAxis.x;
            look.n23 = zAxis.y;
            look.n33 = zAxis.z;
         }
         m = Matrix3D.IDENTITY;
         this.transform = Matrix3D.multiply(face3d.instance.world,look);
         x = rhd.x;
         y = rhd.y;
         z = rhd.z;
      }
   }
}

