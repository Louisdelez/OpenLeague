package org.papervision3d.core.geom
{
   import flash.utils.Dictionary;
   import org.papervision3d.core.*;
   import org.papervision3d.core.culling.ITriangleCuller;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Triangle3DInstance;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.geom.renderables.Vertex3DInstance;
   import org.papervision3d.core.proto.*;
   import org.papervision3d.core.render.draw.ITriangleDrawer;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class TriangleMesh3D extends Vertices3D
   {
      
      public function TriangleMesh3D(material:MaterialObject3D, vertices:Array, faces:Array, name:String = null, initObject:Object = null)
      {
         super(vertices,name,initObject);
         this.geometry.faces = faces || new Array();
         this.material = material || MaterialObject3D.DEFAULT;
      }
      
      override public function project(parent:DisplayObject3D, camera:CameraObject3D, sorted:Array = null) : Number
      {
         var faces:Array = null;
         var screenZs:Number = NaN;
         var visibleFaces:Number = NaN;
         var triCuller:ITriangleCuller = null;
         var vertex0:Vertex3DInstance = null;
         var vertex1:Vertex3DInstance = null;
         var vertex2:Vertex3DInstance = null;
         var iFace:Triangle3DInstance = null;
         var face:Triangle3D = null;
         var mat:MaterialObject3D = null;
         super.project(parent,camera,sorted);
         if(!sorted)
         {
            sorted = this._sorted;
         }
         faces = this.geometry.faces;
         screenZs = 0;
         visibleFaces = 0;
         triCuller = scene.triangleCuller;
         for each(face in faces)
         {
            mat = Boolean(face.material) ? face.material : material;
            iFace = face.face3DInstance;
            vertex0 = face.v0.vertex3DInstance;
            vertex1 = face.v1.vertex3DInstance;
            vertex2 = face.v2.vertex3DInstance;
            if(iFace.visible = triCuller.testFace(face,vertex0,vertex1,vertex2))
            {
               if(mat.needsFaceNormals)
               {
                  face.faceNormal.copyTo(iFace.faceNormal);
                  Matrix3D.multiplyVector3x3(this.view,iFace.faceNormal);
               }
               if(mat.needsVertexNormals)
               {
                  face.v0.normal.copyTo(face.v0.vertex3DInstance.normal);
                  Matrix3D.multiplyVector3x3(this.world,vertex0.normal);
                  face.v1.normal.copyTo(face.v1.vertex3DInstance.normal);
                  Matrix3D.multiplyVector3x3(this.world,vertex1.normal);
                  face.v2.normal.copyTo(face.v2.vertex3DInstance.normal);
                  Matrix3D.multiplyVector3x3(this.world,vertex2.normal);
               }
               switch(meshSort)
               {
                  case DisplayObject3D.MESH_SORT_CENTER:
                     screenZs += iFace.screenZ = (vertex0.z + vertex1.z + vertex2.z) * 0.333;
                     break;
                  case DisplayObject3D.MESH_SORT_FAR:
                     screenZs += iFace.screenZ = Math.max(vertex0.z,vertex1.z,vertex2.z);
                     break;
                  case DisplayObject3D.MESH_SORT_CLOSE:
                     screenZs += iFace.screenZ = Math.min(vertex0.z,vertex1.z,vertex2.z);
               }
               visibleFaces++;
               face.renderCommand.renderer = mat as ITriangleDrawer;
               face.renderCommand.screenDepth = iFace.screenZ;
               scene.renderer.addToRenderList(face.renderCommand);
            }
            else
            {
               ++scene.stats.culledTriangles;
            }
         }
         return this.screenZ = screenZs / visibleFaces;
      }
      
      public function mergeVertices() : void
      {
         var uniqueDic:Dictionary = null;
         var uniqueList:Array = null;
         var v:Vertex3D = null;
         var f:Triangle3D = null;
         var vu:Vertex3D = null;
         uniqueDic = new Dictionary();
         uniqueList = new Array();
         for each(v in this.geometry.vertices)
         {
            for each(vu in uniqueDic)
            {
               if(v.x == vu.x && v.y == vu.y && v.z == vu.z)
               {
                  uniqueDic[v] = vu;
                  break;
               }
            }
            if(!uniqueDic[v])
            {
               uniqueDic[v] = v;
               uniqueList.push(v);
            }
         }
         this.geometry.vertices = uniqueList;
         for each(f in this.geometry.faces)
         {
            f.v0 = uniqueDic[f.v0];
            f.v1 = uniqueDic[f.v1];
            f.v2 = uniqueDic[f.v2];
         }
      }
      
      public function projectTexture(u:String = "x", v:String = "y") : void
      {
         var faces:Array = null;
         var bBox:Object = null;
         var minX:Number = NaN;
         var sizeX:Number = NaN;
         var minY:Number = NaN;
         var sizeY:Number = NaN;
         var objectMaterial:MaterialObject3D = null;
         var i:String = null;
         var myFace:Triangle3D = null;
         var myVertices:Array = null;
         var a:Vertex3D = null;
         var b:Vertex3D = null;
         var c:Vertex3D = null;
         var uvA:NumberUV = null;
         var uvB:NumberUV = null;
         var uvC:NumberUV = null;
         faces = this.geometry.faces;
         bBox = this.boundingBox();
         minX = Number(bBox.min[u]);
         sizeX = Number(bBox.size[u]);
         minY = Number(bBox.min[v]);
         sizeY = Number(bBox.size[v]);
         objectMaterial = this.material;
         for(i in faces)
         {
            myFace = faces[Number(i)];
            myVertices = myFace.vertices;
            a = myVertices[0];
            b = myVertices[1];
            c = myVertices[2];
            uvA = new NumberUV((a[u] - minX) / sizeX,(a[v] - minY) / sizeY);
            uvB = new NumberUV((b[u] - minX) / sizeX,(b[v] - minY) / sizeY);
            uvC = new NumberUV((c[u] - minX) / sizeX,(c[v] - minY) / sizeY);
            myFace.uv = [uvA,uvB,uvC];
         }
      }
   }
}

