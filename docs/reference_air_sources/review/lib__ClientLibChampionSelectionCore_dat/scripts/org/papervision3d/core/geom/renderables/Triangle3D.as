package org.papervision3d.core.geom.renderables
{
   import org.papervision3d.core.Number3D;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.core.render.command.IRenderListItem;
   import org.papervision3d.core.render.command.RenderTriangle;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class Triangle3D implements IRenderable
   {
      
      private static var _totalFaces:Number = 0;
      
      public var vertices:Array;
      
      public var face3DInstance:Triangle3DInstance;
      
      public var instance:DisplayObject3D;
      
      public var id:Number;
      
      public var uv:Array;
      
      public var material:MaterialObject3D;
      
      public var faceNormal:Number3D;
      
      public var renderCommand:RenderTriangle;
      
      public var screenZ:Number;
      
      public var _materialName:String;
      
      public var visible:Boolean;
      
      public var v0:Vertex3D;
      
      public var v1:Vertex3D;
      
      public var v2:Vertex3D;
      
      public function Triangle3D(do3dInstance:DisplayObject3D, vertices:Array, material:MaterialObject3D = null, uv:Array = null)
      {
         super();
         this.instance = do3dInstance;
         this.renderCommand = new RenderTriangle(this);
         face3DInstance = new Triangle3DInstance(this,do3dInstance);
         this.vertices = vertices;
         v0 = vertices[0];
         v1 = vertices[1];
         v2 = vertices[2];
         this.material = material;
         this.uv = uv;
         this.id = _totalFaces++;
         createNormal();
      }
      
      public function getRenderListItem() : IRenderListItem
      {
         return renderCommand;
      }
      
      protected function createNormal() : void
      {
         var vn0:Number3D = null;
         var vn1:Number3D = null;
         var vn2:Number3D = null;
         var vt1:Number3D = null;
         var vt2:Number3D = null;
         vn0 = v0.toNumber3D();
         vn1 = v1.toNumber3D();
         vn2 = v2.toNumber3D();
         vt1 = Number3D.sub(vn1,vn0);
         vt2 = Number3D.sub(vn2,vn0);
         faceNormal = Number3D.cross(vt2,vt1);
         faceNormal.normalize();
      }
   }
}

