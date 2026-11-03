package org.papervision3d.cameras
{
   import org.papervision3d.core.Matrix3D;
   import org.papervision3d.core.Number3D;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class Camera3D extends CameraObject3D
   {
      
      public var goto:Number3D;
      
      public var target:DisplayObject3D;
      
      public function Camera3D(target:DisplayObject3D = null, zoom:Number = 2, focus:Number = 100, initObject:Object = null)
      {
         super(zoom,focus,initObject);
         this.target = target || DisplayObject3D.ZERO;
         this.goto = new Number3D(this.x,this.y,this.z);
      }
      
      override public function transformView(transform:Matrix3D = null) : void
      {
         this.lookAt(this.target);
         super.transformView();
      }
      
      public function hover(type:Number, mouseX:Number, mouseY:Number) : void
      {
         var target:DisplayObject3D = null;
         var goto:Number3D = null;
         var camSpeed:Number = NaN;
         var dX:Number = NaN;
         var dZ:Number = NaN;
         var ang:Number = NaN;
         var dist:Number = NaN;
         var xMouse:Number = NaN;
         var camX:Number = NaN;
         var camZ:Number = NaN;
         var camY:Number = NaN;
         target = this.target;
         goto = this.goto;
         camSpeed = 8;
         switch(type)
         {
            case 0:
               dX = goto.x - target.x;
               dZ = goto.z - target.z;
               ang = Math.atan2(dZ,dX);
               dist = Math.sqrt(dX * dX + dZ * dZ);
               xMouse = 0.5 * mouseX;
               camX = dist * Math.cos(ang - xMouse);
               camZ = dist * Math.sin(ang - xMouse);
               camY = goto.y - 300 * mouseY;
               this.x -= (this.x - camX) / camSpeed;
               this.y -= (this.y - camY) / camSpeed;
               this.z -= (this.z - camZ) / camSpeed;
               break;
            case 1:
               this.x -= (this.x - 1000 * mouseX) / camSpeed;
               this.y -= (this.y - 1000 * mouseY) / camSpeed;
         }
      }
   }
}

