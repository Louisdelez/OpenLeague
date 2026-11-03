package org.papervision3d.objects
{
   import org.papervision3d.core.NumberUV;
   import org.papervision3d.core.geom.TriangleMesh3D;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.proto.MaterialObject3D;
   
   public class Plane extends TriangleMesh3D
   {
      
      public static var DEFAULT_SIZE:Number = 500;
      
      public static var DEFAULT_SCALE:Number = 1;
      
      public static var DEFAULT_SEGMENTS:Number = 1;
      
      public var segmentsH:Number;
      
      public var segmentsW:Number;
      
      public function Plane(material:MaterialObject3D = null, width:Number = 0, height:Number = 0, segmentsW:Number = 0, segmentsH:Number = 0, initObject:Object = null)
      {
         var scale:Number = NaN;
         super(material,new Array(),new Array(),null,initObject);
         this.segmentsW = segmentsW || DEFAULT_SEGMENTS;
         this.segmentsH = segmentsH || this.segmentsW;
         scale = DEFAULT_SCALE;
         if(!height)
         {
            if(Boolean(width))
            {
               scale = width;
            }
            if(Boolean(material) && Boolean(material.bitmap))
            {
               width = material.bitmap.width * scale;
               height = material.bitmap.height * scale;
            }
            else
            {
               width = DEFAULT_SIZE * scale;
               height = DEFAULT_SIZE * scale;
            }
         }
         buildPlane(width,height);
      }
      
      private function buildPlane(width:Number, height:Number) : void
      {
         var gridX:Number = NaN;
         var gridY:Number = NaN;
         var gridX1:Number = NaN;
         var gridY1:Number = NaN;
         var vertices:Array = null;
         var faces:Array = null;
         var textureX:Number = NaN;
         var textureY:Number = NaN;
         var iW:Number = NaN;
         var iH:Number = NaN;
         var ix:int = 0;
         var uvA:NumberUV = null;
         var uvC:NumberUV = null;
         var uvB:NumberUV = null;
         var iy:int = 0;
         var x:Number = NaN;
         var y:Number = NaN;
         var a:Vertex3D = null;
         var c:Vertex3D = null;
         var b:Vertex3D = null;
         gridX = this.segmentsW;
         gridY = this.segmentsH;
         gridX1 = gridX + 1;
         gridY1 = gridY + 1;
         vertices = this.geometry.vertices;
         faces = this.geometry.faces;
         textureX = width / 2;
         textureY = height / 2;
         iW = width / gridX;
         iH = height / gridY;
         for(ix = 0; ix < gridX + 1; ix++)
         {
            for(iy = 0; iy < gridY1; iy++)
            {
               x = ix * iW - textureX;
               y = iy * iH - textureY;
               vertices.push(new Vertex3D(x,y,0));
            }
         }
         for(ix = 0; ix < gridX; ix++)
         {
            for(iy = 0; iy < gridY; iy++)
            {
               a = vertices[ix * gridY1 + iy];
               c = vertices[ix * gridY1 + (iy + 1)];
               b = vertices[(ix + 1) * gridY1 + iy];
               uvA = new NumberUV(ix / gridX,iy / gridY);
               uvC = new NumberUV(ix / gridX,(iy + 1) / gridY);
               uvB = new NumberUV((ix + 1) / gridX,iy / gridY);
               faces.push(new Triangle3D(this,[a,b,c],null,[uvA,uvB,uvC]));
               a = vertices[(ix + 1) * gridY1 + (iy + 1)];
               c = vertices[(ix + 1) * gridY1 + iy];
               b = vertices[ix * gridY1 + (iy + 1)];
               uvA = new NumberUV((ix + 1) / gridX,(iy + 1) / gridY);
               uvC = new NumberUV((ix + 1) / gridX,iy / gridY);
               uvB = new NumberUV(ix / gridX,(iy + 1) / gridY);
               faces.push(new Triangle3D(this,[a,b,c],null,[uvA,uvB,uvC]));
            }
         }
         this.geometry.ready = true;
      }
   }
}

