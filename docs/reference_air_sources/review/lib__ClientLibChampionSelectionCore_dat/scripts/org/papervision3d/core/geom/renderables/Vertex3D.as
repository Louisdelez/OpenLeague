package org.papervision3d.core.geom.renderables
{
   import flash.utils.Dictionary;
   import org.papervision3d.core.Number3D;
   import org.papervision3d.core.render.command.IRenderListItem;
   
   public class Vertex3D implements IRenderable
   {
      
      public var vertex3DInstance:Vertex3DInstance;
      
      public var connectedFaces:Dictionary;
      
      public var normal:Number3D;
      
      public var extra:Object;
      
      public var x:Number;
      
      public var y:Number;
      
      public var z:Number;
      
      public function Vertex3D(x:Number = 0, y:Number = 0, z:Number = 0)
      {
         super();
         this.x = x;
         this.y = y;
         this.z = z;
         this.vertex3DInstance = new Vertex3DInstance();
         this.normal = new Number3D();
         this.connectedFaces = new Dictionary();
      }
      
      public function getRenderListItem() : IRenderListItem
      {
         return null;
      }
      
      public function calculateNormal() : void
      {
         var face:Triangle3D = null;
         var count:Number = NaN;
         normal = new Number3D();
         count = 0;
         for each(face in connectedFaces)
         {
            count++;
            normal = Number3D.add(face.faceNormal,normal);
         }
         normal.x /= count;
         normal.y /= count;
         normal.z /= count;
         normal.normalize();
      }
      
      public function toNumber3D() : Number3D
      {
         return new Number3D(x,y,z);
      }
      
      public function clone() : Vertex3D
      {
         var clone:Vertex3D = null;
         clone = new Vertex3D(x,y,z);
         clone.extra = extra;
         clone.vertex3DInstance = vertex3DInstance.clone();
         clone.normal = normal.clone();
         return clone;
      }
   }
}

