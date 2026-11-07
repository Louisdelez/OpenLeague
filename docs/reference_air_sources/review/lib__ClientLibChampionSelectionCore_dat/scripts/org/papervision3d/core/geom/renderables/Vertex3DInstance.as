package org.papervision3d.core.geom.renderables
{
   import org.papervision3d.core.Number3D;
   
   public class Vertex3DInstance
   {
      
      public var visible:Boolean;
      
      public var normal:Number3D;
      
      public var extra:Object;
      
      public var x:Number;
      
      public var y:Number;
      
      public var z:Number;
      
      public function Vertex3DInstance(x:Number = 0, y:Number = 0, z:Number = 0)
      {
         super();
         this.x = x;
         this.y = y;
         this.z = z;
         this.visible = false;
         this.normal = new Number3D();
      }
      
      public static function cross(v0:Vertex3DInstance, v1:Vertex3DInstance) : Number
      {
         return v0.x * v1.y - v1.x * v0.y;
      }
      
      public static function dot(v0:Vertex3DInstance, v1:Vertex3DInstance) : Number
      {
         return v0.x * v1.x + v0.y * v1.y;
      }
      
      public static function sub(v0:Vertex3DInstance, v1:Vertex3DInstance) : Vertex3DInstance
      {
         return new Vertex3DInstance(v1.x - v0.x,v1.y - v0.y);
      }
      
      public function clone() : Vertex3DInstance
      {
         var clone:Vertex3DInstance = null;
         clone = new Vertex3DInstance(x,y,z);
         clone.visible = visible;
         clone.extra = extra;
         return clone;
      }
   }
}

